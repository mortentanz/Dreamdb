/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspInsertProjection.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspInsertProjection
  
  Purpose     : Inserts projection identification in the database while maintaining referential integrity.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspInsertProjection', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspInsertProjection
GO

CREATE PROCEDURE Demographics.uspInsertProjection (
  @projectionid smallint output,
  @revision tinyint output,
  @created datetime output,
  @modified datetime output,
  @replace bit = 0,
  @title varchar(100),
  @caption varchar(100) = null,
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
    SELECT 
      @e = isnull(convert(bit, p.ProjectionID), 0), 
      @id = p.ProjectionID, @ro = p.IsReadOnly, @r = isnull(p.Revision, 0)
    FROM Demographics.Projection p
    WHERE 
      p.Title = @title AND 
      p.Revision = (SELECT max(Revision) FROM Demographics.Projection WHERE Title = @title)
    ;
    -- Projection exists, replace was specified but projection is marked readonly
    IF (@e = 1) AND (@replace = 1) AND (@ro = 1) RAISERROR(60104, 16, 1);
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

      -- Projection exists so get attributes from current version
      SELECT 
        @caption = coalesce(@caption, Caption),
        @params = coalesce(@params, Parameters), 
        @created = Created,
        @texten = coalesce(@texten, TextEn),
        @textda = coalesce(@textda, TextDa)
      FROM Demographics.Projection 
      WHERE ProjectionID = @id
      ;

      -- Derive revision number from semantics: If replacing a revision use existing, otherwise increment
      SET @revision = CASE WHEN (@replace = 1) THEN @r ELSE @r + 1 END;

      -- If we are replacing an existing revision, delete (to reinsert).
      -- Will fail if any forecast contains the id of the current projection in the ReferenceID column (by FK relation)
      -- Data is deleted on next run of cleanup job.
      IF (@replace = 1)
      DELETE FROM Demographics.Projection WHERE ProjectionID = @id;

    END

    SET @texten = coalesce(@texten, 'No description given.');
    SET @textda = coalesce(@textda, 'Beskrivelse mangler.');

    INSERT Demographics.Projection
    VALUES (@title, @caption, @revision, @created, @modified, @user, @login, @isreadonly, @ispublished, @texten, @textda, @params);
    SET @projectionid = scope_identity();
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