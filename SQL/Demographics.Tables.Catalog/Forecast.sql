/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Catalog/Forecast.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.Forecast
  
  Purpose       : Stores a catalog of forecasts to be used for exogenous specification in projections.

  Alternate keys: Title, Revision
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.Forecast', 'U') IS NOT NULL
DROP TABLE Demographics.Forecast
GO

CREATE TABLE Demographics.Forecast (

  ForecastID smallint identity(1,1) not null,
  Class varchar(20) not null, 
  Title varchar(100) not null,
  Caption varchar(100) null,
  
  ReferenceID smallint null,
  EstimationID smallint null,
  
  Revision tinyint not null constraint DF_Forecast_Revision default 0,
  Created datetime not null constraint DF_Forecast_Created default (getdate()),
  Modified datetime not null constraint DF_Forecast_Modified default (getdate()),
  UserName sysname not null,
  LoginName sysname not null,
  
  IsReadOnly bit not null constraint DF_Forecast_IsReadOnly default 0,
  IsPublished bit not null constraint DF_Forecast_IsPublished default 0,

  TextEn varchar(600) not null 
    constraint DF_Forecast_TextEn default ('No description available.'),
  TextDa varchar(600) collate Danish_Norwegian_CI_AS not null 
    constraint DF_Forecast_TextDa default ('Beskrivelse mangler.'),

  Parameters xml null,
  
  CONSTRAINT PK_Forecast PRIMARY KEY (ForecastID DESC),
  CONSTRAINT IX_Forecast_Unique UNIQUE (Title, Class, Revision),

  CONSTRAINT FK_Forecast_ReferenceProjection FOREIGN KEY (ReferenceID)
  REFERENCES Demographics.Projection (ProjectionID),

  CONSTRAINT FK_Forecast_Estimation FOREIGN KEY (EstimationID)
  REFERENCES Demographics.Estimation (EstimationID),

  CONSTRAINT CK_Forecast_Class CHECK (Class IN (
    'Fertility', 'Mortality', 'Immigration', 'Emigration', 'Naturalization', 'Birth'
  ))

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Catalog of forecasts of demographic phenomena.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'String identifying the class or subject of the forecast (check constrained).',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Class'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short title for the forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Title'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short symbolic name for internal identification of the forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Caption'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The projection to which this forecast represents a schock (if any).',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'ReferenceID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'The estimation results that this forecast is based on (if any).',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'EstimationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Revision number.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date of creation in the database.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Created'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Date of last modification in the database.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Modified'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Database user name of creator / modifier.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'UserName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Login name of creator / modifier.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'LoginName'

EXECUTE sp_addextendedproperty
N'MS_Description', N'States whether the forecast is read only.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'IsReadOnly'

EXECUTE sp_addextendedproperty
N'MS_Description', N'States whether the forecast participates in published projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'IsPublished'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short description of the forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Short description of the forecast in Danish.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'TextDa'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Runtime parameters used by the forecast component.',
N'SCHEMA', N'Demographics', N'TABLE', N'Forecast', N'COLUMN', N'Parameters'
GO