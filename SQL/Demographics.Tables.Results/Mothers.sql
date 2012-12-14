/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Mothers.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Mothers
  
  Purpose       : Projected number of new mothers grouped by origin, child gender and age
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Mothers', 'U') IS NOT NULL
DROP TABLE Demographics.Mothers
GO

CREATE TABLE Demographics.Mothers (

  MothersID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  OriginID tinyint not null,
  ChildGenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null
  
  CONSTRAINT PK_Mothers PRIMARY KEY (MothersID),
  CONSTRAINT IX_Mothers_Unique UNIQUE (ProjectionID, OriginID, ChildGenderID, Age, [Year]),
  
  CONSTRAINT FK_Mothers_Origin FOREIGN KEY (OriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Mothers_Gender FOREIGN KEY (ChildGenderID)
	REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of new mothers.',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'MothersID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin of mother.',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'ChildGenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age (of mother).',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of women giving birth.',
N'SCHEMA', N'Demographics', N'TABLE', N'Mothers', N'COLUMN', N'Persons'
GO
