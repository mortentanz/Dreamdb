/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSPermit.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSPermit
  
  Purpose       : Legal basis of immigrants residence in Denmark (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									PermitID on dbo.DSPermit

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSPermit', 'U') IS NOT NULL
DROP TABLE ETL.DSPermit
GO

CREATE TABLE ETL.DSPermit (
  Token varchar(2) not null,
	DSDimensionID smallint not null,
	PermitID tinyint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSPermit PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSPermit_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_DSPermit FOREIGN KEY (PermitID)
	REFERENCES dbo.Permit (PermitID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Legal basis of immigrants residence in Denmark (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSPermit'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSPermit', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSPermit', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for origin type', 
N'SCHEMA', N'ETL', N'TABLE', N'DSPermit', N'COLUMN', N'PermitID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSPermit', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSPermit', N'COLUMN', N'TextDa'
GO