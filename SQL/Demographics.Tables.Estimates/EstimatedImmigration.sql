/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Estimates/EstimatedImmigration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.EstimatedImmigration
  
  Purpose       : Stores sample and inference based estimates of immigration
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.EstimatedImmigration', 'U') IS NOT NULL
DROP TABLE Demographics.EstimatedImmigration
GO

CREATE TABLE Demographics.EstimatedImmigration (
  
  EstimateID bigint identity(1,1) not null,
  EstimationID smallint not null,
  
  OriginID tinyint not null,
  GenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Estimate float not null,
  
  CONSTRAINT PK_EstimatedImmigration PRIMARY KEY (EstimateID),
  CONSTRAINT IX_EstimatedImmigration_Unique UNIQUE ([Year], EstimationID, OriginID, GenderID, Age),
  
  CONSTRAINT FK_EstimatedImmigration_Estimation FOREIGN KEY (EstimationID)
  REFERENCES Demographics.Estimation (EstimationID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_EstimatedImmigration_Origin FOREIGN KEY (OriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_EstimatedImmigration_Gender FOREIGN KEY (GenderID)
  REFERENCES dbo.Gender (GenderID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Stores forecasted emigration for exogenous specification in projections.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'EstimateID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for estimation information.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'EstimationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of estimate.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimated fertility frequency.',
N'SCHEMA', N'Demographics', N'TABLE', N'EstimatedImmigration', N'COLUMN', N'Estimate'
GO