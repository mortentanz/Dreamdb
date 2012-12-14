/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Permit.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Permit
  
  Purpose       : Legal basis of immigrants residence in Denmark
  
	Primary key		: PermitID

  Columns
  TextEn        : Short descriptive text in English
  TextDa        : Short descriptive text in Danish

-----------------------------------------------------------------------------------------------------------*/
IF object_id('dbo.Permit', 'U') IS NOT NULL
DROP TABLE dbo.Permit
GO


CREATE TABLE dbo.Permit (
	
	PermitID tinyint not null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_Permit PRIMARY KEY (PermitID),

)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Legal basis of immigrants residence in Denmark', 
N'SCHEMA', N'dbo', N'TABLE', N'Permit'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for origin type', 
N'SCHEMA', N'dbo', N'TABLE', N'Permit', N'COLUMN', N'PermitID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Permit', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Permit', N'COLUMN', N'TextDa'
GO