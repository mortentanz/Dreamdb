/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspInsertDSDimension.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : ETL.uspInsertDSDimension
  
  Purpose     : Inserts identification of a dimension lookup table containing source classifiers from
                Statistics Denmark.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'ETL.uspInsertDSDimension', N'P') IS NOT NULL
DROP PROCEDURE ETL.uspInsertDSDimension
GO

CREATE PROCEDURE ETL.uspInsertDSDimension (
  @dsdimensionid smallint output,
  @revision tinyint output,
  @title varchar(20),
  @tablename sysname,
  @created datetime = null,
  @modified datetime = null,
  @texten varchar(100) = null,
  @textda varchar(100) = null
)
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY
    IF (@title IS NULL) RAISERROR(80005, 16, 1, '@title');
    IF (@tablename IS NULL) RAISERROR(80005, 16, 2, '@tablename');
    IF (NOT EXISTS (SELECT * FROM sys.tables WHERE name = @tablename)) RAISERROR(60002, 16, 1);
    
    SET @created = coalesce(@created, getdate());
    SET @modified = coalesce(@modified, @created);
    SET @texten = coalesce(@texten, 'Description is pending');
    SET @textda = coalesce(@textda, 'Beskrivelse mangler');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  BEGIN TRY
    DECLARE @r tinyint;
    SELECT @r = convert(tinyint, isnull(max(Revision) + 1, 1)) FROM ETL.DSDimension WHERE Title = @title;
    SET @revision = coalesce(@revision, @r);
    
    INSERT ETL.DSDimension VALUES (@title, @tablename, @revision, @created, @modified, @texten, @textda); 
    SET @dsdimensionid = SCOPE_IDENTITY();
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH

END
GO