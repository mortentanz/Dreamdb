/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspAuditExecution.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure     : ETL.uspAuditExecution
  
  Description   : Inserts an audit trail in the database.
  
  Returns       : Zero if succesful and nonzero otherwise.

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'ETL.uspAuditExecution', N'P') IS NOT NULL
DROP PROCEDURE ETL.uspAuditExecution
GO

CREATE PROCEDURE ETL.uspAuditExecution (
  @auditid int OUTPUT,
  @machine nvarchar(128),
  @user nvarchar(128),
  @packageid nvarchar(38),
  @packagename nvarchar(128),
  @packagetime datetime
)
AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @packageguid uniqueidentifier;
  DECLARE @taskguid uniqueidentifier;

  BEGIN TRY
    IF (@machine IS NULL) RAISERROR(80005, 16, 1, N'@machine');
    IF (@user IS NULL) RAISERROR(80005, 16, 1, N'@user');
    IF (@packageid IS NULL) RAISERROR(80005, 16, 1, N'@packageid');
    IF (@packagename IS NULL) RAISERROR(80005, 16, 1, N'@packagename');
    IF (@packagetime IS NULL) RAISERROR(80005, 16, 1, N'@packagetime');
    SET @packageguid = convert(uniqueidentifier, @packageid);
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspPrintError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    INSERT ETL.ExecutionAudit VALUES (
      @machine, @user, @packageguid, @packagename, @packagetime, NULL, NULL, NULL, NULL
    );
    SET @auditid = scope_identity();
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