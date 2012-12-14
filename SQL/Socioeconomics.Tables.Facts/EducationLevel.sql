/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Facts/EducationLevel.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.EducationLevel
  
  Purpose       : Population by education level.
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Socioeconomics.EducationLevel', 'U') IS NOT NULL
DROP TABLE Socioeconomics.EducationLevel
GO

CREATE TABLE Socioeconomics.EducationLevel (

  LevelID int identity(1,1) not null,
  DatasetID smallint not null,
  EducationID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_EducationLevel PRIMARY KEY (LevelID),

  CONSTRAINT IX_EducationLevel_Unique UNIQUE (DatasetID, [Year], EducationID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_EducationLevel_Catalog FOREIGN KEY (DatasetID)
  REFERENCES Socioeconomics.EducationCatalog (DatasetID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_EducationLevel_Education FOREIGN KEY (EducationID)
  REFERENCES dbo.Education (EducationID),
  
  CONSTRAINT FK_EducationLevel_Origin FOREIGN KEY (OriginID)
  REFERENCES Socioeconomics.Origin (OriginID),
  
  CONSTRAINT FK_EducationLevel_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Population by level of education',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'LevelID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalogged dataset information',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for level of education',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'EducationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationLevel', N'COLUMN', N'Persons'
GO