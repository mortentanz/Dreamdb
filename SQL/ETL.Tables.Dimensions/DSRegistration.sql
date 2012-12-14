/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSRegistration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSRegistration
  
  Purpose       : Source data registration type (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									RegistrationID on dbo.DSRegistration

  Columns
  Token         : Token used in source file
  TextEn        : Short descriptive text in English
  TextDa        : Short descriptive text in Danish

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSRegistration', 'U') IS NOT NULL
DROP TABLE ETL.DSRegistration
GO


CREATE TABLE ETL.DSRegistration (
	
	Token varchar(1) not null,
	DSDimensionID smallint not null,
	RegistrationID tinyint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSRegistration PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSRegistration_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_DSRegistration FOREIGN KEY (RegistrationID)
	REFERENCES dbo.Registration (RegistrationID)
	ON DELETE SET NULL
	ON UPDATE CASCADE

)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Source data registration type (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegistration'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegistration', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegistration', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for region', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegistration', N'COLUMN', N'RegistrationID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegistration', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegistration', N'COLUMN', N'TextDa'
GO