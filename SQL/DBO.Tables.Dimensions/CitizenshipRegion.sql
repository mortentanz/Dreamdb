/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Tables.Dimensions/CitizenshipRegion.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : dbo.CitizenshipRegion
  
  Purpose       : Implements the many-to-many relationship between citizenship and region 
  
  Primary key   : CitizenshipID, RegionID
  
  Foreign keys  : CitizenshipID on dbo.Citizenship.CitizenshipID (cascades updates and deletes)
                  RegionID on dbo.Region.RegionID

-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('dbo.CitizenshipRegion', 'U') IS NOT NULL
DROP TABLE dbo.CitizenshipRegion
GO


CREATE TABLE dbo.CitizenshipRegion (

  CitizenshipID tinyint not null,
  RegionID smallint not null,
  
  CONSTRAINT PK_CitizenshipRegion PRIMARY KEY CLUSTERED (CitizenshipID, RegionID),
  
  CONSTRAINT FK_CitizenshipRegion_Citizenship FOREIGN KEY (CitizenshipID)
  REFERENCES dbo.Citizenship (CitizenshipID),
    
  CONSTRAINT FK_CitizenshipRegion_Region FOREIGN KEY (RegionID)
  REFERENCES dbo.Region (RegionID)

)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Mapping citizenship and region (many to many normalization)',
N'SCHEMA', N'dbo', N'TABLE', N'CitizenshipRegion'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for citizenship',
N'SCHEMA', N'dbo', N'TABLE', N'CitizenshipRegion', N'COLUMN', N'CitizenshipID'

EXECUTE sp_addextendedproperty N'MS_Description', N'Foreign key for region',
N'SCHEMA', N'dbo', N'TABLE', N'CitizenshipRegion', N'COLUMN', N'RegionID'
GO