/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Development.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Development
  
  Purpose       : Economic stage of development
  
  Primary key   : DevelopmentID
  
  Columns
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Development', 'U') IS NOT NULL
DROP TABLE dbo.Development
GO


CREATE TABLE dbo.Development (

  DevelopmentID tinyint not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Development PRIMARY KEY CLUSTERED (DevelopmentID)
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Economic stage of development', 
N'SCHEMA', N'dbo', N'TABLE', N'Development'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key', 
N'SCHEMA', N'dbo', N'TABLE', N'Development', N'COLUMN', N'DevelopmentID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Development', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Development', N'COLUMN', N'TextDa'
GO
