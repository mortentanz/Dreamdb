/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspInsertEstimation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspInsertEstimation
  
  Purpose     : Inserts Estimation in the database while maintaining referential integrity.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspInsertEstimation', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspInsertEstimation
GO

CREATE PROCEDURE Demographics.uspInsertEstimation (
  @estimationid smallint output,
  @revision tinyint output,
  @created datetime output,
  @modified datetime output,
  @replace bit = 0,
  @class varchar(20),
  @title varchar(100),
  @caption varchar(100) = null,
  @firstyear smallint,
  @lastyear smallint,
  @lastsampleyear smallint = null,
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

    IF NOT (@class IN ('Mortality', 'Fertility', 'Emigration', 'Immigration')) RAISERROR(60302, 16, 1);
    
    IF (@firstyear IS NULL) RAISERROR(80005, 16, 3, '@firstyear');
    IF (@lastyear IS NULL) RAISERROR(80005, 16, 4, '@lastyear');
    IF (@lastsampleyear IS NULL) AND (@class IN ('Mortality', 'Fertility')) RAISERROR(80005, 16, 5, '@lastsampleyear');
    
    IF (@firstyear > @lastyear) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear');
    IF (@class IN ('Mortality', 'Fertility'))
    BEGIN
			IF (@firstyear > @lastsampleyear) RAISERROR(80001, 16, 2, '@firstyear', '@lastsampleyear');
			IF (@lastsampleyear > @lastyear) RAISERROR(80001, 16, 3, '@lastsampleyear', '@lastyear');
    END
  
    SELECT 
      @e = isnull(convert(bit, e.EstimationID), 0), 
      @id = e.EstimationID, @ro = e.IsReadOnly, @r = isnull(e.Revision, 0)
    FROM Demographics.Estimation e
    WHERE 
      e.Title = @title AND e.Class = @class AND
      e.Revision = (SELECT max(Revision) FROM Demographics.Estimation WHERE Title = @title AND Class = @class)
    ;
    -- Estimation exists, replace was specified but projection is marked readonly
    IF (@e = 1) AND (@replace = 1) AND (@ro = 1) RAISERROR(60304, 16, 1);
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
    SET @revision = 0;
    
    IF (@e = 1)
    BEGIN

      -- Estimation exists so get attributes from current version
      SELECT 
        @caption = coalesce(@caption, Caption), 
        @created = Created,
        @texten = coalesce(@texten, TextEn),
        @textda = coalesce(@textda, TextDa)
      FROM Demographics.Estimation
      WHERE EstimationID = @id
      ;

      -- Derive revision number from semantics: If replacing a revision use existing, otherwise increment
      SET @revision = CASE WHEN (@replace = 1) THEN @r ELSE @r + 1 END;

      -- If we are replacing an existing revision, delete (to reinsert). Implies that all data is deleted as well!!
      IF (@replace = 1)
      DELETE FROM Demographics.Estimation WHERE EstimationID = @id;

    END

    SET @texten = coalesce(@texten, 'No description given.');
    SET @textda = coalesce(@textda, 'Beskrivelse mangler.');

    INSERT Demographics.Estimation
    VALUES (
      @class, @title, @caption, @firstyear, @lastyear, @lastsampleyear, 
      @revision, @created, @modified, @user, @login, @isreadonly, @ispublished, @texten, @textda, @params
    );
    SET @estimationid = scope_identity();
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