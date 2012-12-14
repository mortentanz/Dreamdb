/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSBirths.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSBirths
  
  Purpose     : Gets number of newborn children for a specified range of years. Intended for the population 
                projection model. The procedure returns a single resultset containing numbers of persons in 
                groups classified by origin, gender and age.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSBirths', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSBirths
GO

CREATE PROCEDURE Demographics.uspGetDSBirths (
  @firstyear smallint = 1981,
  @lastyear smallint = null
)
AS
BEGIN

	SET NOCOUNT ON

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSBirths

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

  SELECT ChildOriginID, ChildGenderID,  Age, [Year], Persons
  FROM Demographics.DSBirths
  WHERE [Year] BETWEEN @f AND @l
  RETURN 0;
  
END
GO  