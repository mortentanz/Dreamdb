/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Catalog/Projection.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.Projection
  
  Primary key   : ProjectionID (pseudo identity)

  Alternate keys: Title, Revision
  
  Remarks       : All CRUD operations against the table are attended to by Insert / Update / Delete procs
                  that are programmed as to maintain referential integrity of the projection entities.

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Projection', 'U') IS NOT NULL
DROP TABLE Demographics.Projection
GO

CREATE TABLE Demographics.Projection (

  ProjectionID smallint identity(1,1) not null,
  Title varchar(100) not null,
  Caption varchar(100) null,
    
  Revision tinyint not null constraint DF_Projection_Revision default 0,
  Created datetime not null constraint DF_Projection_Created default (getdate()),
  Modified datetime not null constraint DF_Projection_Modified default (getdate()),
  UserName sysname not null,
  LoginName sysname not null,
  
  IsReadOnly bit not null constraint DF_Projection_IsReadOnly default 0,
  IsPublished bit not null constraint DF_Projection_IsPublished default 0,

  TextEn varchar(600) not null 
    constraint DF_Projection_TextEn default ('No description available.'),
  TextDa varchar(600) collate Danish_Norwegian_CI_AS not null 
    constraint DF_Projection_TextDa default ('Beskrivelse mangler.'),

  Parameters xml null,
  
  CONSTRAINT PK_Projection PRIMARY KEY (ProjectionID DESC),
  CONSTRAINT IX_Projection_Title_Unique UNIQUE (Title, Revision)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Catalog of demographic projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key for identifying projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short title for the projection.', 
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'Title'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short symbolic name for internal identification of the projection.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'Caption'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Revision number.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date of creation in the database.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'Created'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date of last modification in the database.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'Modified'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Database user name of creator / modifier.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'UserName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Login name of creator / modifier.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'LoginName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'States whether the projection is readonly.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'IsReadOnly'

EXECUTE sp_addextendedproperty
N'MS_Description', N'States whether the projection is published to external users. Implies readonly if set.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'IsPublished'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Brief explanatory text in English.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Brief explanatory text in Danish.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'TextDa'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Runtime parameter values as used by projection component.',
N'SCHEMA', N'Demographics', N'TABLE', N'Projection', N'COLUMN', N'Parameters'
GO