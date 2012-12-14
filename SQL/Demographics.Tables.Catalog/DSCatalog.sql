/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Catalog/DSCatalog.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $
  
  Table         : Demographics.DSCatalog
  
  Purpose       : Catalogs data sets containing demographic data as delivered from Statistics Denmark.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.DSCatalog', N'U') IS NOT NULL
DROP TABLE Demographics.DSCatalog
GO

CREATE TABLE Demographics.DSCatalog (

  DatasetID smallint identity(1,1),
  Setname varchar(30) not null,
  Revision tinyint constraint DF_DSCatalog_Revision DEFAULT (1) not null, 
  [Year] smallint not null,
  DateLoaded datetime not null,
  IsArchived bit constraint DF_DSCatalog_IsArchived DEFAULT (0),
  TextEn varchar(400) 
		constraint DF_DSCatalog_TextEn default 'No description given' not null,
  TextDa varchar(400) collate Danish_Norwegian_CI_AS 
		constraint DF_DSCatalog_TextDa default 'Ingen beskrivelse' not null,

  CONSTRAINT PK_DSCatalog PRIMARY KEY (DatasetID DESC),

  CONSTRAINT IX_DSCatalog_Unique UNIQUE (Setname, Revision, [Year]),
  
  CONSTRAINT CK_DSCatalog_Setname CHECK (
    Setname IN (
      N'BEFA', N'DODE', N'FODT', N'INDV', N'MOAR', N'UDVA', 
      N'IEBFM', N'IPERMITS', N'EPERMITS', N'CHILDREN'
    )
  )
)
GO


EXECUTE sp_addextendedproperty 
N'MS_Description', N'Catalogs source datasets from Statistics Denmark',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Surrogate primary key for dataset',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Name of dataset used in source files',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'Setname'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Year of observation',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Date and time that the dataset was loaded into the database',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'DateLoaded'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'States whether the original source directory is available in file archive',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'IsArchived'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Description of dataset',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Description of dataset in Danish',
N'SCHEMA', N'Demographics', N'TABLE', N'DSCatalog', N'COLUMN', N'TextDa'
GO