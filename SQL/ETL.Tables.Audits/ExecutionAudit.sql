/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Audits/ExecutionAudit.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.ExecutionAudit
  
  Purpose       : Logs ETL package execution

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.ExecutionAudit', 'U') IS NOT NULL
DROP TABLE ETL.ExecutionAudit
GO

CREATE TABLE ETL.ExecutionAudit (

  AuditID int identity(1,1) not null,

  MachineName sysname not null,
  UserName sysname not null,

  PackageID uniqueidentifier not null,
  PackageName nvarchar(128) not null,
  PackageStartTime datetime not null,

  RowsExtracted int null,
  RowsLoaded int null,
  RowsInError int null,

  Success bit null,
    
  CONSTRAINT PK_ExecutionAudit PRIMARY KEY (AuditID DESC)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'ETL package execution auditing.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Id of audit entry.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'AuditID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Name of machine executing package.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'MachineName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'User name executing package.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'UserName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Global unique identifier of package.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'PackageID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Name of package.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'Packagename'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Time and date that package started.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'PackageStartTime'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The number of rows extracted by the task (if any).',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'RowsExtracted'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The number of rows loaded in the database (if any).',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'RowsLoaded'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The number of rows having errors (if any).',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'RowsInError'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Flag indicating whether execution was successful.',
N'SCHEMA', N'ETL', N'TABLE', N'ExecutionAudit', N'COLUMN', N'Success'
GO