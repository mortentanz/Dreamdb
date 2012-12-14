/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Tables.Dimensions/DSDimension.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : ETL.DSDimension
  
  Purpose       : Catalog of classifications used in primary data files from Statistics Denmark
  
  Primary key   : DSDimensionID (identity column surrogate key)
  Alternate key : Title, Revision

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('ETL.DSDimension', 'U') IS NOT NULL
DROP TABLE ETL.DSDimension
GO

CREATE TABLE ETL.DSDimension (
  DSDimensionID smallint identity(1,1) not null,
  
  Title varchar(20) not null,
  TableName sysname not null,
  Revision tinyint not null constraint DF_DSDimension_Revision default 1,
  Created datetime not null constraint DF_DSDimension_Created default (GetDate()),
  Modified datetime not null constraint DF_DSDimension_Modified default (GetDate()),

  TextEn varchar(100) null,
  TextDa varchar(100) collate Danish_Norwegian_CI_AS null,

  CONSTRAINT PK_DSDimension PRIMARY KEY (DSDimensionID),
  CONSTRAINT IX_DSDimension_Unique UNIQUE (Title, Revision)
)
GO

EXECUTE sp_addextendedproperty 
N'MS_Description', N'Catalog of classifications used in primary data files from Statistics Denmark (DS)', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension'

EXECUTE sp_addextendedproperty N'MS_Description', N'Title as used by DS or an adapted title', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'Title'

EXECUTE sp_addextendedproperty N'MS_Description', N'Name of database table storing classifiers', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'TableName'

EXECUTE sp_addextendedproperty N'MS_Description', N'Revision of the classification', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty N'MS_Description', N'Date of creation in database', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'Created'

EXECUTE sp_addextendedproperty N'MS_Description', N'Date of last modification in database', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'Modified'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'ETL', N'TABLE', N'DSDimension', N'COLUMN', N'TextDa'
GO