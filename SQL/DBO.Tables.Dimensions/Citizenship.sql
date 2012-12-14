/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Citizenship.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Citizenship
  
  Purpose       : Citizenship derived from issuing region
  
  Primary key   : CitizenshipID
  
  Columns
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish


-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Citizenship', 'U') IS NOT NULL
DROP TABLE dbo.Citizenship
GO


CREATE TABLE dbo.Citizenship (

  CitizenshipID tinyint not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Citizenship PRIMARY KEY CLUSTERED (CitizenshipID)
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Citizenship derived from issuing region',
N'SCHEMA', N'dbo', N'TABLE', N'Citizenship'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'Citizenship', N'COLUMN', N'CitizenshipID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Citizenship', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Citizenship', N'COLUMN', N'TextDa'
GO