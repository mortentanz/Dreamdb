/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSHemisphere.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSHemisphere
  
  Purpose       : Hemisphere of geographic region (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									HemisphereID on dbo.Hemisphere

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSHemisphere', 'U') IS NOT NULL
DROP TABLE ETL.DSHemisphere
GO

CREATE TABLE ETL.DSHemisphere (
	Token varchar(2) not null,
	DSDimensionID smallint not null,
	HemisphereID tinyint null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSHemisphere PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSHemisphere_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_Hemisphere FOREIGN KEY (HemisphereID)
	REFERENCES dbo.Hemisphere (HemisphereID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Hemisphere of geographic region (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSHemisphere'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSHemisphere', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSHemisphere', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for hemisphere', 
N'SCHEMA', N'ETL', N'TABLE', N'DSHemisphere', N'COLUMN', N'HemisphereID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSHemisphere', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSHemisphere', N'COLUMN', N'TextDa'
GO