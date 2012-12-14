/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/HMDLife.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Table         : Demographics.HMDLife
  
  Purpose       : Stores life table data from the Human Mortality Database (HMD)
                  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.HMDLife', 'U') IS NOT NULL
DROP TABLE Demographics.HMDLife
GO


CREATE TABLE Demographics.HMDLife (

  HMDLifeID int identity(1,1) not null,
  DatasetID smallint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Rate float not null,
  Frequency float not null,
  AverageLived float not null,
  Survivors int not null,
  Deaths int not null,
  YearsLived int not null,
  YearsRemaining int not null,
  LifeExpectancy float not null,

  CONSTRAINT PK_HMDMortality PRIMARY KEY CLUSTERED (HMDLifeID DESC),
  CONSTRAINT IX_HMDMortality_Unique UNIQUE (DatasetID, Age, [Year]),
  
  CONSTRAINT FK_HMDMortality_HMDCatalog FOREIGN KEY (DatasetID)
		REFERENCES Demographics.HMDCatalog (DatasetID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
  
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Lifetable data from the Human Mortality Database.',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for HMD source dataset.',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Mortality rate (mx)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'Rate'    

EXECUTE sp_addextendedproperty
N'MS_Description', N'Mortality frequency (qx)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'Frequency' 

EXECUTE sp_addextendedproperty
N'MS_Description', N'Average years lived before dying at specified age (ax)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'AverageLived'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of survivors (lx)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'Survivors'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of deaths (dx)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'Deaths'   

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of person-years lived (Lx)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'YearsLived'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons-years remaining (Tx)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'YearsRemaining'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Life expectancy (ex)',
N'SCHEMA', N'Demographics', N'TABLE', N'HMDLife', N'COLUMN', N'LifeExpectancy'
GO