/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSChildren.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.DSChildren
  
  Purpose       : Population seen as children of generations of mothers identified by age.
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.DSChildren', 'U') IS NOT NULL
DROP TABLE Demographics.DSChildren
GO

CREATE TABLE Demographics.DSChildren (
  
  ChildrenID bigint identity(1,1) not null,
  DatasetID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  MotherAge tinyint null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_DSChildren PRIMARY KEY (ChildrenID),
  CONSTRAINT IX_DSChildren_Unique UNIQUE (DatasetID, OriginID, GenderID, Age, MotherAge, [Year]),
  
  CONSTRAINT FK_DSChildren_DSCatalog FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
	ON DELETE CASCADE,
  
  CONSTRAINT FK_DSChildren_Origin FOREIGN KEY (OriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_DSChildren_Gender FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Stores number of persons by age of their mothers.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'ChildrenID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for dataset information.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin of children.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of mothers (may be null).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'MotherAge'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSChildren', N'COLUMN', N'Persons'
GO