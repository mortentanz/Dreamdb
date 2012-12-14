/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Hemisphere.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Hemisphere
  
  Purpose       : Hemisphere of geographic region
  
  Primary key   : HemisphereID
  
  Columns
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Hemisphere', 'U') IS NOT NULL
DROP TABLE dbo.Hemisphere
GO


CREATE TABLE dbo.Hemisphere (

  HemisphereID tinyint not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Hemisphere PRIMARY KEY CLUSTERED (HemisphereID)
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Hemisphere of geographic region', 
N'SCHEMA', N'dbo', N'TABLE', N'Hemisphere'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key', 
N'SCHEMA', N'dbo', N'TABLE', N'Hemisphere', N'COLUMN', N'HemisphereID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Hemisphere', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Hemisphere', N'COLUMN', N'TextDa'
GO