/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Forecasts/ForecastedBirthNaturalization.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.ForecastedBirthNaturalization
  
  Purpose       : Stores forecasted 

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.ForecastedBirthNaturalization', 'U') IS NOT NULL
DROP TABLE Demographics.ForecastedBirthNaturalization
GO

CREATE TABLE Demographics.ForecastedBirthNaturalization (
	
	EstimateID int identity(1,1) not null,
	ForecastID smallint not null,
	MotherOriginID tinyint not null,
	FatherOriginID tinyint constraint DF_ForecastedBirthNaturalization_FatherOrigin default (0) not null,
	[Year] smallint not null,
	Estimate float not null,
	
	CONSTRAINT PK_ForecastedBirthNaturalization PRIMARY KEY (EstimateID),
	
	CONSTRAINT IX_ForecastedBirthNaturalization_Unique UNIQUE (ForecastID, MotherOriginID, FatherOriginID, [Year]),
	
	CONSTRAINT FK_ForecastedBirthNaturalization_Forecast FOREIGN KEY (ForecastID)
	REFERENCES Demographics.Forecast (ForecastID)
	ON DELETE CASCADE, 
	
	CONSTRAINT FK_ForecastedBirthNaturalization_MotherOrigin FOREIGN KEY (MotherOriginID)
	REFERENCES Demographics.Origin (OriginID),
	
	CONSTRAINT FK_ForecastedBirthNaturalization_FatherOrigin FOREIGN KEY (FatherOriginID)
	REFERENCES Demographics.Origin (OriginID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Propability that a child will attain mothers origin by naturalization given fathers origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for (Birth) forecast information.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for mothers origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization', N'COLUMN', N'MotherOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for fathers origin (defaults to NA).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization', N'COLUMN', N'FatherOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimate',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthNaturalization', N'COLUMN', N'Estimate'
GO