/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Schemas.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

-----------------------------------------------------------------------------------------------------------*/
print 'Creating schemas for grouping database objects in database $(dbname)'
go

create schema Demographics authorization dbo
go
execute sp_addextendedproperty 
N'MS_Description', N'Groups objects supporting demographic data and projections',
N'SCHEMA', N'Demographics'
go

create schema Socioeconomics authorization dbo
go
execute sp_addextendedproperty 
N'MS_Description', N'Groups objects storing and supporting socioeconomic data',
N'SCHEMA', N'Socioeconomics'
go

create schema ETL authorization dbo
go
execute sp_addextendedproperty 
N'MS_Description', N'Groups objects supporting Extract, Transform and Load operations',
N'SCHEMA', N'ETL'
go

print ' -> Added the schemas Demographics, Labourmarket and ETL'
go