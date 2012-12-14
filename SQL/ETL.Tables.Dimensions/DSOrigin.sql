/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSOrigin.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : dbo.DSOrigin
  
  Purpose       : Origin classification values (DS)
  
  Primary key   : Token, DSDimensionID

  Foreign keys  : DSDimensionID on dbo.DSDimensionID
									TypeID on dbo.OriginType
									NationalityID on dbo.Nationality
									HemisphereID on dbo.Hemisphere
									CitizenshipID on dbo.Citizenship

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('ETL.DSOrigin', 'U') IS NOT NULL
DROP TABLE ETL.DSOrigin
GO

CREATE TABLE ETL.DSOrigin (
	Token varchar(20) not null,
  DSDimensionID smallint not null,
  TypeID tinyint null,
  NationalityID tinyint null,
  HemisphereID tinyint null,
  CitizenshipID tinyint null,

  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_DSOrigin PRIMARY KEY (Token, DSDimensionID),
  
  CONSTRAINT FK_DSOrigin_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
  
  CONSTRAINT FK_DSOrigin_OriginType FOREIGN KEY (TypeID)
  REFERENCES dbo.OriginType (TypeID)
	ON DELETE SET NULL
	ON UPDATE CASCADE,
  
  CONSTRAINT FK_DSOrigin_Nationality FOREIGN KEY (NationalityID)
	REFERENCES dbo.Nationality (NationalityID)
	ON DELETE SET NULL
	ON UPDATE CASCADE,

  CONSTRAINT FK_DSOrigin_Citizenship FOREIGN KEY (CitizenshipID)
  REFERENCES dbo.Citizenship (CitizenshipID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO  

EXECUTE sp_addextendedproperty N'MS_Description', N'Origin classification values (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for origin type', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'TypeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for nationality', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'NationalityID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for hemisphere', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'HemisphereID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for citizenship', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'CitizenshipID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSOrigin', N'COLUMN', N'TextDa'
GO