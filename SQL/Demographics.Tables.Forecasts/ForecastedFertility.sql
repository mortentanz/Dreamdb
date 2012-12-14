/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Forecasts/ForecastedFertility.sql $
  $Revision: 2 $
  $Date: 12/21/06 12:57 $
  $Author: mls $

  Table         : Demographics.ForecastedFertility
  
  Purpose       : Stores forecasted fertility to be used for exogenous specification in projections

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.ForecastedFertility', 'U') IS NOT NULL
DROP TABLE Demographics.ForecastedFertility
GO

CREATE TABLE Demographics.ForecastedFertility (
  
  EstimateID bigint identity(1,1) not null,
  ForecastID smallint not null,
  OriginID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_ForecastedFertility PRIMARY KEY (EstimateID),
  CONSTRAINT IX_ForecastedFertility_Unique UNIQUE ([Year], ForecastID, OriginID, Age),
  
  CONSTRAINT FK_ForecastedFertility_Forecast FOREIGN KEY (ForecastID)
  REFERENCES Demographics.Forecast (ForecastID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_ForecastedFertility_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted fertility to be used for exogenous specification in projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for forecast information.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted fertility.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedFertility', N'COLUMN', N'Estimate'
GO