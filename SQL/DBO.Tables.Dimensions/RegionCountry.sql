/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/RegionCountry.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Country
  
  Purpose       : Maps countries to region (many-to-many normalization)
  
  Primary key   : DurationID
  
  Columns
  Label					: Symbolic label
  TextEn        : Brief textual description in English
  TextDa        : Brief textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.RegionRegion', 'U') IS NOT NULL
DROP TABLE dbo.RegionCountry
GO

CREATE TABLE dbo.RegionCountry (

  RegionID smallint not null,
  CountryID smallint not null,
  
  CONSTRAINT PK_RegionCountry PRIMARY KEY (RegionID, CountryID),

  CONSTRAINT FK_RegionCountry_Region FOREIGN KEY (RegionID)
  REFERENCES dbo.Region (RegionID)
  ON UPDATE CASCADE
  ON DELETE CASCADE,
  
  CONSTRAINT FK_RegionCountry_Country FOREIGN KEY (CountryID)
  REFERENCES dbo.Country (CountryID)

)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Mapping country and region (many to many normalization)',
N'SCHEMA', N'dbo', N'TABLE', N'RegionCountry'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for region',
N'SCHEMA', N'dbo', N'TABLE', N'RegionCountry', N'COLUMN', N'RegionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for country',
N'SCHEMA', N'dbo', N'TABLE', N'RegionCountry', N'COLUMN', N'CountryID'

GO