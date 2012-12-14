/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSStatus.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSStatus
  
  Purpose       : Labourmarket and social status (DS)
  
	Primary key		: Token, DSDimensionID

  Foreign keys  : DSDimensionID on ETL.DSDimension
									NodeID on Socioeconomics.StatusTree

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.DSStatus', 'U') IS NOT NULL
DROP TABLE ETL.DSStatus
GO

CREATE TABLE ETL.DSStatus (
  Token varchar(3) not null,
	DSDimensionID smallint not null,
	NodeID smallint null,
	TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
	
	CONSTRAINT PK_DSStatus PRIMARY KEY (Token, DSDimensionID),

	CONSTRAINT FK_DSStatus_DSDimension FOREIGN KEY (DSDimensionID)
	REFERENCES ETL.DSDimension (DSDimensionID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	CONSTRAINT FK_DSStatus_StatusTree FOREIGN KEY (NodeID)
	REFERENCES Socioeconomics.StatusTree (NodeID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
)
GO

EXECUTE sp_addextendedproperty N'MS_Description', N'Labourmarket and social status (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSStatus'

EXECUTE sp_addextendedproperty N'MS_Description', N'Token used in source file', 
N'SCHEMA', N'ETL', N'TABLE', N'DSStatus', N'COLUMN', N'Token'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for DSDimension', 
N'SCHEMA', N'ETL', N'TABLE', N'DSStatus', N'COLUMN', N'DSDimensionID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for location in status tree', 
N'SCHEMA', N'ETL', N'TABLE', N'DSStatus', N'COLUMN', N'NodeID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSStatus', N'COLUMN', N'TextDa'
GO