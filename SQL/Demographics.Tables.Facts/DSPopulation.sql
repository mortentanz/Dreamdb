/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSPopulation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.DSPopulation
  
  Purpose       : Stores total population classified by origin, gender, age and year

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.DSPopulation', 'U') IS NOT NULL
DROP TABLE Demographics.DSPopulation
GO


CREATE TABLE Demographics.DSPopulation (

  DSPopulationID int identity(1,1) not null,
  DatasetID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_DSPopulation PRIMARY KEY CLUSTERED (DSPopulationID),
  
  CONSTRAINT IX_DSPopulationUnique UNIQUE NONCLUSTERED (
    OriginID,
    GenderID,
    Age,
    [Year]
  ),
  
  CONSTRAINT FK_DSPopulation_Dataset FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
  ON DELETE CASCADE,

  CONSTRAINT FK_DSPopulation_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_DSPopulation_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Population grouped by origin, gender, and age primo specified year.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'DSPopulationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalog dataset information.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for national origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation (primo).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons on January 1st.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPopulation', N'COLUMN', N'Persons'
GO