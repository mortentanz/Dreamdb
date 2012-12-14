/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Forecasts/ForecastedBirthOrigin.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.ForecastedBirthOrigin
  
  Purpose       : Stores

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.ForecastedBirthOrigin', 'U') IS NOT NULL
DROP TABLE Demographics.ForecastedBirthOrigin
GO

CREATE TABLE Demographics.ForecastedBirthOrigin (
	
	EstimateID int identity(1,1) not null,
	ForecastID smallint not null,
	MotherOriginID tinyint not null,
	FatherOriginID tinyint constraint DF_ForecastedBirthOrigin_FatherOrigin default (0) not null,
	[Year] smallint not null,
	Estimate float not null,
	
	CONSTRAINT PK_ForecastedBirthOrigin PRIMARY KEY (EstimateID),
	
	CONSTRAINT IX_ForecastedBirthOrigin_Unique UNIQUE (ForecastID, MotherOriginID, FatherOriginID, [Year]),
	
	CONSTRAINT FK_ForecastedBirthOrigin_Forecast FOREIGN KEY (ForecastID)
	REFERENCES Demographics.Forecast (ForecastID)
	ON DELETE CASCADE, 
	
	CONSTRAINT FK_ForecastedBirthOrigin_MotherOrigin FOREIGN KEY (MotherOriginID)
	REFERENCES Demographics.Origin (OriginID),
	
	CONSTRAINT FK_ForecastedBirthOrigin_FatherOrigin FOREIGN KEY (FatherOriginID)
	REFERENCES Demographics.Origin (OriginID)

)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Propability that a newborn child will attain mothers origin given fathers origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for (Birth) forecast information.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin', N'COLUMN', N'ForecastID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for mothers origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin', N'COLUMN', N'MotherOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for fathers origin (defaults to NA).',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin', N'COLUMN', N'FatherOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year.',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimate',
N'SCHEMA', N'Demographics', N'TABLE', N'ForecastedBirthOrigin', N'COLUMN', N'Estimate'
GO