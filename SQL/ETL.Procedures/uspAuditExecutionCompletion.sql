/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspAuditExecutionCompletion.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure     : ETL.uspAuditExecutionCompletion
  
  Description   : Ends an audit trail in the database.
  
  Returns       : Zero if succesful and nonzero otherwise.

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'ETL.uspAuditExecutionCompletion', N'P') IS NOT NULL
DROP PROCEDURE ETL.uspAuditExecutionCompletion
GO

CREATE PROCEDURE ETL.uspAuditExecutionCompletion (
  @auditid int,
  @rowsextracted int = null,
  @rowsloaded int = null,
  @rowsinerror int = null,
  @success bit = null
)
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY
    IF (NOT EXISTS (SELECT * FROM ETL.ExecutionAudit WHERE AuditID = @auditid)) RAISERROR(60007, 16, 1);
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspPrintError;
    RETURN 1;
  END CATCH
  
  BEGIN TRY
    UPDATE ETL.ExecutionAudit
    SET 
      RowsExtracted = @rowsextracted, RowsLoaded = @rowsloaded, RowsInError = @rowsinerror, 
      Success = @success
    WHERE AuditID = @auditid;
    RETURN 0;
  END TRY
  BEGIN CATCH
    IF (@@trancount > 0) ROLLBACK;
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspPrintError;
    RETURN 1;
  END CATCH

END
GO