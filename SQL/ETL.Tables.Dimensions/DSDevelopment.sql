/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSDevelopment.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSDevelopment
  
  Purpose       : Economic development stage of geographic region (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									DevelopmentID on dbo.Development

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSDevelopment', 'U') IS NOT NULL
DROP TABLE ETL.DSDevelopment
GO

CREATE TABLE ETL.DSDevelopment (
	Token varchar(2) not null,
	DSDimensionID smallint not null,
	DevelopmentID tinyint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSDevelopment PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSDevelopment_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_Development FOREIGN KEY (DevelopmentID)
	REFERENCES dbo.Development (DevelopmentID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Economic development stage of geographic region (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDevelopment'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDevelopment', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDevelopment', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for Development', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDevelopment', N'COLUMN', N'DevelopmentID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDevelopment', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDevelopment', N'COLUMN', N'TextDa'
GO