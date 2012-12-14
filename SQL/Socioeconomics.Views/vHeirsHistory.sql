/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Views/vHeirsHistory.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Socioeconomics.vHeirsHistory
  
  Purpose       : Number of persons having mothers of age likely to leave bequests (by model convention).
  
  Remarks       : The number of persons is not supposed to add up to the population in the relevant gender /
                  age group, since persons whose parents has left the country, are deceased or simply 
                  unknown are not included in the data.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.vHeirsHistory', 'V') IS NOT NULL
DROP VIEW Socioeconomics.vHeirsHistory
GO

CREATE VIEW Socioeconomics.vHeirsHistory 
AS
	SELECT p.GenderID, p.Age, p.MotherAge, p.[Year], sum(p.Persons) AS Persons
	FROM Demographics.DSChildren p
		INNER JOIN Demographics.DSCatalog dsc ON p.DatasetID = dsc.DatasetID
	WHERE
		p.MotherAge BETWEEN 72 AND 76  AND

		dsc.Revision = (
			SELECT max(Revision) FROM Demographics.DSCatalog WHERE Setname = 'CHILDREN' AND [Year] = p.[Year]
		)
	GROUP BY p.GenderID, p.Age, p.MotherAge, p.[Year]
GO


EXECUTE sp_addextendedproperty
N'MS_Description', N'Number persons by age of mothers in the range of ages leaving bequests.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vHeirsHistory'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Identifier for gender.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vHeirsHistory', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vHeirsHistory', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of mother in range of ages leaving bequests.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vHeirsHistory', N'COLUMN', N'MotherAge'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vHeirsHistory', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of persons.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vHeirsHistory', N'COLUMN', N'Persons'
GO