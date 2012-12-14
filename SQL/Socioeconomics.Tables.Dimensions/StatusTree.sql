/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Dimensions/StatusTree.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.StatusTree
  
  Purpose       : Labourmarket and social status hierarchy
  
	Primary key		: NodeID (surrogate primary key)

  Foreign keys  : ParentID on Self
									StatusTypeID on Socioeconomics.StatusType

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.StatusTree', 'U') IS NOT NULL
DROP TABLE Socioeconomics.StatusTree
GO

CREATE TABLE Socioeconomics.StatusTree (
	NodeID smallint identity(1,1) not null,
	ParentID smallint null,
	TypeID tinyint null,
	Revision tinyint not null,
	TextEn varchar(200) not null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_StatusTree PRIMARY KEY (NodeID),
	
	CONSTRAINT FK_Status_ParentStatus FOREIGN KEY (ParentID)
	REFERENCES Socioeconomics.StatusTree (NodeID),

	CONSTRAINT FK_Status_StatusType FOREIGN KEY (TypeID)
	REFERENCES Socioeconomics.StatusType (TypeID)
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Labourmarket and social status hierarchy', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree', N'COLUMN', N'NodeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key to parent status (self-reference)',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree', N'COLUMN', N'ParentID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for status type', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree', N'COLUMN', N'TypeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Revision number of status classification', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusTree', N'COLUMN', N'TextDa'
GO