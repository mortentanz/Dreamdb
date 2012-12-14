/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Results/Immigrants.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.Immigrants
  
  Purpose       : Projected number of immigrants grouped by origin, gender and age
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Immigrants', 'U') IS NOT NULL
DROP TABLE Demographics.Immigrants
GO

CREATE TABLE Demographics.Immigrants (

  ImmigrantsID bigint identity(1,1) not null,
  ProjectionID smallint not null,
  
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons float not null,
  
  CONSTRAINT PK_Immigrants PRIMARY KEY (ImmigrantsID),
  CONSTRAINT IX_Immigrants_Unique UNIQUE (ProjectionID, OriginID, GenderID, Age, [Year]),
  
  CONSTRAINT FK_Immigrants_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_Immigrants_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)
  
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of immigrants.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'ImmigrantsID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for projection information.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of projection.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Projected number of arriving immigrants.',
N'SCHEMA', N'Demographics', N'TABLE', N'Immigrants', N'COLUMN', N'Persons'
GO