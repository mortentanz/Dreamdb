/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Catalog/HMDCatalog.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.HMDCatalog
  
  Purpose       : Stores a catalog of HMD datasets available in the database

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.HMDCatalog', 'U') IS NOT NULL
DROP TABLE Demographics.HMDCatalog
GO

CREATE TABLE Demographics.HMDCatalog (

  DatasetID smallint identity(1,1) not null,
  Setname varchar(30) not null,
  Country varchar(20) not null,
  Gender varchar(8) not null,
  
  Modified datetime not null,
  Version varchar(20) not null,
  FirstYear smallint not null,
  LastYear smallint not null,
  
  DateLoaded datetime not null,

  TextEn varchar(400) 
		constraint DF_HMDCatalog_TextEn default 'No description given' not null,
  TextDa varchar(400) collate Danish_Norwegian_CI_AS 
		constraint DF_HMDCatalog_TextDa default 'Ingen beskrivelse' not null,
  
  CONSTRAINT PK_HMDCatalog PRIMARY KEY CLUSTERED (DatasetID DESC),
  CONSTRAINT IX_HMDCatalog_Unique UNIQUE (Setname, Country, Gender, Modified, Version)
  
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Catalog of Human Mortality Database datasets',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog'

EXECUTE sp_addextendedproperty
N'MS_Description', N'String identifying dataset contents',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'Setname'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The country described',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'Country'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Gender (currently Male, Female, Total)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'Gender'

EXECUTE sp_addextendedproperty
N'MS_Description', N'HMD modification date identicication',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'Modified'

EXECUTE sp_addextendedproperty
N'MS_Description', N'String identifying HMD version, e.g. HMD 4',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'Version'

EXECUTE sp_addextendedproperty
N'MS_Description', N'First year available in the dataset',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'FirstYear'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Last year available in the dataset',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'LastYear'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The date and time that the file was loaded',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'DateLoaded'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Brief description of the dataset in English',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Brief description of the dataset in Danish',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDCatalog', N'COLUMN', N'TextDa'
GO