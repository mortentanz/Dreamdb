/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Facts/EducationEnrollment.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.EducationEnrollment
  
  Purpose       : Population enrolled in education system by current level of education.
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Socioeconomics.EducationEnrollment', 'U') IS NOT NULL
DROP TABLE Socioeconomics.EducationEnrollment
GO

CREATE TABLE Socioeconomics.EducationEnrollment (

  EnrollmentID int identity(1,1) not null,
  DatasetID smallint not null,
  LevelID smallint not null,
  EducationID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_EducationEnrollment PRIMARY KEY (LevelID),
  CONSTRAINT IX_EducationEnrollment_Unique UNIQUE (DatasetID, [Year], LevelID, EducationID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_EducationEnrollment_Catalog FOREIGN KEY (DatasetID)
  REFERENCES Socioeconomics.EducationCatalog (DatasetID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_EducationEnrollment_Level FOREIGN KEY (LevelID)
  REFERENCES dbo.Education (EducationID),
  
  CONSTRAINT FK_EducationEnrollment_Education FOREIGN KEY (EducationID)
  REFERENCES dbo.Education (EducationID),
  
  CONSTRAINT FK_EducationEnrollment_Origin FOREIGN KEY (OriginID)
  REFERENCES Socioeconomics.Origin (OriginID),
  
  CONSTRAINT FK_EducationEnrollment_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Population enrolled in education system by current level of education',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'EnrollmentID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalogged dataset information',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for education level attained',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'LevelID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for education attended',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'EducationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'EducationEnrollment', N'COLUMN', N'Persons'
GO