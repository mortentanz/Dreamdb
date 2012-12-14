/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Emigrants.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Emigrants
  
  Purpose       : Projected number of emigrants
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Emigrants', 'U') IS NOT NULL
DROP TABLE Demographics.Emigrants
GO

CREATE TABLE Demographics.Emigrants (

  EmigrantsID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_Emigrants PRIMARY KEY (EmigrantsID),
  CONSTRAINT IX_Emigrants_Unique UNIQUE (ProjectionID, OriginID, GenderID, Age, [Year]),
  
  CONSTRAINT FK_Emigrants_Origin FOREIGN KEY (OriginID)
	REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Emigrants_Gender FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)
  
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of emigrants.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'EmigrantsID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of projection.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of departing emigrants.',
N'SCHEMA', N'Demographics', N'TABLE', N'Emigrants', N'COLUMN', N'Persons'
GO