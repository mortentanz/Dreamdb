/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Estimates/EstimatedFertility.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.EstimatedFertility
  
  Purpose       : Stores sample and inference based estimates of fertility
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.EstimatedFertility', 'U') IS NOT NULL
DROP TABLE Demographics.EstimatedFertility
GO

CREATE TABLE Demographics.EstimatedFertility (
  
  EstimateID bigint identity(1,1) not null,
  EstimationID smallint not null,
  
  OriginID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_EstimatedFertility PRIMARY KEY (EstimateID),
  CONSTRAINT IX_EstimatedFertility_Unique UNIQUE ([Year], EstimationID, OriginID, Age),
  
  CONSTRAINT FK_EstimatedFertility_Estimation FOREIGN KEY (EstimationID)
  REFERENCES Demographics.Estimation (EstimationID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_EstimatedFertility_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Stores forecasted emigration for exogenous specification in projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for estimation information.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility', N'COLUMN', N'EstimationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of estimate.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimated fertility frequency.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedFertility', N'COLUMN', N'Estimate'
GO