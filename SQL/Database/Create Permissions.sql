/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Permissions.sql $
  $Revision: 2 $
  $Date: 18-12-06 16:06 $
  $Author: Meg $
  
  SQLCMD script granting permissions on database objects.

-----------------------------------------------------------------------------------------------------------*/
print 'Granting database permissions for $(dbname) to Dream users'
go

use master
go

if (0 = (select count(*) from sys.syslogins where name = N'FM\DEP DREAM'))
begin
  CREATE LOGIN [FM\DEP DREAM] FROM WINDOWS
  print ' -> Created server login for Dream windows user group'
end
go

use $(dbname)
go

if (0 = (select count(*) from sys.sysusers where name = N'dream'))
begin
  CREATE USER dream FOR LOGIN [FM\DEP DREAM]
  print ' -> Created database user dream for the FM\DEP DREAM login'
end
go

-- For now all authenticated Dream users are added as owners of the database to
-- provide nearly full access rigths on all objects in the database. This replaces
-- the explicit (least privelege required) approach taken below and do imply 
-- inherently less security and integrity protection.
EXECUTE sp_addrolemember N'db_owner', N'Dream'
go
print ' -> Added dream database user to db_owner role'
go

/*
EXECUTE sp_addrolemember N'db_datareader', N'Dream'
go
print ' -> Added dream database user to db_datareader role'
go

GRANT EXECUTE ON SCHEMA::Demographics TO dream
GRANT INSERT ON SCHEMA::Demographics TO dream
GRANT SELECT ON SCHEMA::Demographics TO dream
GRANT UPDATE ON SCHEMA::Demographics TO dream
GRANT VIEW DEFINITION ON SCHEMA::Demographics TO dream
print ' -> Granted dream database user permissions on Demographics schema'
go

GRANT DELETE ON Demographics.Estimation TO dream
GRANT DELETE ON Demographics.Forecast TO dream
GRANT DELETE ON Demographics.Projection TO dream
print ' -> Granted dream database user delete permissions on selected tables in Demographics'
go

GRANT EXECUTE ON SCHEMA::Socioeconomics TO dream
GRANT INSERT ON SCHEMA::Socioeconomics TO dream
GRANT SELECT ON SCHEMA::Socioeconomics TO dream
GRANT UPDATE ON SCHEMA::Socioeconomics TO dream
GRANT VIEW DEFINITION ON SCHEMA::Socioeconomics TO dream
print ' -> Granted dream database user permissions on Socioeconomics schema'
go
*/