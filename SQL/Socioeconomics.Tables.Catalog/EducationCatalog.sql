/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Catalog/EducationCatalog.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.EducationCatalog
  
  Purpose       : Catalogs datasets with education data.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.EducationCatalog', 'U') IS NOT NULL
DROP TABLE Socioeconomics.EducationCatalog
GO

CREATE TABLE Socioeconomics.EducationCatalog (
  
  DatasetID smallint identity(1,1) not null,
  Setname varchar(30) not null,
  DataRevision char not null,
  DateLoaded datetime not null,
  [Year] smallint not null,
  TextEn varchar(400) 
		constraint DF_EducationCatalog_TextEn default 'No description given' not null,
  TextDa varchar(400) collate Danish_Norwegian_CI_AS 
		constraint DF_EducationCatalog_TextDa default 'Ingen beskrivelse' not null,

  CONSTRAINT PK_EducationCatalog PRIMARY KEY (DatasetID DESC),

  CONSTRAINT IX_EducationCatalog_Unique UNIQUE (Setname, DataRevision, [Year])
  
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Catalog of education datasets',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Name of dataset as specified in source file name',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'Setname'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Data revision identification',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'DataRevision'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date that the dataset was loaded in the database',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'DateLoaded'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Description of dataset',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Description of dataset in Danish',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationCatalog', N'COLUMN', N'TextDa'
GO