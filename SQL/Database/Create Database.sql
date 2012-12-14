/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Database.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $
  
  SQLCMD script for creating the database. Any existing database with the specified name is implicitly
  dropped. 
  
  SQLCMD parameters from create file
  
  solution  : qualified path for solution root (e.g. F:\Projects\Dreamdb\)
  server    : server[\instance]
  dbname    : name of database
  config    : develop | production
  
  SQLCMD parameters from dynamically resolved configuration file (server.config.sql)
  mdfpath   : qualified path for data files as c-style string with closing backslash
  ldfpath   : qualified path for log files as c-style string with closing backslash
  

-----------------------------------------------------------------------------------------------------------*/
:on error exit

if (db_name() <> 'master') use master
go

print 'Creating database $(dbname) on server $(server)..'
go

-- Delete any exisiting database with the specified name (requires that no active connections exists)
if exists (select * from sysdatabases where name = '$(dbname)')
begin
  execute msdb.dbo.sp_delete_database_backuphistory @database_name = '$(dbname)'
  alter database $(dbname) set single_user with rollback immediate
  drop database $(dbname)
end
print ' -> Dropped existing database'
go

-- Create database with specified name and file locations (server and configuration specific)
create database $(dbname) 
on (
  name = '$(dbname)_dat', 
  filename = '$(mdfpath)$(dbname)_dat.mdf', 
  size = 200MB, 
  maxsize = unlimited, 
  filegrowth = 20MB
)
log on ( 
  name = '$(dbname)_log', 
  filename = '$(ldfpath)$(dbname)_log.ldf',
  size = 100MB,
  maxsize = unlimited,
  filegrowth = 20MB 
)
collate Latin1_General_CI_AS
with trustworthy on
print ' -> Created database $(dbname)'
go

-- Set options for recovery and ANSI compliance
alter database $(dbname) set recovery simple with no_wait
alter database $(dbname) set ansi_null_default on with no_wait
alter database $(dbname) set ansi_nulls on with no_wait
alter database $(dbname) set ansi_padding on with no_wait
alter database $(dbname) set ansi_warnings on with no_wait
alter database $(dbname) set concat_null_yields_null on with no_wait
print ' -> Set options for recovery mode, ansi-settings and null handling on database $(dbname)'
go

-- Disable full-text indexing on database (if installed on server)
if(1 = fulltextserviceproperty('IsFullTextInstalled'))
begin
execute $(dbname).dbo.sp_fulltext_database @action='disable'
print ' -> Disabled full-text query search engine for database $(dbname)'
end
go

use $(dbname)
go

:on error ignore