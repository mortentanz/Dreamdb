/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Facts/RAS.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.RAS
  
  Purpose       : Population by socioeconomic status (hierarchy nodes), and education
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Socioeconomics.RAS', 'U') IS NOT NULL
DROP TABLE Socioeconomics.RAS
GO

CREATE TABLE Socioeconomics.RAS (
  RASID int identity(1,1) not null,
  DatasetID smallint not null,
  NodeID smallint not null,
	EducationID smallint not null,
	RegistrationID tinyint not null,
	DurationID smallint not null,
	DurationTotalID smallint not null,
  OriginID tinyint not null,
	GenderID tinyint not null,
	Age tinyint not null,
	[Year] smallint not null,
	Persons int not null,
  
  CONSTRAINT PK_RAS PRIMARY KEY CLUSTERED (RASID),
  
  CONSTRAINT IX_RAS_Unique UNIQUE (
		[Year], NodeID, EducationID, RegistrationID, DurationID, DurationTotalID, 
		OriginID, GenderID, Age, DatasetID
	),

  CONSTRAINT FK_RAS_Catalog FOREIGN KEY (DatasetID)
  REFERENCES Socioeconomics.RASCatalog (DatasetID)
  ON DELETE CASCADE,

	CONSTRAINT FK_RAS_StatusTree FOREIGN KEY (NodeID)
	REFERENCES Socioeconomics.StatusTree (NodeID),

	CONSTRAINT FK_RAS_Education FOREIGN KEY (EducationID)
	REFERENCES dbo.Education (EducationID),
	
	CONSTRAINT FK_RAS_Registration FOREIGN KEY (RegistrationID)
	REFERENCES dbo.Registration (RegistrationID),
	
	CONSTRAINT FK_RAS_Duration FOREIGN KEY (DurationID)  
	REFERENCES dbo.Duration (DurationID),
	
	CONSTRAINT FK_RAS_DurationTotal FOREIGN KEY (DurationTotalID)
	REFERENCES dbo.Duration (DurationID),
  
  CONSTRAINT FK_RAS_Origin FOREIGN KEY (OriginID)
  REFERENCES Socioeconomics.Origin (OriginID),

	CONSTRAINT FK_RAS_GenderID FOREIGN KEY (GenderID)
	REFERENCES dbo.Gender (GenderID)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Population by socioeconomic status, education and demographic attributes',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'RASID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for RAS dataset catalog information',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for labourmarket and social status as of November previous year',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'NodeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for level of education',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'EducationID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for registration type of level of education',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'RegistrationID'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Foreign key for duration of residence in Denmark since last arrival', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'DurationID'

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Foreign key for duration of residence in Denmark since first arrival', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'DurationTotalID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for origin', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for gender', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Age', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty N'MS_Description', N'Year', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty N'MS_Description', N'Persons as of January 1st', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'RAS', N'COLUMN', N'Persons'
GO