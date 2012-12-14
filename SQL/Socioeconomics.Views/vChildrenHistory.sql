/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Views/vChildrenHistory.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Socioeconomics.vChildrenHistory
  
  Purpose       : Historic child population at origin specification used in the socioeconomics schema.
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.vChildrenHistory', 'V') IS NOT NULL
DROP VIEW Socioeconomics.vChildrenHistory
GO

CREATE VIEW Socioeconomics.vChildrenHistory
AS

	SELECT so.OriginID, p.GenderID, p.Age, p.MotherAge, p.[Year], sum(p.Persons) AS Persons
	FROM Demographics.DSChildren p
		INNER JOIN Demographics.DSCatalog dsc ON p.DatasetID = dsc.DatasetID
		INNER JOIN Demographics.Origin do ON p.OriginID = do.OriginID
		INNER JOIN Socioeconomics.Origin so ON 
			(so.TypeID = 1 AND do.TypeID = 1) OR	(so.TypeID = do.TypeID AND so.NationalityID = do.NationalityID)
	WHERE
		p.Age < 18 AND
		dsc.Revision = (
			SELECT max(Revision) FROM Demographics.DSCatalog WHERE Setname = 'CHILDREN' AND [Year] = p.[Year]
		)
	GROUP BY so.OriginID, p.GenderID, p.Age, p.MotherAge, p.[Year]

GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Historic population of children by age of mother (see description of MotherAge).',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Origin of children at representation used in socioeconomics.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Gender of children.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of children.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age of mother (zero implies that mother is not known).',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory', N'COLUMN', N'MotherAge'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of observation',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Number of children.',
N'SCHEMA', N'Socioeconomics', N'VIEW', N'vChildrenHistory', N'COLUMN', N'Persons'
GO