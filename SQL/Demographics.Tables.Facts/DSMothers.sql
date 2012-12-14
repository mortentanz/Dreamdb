/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSMothers.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.DSMothers
  
  Purpose       : Observed number of mothers giving birth by origin, age, child gender and year

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.DSMothers', 'U') IS NOT NULL
DROP TABLE Demographics.DSMothers
GO


CREATE TABLE Demographics.DSMothers (

  DSMothersID int identity(1,1) not null,
  DatasetID smallint not null,
  OriginID tinyint not null,
  ChildGenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_DSMothers PRIMARY KEY CLUSTERED (DSMothersID),
  
  CONSTRAINT IX_DSMothersUnique UNIQUE NONCLUSTERED (
    OriginID,
    ChildGenderID,
    Age,
    [Year]
  ),
  
  CONSTRAINT FK_DSMothers_DSCatalog FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_DSMothers_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_DSMothers_ChildGender FOREIGN KEY (ChildGenderID)
	REFERENCES dbo.Gender (GenderID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of women giving birth grouped by origin, gender, and age over the course of year.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'DSMothersID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalog dataset information.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for national origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'ChildGenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age (using ultimo convention).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of women giving birth.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSMothers', N'COLUMN', N'Persons'
GO