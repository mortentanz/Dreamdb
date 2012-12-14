/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/Duration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.Duration
  
  Purpose       : Duration measured in years
  
  Primary key   : DurationID
  
  Columns
  Years         : The number of years (the duration)
  TextEn        : Brief textual description in English
  TextDa        : Brief textual description in Danish

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.Duration', 'U') IS NOT NULL
DROP TABLE dbo.Duration
GO

CREATE TABLE dbo.Duration (

  DurationID smallint not null,
  Years tinyint null,
  TextEn varchar(50) not null,
  TextDa varchar(50) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Duration PRIMARY KEY CLUSTERED (DurationID)

)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Duration measured in years', 
N'SCHEMA', N'dbo', N'TABLE', N'Duration'

EXECUTE sp_addextendedproperty N'MS_Description', N'Surrogate primary key', 
N'SCHEMA', N'dbo', N'TABLE', N'Duration', N'COLUMN', N'DurationID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Years of duration', 
N'SCHEMA', N'dbo', N'TABLE', N'Duration', N'COLUMN', N'Years'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'dbo', N'TABLE', N'Duration', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'dbo', N'TABLE', N'Duration', N'COLUMN', N'TextDa'
GO