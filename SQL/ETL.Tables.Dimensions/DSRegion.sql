/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSRegion.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSRegion
  
  Purpose       : Region derived from economic stage of development (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									RegionID on dbo.DSRegion

  Columns
  Token         : Token used in source file
  TextEn        : Short descriptive text in English
  TextDa        : Short descriptive text in Danish

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSRegion', 'U') IS NOT NULL
DROP TABLE ETL.DSRegion
GO

CREATE TABLE ETL.DSRegion (
	Token varchar(2) not null,
	DSDimensionID smallint not null,
	RegionID smallint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSRegion PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSRegion_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_DSRegion FOREIGN KEY (RegionID)
	REFERENCES dbo.Region (RegionID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Region derived from economic stage of development (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegion'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegion', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegion', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for region', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegion', N'COLUMN', N'RegionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegion', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSRegion', N'COLUMN', N'TextDa'
GO