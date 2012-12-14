/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspAuditEvent.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : ETL.uspAuditEvent
  
  Purpose     : Audits SSIS package events
              
  Returns     : The procedure always return zero if sucessful and a nonsero value otherwise.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspAuditEvent', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspAuditEvent
GO

CREATE PROCEDURE ETL.uspAuditEvent (
  @auditid int,
  @packageid nvarchar(38),
  @packagename nvarchar(255),
  @packagetime datetime,
  @taskid nvarchar(38),
  @taskname nvarchar(255),
  @tasktime datetime,
  @eventtype nvarchar(20),
  @eventtime datetime,
  @eventcode int = null,
  @eventdescription nvarchar(1000) = null
)
AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @packageguid uniqueidentifier;
  DECLARE @taskguid uniqueidentifier; 

  BEGIN TRY
    IF (NOT EXISTS (SELECT * FROM ETL.ExecutionAudit WHERE AuditID = @auditid)) RAISERROR(60006, 16, 1);
    IF (@packageid IS NULL) RAISERROR(80005, 16, 1, N'@packageid');
    IF (@packagename IS NULL) RAISERROR(80005, 16, 1, N'@packagename');
    IF (@packagetime IS NULL) RAISERROR(80005, 16, 1, N'@packagetime');
    IF (@taskid IS NULL) RAISERROR(80005, 16, 1, N'@taskid');
    IF (@taskname IS NULL) RAISERROR(80005, 16, 1, N'@taskname');
    IF (@tasktime IS NULL) RAISERROR(80005, 16, 1, N'@tasktime');
    IF (@eventtype IS NULL) RAISERROR(80005, 16, 1, N'@eventtype');
    IF (@eventtime IS NULL) RAISERROR(80005, 16, 1, N'@eventtime');
    SET @packageguid = convert(uniqueidentifier, @packageid);
    SET @taskguid = convert(uniqueidentifier, @taskid);
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspPrintError;
    RETURN -1;
  END CATCH

  BEGIN TRY
    INSERT ETL.EventAudit VALUES (
      @auditid, @packageguid, @packagename, @packagetime, @taskguid, @taskname, @tasktime,
      @eventtype, @eventtime, @eventcode, @eventdescription
    );
    RETURN 0;
  END TRY
  BEGIN CATCH
    IF (@@trancount > 0) ROLLBACK;
    EXECUTE dbo.uspLogError
    EXECUTE dbo.uspPrintError
    RETURN 1;
  END CATCH

END
GO