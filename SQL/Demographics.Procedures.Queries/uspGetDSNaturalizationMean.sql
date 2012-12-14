/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSNaturalizationMean.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSNaturalizationFrequency
  
  Purpose     : Returns mean net naturalization rate by origin, gender, and age over a specified range of 
                years. Intended for use by the population projection model. The procedure returns a single
                resultset containing calculated mean net naturalization frequencies pertaining to groups of
                persons classified by origin, gender and age. The naturalization rate is defined as a rate
                of exits from the group of persons having a particular origin.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSNaturalizationMean', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSNaturalizationMean
GO

CREATE PROCEDURE Demographics.uspGetDSNaturalizationMean (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE @ymin smallint;
  DECLARE @ymax smallint;
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSMothers;

  DECLARE @f smallint;
  DECLARE @l smallint;
  SET @f = coalesce(@firstyear, @ymin);
  IF (@lastyear IS NULL)
    SET @l = CASE WHEN @impute = 0 THEN (@ymax - 1) ELSE @ymax END;
  ELSE
    SET @l = @lastyear;

  BEGIN TRY
    IF (@f > @l) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear');
    IF (@f < @ymin) RAISERROR(80002, 16, 1, '@firstyear');
    IF (@impute = 1 AND @l > @ymax) OR (@impute = 0 AND @l > dateadd(yyyy, -1, @ymax)) 
      RAISERROR(80003, 16, 1, '@lastyear');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  ; 

  SELECT n.OriginID, n.GenderID AS GenderID, n.Age, convert(float, sum(n.Persons)) / sum(e.Persons) AS Frequency
  FROM Demographics.ufnGetDSNaturalized(@f, @l, @impute) n
    INNER JOIN Demographics.ufnGetDSExposedToRisk(@f, @l, @impute) e ON 
    n.OriginID = e.OriginID AND n.GenderID = e.GenderID AND n.Age = e.Age AND n.[Year] = e.[Year]
  GROUP BY n.OriginID, n.GenderID, n.Age;

END
GO