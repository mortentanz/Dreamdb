/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Population.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Population
  
  Purpose       : Projected number of persons in the population grouped by origin, gender and age
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Population', 'U') IS NOT NULL
DROP TABLE Demographics.[Population]
GO

CREATE TABLE Demographics.[Population] (

  PopulationID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null

  CONSTRAINT PK_Population PRIMARY KEY (PopulationID),
  CONSTRAINT IX_Population_Unique UNIQUE (ProjectionID, OriginID, GenderID, Age, [Year]),
  
  CONSTRAINT FK_Population_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Population_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected population size.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'PopulationID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of persons in group.',
N'SCHEMA', N'Demographics', N'TABLE', N'Population', N'COLUMN', N'Persons'
GO