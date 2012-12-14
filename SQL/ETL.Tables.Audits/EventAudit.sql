/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Audits/EventAudit.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.EventAudit
  
  Purpose       : Logs SSIS executable events

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.EventAudit', 'U') IS NOT NULL
DROP TABLE ETL.EventAudit
GO

CREATE TABLE ETL.EventAudit (

  EventID int identity(1,1) not null,  
  AuditID int not null,
  
  PackageID uniqueidentifier not null,
  PackageName nvarchar(128) not null,
  PackageStartTime datetime not null,

  TaskID uniqueidentifier not null,
  TaskName nvarchar(128) not null,
  TaskStartTime datetime not null,

  EventType nvarchar(20) not null,
  EventTime datetime not null,
  EventCode int null,
  EventDescription nvarchar(1000) null,
  
  CONSTRAINT PK_EventAudit PRIMARY KEY (EventID DESC),
  
  CONSTRAINT FK_EventAudit_ExecutionAudit FOREIGN KEY (AuditID)
  REFERENCES ETL.ExecutionAudit (AuditID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'SSIS container and executable event audits.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Event identification (identity column).',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'EventID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for package audit trail.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'AuditID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Global unique identifier of package.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'PackageID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Name of package.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'Packagename'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Time and date that package started.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'PackageStartTime'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Global unique identifier of task (or container) raising the event.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'TaskID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Name of task (or container) raising the event.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'TaskName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Time and date that task (or container) was started.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'TaskStartTime'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Time and date that the event handler started.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'EventTime'

EXECUTE sp_addextendedproperty
N'MS_Description', N'String identifying the type of event (eg. OnPreExecute, OnWarning etc.).',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'EventType'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Code identifying event (eg. error code).',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'EventCode'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Description of execution event.',
N'SCHEMA', N'ETL', N'TABLE', N'EventAudit', N'COLUMN', N'EventDescription'
GO