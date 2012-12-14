/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Forecasts/ForecastedMortality.sql $
  $Revision: 2 $
  $Date: 12/21/06 12:57 $
  $Author: mls $

  Table         : Demographics.ForecastedMortality
  
  Purpose       : Stores forecasted mortality to be used as exogenous inputs in projections.

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.ForecastedMortality', 'U') IS NOT NULL
DROP TABLE Demographics.ForecastedMortality
GO

CREATE TABLE Demographics.ForecastedMortality (
  
  EstimateID bigint identity(1,1) not null,
  ForecastID smallint not null,
  OriginID tinyint not null constraint DF_ForecastedMortality_Origin default (0),
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_ForecastedMortality PRIMARY KEY (EstimateID),
  CONSTRAINT IX_ForecastedMortality_Unique UNIQUE ([Year], ForecastID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_ForecastedMortality_Forecast FOREIGN KEY (ForecastID)
  REFERENCES Demographics.Forecast (ForecastID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_ForecastedMortality_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_ForecastedMortality_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted mortality for use as exogenous inputs in projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for forecast information.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin (defaults to not available).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted mortality.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedMortality', N'COLUMN', N'Estimate'
GO