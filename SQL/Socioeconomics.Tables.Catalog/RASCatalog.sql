/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Catalog/RASCatalog.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $
  
  Table         : Socioeconomics.RASCatalog
  
  Purpose       : Catalogs data sets from the register-based labourmarket statistics (RAS)
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.RASCatalog', 'U') IS NOT NULL
DROP TABLE Socioeconomics.RASCatalog
GO

CREATE TABLE Socioeconomics.RASCatalog (
  
  DatasetID smallint identity(1,1) not null,
  Setname varchar(30) not null,
  DataRevision char not null,
  StatusRevision tinyint not null,
  DateLoaded datetime not null,
  [Year] smallint not null,
  TextEn varchar(400) 
		constraint DF_RASCatalog_TextEn default 'No description given' not null,
  TextDa varchar(400) collate Danish_Norwegian_CI_AS 
		constraint DF_RASCatalog_TextDa default 'Ingen beskrivelse' not null,

  CONSTRAINT PK_RASCatalog PRIMARY KEY (DatasetID DESC),

  CONSTRAINT IX_RASCatalog_Unique UNIQUE (Setname, DataRevision, [Year])

)
GO

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Catalogs datasets from RAS',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Surrogate primary key for RAS dataset',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'The name of the dataset',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'Setname'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'The year of observation at primo convention',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Dataset revision',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'DataRevision'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Revision identifier for status definition',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'StatusRevision'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Date and time that the dataset was loaded into the database',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'DateLoaded'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Description of dataset',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Description of dataset in Danish',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RASCatalog', N'COLUMN', N'TextDa'

GO