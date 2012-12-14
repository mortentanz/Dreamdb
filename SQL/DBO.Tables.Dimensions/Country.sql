/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Country.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Country
  
  Purpose       : Country
  
  Primary key   : DurationID
  
  Columns
  Label					: Symbolic label
  TextEn        : Brief textual description in English
  TextDa        : Brief textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Country', 'U') IS NOT NULL
DROP TABLE dbo.Country
GO

CREATE TABLE dbo.Country (

  CountryID smallint not null,
  DevelopmentID tinyint not null constraint DF_Country_Development DEFAULT (0),
  HemisphereID tinyint not null constraint DF_Country_Hemisphere DEFAULT (0),
  Label varchar(4) not null,
  TextEn varchar(50) not null,
  TextDa varchar(50) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Country PRIMARY KEY CLUSTERED (CountryID),
  
  CONSTRAINT FK_Country_Development FOREIGN KEY (DevelopmentID)
  REFERENCES dbo.Development (DevelopmentID)
  ON UPDATE CASCADE
  ON DELETE SET DEFAULT,

  CONSTRAINT FK_Country_Hemisphere FOREIGN KEY (HemisphereID)
  REFERENCES dbo.Hemisphere (HemisphereID)
  ON UPDATE CASCADE
  ON DELETE SET DEFAULT

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Country',
N'SCHEMA', N'dbo', N'TABLE', N'Country'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'CountryID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for economic development stage',
N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'DevelopmentID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for hemisphere',
N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'HemisphereID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Symbolic label', 
N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'Label'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'TextDa'
GO