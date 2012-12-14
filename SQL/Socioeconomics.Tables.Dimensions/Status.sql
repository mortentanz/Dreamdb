/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Dimensions/Status.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.Status
  
  Purpose       : Socioeconomic status as derived of labourmarket and social status
  
	Primary key		: StatusID (surrogate primary key)

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Socioeconomics.Status', N'U') IS NOT NULL
DROP TABLE Socioeconomics.Status
GO

CREATE TABLE Socioeconomics.Status (
  StatusID smallint identity(1,1) not null,
  Revision tinyint not null,
  Label varchar(31) not null,
  TextEn varchar(128) not null,
  TextDa varchar(128) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Status PRIMARY KEY (StatusID),
  
  CONSTRAINT IX_Status_Unique UNIQUE (Revision, Label)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Socioeconomic status as derived of labourmarket and social status',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'Status'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'Status', N'COLUMN', N'StatusID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Revision of socioeconomic status',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'Status', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Symbolic label',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'Status', N'COLUMN', N'Label'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Descriptive text',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'Status', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Descriptive text in Danish',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'Status', N'COLUMN', N'TextDa'
GO