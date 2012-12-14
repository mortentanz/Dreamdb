/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSParents.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.DSParents
  
  Purpose       : Stored microlevel observations of parent attributes for newborn children
  
  Primary key   : DSParentsID (pseudo identity)
  
  Alternate key : ChildPNR (not implemented)
  
  Foreign keys  : Several foreign key relationships are defined, see implementation
  
  Columns       : Children are uniquely identified using PNR and classified by foreign keys to origintype,
                  region and gender. Region is mapped for nationality, citizenship and birthregion. All
                  columns characterizing individual children are defined as not nullable
                  
                  For mothers and fathers the same characteristics apply, though all are nullable (implying
                  unknown or unregistrered mother or father respectively) and characteristics for fathers 
                  and mothers include age and supresses gender.
  
-----------------------------------------------------------------------------------------------------------*/
IF OBJECT_ID('Demographics.DSParents', 'U') IS NOT NULL
DROP TABLE Demographics.DSParents
GO


CREATE TABLE Demographics.DSParents (

  DSParentsID int identity(1,1) not null,
  DatasetID smallint not null,
  
  -- Child attributes
  ChildPNR varchar(10) not null,
  ChildOriginTypeID tinyint not null,
  ChildNationalityRegionID smallint not null,
  ChildCitizenshipRegionID smallint not null,
  ChildBirthRegionID smallint not null,
  ChildGenderID tinyint not null,
  
  -- Mothers attributes, all nullable  
  MotherPNR varchar(10) null,
  MotherOriginTypeID tinyint null,
  MotherNationalityRegionID smallint null,
  MotherCitizenshipRegionID smallint null,
  MotherBirthRegionID smallint null,
  MotherAge tinyint null,

  -- Fathers attributes, all nullable
  FatherPNR varchar(10) null,
  FatherOriginTypeID tinyint null,
  FatherNationalityRegionID smallint null,
  FatherCitizenshipRegionID smallint null,
  FatherBirthRegionID smallint null,
  FatherAge tinyint null,

  [Year] smallint not null,

  CONSTRAINT PK_DSParents PRIMARY KEY CLUSTERED (DSParentsID),
  
  CONSTRAINT FK_DSParents_DSCatalog FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_DSParents_ChildOriginType FOREIGN KEY (ChildOriginTypeID)
  REFERENCES dbo.OriginType (TypeID),
      
  CONSTRAINT FK_DSParents_ChildNationalityRegion FOREIGN KEY (ChildNationalityRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_ChildCitizenshipRegion FOREIGN KEY (ChildCitizenshipRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_ChildBirthRegion FOREIGN KEY (ChildBirthRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_ChildGender FOREIGN KEY (ChildGenderID)
  REFERENCES dbo.Gender (GenderID),
  
  CONSTRAINT FK_DSParents_MotherOriginType FOREIGN KEY (MotherOriginTypeID)
  REFERENCES dbo.OriginType (TypeID),
      
  CONSTRAINT FK_DSParents_MotherNationalityRegion FOREIGN KEY (MotherNationalityRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_MotherCitizenshipRegion FOREIGN KEY (MotherCitizenshipRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_MotherBirthRegion FOREIGN KEY (MotherBirthRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_FatherOriginType FOREIGN KEY (FatherOriginTypeID)
  REFERENCES dbo.OriginType (TypeID),
      
  CONSTRAINT FK_DSParents_FatherNationalityRegion FOREIGN KEY (FatherNationalityRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_FatherCitizenshipRegion FOREIGN KEY (FatherCitizenshipRegionID)
  REFERENCES dbo.Region (RegionID),
  
  CONSTRAINT FK_DSParents_FatherBirthRegion FOREIGN KEY (FatherBirthRegionID)
  REFERENCES dbo.Region (RegionID)
)
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Micro-level data on parents to new-born children.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key, identity column.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'DSParentsID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalog information on dataset.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'DatasetID'
  
EXECUTE sp_addextendedproperty
N'MS_Description', N'Unique string identifying child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'ChildPNR'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Origin type of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'ChildOriginTypeID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region of nationality of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'ChildNationalityRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region issuing citizenship for child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'ChildCitizenshipRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region in which child was born.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'ChildBirthRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Gender of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'ChildGenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Unique string identifying mother of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'MotherPNR'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Origin type of mother',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'MotherOriginTypeID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region of nationality of mother.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'MotherNationalityRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region issuing citizenship to mother.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'MotherCitizenshipRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region in which mother was born.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'MotherBirthRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of mother.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'MotherAge'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Unique string identifying father.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'FatherPNR'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Origin type of father.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'FatherOriginTypeID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region of nationality of father.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'FatherNationalityRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region issuing citizenship to father.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'FatherCitizenshipRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Region in which father was born.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'FatherBirthRegionID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of father.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'FatherAge'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSParents', N'COLUMN', N'Year'
GO