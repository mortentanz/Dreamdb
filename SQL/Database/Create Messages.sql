/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Messages.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Script adding custom error messages that may be raised by stored procedures. The following conventions are
  for error number ranges are used:
  
  50001 - 59999 : Informational messages, all with a severity of 10.
  60000 - 69999 : Errors related to violation of referential integrity and / or versioning.
  70000 - 79999 : Errors related to runtime environment and resources (eg. filesystem).
  80000 - 90000 : Errors related to availability of data or consistency of operations.

-------------------------------------------------------------------------------------------------------------*/

-- Clear out any existing custom messages by executing sp_dropmessage
print 'Creating or recreating custom error messages in sys.messages for database $(dbname)'
go

declare @msgid int
declare msgcursor cursor for 
  select message_id from sys.messages
  where message_id between 50001 and 90000

open msgcursor
fetch next from msgcursor into @msgid
while @@fetch_status = 0
begin
  execute sp_dropmessage @msgnum = @msgid, @lang = 'all'
  fetch next from msgcursor into @msgid
end
close msgcursor
deallocate msgcursor
if @msgid is not null
print ' -> Dropped existing messages in range from 50001 to 90000'
go

-- Errors related to violation of referential integrity and / or versioning.
execute sp_addmessage
  @msgnum = 60001,
  @severity = 11,
  @msgtext = 'The specified schema does not exist.'
go

execute sp_addmessage
  @msgnum = 60002,
  @severity = 11,
  @msgtext = 'The specified table does not exist or is not a part of the specified schema.'
go

execute sp_addmessage
  @msgnum = 60003,
  @severity = 11,
  @msgtext = 'The specified column is not defined for the specified table.'
go

execute sp_addmessage
  @msgnum = 60004,
  @severity = 16,
  @msgtext = 'The specified column is not an integer type. Only tinyint, smallint, int are supported.'
go  

execute sp_addmessage
  @msgnum = 60005,
  @severity = 16,
  @msgtext = 'Cannot insert or update classifer: The specified identifier is invalid.'
go

execute sp_addmessage
  @msgnum = 60006,
  @severity = 16,
  @msgtext = 'Cannot create ETL audit: The specified audit id does not exist.'
go

execute sp_addmessage
  @msgnum = 60007,
  @severity = 16,
  @msgtext = 'Cannot commit ETL audit: The specified audit id does not exist.'
go

execute sp_addmessage
  @msgnum = 60008,
  @severity = 16,
  @msgtext = 'Cannot return mortality rates: The specified estimation does not exists or is not of the correct class.'
go  

execute sp_addmessage
  @msgnum = 60101,
  @severity = 16,
  @msgtext = 'Cannot catalog RAS dataset: The specified status revision is not defined in the database.'
go

execute sp_addmessage
  @msgnum = 60102,
  @severity = 16,
  @msgtext = 'Cannot catalog DS demographic dataset: The specified dataset name is not supported.'
go

execute sp_addmessage
  @msgnum = 60103,
  @severity = 16,
  @msgtext = 'Cannot insert projection: A projection with the specified title exists and replace was not specified.'
go

execute sp_addmessage
  @msgnum = 60104,
  @severity = 16,
  @msgtext = 'Cannot insert projection: A projection with the specified title exists and is marked readonly.'
go

execute sp_addmessage
  @msgnum = 60105,
  @severity = 16,
  @msgtext = 'Cannot update projection: The specified projection does not exist.'
go

EXECUTE sp_addmessage
  @msgnum = 60106,
  @severity = 16,
  @msgtext = 'Cannot update projection: Updates to published projections are not allowed.'
go

EXECUTE sp_addmessage
  @msgnum = 60107,
  @severity = 16,
  @msgtext = 'Cannot update projection: Projection is marked readonly and @isreadonly was not set.'
go

EXECUTE sp_addmessage
  @msgnum = 60108,
  @severity = 16,
  @msgtext = 'Cannot publish projection : %s.'
go

EXECUTE sp_addmessage
  @msgnum = 60109,
  @severity = 16,
  @msgtext = 'Cannot delete projection: %s.'
go  

EXECUTE sp_addmessage
	@msgnum = 60110,
	@severity = 16,
	@msgtext = 'Cannot update projection: %s.'
go

EXECUTE sp_addmessage
  @msgnum = 60201,
  @severity = 16,
  @msgtext = 'Cannot insert forecast: %s.'
go

EXECUTE sp_addmessage
  @msgnum = 60202,
  @severity = 16,
  @msgtext = 'Cannot insert forecast: The specified class of forecast is not supported.'
go

EXECUTE sp_addmessage
  @msgnum = 60203,
  @severity = 16,
  @msgtext = 'Cannot insert forecast: A forecast with the specified title and class exists and replace was not specified.'
go

execute sp_addmessage
  @msgnum = 60204,
  @severity = 16,
  @msgtext = 'Cannot insert forecast: A forecast with the specified title exists and is marked readonly.'
go

execute sp_addmessage
  @msgnum = 60205,
  @severity = 16,
  @msgtext = 'Cannot update forecast: The specified forecast does not exist.'
go

EXECUTE sp_addmessage
  @msgnum = 60206,
  @severity = 16,
  @msgtext = 'Cannot update forecast: Updates to published forecasts are not allowed.'
go

EXECUTE sp_addmessage
  @msgnum = 60207,
  @severity = 16,
  @msgtext = 'Cannot update forecast: Forecast is marked readonly and @isreadonly was not set.'
go

EXECUTE sp_addmessage
  @msgnum = 60208,
  @severity = 16,
  @msgtext = 'Cannot publish forecast : %s.'
go

EXECUTE sp_addmessage
  @msgnum = 60209,
  @severity = 16,
  @msgtext = 'Cannot delete forecast: %s.'
go  

EXECUTE sp_addmessage
  @msgnum = 60210,
  @severity = 16,
  @msgtext = 'Cannot update forecast: %s.'
go

EXECUTE sp_addmessage
  @msgnum = 60302,
  @severity = 16,
  @msgtext = 'Cannot insert estimation: The specified class of estimation is not supported.'
go

EXECUTE sp_addmessage
  @msgnum = 60303,
  @severity = 16,
  @msgtext = 'Cannot insert estimation: An estimation with the specified title and class exists and replace was not specified.'
go

execute sp_addmessage
  @msgnum = 60304,
  @severity = 16,
  @msgtext = 'Cannot insert estimation: An estimation with the specified title exists and is marked readonly.'
go

execute sp_addmessage
  @msgnum = 60305,
  @severity = 16,
  @msgtext = 'Cannot update estimation: The specified estimation does not exist.'
go

EXECUTE sp_addmessage
  @msgnum = 60306,
  @severity = 16,
  @msgtext = 'Cannot update estimation: Updates to published estimations are not allowed.'
go

EXECUTE sp_addmessage
  @msgnum = 60307,
  @severity = 16,
  @msgtext = 'Cannot update estimation: Estimation is marked readonly and @isreadonly was not set.'
go

EXECUTE sp_addmessage
  @msgnum = 60308,
  @severity = 16,
  @msgtext = 'Cannot publish estimation: %s.'
go

EXECUTE sp_addmessage
  @msgnum = 60309,
  @severity = 16,
  @msgtext = 'Cannot delete estimation: %s.'
go  

EXECUTE sp_addmessage
  @msgnum = 60401,
  @severity = 16,
  @msgtext = 'Cannot extract projection data: %s.'
go

print ' -> Added error messages related to violation of referential integrity and / or versioning'
go

-- Input parameter errors related to runtime environment and resources (eg. filesystem).
execute sp_addmessage
  @msgnum = 70001,
  @severity = 16,
  @msgtext = 'Invalid input parameter: The path specified in %s is not available.'
go

execute sp_addmessage
  @msgnum = 70002,
  @severity = 16,
  @msgtext = 'Invalid input parameter: The file specified in %s is not available.'
go

execute sp_addmessage
  @msgnum = 70003,
  @severity = 16,
  @msgtext = 'Invalid input parameter: A required format file was not found at the path specified in %s.'
go

execute sp_addmessage
  @msgnum = 70010,
  @severity = 16,
  @msgtext = 'Failed to parse data files from filesystem.'
go

print ' -> Added error messages related to runtime environment and resources (e.g. filesystem).'
go

-- Input parameter errors related to availability of data or cosistency.
execute sp_addmessage
  @msgnum = 80001,
  @severity = 16,
  @msgtext = 'Invalid input parameters: %s must preceede %s.'
go
  
execute sp_addmessage  
  @msgnum = 80002,
  @severity = 16,
  @msgtext = 'Invalid input parameter: %s comes before first available year.'
go

execute sp_addmessage
  @msgnum = 80003,
  @severity = 16,
  @msgtext = 'Invalid input parameter: %s comes after last available year.'  
go

execute sp_addmessage
  @msgnum = 80004,
  @severity = 16,
  @msgtext = 'Invalid input parameter: %s comes after last available year (calculation requires a lead operation on year).'  
go

execute sp_addmessage
  @msgnum = 80005,
  @severity = 16,
  @msgtext = 'Invalid input parameter: NULL is not allowed for the parameter %s.'
go

execute sp_addmessage
	@msgnum = 80006,
	@severity = 16,
	@msgtext = 'Invalid input parameter: NULL is not allowed for parameter %s for the specified file operation.'
go

execute sp_addmessage
  @msgnum = 80007,
  @severity = 16,
  @msgtext = 'Invalid input parameter: The file specified in parameter %s does not exist.'
go

execute sp_addmessage
	@msgnum = 80010,
	@severity = 16,
	@msgtext = 'Invalid input parameter: %s.'
go

print ' -> Added error messages related to availablity of data or consistency'
go