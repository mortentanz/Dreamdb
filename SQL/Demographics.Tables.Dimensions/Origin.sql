/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Tables.Dimensions/Origin.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Table         : Demographics.Origin
  
  Purpose       : Origin as composed by origintype, nationality and citizenship
  
  Primary key   : OriginID (surrogate identity column)
  Alternate key : TypeID, NationalityID, CitizenshipID

  Foreign keys  : TypeID on Demographics.OriginType.TypeID
                : NationalityID on dbo.Nationality.NationalityID
                : CitizenshipID on dbo.Citizenship.CitizenshipID
  
  Columns
  Label         : Short symbolic label
  TextEn        : Textual description in English
  TextDa        : Textual description in Danish

  Remarks       : Values of zero for TypeID, NationalityID and CitizenshipID implies not available

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.Origin', 'U') IS NOT NULL
DROP TABLE Demographics.Origin
GO


CREATE TABLE Demographics.Origin (

  OriginID tinyint identity(0,1) not null,
  TypeID tinyint not null constraint DF_Origin_TypeID default (0),
  NationalityID tinyint not null constraint DF_Origin_NationalityID default (0),
  CitizenshipID tinyint not null constraint DF_Origin_CitizenshipID default (0),
  
  Label varchar(31) null,
  TextEn varchar(200) not null,
  TextDa varchar(200) collate Danish_Norwegian_CI_AS not null,
  
  CONSTRAINT PK_Origin PRIMARY KEY CLUSTERED (OriginID),
  
  CONSTRAINT FK_Origin_OriginType FOREIGN KEY (TypeID)
    REFERENCES dbo.OriginType (TypeID),
    
  CONSTRAINT FK_Origin_Nationality FOREIGN KEY (NationalityID)
    REFERENCES dbo.Nationality (NationalityID),
    
  CONSTRAINT FK_Origin_Citizenship FOREIGN KEY (CitizenshipID)
    REFERENCES dbo.Citizenship (CitizenshipID)
)
GO


EXECUTE sp_addextendedproperty 
N'MS_Description', N'Origin as composed by origin type, nationality and citizenship',
N'SCHEMA', N'Demographics', N'TABLE', N'Origin'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Surrogate primary key',
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin type',
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'TypeID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for nationality',
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'NationalityID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for citizenship',
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'CitizenshipID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Symbolic label',
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'Label'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in English', 
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'TextEn'

EXECUTE sp_addextendedproperty N'MS_Description', N'Short descriptive text in Danish', 
N'SCHEMA', N'Demographics', N'TABLE', N'Origin', N'COLUMN', N'TextDa'
GO