/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Gender.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Gender
  
  Purpose       : Gender
  
  Primary key   : GenderID

  Columns
  Label					: Symbolic label
  TextDa        : Brief textual description in Danish
  TextEn        : Brief textual description

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Gender', 'U') IS NOT NULL
DROP TABLE dbo.Gender
GO


CREATE TABLE dbo.Gender (

  GenderID tinyint not null,
  Label varchar(2) not null,
  TextEn varchar(30) not null,
  TextDa varchar(30) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Gender PRIMARY KEY CLUSTERED (GenderID)

)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Gender', 
N'SCHEMA', N'dbo', N'TABLE', N'Gender'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key', 
N'SCHEMA', N'dbo', N'TABLE', N'Gender', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Symbolic label', 
N'SCHEMA', N'dbo', N'TABLE', N'Gender', N'COLUMN', N'Label'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Gender', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Gender', N'COLUMN', N'TextDa'
GO