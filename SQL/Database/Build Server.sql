/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Build Server.sql $
  $Revision: 4 $
  $Date: 12/21/06 12:11 $
  $Author: mls $
  
  SQLCMD script for building the the Dreamdb database and initialize its state on FMDREAM1.

-----------------------------------------------------------------------------------------------------------*/
:setvar server FMDREAM1
:setvar dbname Dreamdb

-- Local working folder (solution root)
:setvar solutions "F:\Solutions\Dreamdb\"
:setvar sqlroot "F:\Solutions\Dreamdb\SQL\"

-- Paths for data file and log file (filenames are generated by the Database.sql script)
:setvar mdfpath "E:\SQLData\"
:setvar ldfpath "E:\SQLData\"

-- Initiate SQLCMD build scripts.
:r $(solutions)\SQL\Database\"Create Database.sql"
:r $(solutions)\SQL\Database\"Create Messages.sql"
:r $(solutions)\SQL\Database\"Create Schemas.sql"
:r $(solutions)\SQL\Database\"Create Tables.sql"
:r $(solutions)\SQL\Database\"Create Views.sql"
:r $(solutions)\SQL\Database\"Create CLR Objects.sql"
:r $(solutions)\SQL\Database\"Create Functions.sql"
:r $(solutions)\SQL\Database\"Create Procedures.sql"
:r $(solutions)\SQL\Database\"Create Permissions.sql"
print 'DONE!'
go
