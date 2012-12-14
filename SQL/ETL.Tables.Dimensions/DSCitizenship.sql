/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSCitizenship.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSCitizenship
  
  Purpose       : Citizenship (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									CitizenshipID on dbo.Citizenship

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSCitizenship', 'U') IS NOT NULL
DROP TABLE ETL.DSCitizenship
GO

CREATE TABLE ETL.DSCitizenship (
	Token varchar(2) not null,
	DSDimensionID smallint not null,
	CitizenshipID tinyint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSCitizenship PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSCitizenship_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_Citizenship FOREIGN KEY (CitizenshipID)
	REFERENCES dbo.Citizenship (CitizenshipID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Citizenship (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCitizenship'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCitizenship', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCitizenship', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for citizenship', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCitizenship', N'COLUMN', N'CitizenshipID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCitizenship', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCitizenship', N'COLUMN', N'TextDa'
GO