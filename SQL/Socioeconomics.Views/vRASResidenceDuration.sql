/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Views/vRASResidenceDuration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Socioeconomics.vRASResidenceDuration
  
  Purpose       : Immigrants by duration of residence as available from most recent RAS datasets.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.vRASResidenceDuration', 'V') IS NOT NULL
DROP VIEW Socioeconomics.vRASResidenceDuration
GO

CREATE VIEW Socioeconomics.vRASResidenceDuration
AS
SELECT r.OriginID, r.GenderID, r.DurationID, r.Age, r.[Year], sum(r.Persons) AS Persons
FROM Socioeconomics.RAS r
  INNER JOIN Socioeconomics.Origin so ON r.OriginID = so.OriginID
  INNER JOIN Socioeconomics.RASCatalog rc ON rc.DatasetID = r.DatasetID
  INNER JOIN Socioeconomics.StatusTree st ON r.NodeID = st.NodeID
WHERE 
  rc.DataRevision = (SELECT max(DataRevision) FROM Socioeconomics.RASCatalog WHERE [Year] = r.[Year]) AND
  rc.StatusRevision = (SELECT max(StatusRevision) FROM Socioeconomics.RASCatalog WHERE [Year] = r.[Year]) AND
  st.ParentID IS NULL AND -- The population total is the root node in any StatusTree revision
  so.TypeID = 2 -- We only want immigrant origins
GROUP BY r.GenderID, r.OriginID, r.DurationID, r.Age, r.[Year]
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Immigrants by duration of residence as available from most recent RAS datasets.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for gender.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for origin as represented in the socioeconomics schema.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for duration of residence.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration', N'COLUMN', N'DurationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Total number of persons.', 
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASResidenceDuration', N'COLUMN', N'Persons'
GO