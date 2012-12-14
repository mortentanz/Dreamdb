/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSCountry.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSCountry
  
  Purpose       : Country (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									CountryID on dbo.Country

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSCountry', 'U') IS NOT NULL
DROP TABLE ETL.DSCountry
GO

CREATE TABLE ETL.DSCountry (
	Token varchar(4) not null,
	DSDimensionID smallint not null,
	CountryID smallint null,

	STBGRP char(3) not null,
	IELANDG1 char(2) not null,
	IELANDG2 char(1) not null,
	IELANDG3 char(1) not null,
	Label varchar(3) not null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSCountry PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSCountry_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_Country FOREIGN KEY (CountryID)
	REFERENCES dbo.Country (CountryID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Country (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for country', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'CountryID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Citizenship country group (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'STBGRP'

EXECUTE sp_addextendedproperty N'MS_Description', N'Region by stage of economic development (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'IELANDG1'

EXECUTE sp_addextendedproperty N'MS_Description', N'Stage of economic development (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'IELANDG2'

EXECUTE sp_addextendedproperty N'MS_Description', N'Hemisphere (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'IELANDG3'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSCountry', N'COLUMN', N'TextDa'
GO