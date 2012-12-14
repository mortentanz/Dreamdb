/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Registration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Registration
  
  Purpose       : Source data registration type.
  
  Primary key   : RegionID (surrogate primary key)
  
  Columns
  Label					: Symbolic label
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Registration', 'U') IS NOT NULL
DROP TABLE dbo.Registration
GO


CREATE TABLE dbo.Registration (
  RegistrationID tinyint not null,
  Label varchar(31) not null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Registration PRIMARY KEY CLUSTERED (RegistrationID)
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Source data registration type',
N'SCHEMA', N'dbo', N'TABLE', N'Registration'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'dbo', N'TABLE', N'Registration', N'COLUMN', N'RegistrationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Symbolic label',
N'SCHEMA', N'dbo', N'TABLE', N'Registration', N'COLUMN', N'Label'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Registration', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Registration', N'COLUMN', N'TextDa'
GO