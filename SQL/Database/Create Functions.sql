/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Functions.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $
-----------------------------------------------------------------------------------------------------------*/
print 'Creating functions in $(dbname)..'
go

:r $(sqlroot)Demographics.Functions\ufnGetDSEmigration.sql
:r $(sqlroot)Demographics.Functions\ufnGetDSExposedToRisk.sql
:r $(sqlroot)Demographics.Functions\ufnGetDSFertility.sql    
:r $(sqlroot)Demographics.Functions\ufnGetDSImmigration.sql
:r $(sqlroot)Demographics.Functions\ufnGetDSMortalitySimple.sql
:r $(sqlroot)Demographics.Functions\ufnGetDSNaturalized.sql
print ' -> Created functions for Demographics'
go