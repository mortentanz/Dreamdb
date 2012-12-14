/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Procedures.Catalog/uspInsertRASDataset.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : Socioeconomics.uspInsertRASDataset
  
  Purpose     : Inserts identification of a RAS dataset in the RASCatalog and returns a dataset id. The 
                following invariants are maintained by the procedure:
                
              
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Socioeconomics.uspInsertRASDataset', N'P') IS NOT NULL
DROP PROCEDURE Socioeconomics.uspInsertRASDataset
GO

CREATE PROCEDURE Socioeconomics.uspInsertRASDataset (
  @datasetid smallint = 0 output,
  @setname varchar(30),
  @datarevision char,
  @statusrevision tinyint,
  @year smallint,
  @dateloaded datetime = null
) AS
BEGIN

  SET NOCOUNT ON;

  -- Validate input parameters and test for validity
  BEGIN TRY
    IF @setname IS NULL RAISERROR(80005, 16, 1, N'@setname');
    IF @datarevision IS NULL RAISERROR(80005, 16, 2, N'@datarevision');
    IF @statusrevision IS NULL RAISERROR(80005, 16, 3, N'@statusrevision');
    IF @year IS NULL RAISERROR(80005, 16, 4, N'@year');
    SET @dateloaded = isnull(@dateloaded, getdate());

    IF NOT EXISTS (SELECT * FROM Socioeconomics.StatusTree WHERE Revision = @statusrevision)
    RAISERROR(60101, 16, 1);
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    INSERT INTO Socioeconomics.RASCatalog VALUES ( 
      @setname, @datarevision, @statusrevision, 
      @dateloaded, @year, default, default
    );
    SET @datasetid = scope_identity();
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH
  
END
GO