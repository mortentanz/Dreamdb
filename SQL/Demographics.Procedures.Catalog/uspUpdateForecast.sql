/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspUpdateForecast.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspUpdateForecast
  
  Purpose     : Updates forecast identification in the database while maintaining referential integrity.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspUpdateForecast', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspUpdateForecast
GO

CREATE PROCEDURE Demographics.uspUpdateForecast (
  @forecastid smallint,
	@created datetime output,
	@modified datetime output,  
  @title varchar(100) = null,
  @caption varchar(100) = null,
  @referenceid smallint = null,
  @estimationid smallint = null,
  @isreadonly bit = 0,
  @ispublished bit = 0,
  @texten varchar(600) = null,
  @textda varchar(600) = null,
  @params xml = null
) 
AS 
BEGIN

  SET NOCOUNT ON;

  DECLARE @t varchar(100);  
  DECLARE @c varchar(100);
  DECLARE @rid smallint;
  DECLARE @eid smallint
  DECLARE @r bit;
  DECLARE @p bit;
  DECLARE @te varchar(600);
  DECLARE @td varchar(600);
  DECLARE @x xml;

  BEGIN TRY
    IF (@forecastid IS NULL) RAISERROR(80005, 16, 1, '@projectionid');
    IF (NOT EXISTS (SELECT * FROM Demographics.Forecast WHERE ForecastID = @forecastid)) 
      RAISERROR(60205, 16, 2);

    IF (@referenceid IS NOT NULL) 
    AND (0 = (SELECT COUNT(*) FROM Demographics.Projection WHERE ProjectionID = @referenceid))
    RAISERROR(60210, 16, 2, 'The specified reference projection does not exist.');

    IF (@estimationid IS NOT NULL) AND (0 = (
			SELECT count(*) FROM Demographics.Estimation e
			INNER JOIN Demographics.Forecast f ON f.EstimationID = e.EstimationID AND e.Class = f.Class
			WHERE f.ForecastID = @forecastid
    )) RAISERROR(60210, 16, 1, 'The specified estimation is not found or is not of the correct class');   

    SELECT 
      @t = Title, @c = Caption, @rid = ReferenceID, @eid = EstimationID, @created = Created,
      @r = IsReadOnly, @p = IsPublished, @te = TextEn, @td = TextDa, @x = Parameters
    FROM Demographics.Forecast
    WHERE ForecastID = @forecastid;
    
    -- Projection is published so it is all hands off
    IF (@p = 1) RAISERROR(60206, 16, 3); 
    
    -- Readonly bit is set and not altered by argument
    IF (@r = 1) AND (isnull(@isreadonly, 0) = 0) RAISERROR(60207, 16, 4); 

  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    SET @modified = getdate();
    
    UPDATE Demographics.Forecast
    SET 
      Title = coalesce(@title, @t), 
      Caption = coalesce(@caption, @t), 
      ReferenceID = coalesce(@referenceid, @rid),
      EstimationID = coalesce(@estimationid, @eid),
      Modified = @modified,
      IsReadOnly = coalesce(@isreadonly, @r),
      IsPublished = coalesce(@ispublished, @p),
      TextEn = coalesce(@texten, @te),
      TextDa = coalesce(@textda, @td),
      Parameters = coalesce(@params, @x)
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