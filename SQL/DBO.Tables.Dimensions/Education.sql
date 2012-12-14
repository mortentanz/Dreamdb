/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Education.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Education
  
  Purpose       : Education
  
  Primary key   : EducationID
  
  Columns
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Education', 'U') IS NOT NULL
DROP TABLE dbo.Education
GO


CREATE TABLE dbo.Education (

  EducationID smallint not null,
  Label varchar(31) not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Education PRIMARY KEY CLUSTERED (EducationID)
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Education',
N'SCHEMA', N'dbo', N'TABLE', N'Education'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'Education', N'COLUMN', N'EducationID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Symbolic label', 
N'SCHEMA', N'dbo', N'TABLE', N'Education', N'COLUMN', N'Label'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Education', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Education', N'COLUMN', N'TextDa'
GO