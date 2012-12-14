/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Logs/ErrorLog.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.ErrorLog

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.ErrorLog', 'U') IS NOT NULL
DROP TABLE dbo.ErrorLog
GO

CREATE TABLE dbo.ErrorLog (

  ErrorLogID int identity(1,1) not null,
  ErrorTime datetime not null constraint DF_ErrorLog_ErrorTime default (getdate()),
  UserName sysname not null,
  LoginName sysname null,
  ErrorNumber int not null,
  ErrorSeverity int not null,
  ErrorState int not null,
  ErrorProcedure nvarchar(126) null,
  ErrorLine int null,
  ErrorMessage nvarchar(4000) not null,
  
  CONSTRAINT PK_ErrorLog PRIMARY KEY CLUSTERED (ErrorLogID DESC)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Log of errors raised by stored procedures',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorLogID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The date and time the error was raised',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorTime'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The database user name of the user executing the command leading to error',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'UserName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The database login name of the user executing the command leading to error',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'LoginName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The error number associated with the error',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorNumber'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The error severity level associated with the error',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorSeverity'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The error state associated with the error',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorState'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The name of the procedure rasing the error (may be null)',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorProcedure'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The line number in the procedure rasing the error (may be null)',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorLine'

EXECUTE sp_addextendedproperty
N'MS_Description', N'A message describning the error',
N'SCHEMA', N'dbo', N'TABLE', N'ErrorLog', N'COLUMN', N'ErrorMessage'
GO