/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Deaths.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Deaths
  
  Purpose       : Projected number of deaths grouped by origin, gender and age

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Deaths', 'U') IS NOT NULL
DROP TABLE Demographics.Deaths
GO

CREATE TABLE Demographics.Deaths (

  DeathsID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_Deaths PRIMARY KEY (DeathsID),
  CONSTRAINT IX_Deaths_Unique UNIQUE (ProjectionID, OriginID, GenderID, Age, [Year]),
  
  CONSTRAINT FK_Deaths_Origin FOREIGN KEY (OriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Deaths_Gender FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of deaths.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'DeathsID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Descriptionn', N'Projected number of deaths over the course of the projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'Deaths', N'COLUMN', N'Persons'
GO