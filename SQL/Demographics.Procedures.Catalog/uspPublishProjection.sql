/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspPublishProjection.sql $
  $Revision: 2 $
  $Date: 12/19/06 16:08 $
  $Author: mls $

  Procedure   : Demographics.uspPublishProjection
  
  Purpose     : Sets the IsPublished bit on a projection after validating the integrity of the projection.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspPublishProjection', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspPublishProjection
GO

CREATE PROCEDURE Demographics.uspPublishProjection (
  @projectionid smallint,
  @caption varchar(100) = null,
  @validatestrict bit = 0
) AS
BEGIN

  SET NOCOUNT ON;  

  BEGIN TRY

    DECLARE @c varchar(100);
    SELECT @c = coalesce(@caption, Caption) FROM Demographics.Projection WHERE ProjectionID = @projectionid;
  
    IF (0 = dbo.ufnIsValidCaption(@c)) 
    RAISERROR(60108, 16, 1, 'The specified caption is invalid. Captions must adhere to windows filename conventions');
    
    IF (0 = (SELECT count(*) FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 2, 'The specified projection does not exists.');
    
    IF (0 = (SELECT count(*) FROM Demographics.[Population] WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 3, 'Population data is not available for the specified projection.');
  
    IF (0 = (SELECT count(*) FROM Demographics.Deaths WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 4, 'Number of deaths is not available for the specified projection.');
    
    IF (0 = (SELECT count(*) FROM Demographics.Children WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 5, 'Number of children by age of mothers is not available for the specified projection');

    IF (0 = (SELECT count(*) FROM Demographics.Heirs WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 6, 'Number of heirs by age of mothers is not available for the specified projection');
    
    IF (0 = (SELECT count(*) FROM Demographics.Emigrants WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 7, 'Number of emmigrants is not available for the specified projection');
    
    IF (0 = (SELECT count(*) FROM Demographics.Immigrants WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 8, 'Number of immigrants is not available for the specified projection');
    
    IF (0 = (SELECT count(*) FROM Demographics.ResidenceDuration WHERE ProjectionID = @projectionid))
    RAISERROR(60108, 16, 9, 'Number of immigrants by duration of residence is not available for the specified projection');

    IF (0 = (SELECT count(*) 
      FROM Demographics.ForecastedMortality f
      INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
      INNER JOIN Demographics.Projection p ON pf.ProjectionID = @projectionid
    ))
    RAISERROR(60108, 16, 10, 'Forecasted mortality rates are not cataloged for the specified projection');

		IF (@validatestrict = 1)
		BEGIN
	    IF (SELECT Parameters FROM Demographics.Projection WHERE ProjectionID = @projectionid) IS NULL
      RAISERROR(60108, 16, 11, 'No runtime parameters are defined.');
		
			IF (0 = (SELECT count(*) FROM Demographics.Births WHERE ProjectionID = @projectionid))
			RAISERROR(60108, 16, 12, 'Number of births is not available for the specified projection.');

			IF (0 = (SELECT count(*) FROM Demographics.Mothers WHERE ProjectionID = @projectionid))
			RAISERROR(60108, 16, 13, 'Number of births by mothers origin is not available for the specified projection.');

			IF (0 = (SELECT count(*)
				FROM Demographics.ForecastedFertility f
				INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
				INNER JOIN Demographics.Projection p ON pf.ProjectionID = @projectionid
			)) 
			RAISERROR(60108, 16, 14, 'Forecasted fertility rates are not cataloged for the specified projection');

			IF (0 = (SELECT count(*)
				FROM Demographics.ForecastedEmmigration f
				INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
				INNER JOIN Demographics.Projection p ON pf.ProjectionID = @projectionid
			)) 
			RAISERROR(60108, 16, 15, 'Forecasted emigration is not cataloged for the specified projection');
	    
			IF (0 = (SELECT count(*)
				FROM Demographics.ForecastedImmigration f
				INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
				INNER JOIN Demographics.Projection p ON pf.ProjectionID = @projectionid
			)) 
			RAISERROR(60108, 16, 16, 'Forecasted immigration is not cataloged for the specified projection');

			IF (0 = (SELECT count(*)
				FROM Demographics.ForecastedNaturalization f
				INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
				INNER JOIN Demographics.Projection p ON pf.ProjectionID = @projectionid
			)) 
			RAISERROR(60108, 16, 17, 'Forecasted naturalization is not cataloged for the specified projection');

		END

  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  BEGIN TRY
    UPDATE Demographics.Projection
    SET Caption = @c, IsPublished = 1, IsReadOnly = 1
    WHERE ProjectionID = @projectionid
		;    

    UPDATE Demographics.Forecast
    SET IsPublished = 1, IsReadOnly = 1
    FROM Demographics.Forecast f
    INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
    WHERE pf.ProjectionID = @projectionid
    ;

    UPDATE Demographics.Estimation
    SET IsPublished = 1, IsReadOnly = 1
    FROM Demographics.Estimation e
    INNER JOIN Demographics.Forecast f ON f.EstimationID = e.EstimationID
    INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
    WHERE pf.ProjectionID = @projectionid
    ;

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