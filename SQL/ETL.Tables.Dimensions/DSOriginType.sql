/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSOriginType.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSOriginType
  
  Purpose       : Types of origin (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									OriginTypeID on dbo.OriginType

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSOriginType', 'U') IS NOT NULL
DROP TABLE ETL.DSOriginType
GO

CREATE TABLE ETL.DSOriginType (
	Token varchar(2) not null,
	DSDimensionID smallint not null,
	TypeID tinyint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSOriginType PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSOriginType_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_OriginType_OriginType FOREIGN KEY (TypeID)
	REFERENCES dbo.OriginType (TypeID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Type of origin (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOriginType'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOriginType', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOriginType', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for origin type', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOriginType', N'COLUMN', N'TypeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOriginType', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOriginType', N'COLUMN', N'TextDa'
GO