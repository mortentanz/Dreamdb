/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSPermits.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $
  
  Table         : Demographics.DSPermits
  
  Purpose       : Migration by type of residence permit.

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.DSPermits', N'U') IS NOT NULL
DROP TABLE Demographics.DSPermits
GO

CREATE TABLE Demographics.DSPermits (

  DSPermitsID int identity(1,1) not null,
  DatasetID smallint not null,
  
  DevelopmentID tinyint not null,
  HemisphereID tinyint not null,
  CitizenshipID tinyint not null,
  PermitID tinyint not null,
  Age tinyint not null,
  GenderID tinyint not null,
  [Year] smallint not null,
  Persons int not null

  CONSTRAINT PK_DSPermits PRIMARY KEY (DSPermitsID),
  
  CONSTRAINT IX_DSPermits_Unique UNIQUE (
    DatasetID, DevelopmentID, HemisphereID, CitizenshipID, PermitID, Age, GenderID, [Year], Persons
  ),
  
  CONSTRAINT FK_DSPermits_DSCatalog FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_DSPermits_Development FOREIGN KEY (DevelopmentID)
  REFERENCES dbo.Development (DevelopmentID),
  
  CONSTRAINT FK_DSPermits_Hemisphere FOREIGN KEY (HemisphereID)
  REFERENCES dbo.Hemisphere (HemisphereID),
  
  CONSTRAINT FK_DSPermits_Permit FOREIGN KEY (PermitID)
  REFERENCES dbo.Permit (PermitID),
  
  CONSTRAINT FK_DSPermits_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Migration by type of residence permit',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key for observation',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'DSPermitsID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreig key for dataset identification in catalog',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for economic development stage of origin country',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'DevelopmentID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for hemisphere of origin country',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'HemisphereID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for citizenship',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'CitizenshipID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for type of permit',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'PermitID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of migrating persons',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of arriving persons (negative number implies emigration)',
N'SCHEMA', N'Demographics', N'TABLE', N'DSPermits', N'COLUMN', N'Persons'

GO