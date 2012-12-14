/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Forecasts/ForecastedEmigration.sql $
  $Revision: 2 $
  $Date: 12/21/06 12:57 $
  $Author: mls $

  Table         : Demographics.ForecastedEmigration
  
  Purpose       : Stores forecasted emigration for use as exogenous inputs in projections.
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.ForecastedEmigration', 'U') IS NOT NULL
DROP TABLE Demographics.ForecastedEmigration
GO

CREATE TABLE Demographics.ForecastedEmigration (
  
  EstimateID bigint identity(1,1) not null,
  ForecastID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_ForecastedEmigration PRIMARY KEY (EstimateID),
  CONSTRAINT IX_ForecastedEmigration_Unique UNIQUE ([Year], ForecastID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_ForecastedEmigration_Forecast FOREIGN KEY (ForecastID)
  REFERENCES Demographics.Forecast (ForecastID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_ForecastedEmigration_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_ForecastedEmigration_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Stores forecasted emigration for exogenous specification in projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for forecast information.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted emigration level or frequency.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedEmigration', N'COLUMN', N'Estimate'
GO