/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspDefineForecastEstimation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspDefineForecastEstimation
  
  Purpose     : Associates a projection with a forecastm or updates an existing association
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspDefineForecastEstimation', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspDefineForecastEstimation
GO

CREATE PROCEDURE Demographics.uspDefineForecastEstimation (
	@forecastid smallint,
	@estimationid smallint,
	@replace bit = 0
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @p bit;
		DECLARE @r bit;
		DECLARE @eid smallint;
		DECLARE @c varchar(20);

		SELECT 
			@c = Class,
			@eid = EstimationID,
			@p = IsPublished, 
			@r = IsReadOnly 
		FROM Demographics.Forecast WHERE ForecastID = @forecastid;

		IF (@c IN ('Birth', 'Naturalization')) 
		RAISERROR(60210, 16, 1, 'The specified forecast is of a class that does not supprt estimation inputs');

		IF (0 = (SELECT count(*) FROM Demographics.Estimation WHERE EstimationID = @estimationid AND Class = @c))
		RAISERROR(60210, 16, 2, 'The specified estimation does not exist or is of an invalid class');

		IF (@p IS NULL) RAISERROR(60205, 16, 1);
		IF (@p = 1) RAISERROR(60206, 16, 1);
		IF (@replace = 0)
		BEGIN
			IF (@r = 1) RAISERROR(60207, 16, 1, 'The specified forecast is readonly and @replace was not set.');
			IF (@eid IS NOT NULL) RAISERROR(60207,16, 2, 'The specified forecast is readonly and @replace was not set.');
		END
		
	END TRY
	BEGIN CATCH
		EXECUTE dbo.uspLogError;
		EXECUTE dbo.uspRethrowError;
		RETURN -1;
	END CATCH

	BEGIN TRY
		UPDATE Demographics.Forecast
		SET EstimationID = @estimationid
		WHERE ForecastID = @forecastid;
		RETURN 0;
	END TRY
	BEGIN CATCH
	  IF @@trancount > 0 ROLLBACK;
		EXECUTE dbo.uspLogError;
		EXECUTE dbo.uspRethrowError;
		RETURN 1;	
	END CATCH

END
GO