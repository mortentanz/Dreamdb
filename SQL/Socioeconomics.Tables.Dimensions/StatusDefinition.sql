/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Tables.Dimensions/StatusDefinition.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Socioeconomics.StatusDefinition
  
  Purpose       : Defines socioeconomic status as composite of status tree nodes.
  
	Primary key		: NodeID (surrogate primary key)

  Foreign keys  : StatusID on Socioeconomics.Status
									NodeID on Socioeconomics.StatusTree

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Socioeconomics.StatusDefinition', N'U') IS NOT NULL
DROP TABLE Socioeconomics.StatusDefinition
GO

CREATE TABLE Socioeconomics.StatusDefinition (
  StatusID smallint not null,
  NodeID smallint not null,
  Weight float constraint DF_StatusGroupMember_Weight DEFAULT (1) not null,
  
  CONSTRAINT PK_StatusDefinition PRIMARY KEY (StatusID, NodeID),
  
  CONSTRAINT FK_StatusDefinition_Status FOREIGN KEY (StatusID)
  REFERENCES Socioeconomics.Status (StatusID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_StatusDefinition_StatusTree FOREIGN KEY (NodeID)
  REFERENCES Socioeconomics.StatusTree (NodeID)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Defines socioeconomic status as composite of status tree nodes',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusDefinition'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for socioeconomic status being defined',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusDefinition', N'COLUMN', N'StatusID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for status tree node participating in composite',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusDefinition', N'COLUMN', N'NodeID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Weight with which the status tree node enters the status definition',
N'SCHEMA', N'Socioeconomics', N'TABLE', N'StatusDefinition', N'COLUMN', N'Weight'
GO