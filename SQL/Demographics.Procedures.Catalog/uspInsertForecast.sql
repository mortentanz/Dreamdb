/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspInsertForecast.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspInsertForecast
  
  Purpose     : Inserts forecast identification in the database while maintaining referential integrity.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspInsertForecast', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspInsertForecast
GO

CREATE PROCEDURE Demographics.uspInsertForecast (
  @forecastid smallint output,
  @revision tinyint output,
  @created datetime output,
  @modified datetime output,
  @replace bit = 0,  
  @class varchar(20),
  @title varchar(100),
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
  
  DECLARE @e bit;
  DECLARE @id smallint;
  DECLARE @ro bit;
  DECLARE @r tinyint;

  BEGIN TRY
    IF (@title IS NULL) RAISERROR(80005, 16, 1, '@title');
    SET @title = ltrim(rtrim(@title));
    
    IF (@class IS NULL) RAISERROR(80005, 16, 2, '@class');
    SET @class = ltrim(rtrim(@class));
    
    IF NOT (@class IN ('Naturalization', 'Emigration', 'Immigration', 'Mortality', 'Fertility', 'Birth')) 
    RAISERROR(60202, 16, 1);
    
    IF (@class = 'Mortality') AND (@estimationid IS NULL)
    RAISERROR(60201, 16, 1, 'Generation of DREAM input of historic mortality rates requires an estimation id.');
    
    IF (@estimationid IS NOT NULL)
    AND (@class <> (SELECT Class FROM Demographics.Estimation WHERE EstimationID = @estimationid))
    RAISERROR(60201, 16, 2, 'The specified estimation is not of the correct class');   
    
    IF (@referenceid IS NOT NULL)
    AND (0 = (SELECT COUNT(*) FROM Demographics.Projection WHERE ProjectionID = @referenceid))
    RAISERROR(60201, 16, 3, 'The specified reference projection does not exist.');
    
    SELECT 
      @e = isnull(convert(bit, f.ForecastID), 0), 
      @id = f.ForecastID, @ro = f.IsReadOnly, @r = isnull(f.Revision, 0)
    FROM Demographics.Forecast f
    WHERE 
      f.Title = @title AND f.Class = @class AND
      f.Revision = (SELECT max(Revision) FROM Demographics.Forecast WHERE Title = @title AND Class = @class)
    ;
    -- Forecast exists, replace was specified but forecast is marked readonly
    IF (@e = 1) AND (@replace = 1) AND (@ro = 1) RAISERROR(60204, 16, 1);
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    DECLARE @user sysname;
    DECLARE @login sysname;
    
    SET @created = getdate();
    SET @modified = getdate();
    SET @user = convert(sysname, current_user);
    SET @login = convert(sysname, system_user);
    SET @revision = 1;
    
    IF (@e = 1)
    BEGIN

      -- Forecast exists so get attributes from current version
      SELECT 
        @caption = coalesce(@caption, Caption), 
        @referenceid = coalesce(@referenceid, ReferenceID),
        @estimationid = coalesce(@estimationid, EstimationID),
        @created = Created,
        @texten = coalesce(@texten, TextEn),
        @textda = coalesce(@textda, TextDa),
        @params = coalesce(@params, Parameters)
      FROM Demographics.Forecast
      WHERE ForecastID = @id
      ;

      -- Derive revision number from semantics: If replacing a revision use existing, otherwise increment
      SET @revision = CASE WHEN (@replace = 1) THEN @r ELSE @r + 1 END;

      -- If we are replacing an existing revision, delete (to reinsert). Implies that all data is deleted as well!!
      IF (@replace = 1)
      DELETE FROM Demographics.Forecast WHERE ForecastID = @id;

    END

    SET @texten = coalesce(@texten, 'No description given.');
    SET @textda = coalesce(@textda, 'Beskrivelse mangler.');

    INSERT Demographics.Forecast
    VALUES (
      @class, @title, @caption, @referenceid, @estimationid, 
      @revision, @created, @modified, @user, @login, @isreadonly, @ispublished, @texten, @textda, @params
     );
    SET @forecastid = scope_identity();
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