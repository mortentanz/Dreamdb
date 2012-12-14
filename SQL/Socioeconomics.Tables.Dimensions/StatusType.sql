/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Dimensions/StatusType.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.StatusType
  
  Purpose       : Labourmarket and social status type hierarchy
  
	Primary key		: TypeID (surrogate primary key)

  Foreign keys  : ParentID on Self

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.StatusType', 'U') IS NOT NULL
DROP TABLE Socioeconomics.StatusType
GO

CREATE TABLE Socioeconomics.StatusType (
	TypeID tinyint identity(1,1) not null,
	ParentID tinyint null,
	Revision tinyint not null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_StatusType PRIMARY KEY (TypeID),
	
	CONSTRAINT FK_StatusType_ParentType FOREIGN KEY (ParentID)
	REFERENCES Socioeconomics.StatusType (TypeID)
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Labourmarket and social status type hierarchy', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusType'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusType', N'COLUMN', N'TypeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key to parent status type (self-reference)',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusType', N'COLUMN', N'ParentID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Revision number of status type classification', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusType', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusType', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusType', N'COLUMN', N'TextDa'
GO