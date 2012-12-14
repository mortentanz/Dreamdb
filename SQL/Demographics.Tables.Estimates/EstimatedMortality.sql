/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Estimates/EstimatedMortality.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.EstimatedMortality
  
  Purpose       : Stores sample and inference based estimates of mortality
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.EstimatedMortality', 'U') IS NOT NULL
DROP TABLE Demographics.EstimatedMortality
GO

CREATE TABLE Demographics.EstimatedMortality (
  
  EstimateID bigint identity(1,1) not null,
  EstimationID smallint not null,
  
  OriginID tinyint not null constraint DF_EstimatedMortality_Origin default (0),
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_EstimatedMortality PRIMARY KEY (EstimateID),
  CONSTRAINT IX_EstimatedMortality_Unique UNIQUE ([Year], EstimationID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_EstimatedMortality_Estimation FOREIGN KEY (EstimationID)
  REFERENCES Demographics.Estimation (EstimationID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_EstimatedMortality_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_EstimatedMortality_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Stores forecasted emigration for exogenous specification in projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for estimation information.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'EstimationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin (defaults to unknown).',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of estimate.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimated mortality.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedMortality', N'COLUMN', N'Estimate'
GO