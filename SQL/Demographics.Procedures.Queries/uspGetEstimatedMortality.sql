/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetEstimatedMortality.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetEstimatedMortality
  
  Purpose     : Gets the mortality rates by gender, age, origin, and year. Intended for use by the population 
                projection model. The procedure returns a single resultset containing estimated mortality 
                rates pertaining to groups of persons classified by gender, origin, age and year.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetEstimatedMortality', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetEstimatedMortality
GO

CREATE PROCEDURE Demographics.uspGetEstimatedMortality (
  @estimationid smallint,
  @firstyear smallint = null,
  @lastyear smallint = null,
  @infantdeathshare float = 1.0,
  @infantsurvivalshare float = 0.5,
  @origincount tinyint = null output
)  
AS 
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY
    
    IF (@estimationid IS NULL) RAISERROR(80005, 16, 1, '@estimationid');
    IF (@infantdeathshare IS NULL) RAISERROR(80005, 16, 2, '@infantdeathshare');
    IF (@infantsurvivalshare IS NULL) RAISERROR(80005, 16, 3, '@infantsurvivalshare');
    
    DECLARE @i smallint, @f smallint, @l smallint;
    SELECT @i = EstimationID, @f = FirstYear, @l = LastYear
    FROM Demographics.Estimation
    WHERE EstimationID = @estimationid AND Class = 'Mortality'
    ;
    IF (@i IS NULL) RAISERROR(60008, 16, 1);
    IF (isnull(@firstyear, @f) > isnull(@lastyear, @l)) RAISERROR(80001, 16, 1);
    IF (@firstyear IS NOT NULL) AND (@firstyear < @f) RAISERROR(80002, 16, 1, '@firstyear');
    IF (@lastyear IS NOT NULL) AND (@lastyear > @l) RAISERROR(80003, 16, 1, '@lastyear');

    SET @f = coalesce(@firstyear, @f);
    SET @l = coalesce(@lastyear, @l);

	SELECT @origincount = count(DISTINCT OriginID) 
  FROM Demographics.EstimatedMortality
  WHERE EstimationID = @estimationid
  ;

  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH;
  
  BEGIN TRY;
    WITH estimates AS (
      SELECT OriginID, GenderID, Age, [Year], Estimate
      FROM Demographics.EstimatedMortality
      WHERE [Year] BETWEEN @f AND @l AND EstimationID = @estimationid
    ),
    infants AS (
      SELECT OriginID, GenderID, Age, [Year], Estimate
      FROM estimates WHERE Age = 0
    )

    SELECT i.OriginID, i.GenderID, i.Age, i.[Year], @infantdeathshare * i.Estimate AS Mortality
    FROM infants i
    UNION ALL
    SELECT 
      b.OriginID, b.GenderID, b.Age, b.[Year], 
      @infantsurvivalshare * isnull(i.Estimate, 0) + 0.5 * b.Estimate AS Mortality
    FROM estimates b
      LEFT JOIN infants i ON (
        b.OriginID = i.OriginID AND b.GenderID = i.GenderID AND b.[Year] = i.[Year]
      )
    WHERE b.Age = 1
    UNION ALL
    SELECT u.OriginID, u.GenderID, u.Age, u.[Year], 0.5 * (u.Estimate + isnull(p.Estimate, 0)) AS Mortality
    FROM estimates u
      LEFT JOIN estimates p ON (
        u.OriginID = p.OriginID AND u.GenderID = p.GenderID AND u.Age = p.Age + 1 AND u.[Year] = p.[Year]
      )
    WHERE u.Age > 1
    ORDER BY [Year], OriginID, GenderID, Age
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH

END
GO