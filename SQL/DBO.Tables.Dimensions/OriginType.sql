/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/OriginType.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.OriginType
  
  Purpose       : Type of origin
  
  Primary key   : TypeID
  
  Columns
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.OriginType', 'U') IS NOT NULL
DROP TABLE dbo.OriginType
GO


CREATE TABLE dbo.OriginType (
  TypeID tinyint not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_OriginType PRIMARY KEY CLUSTERED (TypeID)
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Legal basis of immigrants residence in Denmark', 
N'SCHEMA', N'dbo', N'TABLE', N'OriginType'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for origin type', 
N'SCHEMA', N'dbo', N'TABLE', N'OriginType', N'COLUMN', N'TypeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'OriginType', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'OriginType', N'COLUMN', N'TextDa'
GO