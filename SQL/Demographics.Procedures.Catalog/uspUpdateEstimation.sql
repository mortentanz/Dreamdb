/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspUpdateEstimation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspUpdateEstimation
  
  Purpose     : Updates estimation identification in the database while maintaining referential integrity.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspUpdateEstimation', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspUpdateEstimation
GO

CREATE PROCEDURE Demographics.uspUpdateEstimation (
  @estimationid smallint,
 	@created datetime output,
	@modified datetime output,  
  @title varchar(100) = null,
  @caption varchar(100) = null,
  @firstyear smallint = null,
  @lastyear smallint = null,
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

  DECLARE @t varchar(100);  
  DECLARE @c varchar(100);
  DECLARE @fy smallint;
  DECLARE @ly smallint;
  DECLARE @lsy smallint;
  DECLARE @r bit;
  DECLARE @p bit;
  DECLARE @te varchar(600);
  DECLARE @td varchar(600);
  DECLARE @x xml;

  BEGIN TRY
    IF (@estimationid IS NULL) RAISERROR(80005, 16, 1, '@estimationid');
    IF (NOT EXISTS (SELECT * FROM Demographics.Estimation WHERE EstimationID = @estimationid)) 
      RAISERROR(60305, 16, 2);

    SELECT 
      @t = Title, @c = Caption, @fy = FirstYear, @ly = LastYear, @lsy = LastSampleYear, @created = Created,
      @r = IsReadOnly, @p = IsPublished, @te = TextEn, @td = TextDa, @x = Parameters
    FROM Demographics.Estimation
    WHERE EstimationID = @estimationid;
    
    -- Estimation is published so it is all hands off
    IF (@p = 1) RAISERROR(60306, 16, 3); 
    
    -- Readonly bit is set and not altered by argument
    IF (@r = 1) AND (isnull(@isreadonly, 0) = 0) RAISERROR(60307, 16, 4);

  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    UPDATE Demographics.Estimation
    SET 
      Title = coalesce(@title, @t), 
      Caption = coalesce(@caption, @t), 
      FirstYear = coalesce(@fy, @firstyear),
      LastYear = coalesce(@ly, @lastyear),
      LastSampleYear = coalesce(@lsy, @lastsampleyear),
      Modified = getdate(),
      IsReadOnly = coalesce(@isreadonly, @r),
      IsPublished = coalesce(@ispublished, @p),
      TextEn = coalesce(@texten, @te),
      TextDa = coalesce(@textda, @td),
      Parameters = coalesce(@params, @x)
    WHERE EstimationID = @estimationid;
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