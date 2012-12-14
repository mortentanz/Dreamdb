/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Nationality.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Nationality
  
  Purpose       : Nationality derived from native region 
  
  Primary key   : NationalityID
  
  Columns
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Nationality', 'U') IS NOT NULL
DROP TABLE dbo.Nationality
GO


CREATE TABLE dbo.Nationality (

  NationalityID tinyint not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Nationality PRIMARY KEY CLUSTERED (NationalityID)
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Nationality derived from native region ',
N'SCHEMA', N'dbo', N'TABLE', N'Nationality'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'Nationality', N'COLUMN', N'NationalityID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Nationality', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Nationality', N'COLUMN', N'TextDa'
GO