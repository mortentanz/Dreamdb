/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSEducation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSEducation
  
  Purpose       : Education (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									EducationID on dbo.Education

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSEducation', 'U') IS NOT NULL
DROP TABLE ETL.DSEducation
GO

CREATE TABLE ETL.DSEducation (
	Token varchar(10) not null,
	DSDimensionID smallint not null,
	EducationID smallint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSEducation PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSEducaiton_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_Education FOREIGN KEY (EducationID)
	REFERENCES dbo.Education (EducationID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Education (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSEducation'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSEducation', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSEducation', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for Education', 
N'SCHEMA', N'ETL', N'TABLE', N'DSEducation', N'COLUMN', N'EducationID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSEducation', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSEducation', N'COLUMN', N'TextDa'
GO