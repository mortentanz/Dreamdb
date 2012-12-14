/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Views/vPopulationHistory.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Socioeconomics.vPopulationHistory
  
  Purpose       : Historic population at origin specification used in the socioeconomics schema.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.vPopulationHistory', 'V') IS NOT NULL
DROP VIEW Socioeconomics.vPopulationHistory
GO

CREATE VIEW Socioeconomics.vPopulationHistory AS
SELECT so.OriginID, p.GenderID, p.Age, p.[Year], sum(p.Persons) AS Persons
FROM Demographics.DSChildren p
  INNER JOIN Demographics.DSCatalog dsc ON p.DatasetID = dsc.DatasetID
	INNER JOIN Demographics.Origin o ON p.OriginID = o.OriginID
	INNER JOIN Socioeconomics.Origin so ON 
		(so.TypeID = 1 AND o.TypeID = 1) OR	(so.TypeID = o.TypeID AND so.NationalityID = o.NationalityID)
WHERE
  dsc.Revision = (
    SELECT max(Revision) FROM Demographics.DSCatalog WHERE Setname = 'CHILDREN' AND [Year] = p.[Year]
  )
GROUP BY so.OriginID, p.GenderID, p.Age, p.[Year]
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Historic population at origin specification used in the socioeconomics schema.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vPopulationHistory'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for origin as specified in the socioeconommics schema.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for gender.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation (primo).',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vPopulationHistory', N'COLUMN', N'Persons'
GO