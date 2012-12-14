/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspInsertDSDataset.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspInsertDSDataset
  
  Purpose     : Inserts identification of a dataset in the DSCatalog and returns a dataset id.                 
              
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspInsertDSDataset', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspInsertDSDataset
GO

CREATE PROCEDURE Demographics.uspInsertDSDataset (
  @datasetid smallint = 0 output,
  @setname varchar(30),
  @year smallint,
  @revision tinyint = null,
  @dateloaded datetime = null,
  @isarchived bit = 0
)
AS
BEGIN
  
  BEGIN TRY
    IF (@setname IS NULL) RAISERROR(80005, 16, 1, '@setname');
    IF (@year IS NULL) RAISERROR(80005, 16, 2, '@year');
    IF (NOT @setname IN (
      N'BEFA', N'DODE', N'FODT', N'INDV', N'MOAR', N'UDVA', N'IEBFM', N'IPERMITS', N'EPERMITS', N'CHILDREN')
    ) RAISERROR(60102, 16, 1);
    SET @revision = coalesce(@revision, 1);
    SET @dateloaded = coalesce(@dateloaded, getdate());
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH
  
  BEGIN TRY
    INSERT Demographics.DSCatalog 
    VALUES (@setname, @revision, @year, @dateloaded, @isarchived, default, default);
    SET @datasetid = scope_identity();
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 2;
  END CATCH

END
GO