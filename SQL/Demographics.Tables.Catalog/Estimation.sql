/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Catalog/Estimation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.Estimation
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Estimation', 'U') IS NOT NULL
DROP TABLE Demographics.Estimation
GO

CREATE TABLE Demographics.Estimation (

  EstimationID smallint identity(1,1) not null,
  Class varchar(20) not null, 
  Title varchar(100) not null,
  Caption varchar(100) null,
  FirstYear smallint not null,
  LastYear smallint not null,
  LastSampleYear smallint null,
  
  Revision tinyint not null constraint DF_Estimation_Revision default 0,
  Created datetime not null constraint DF_Estimation_Created default (getdate()),
  Modified datetime not null constraint DF_Estimation_Modified default (getdate()),
  UserName sysname not null,
  LoginName sysname not null,
  
  IsReadOnly bit not null constraint DF_Estimation_IsReadOnly default 0,
  IsPublished bit not null constraint DF_Estimation_IsPublished default 0,

  TextEn varchar(600) not null 
    constraint DF_Estimation_TextEn default ('No description available.'),
  TextDa varchar(600) collate Danish_Norwegian_CI_AS not null 
    constraint DF_Estimation_TextDa default ('Beskrivelse mangler.'),
  
  Parameters xml null,
  
  CONSTRAINT PK_Estimation PRIMARY KEY (EstimationID DESC),
  CONSTRAINT IX_Estimation_Unique UNIQUE (Title, Class, Revision, FirstYear, LastYear, LastSampleYear),

  CONSTRAINT CK_Estimation_Class CHECK (Class IN ('Fertility', 'Mortality', 'Immigration', 'Emigration'))

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Catalog of inference based projections of fertility, mortality and migration.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'EstimationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'String describing the subject of the estimation (Fertility, Mortality, Immigration or Emigration).',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Class'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short title for the estimation.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Title'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short symbolic identifier for the estimation used internally.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Caption'

EXECUTE sp_addextendedproperty
N'MS_Description', N'First year in estimation result time series.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'FirstYear'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Last year in estimation result time series.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'LastYear'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Last sample year in estimation result time series.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'LastSampleYear'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Revision identification.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date and time that the estimation was added to the database.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Created'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date and time that the estimation was last modified.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Modified'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Database user name of creator / modifier.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'UserName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Database login name of creator / modifier.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'LoginName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'States whether the estimation is marked read only.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'IsReadOnly'

EXECUTE sp_addextendedproperty
N'MS_Description', N'States whether the estimation is used for producing published projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'IsPublished'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Description of the estimation.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Description of the estimation in Danish.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'TextDa'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Runtime parameters used by the estimation component.',
N'SCHEMA', N'Demographics', N'TABLE', N'Estimation', N'COLUMN', N'Parameters'
GO