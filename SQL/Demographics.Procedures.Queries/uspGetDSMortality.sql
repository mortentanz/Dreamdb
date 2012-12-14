/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSMortality.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSMortality
  
  Purpose     : Gets the mortality rates by gender, age, and year. Intended for use by the population 
                projection model. The procedure returns a single resultset containing observed and optionally
                imputed mortality rates pertaining to groups of persons classified by gender, age and year. 

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSMortality', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSMortality
GO

CREATE PROCEDURE Demographics.uspGetDSMortality (
  @firstyear smallint = 1981,
  @lastyear smallint = null
)
AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSDeaths
  ;

  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  SET @l = coalesce(@lastyear, @ymax)  
  ;
  
  BEGIN TRY
    IF (@f > @l) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear');
    IF (@f < @ymin) RAISERROR(80002, 16, 1, '@firstyear');
    IF (@l > @ymax) RAISERROR(80003, 16, 1, '@lastyear');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  SELECT GenderID, Age, [Year], Frequency
  FROM Demographics.ufnGetDSMortalitySimple(@f, @l)
  ORDER BY [Year], GenderID, Age
  RETURN 0;

END
GO
