/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Views/vRASByStatus.sql $
  $Revision: 2 $
  $Date: 12/21/06 15:58 $
  $Author: mls $

  View          : Socioeconomics.vRASByStatus
  
  Purpose       : RAS population by socioeconomics status.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Socioeconomics.vRASByStatus', N'V') IS NOT NULL
DROP VIEW Socioeconomics.vRASByStatus
GO

CREATE VIEW Socioeconomics.vRASByStatus AS
SELECT 
  s.StatusID, s.Revision,
  r.DatasetID, r.EducationID, r.RegistrationID, r.DurationID, r.OriginID, r.GenderID, r.Age, r.[Year],
  sum(convert(int, sd.Weight * r.Persons)) AS Persons
FROM Socioeconomics.RAS r
INNER JOIN Socioeconomics.StatusDefinition sd ON r.NodeID = sd.NodeID
INNER JOIN Socioeconomics.Status s ON s.StatusID = sd.StatusID
GROUP BY 
  s.StatusID, s.Revision,
  r.DatasetID, r.EducationID, r.RegistrationID, r.DurationID, r.OriginID, r.GenderID, r.Age, r.[Year]
HAVING sum(convert(int, sd.Weight * r.Persons)) <> 0
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'View presenting RAS population by socioeconomic status',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Status identifier',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'StatusID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Revision of status definition',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'Revision'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identification of RAS dataset',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'DatasetID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Education identifier',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'EducationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for type of education registration',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'RegistrationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for duration of residence in Denmark (DurationTotal not included)',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'DurationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for origin',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identification of gender',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vRASByStatus', N'COLUMN', N'Persons'

GO