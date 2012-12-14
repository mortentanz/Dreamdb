/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Views/vMortalityMedio.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  View          : Demographics.vMortalityMedio
  
  Purpose       : Mortality rate estimation results mediofied for calculation of expected remaining lifetime.
                  
  
-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.vMortalityMedio', 'V') IS NOT NULL
DROP VIEW Demographics.vMortalityMedio
GO

CREATE VIEW Demographics.vMortalityMedio 
AS

	SELECT u.EstimationID, u.OriginID, u.GenderID, u.Age, u.[Year], 0.5 * (u.Estimate + p.Estimate) AS Estimate
	FROM Demographics.EstimatedMortality u
	INNER JOIN Demographics.EstimatedMortality p ON 
		u.EstimationID = p.EstimationID AND 
		u.OriginID = p.OriginID AND
		u.GenderID = p.GenderID AND
		u.Age = p.Age AND
		u.[Year] = p.[Year] + 1

GO

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimated mortality rates mediofied for calculation of expected remaining lifetime.',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Estimation catalog identification.',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio', N'COLUMN', N'EstimationID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Origin identification (likely NA).',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio', N'COLUMN', N'OriginID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Gender identification.',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio', N'COLUMN', N'GenderID'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Age.',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio', N'COLUMN', N'Age'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Year of estimate (ultimo).',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio', N'COLUMN', N'Year'

EXECUTE sp_addextendedproperty
N'MS_Description', N'Medio (over year) representation of estimated mortality',
N'SCHEMA', N'Demographics', N'VIEW', N'vMortalityMedio', N'COLUMN', N'Estimate'
GO