/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Births.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Births
  
  Purpose       : Projected number of births grouped by child origin and gender attributes and mothers age

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Births', 'U') IS NOT NULL
DROP TABLE Demographics.Births
GO

CREATE TABLE Demographics.Births (

  BirthsID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  ChildOriginID tinyint not null,
  ChildGenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_Births PRIMARY KEY (BirthsID),
  CONSTRAINT IX_Births_Unique UNIQUE (ProjectionID, ChildOriginID, ChildGenderID, Age, [Year]),

  CONSTRAINT FK_Births_Origin FOREIGN KEY (ChildOriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Births_Gender FOREIGN KEY (ChildGenderID)
	REFERENCES dbo.Gender (GenderID)
  
)
GO

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of births.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'BirthsID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'ChildOriginID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'ChildGenderID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of births over the course of the projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Births', N'COLUMN', N'Persons'
GO