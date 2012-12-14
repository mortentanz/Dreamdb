/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Views/vDSChildOrigin.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Demographics.vDSChildOrigin
  
  Purpose       : Births by child and mother origin, used for determining child origin distribution given
									mothers origin.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.vDSChildOrigin', 'V') IS NOT NULL
DROP VIEW Demographics.vDSChildOrigin
GO


CREATE VIEW Demographics.vDSChildOrigin
AS

  WITH OriginDetailMap AS (
    SELECT o.OriginID, o.TypeID, nr.RegionID AS NationalityRegionID, cr.RegionID AS CitizenshipRegionID
    FROM Demographics.Origin o
    INNER JOIN dbo.NationalityRegion nr ON o.NationalityID = nr.NationalityID
    INNER JOIN dbo.CitizenshipRegion cr ON o.CitizenshipID = cr.CitizenshipID
  )
  SELECT isnull(modm.OriginID, 0) AS MotherOriginID, isnull(codm.OriginID, 0) AS ChildOriginID, [Year], COUNT(*) AS Children
  FROM Demographics.DSParents p
  LEFT JOIN OriginDetailMap modm ON (
    p.MotherOriginTypeID = modm.TypeID AND
    p.MotherNationalityRegionID = modm.NationalityRegionID AND
    p.MotherCitizenshipRegionID = modm.CitizenshipRegionID
  )
  LEFT JOIN OriginDetailMap codm ON (
    p.ChildOriginTypeID = codm.TypeID AND
    p.ChildNationalityRegionID = codm.NationalityRegionID AND
    p.ChildCitizenshipRegionID = codm.CitizenshipRegionID
  )
  GROUP BY modm.OriginID, codm.OriginID, [Year]

GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of newborn children by origin and mother origin.',
N'SCHEMA', N'Demographics', N'VIEW', N'vDSChildOrigin'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for mothers origin.',
N'SCHEMA', N'Demographics', N'VIEW', N'vDSChildOrigin', N'COLUMN', N'MotherOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for child origin.',
N'SCHEMA', N'Demographics', N'VIEW', N'vDSChildOrigin', N'COLUMN', N'ChildOriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Demographics', N'VIEW', N'vDSChildOrigin', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of children with the specified origin born by mothers with specified origin.',
N'SCHEMA', N'Demographics', N'VIEW', N'vDSChildOrigin', N'COLUMN', N'Children'
GO