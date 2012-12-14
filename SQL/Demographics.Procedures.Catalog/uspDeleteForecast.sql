/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspDeleteForecast.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspDeleteForecast
  
  Purpose     : Deletes a forecast from the database.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspDeleteForecast', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspDeleteForecast
GO

CREATE PROCEDURE Demographics.uspDeleteForecast (
  @forecastid smallint,
  @unconditional bit = 0
) 
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

    IF (@forecastid IS NULL) RAISERROR(80005, 16, 1, '@forecastid');
    IF (NOT EXISTS (SELECT * FROM Demographics.Forecast WHERE ForecastID = @forecastid)) 
    RAISERROR(60205, 16, 2);
    
    DECLARE @r bit;
    DECLARE @p bit;
    SELECT @r = IsReadOnly, @p = IsPublished FROM Demographics.Forecast WHERE ForecastID = @forecastid 
    
    IF (@p = 1) RAISERROR(60209, 16, 1, 'The forecast is marked published');
    IF (@r = 1 AND @unconditional = 0) RAISERROR(60209, 16, 2, 'The forecast is marked readonly');
  
    DELETE FROM Demographics.Forecast
    WHERE ForecastID = @forecastid;
    RETURN 0;

  END TRY
  BEGIN CATCH
    IF @@trancount > 0 ROLLBACK;
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN (CASE WHEN ERROR_NUMBER() IN (80005, 60105, 60109) THEN -1 ELSE 1 END);
  END CATCH

END
GO