/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSBoyShare.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSBoyShare
  
  Purpose     : Determines the share of newborn children that are boys over the course of the specified years.
  
	Remarks			: The procedure does not return a result set and should be executed as ExecuteNonQuery.
  
-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSBoyShare', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSBoyShare
GO

CREATE PROCEDURE Demographics.uspGetDSBoyShare (
	@firstyear smallint = 1981,
	@lastyear smallint = null,
	@boyshare float output
)
AS
BEGIN

	SET NOCOUNT ON;

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
  END CATCH;

	
	DECLARE @boys int;
	DECLARE @total int;
	
	SELECT @boys = sum(Persons) FROM Demographics.DSBirths WHERE [Year] BETWEEN @f AND @l AND ChildGenderID = 1;
	SELECT @total = sum(Persons) FROM Demographics.DSBirths WHERE [Year] BETWEEN @f AND @l;
	
	SET @boyshare = convert(float, @boys) / @total;
	RETURN 0;

END
GO