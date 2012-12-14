/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSImmigrants.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.DSEmigrants
  
  Purpose       : Stores gross immigrant arrivals measured in number of persons
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.DSImmigrants', 'U') IS NOT NULL
DROP TABLE Demographics.DSImmigrants
GO


CREATE TABLE Demographics.DSImmigrants (
  
  DSImmigrantsID int identity(1,1) not null,
  DatasetID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_DSImmigrants PRIMARY KEY CLUSTERED (DSImmigrantsID),
  
  CONSTRAINT IX_DSImmigrantsUnique UNIQUE NONCLUSTERED (
    OriginID,
    GenderID,
    Age,
    [Year]
  ),
  
  CONSTRAINT FK_DSImmigrants_DSCatalog FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
  ON DELETE CASCADE,

  CONSTRAINT FK_DSImmigrants_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_DSImmigrants_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Arriving immigrants grouped by origin, gender, and age over the course of year.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'DSImmigrantsID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalog dataset information.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for national origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age using ultimo convention.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSImmigrants', N'COLUMN', N'Persons'
GO