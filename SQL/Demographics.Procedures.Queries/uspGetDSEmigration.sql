/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSEmigration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSEmigration
  
  Purpose     : Gets gross emigration rates for a specified range of years. Intended for the population 
                projection model. The procedure returns a single resultset containing calculated gross 
                emigration rates pertaining to groups of persons classified by origin, gender and age. 

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSEmigration', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSEmigration
GO

CREATE PROCEDURE Demographics.uspGetDSEmigration (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSEmigrants
  ;

  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  IF (@lastyear IS NULL)
    SET @l = CASE WHEN @impute = 0 THEN (@ymax - 1) ELSE @ymax END
  ELSE
    SET @l = @lastyear
  ;

  BEGIN TRY
    IF (@f > @l) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear')
    IF (@f < @ymin) RAISERROR(80002, 16, 1, '@firstyear')
    IF (@impute = 1 AND @l > @ymax) OR (@impute = 0 AND @l > (@ymax - 1)) RAISERROR(80003, 16, 1, '@lastyear');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  ;

  SELECT e.OriginID, e.GenderID, e.Age, e.[Year], e.Frequency
  FROM Demographics.ufnGetDSEmigration(@f, @l, @impute) e
  ORDER BY e.OriginID, e.GenderID, e.Age, e.[Year]
  RETURN 0;
  
END
GO