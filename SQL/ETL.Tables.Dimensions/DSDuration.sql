/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSDuration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSDuration
  
  Purpose       : Duration (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									DurationID on dbo.Duration

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSDuration', 'U') IS NOT NULL
DROP TABLE ETL.DSDuration
GO

CREATE TABLE ETL.DSDuration (
	Token varchar(4) not null,
	DSDimensionID smallint not null,
	DurationID smallint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSDuration PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSDuration_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_Duration FOREIGN KEY (DurationID)
	REFERENCES dbo.Duration (DurationID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Duration (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDuration'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDuration', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDuration', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for Duration', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDuration', N'COLUMN', N'DurationID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDuration', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDuration', N'COLUMN', N'TextDa'
GO  