/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Children.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Children
  
  Purpose       : Projected number of persons by age of mother
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Children', 'U') IS NOT NULL
DROP TABLE Demographics.Children
GO

CREATE TABLE Demographics.Children (
  
  ChildrenID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  MotherAge tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_Children PRIMARY KEY (ChildrenID),
  CONSTRAINT IX_Children_Unique UNIQUE (ProjectionID, OriginID, GenderID, Age, MotherAge, [Year]),
  
  CONSTRAINT FK_Children_Origin FOREIGN KEY (OriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Children_Gender FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected population size by age of mothers.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'ChildrenID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age of mothers.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'MotherAge'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of persons.',
N'SCHEMA', N'Demographics', N'TABLE', N'Children', N'COLUMN', N'Persons'
GO