/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Region.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Region
  
  Purpose       : Geographic region
  
  Primary key   : RegionID
  
  Foreign keys	: DevelopmentID on dbo.Development
									HemisphereID on dbo.Hemisphere
  
  Columns
  TextDa        : Textual description in Danish
  TextEn        : Textual description

-----------------------------------------------------------------------------------------------------------*/
IF object_id('dbo.Region', 'U') IS NOT NULL
DROP TABLE dbo.Region
GO


CREATE TABLE dbo.Region (

  RegionID smallint not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Region PRIMARY KEY CLUSTERED (RegionID),
  
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Geographic region',
N'SCHEMA', N'dbo', N'TABLE', N'Region'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'Region', N'COLUMN', N'RegionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Region', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Region', N'COLUMN', N'TextDa'
GO