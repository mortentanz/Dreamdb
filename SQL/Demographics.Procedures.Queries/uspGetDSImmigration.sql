/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSImmigration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSImmigration
  
  Purpose     : Gets gross immigration rates for a specified range of years. Intended for the population 
                projection model. The procedure returns a single resultset containing calculated gross 
                immigration rates pertaining to groups of persons classified by origin, gender and age. 

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSImmigration', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSImmigration 
GO

CREATE PROCEDURE Demographics.uspGetDSImmigration (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSImmigrants
  ;
  
  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  IF (@lastyear IS NULL)
    SET @l = CASE WHEN @impute = 0 THEN (@ymax - 1) ELSE @ymax END
  ELSE
    SET @l = @lastyear
  ;

  BEGIN TRY
    IF (@f > @l) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear');
    IF (@f < @ymin) RAISERROR(80002, 16, 1, '@firstyear');
    IF (@impute = 1 AND @l > @ymax) OR (@impute = 0 AND @l > (@ymax - 1)) RAISERROR(80003, 16, 1, '@lastyear');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  SELECT i.OriginID, i.GenderID, i.Age, i.[Year], i.Frequency
  FROM Demographics.ufnGetDSImmigration(@f, @l, @impute) i
  ORDER BY i.[Year], i.OriginID, i.GenderID, i.Age
  RETURN 0;
  
END
GO