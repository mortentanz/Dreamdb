/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Forecasts/ForecastedNaturalization.sql $
  $Revision: 2 $
  $Date: 12/21/06 12:57 $
  $Author: mls $

  Table         : Demographics.ForecastedNaturalization
  
  Purpose       : Stores forecasted naturalization for use as exogenous data for projections.

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.ForecastedNaturalization', 'U') IS NOT NULL
DROP TABLE Demographics.ForecastedNaturalization
GO

CREATE TABLE Demographics.ForecastedNaturalization (
  
  EstimateID bigint identity(1,1) not null,
  ForecastID smallint not null,
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_ForecastedNaturalization PRIMARY KEY (EstimateID),
  CONSTRAINT IX_ForecastedNaturalization_Unique UNIQUE ([Year], ForecastID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_ForecastedNaturalization_Forecast FOREIGN KEY (ForecastID)
  REFERENCES Demographics.Forecast (ForecastID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_ForecastedNaturalization_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_ForecastedNaturalization_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted naturalization for use as exogenous data for demographic projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for forecast information',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin from which naturalization implies exit.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of forecast.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Forecasted naturalization value.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedNaturalization', N'COLUMN', N'Estimate'
GO