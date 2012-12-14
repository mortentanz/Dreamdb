/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspDefineProjectionForecast.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspDefineProjectionForecast
  
  Purpose     : Associates a projection with a forecastm or updates an existing association
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspDefineProjectionForecast', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspDefineProjectionForecast
GO

CREATE PROCEDURE Demographics.uspDefineProjectionForecast (
	@projectionid smallint,
	@forecastid smallint,
	@replace bit = 0
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @p bit;
		DECLARE @r bit;

		SELECT @p = IsPublished, @r = IsReadOnly FROM Demographics.Projection WHERE ProjectionID = @projectionid;
		IF (@p IS NULL) RAISERROR(60105, 16, 1);
		IF (@p = 1) RAISERROR(60106, 16, 1);
		IF (@r = 1) AND (@replace = 0) 
		RAISERROR(60107, 16, 1, 'The specified projection is readonly and @replace was not set.');

		DECLARE @fid smallint;
		DECLARE @c varchar(20);

		SELECT @c = Class FROM Demographics.Forecast WHERE ForecastID = @forecastid;
		IF (@c IS NULL) RAISERROR(60110, 16, 1, 'The specified forecast does not exist');

		SELECT @fid = f.ForecastID
		FROM Demographics.Forecast f
		INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
		WHERE 
			f.Class = @c AND
			pf.ProjectionID = @projectionid
		;
		IF (@fid IS NOT NULL) AND (@replace = 0) 
		RAISERROR(60107, 16, 2, 'This class of forecast is already defined and @replace was not set.');

	END TRY
	BEGIN CATCH
		EXECUTE dbo.uspLogError;
		EXECUTE dbo.uspRethrowError;
		RETURN -1;
	END CATCH

		
	BEGIN TRY
		IF (@fid IS NOT NULL)
		BEGIN
			UPDATE Demographics.ProjectionForecast
			SET ForecastID = @forecastid
			WHERE ProjectionID = @projectionid AND ForecastID = @fid;
			RETURN 0;
		END
		ELSE
		BEGIN
			INSERT Demographics.ProjectionForecast
			VALUES (@projectionid, @forecastid);
			RETURN 0;
		END	
	END TRY
	
	BEGIN CATCH
	  IF @@trancount > 0 ROLLBACK;
		EXECUTE dbo.uspLogError;
		EXECUTE dbo.uspRethrowError;
		RETURN 1;
	END CATCH

END
GO