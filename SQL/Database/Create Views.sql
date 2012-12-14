/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Views.sql $
  $Revision: 2 $
  $Date: 12/19/06 11:14 $
  $Author: mls $
-----------------------------------------------------------------------------------------------------------*/
print 'Creating views in $(dbname)..'
go

:r $(sqlroot)Demographics.Views\vPopulationHistory.sql
:r $(sqlroot)Demographics.Views\vDSChildOrigin.sql
:r $(sqlroot)Demographics.Views\vMortalityMedio.sql
:r $(sqlroot)Socioeconomics.Views\vChildrenHistory.sql
:r $(sqlroot)Socioeconomics.Views\vHeirsHistory.sql
:r $(sqlroot)Socioeconomics.Views\vPopulationHistory.sql
:r $(sqlroot)Socioeconomics.Views\vRASByStatus.sql
:r $(sqlroot)Socioeconomics.Views\vRASResidenceDuration.sql
print ' -> Created views'
go