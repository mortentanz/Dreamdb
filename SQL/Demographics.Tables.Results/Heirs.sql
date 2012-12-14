/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Heirs.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Heirs
  
  Purpose       : Projected number of heirs by bequest age of mothers.
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Heirs', 'U') IS NOT NULL
DROP TABLE Demographics.Heirs
GO

CREATE TABLE Demographics.Heirs (
  
  HeirsID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  MotherAge tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_Heirs PRIMARY KEY (HeirsID),
  CONSTRAINT IX_Heirs_Unique UNIQUE (ProjectionID, GenderID, Age, MotherAge, [Year]),
  
  CONSTRAINT FK_Heirs_Gender FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of heirs by bequest age of mothers.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'HeirsID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Identifier for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age of mothers.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'MotherAge'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of heirs.',
N'SCHEMA', N'Demographics', N'TABLE', N'Heirs', N'COLUMN', N'Persons'
GO