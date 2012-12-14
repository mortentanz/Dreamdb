/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/ResidenceDuration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.ResidenceDuration
  
  Purpose       : Projected number of immigrants grouped by origin, duration of residence, gender and age

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.ResidenceDuration', 'U') IS NOT NULL
DROP TABLE Demographics.ResidenceDuration
GO

CREATE TABLE Demographics.ResidenceDuration (

  ResidenceDurationID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  OriginID tinyint not null,
  DurationID smallint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_ResidenceDuration PRIMARY KEY (ResidenceDurationID),
  CONSTRAINT IX_ResidenceDuration_Unique UNIQUE (ProjectionID, OriginID, DurationID, GenderID, Age, [Year]),
  
  CONSTRAINT FK_ResidenceDuration_Origin FOREIGN KEY (OriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_ResidenceDuration_Duration FOREIGN KEY (DurationID)
	REFERENCES dbo.Duration (DurationID),
  
  CONSTRAINT FK_ResidenceDuration_Gender FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)
  
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of resident immigrants by duration of residence in Denmark.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'ResidenceDurationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for duration.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'DurationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projection year.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of resident immigrants.',
N'SCHEMA', N'Demographics', N'TABLE', N'ResidenceDuration', N'COLUMN', N'Persons'
GO