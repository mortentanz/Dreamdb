/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Views/vPopulationHistory.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Demographics.vPopulationHistory
  
  Purpose       : Population by gender, age and full origin specification (without the residual) as 
                  available from the most recent revision of the data in the DSChildren table.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.vPopulationHistory', 'V') IS NOT NULL
DROP VIEW Demographics.vPopulationHistory
GO

CREATE VIEW Demographics.vPopulationHistory AS
SELECT p.OriginID, p.GenderID, p.Age, p.[Year], sum(p.Persons) AS Persons
FROM Demographics.DSChildren p
	INNER JOIN Demographics.DSCatalog dsc ON p.DatasetID = dsc.DatasetID
WHERE dsc.Revision = (SELECT max(Revision) FROM Demographics.DSCatalog WHERE dsc.[Year] = p.[Year])
GROUP BY p.OriginID, p.GenderID, p.Age, p.[Year]
GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Population derived from DSChildren at complete origin specification.',
N'SCHEMA', N'Demographics', N'VIEW', N'vPopulationHistory'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for origin (no residual).',
N'SCHEMA', N'Demographics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Foreign key for gender.',
N'SCHEMA', N'Demographics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation (primo).',
N'SCHEMA', N'Demographics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons.',
N'SCHEMA', N'Demographics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'Persons'
GO