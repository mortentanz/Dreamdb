/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspUpdateProjection.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspUpdateProjection
  
  Purpose     : Updates projection identification in the database while maintaining referential integrity.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspUpdateProjection', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspUpdateProjection
GO

CREATE PROCEDURE Demographics.uspUpdateProjection (
  @projectionid smallint,
	@created datetime output,
	@modified datetime output,  
  @title varchar(100) = null,
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

  DECLARE @t varchar(100);  
  DECLARE @c varchar(100);
  DECLARE @r bit;
  DECLARE @p bit;
  DECLARE @e varchar(600);
  DECLARE @d varchar(600);
  DECLARE @x xml;

  BEGIN TRY
    IF (@projectionid IS NULL) RAISERROR(80005, 16, 1, '@projectionid');
    IF (NOT EXISTS (SELECT * FROM Demographics.Projection WHERE ProjectionID = @projectionid)) 
      RAISERROR(60105, 16, 2);

    SELECT 
			@t = Title, @c = Caption, @created = Created, 
			@r = IsReadOnly, @p = IsPublished, @e = TextEn, @d = TextDa, @x = Parameters
    FROM Demographics.Projection
    WHERE ProjectionID = @projectionid;
    
    -- Projection is published so it is all hands off
    IF (@p = 1) RAISERROR(60106, 16, 3); 
    
    -- Readonly bit is set and not altered by argument
    IF (@r = 1) AND (isnull(@isreadonly, 0) = 0) RAISERROR(60107, 16, 4);
    
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    SET @p = coalesce(@ispublished, @p);
    SET @r = CASE WHEN (@p = 1) THEN 1 ELSE coalesce(@isreadonly, @r) END;
    SET @modified = getdate();
    UPDATE Demographics.Projection
    SET 
      Title = coalesce(@title, @t), 
      Caption = coalesce(@caption, @t),
      Modified = @modified,
      IsPublished = @p,
      IsReadOnly = @r,
      TextEn = coalesce(@texten, @e),
      TextDa = coalesce(@textda, @d),
      Parameters = coalesce(@params, @x)
    WHERE ProjectionID = @projectionid;
  END TRY
  BEGIN CATCH
    IF @@trancount > 0 ROLLBACK;
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH

END
GO