/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Facts/DSBirths.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.DSBirths
  
  Purpose       : Number of newborn children by age of mothers
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.DSBirths', 'U') IS NOT NULL
DROP TABLE Demographics.DSBirths
GO


CREATE TABLE Demographics.DSBirths (

  DSBirthsID int identity(1,1) not null,
  DatasetID smallint not null,
  ChildOriginID tinyint not null,
  ChildGenderID tinyint not null,
  Age tinyint not null,
  [Year] smallint not null,
  Persons int not null,
  
  CONSTRAINT PK_DSBirths PRIMARY KEY CLUSTERED (DSBirthsID),
  
  CONSTRAINT IX_DSBirthsUnique UNIQUE NONCLUSTERED (
    ChildOriginID,
    ChildGenderID,
    Age,
    [Year]
  ),
  
  CONSTRAINT FK_DSBirths_DSCatalog FOREIGN KEY (DatasetID)
  REFERENCES Demographics.DSCatalog (DatasetID)
  ON DELETE CASCADE,
  
  CONSTRAINT FK_DSBirths_ChildOrigin FOREIGN KEY (ChildOriginID)
  REFERENCES Demographics.Origin (OriginID),
  
  CONSTRAINT FK_DSBirths_ChildGender FOREIGN KEY (ChildGenderID)
	REFERENCES dbo.Gender (GenderID)
 
)
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of births grouped by origin, gender, and mothers age over the course of year.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key (identity column).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'DSBirthsID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for catalog dataset information.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for national origin of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'ChildOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender of child.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'ChildGenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of mother giving birth (using ultimo convention).',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of children.',
N'SCHEMA', N'Demographics', N'TABLE', N'DSBirths', N'COLUMN', N'Persons'
GO