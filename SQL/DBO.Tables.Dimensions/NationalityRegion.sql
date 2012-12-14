/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/NationalityRegion.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.NationalityRegion
  
  Purpose       : Mapping nationality and region (normalization table)
  
  Primary key   : NationalityID, RegionID
  
  Foreign keys  : NationalityID on dbo.Nationality (cascades updates and deletes)
                  RegionID on dbo.Region.RegionID

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.NationalityRegion', 'U') IS NOT NULL
DROP TABLE dbo.NationalityRegion
GO


CREATE TABLE  dbo.NationalityRegion (

  NationalityID tinyint not null,
  RegionID smallint not null,
  
  CONSTRAINT PK_NationalityRegion PRIMARY KEY CLUSTERED (NationalityID, RegionID),
  
  CONSTRAINT FK_NationalityRegion_Nationality FOREIGN KEY (NationalityID)
  REFERENCES dbo.Nationality (NationalityID),
    
  CONSTRAINT FK_NationalityRegion_Region FOREIGN KEY (RegionID)
  REFERENCES dbo.Region (RegionID)
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Mapping nationality and region (many to many normalization)',
N'SCHEMA', N'dbo', N'TABLE', N'NationalityRegion'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for nationality',
N'SCHEMA', N'dbo', N'TABLE', N'NationalityRegion', N'COLUMN', N'NationalityID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for region',
N'SCHEMA', N'dbo', N'TABLE', N'NationalityRegion', N'COLUMN', N'RegionID'
GO