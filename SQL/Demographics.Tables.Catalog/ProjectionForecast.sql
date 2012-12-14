/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Catalog/ProjectionForecast.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.ProjectionForecast
  
  Purpose       : Normalization table mapping the relationship between projections and forecasts

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.ProjectionForecast', 'U') IS NOT NULL
DROP TABLE Demographics.ProjectionForecast
GO

CREATE TABLE Demographics.ProjectionForecast (
  
  ProjectionID smallint not null,
  ForecastID smallint not null,
  
  CONSTRAINT PK_ProjectionForecast PRIMARY KEY (ProjectionID, ForecastID),
  
  CONSTRAINT FK_ProjectionForecast_Projection FOREIGN KEY (ProjectionID)
  REFERENCES Demographics.Projection (ProjectionID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_ProjectionForecast_Forecast FOREIGN KEY (ForecastID)
  REFERENCES Demographics.Forecast (ForecastID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Normalization table mapping the relationship between projections and forecasts.',
N'SCHEMA', N'Demographics', N'TABLE', N'ProjectionForecast'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for projection.',
N'SCHEMA', N'Demographics', N'TABLE', N'ProjectionForecast', N'COLUMN', N'ProjectionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for forecast participating in definition of the projection.',
N'SCHEMA', N'Demographics', N'TABLE', N'ProjectionForecast', N'COLUMN', N'ForecastID'
GO