/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSImmigrants.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSImmigrants
  
  Purpose     : Gets number of immigrants for a specified range of years. Intended for the population 
                projection model. The procedure returns a single resultset containing numbers of persons in 
                groups classified by origin, gender and age. 

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSImmigrants', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSImmigrants
GO

CREATE PROCEDURE Demographics.uspGetDSImmigrants (
  @firstyear smallint = 1981,
  @lastyear smallint = null
)
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSImmigrants
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

  SELECT OriginID, GenderID, Age, [Year], Persons
  FROM Demographics.DSImmigrants
  WHERE [Year] BETWEEN @f AND @l
  RETURN 0;
  
END
GO 