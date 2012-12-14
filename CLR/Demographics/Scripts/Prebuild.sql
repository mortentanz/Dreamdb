/*-------------------------------------------------------------------------------------------------
  $Archive: /CLR.root/CLR/Demographics/Scripts/Prebuild.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:48 $
  $Author: mls $

  SQLCMD script preparing deployment of all ETL programmability database objects. Any existing
  CLR programmability objects in the ETL schema are dropped prior to dropping assemblies. The
  script is called in the Pre-build event commandline in the project properties.
  
-------------------------------------------------------------------------------------------------*/
:on error exit

declare @schema nvarchar(128);
declare @module nvarchar(128);
declare @type char(2);
declare @drop_qry nvarchar(255);

set @schema = N'Demographics';

-- Define cursor over names of CLR-based modules (functions and procedures) in ETL schema
declare modulecursor cursor forward_only read_only
for
  select 
    convert(nvarchar(128), s.name) as schemaname,
    convert(nvarchar(128), o.name) as modulename,
    o.type as [type]
  from sys.assembly_modules am
  inner join sys.objects o on am.object_id = o.object_id
  inner join sys.schemas s on o.schema_id = s.schema_id
  where s.name like @schema
;

-- Iterate over qualified (two-part) modulenames and drop them constructing drop statement on the fly
open modulecursor;
fetch next from modulecursor into @schema, @module, @type;
while(@@fetch_status = 0)
begin
  
  if (@type = N'FN') or (@type= N'FS') or (@type = N'FT')
  set @drop_qry = N'drop function ';
  if @type like N'PC'
  set @drop_qry = N'drop procedure ';
  set @drop_qry = @drop_qry + @schema + N'.' + @module;

  execute sp_executesql @drop_qry;
  print 'Dropped the CLR based module ' + @schema + '.' + @module;
  
  fetch next from modulecursor into @schema, @module, @type;

end;
close modulecursor;
deallocate modulecursor;
go

-- Traverse assembly dependency chain and drop assemblies top-down
declare @assembly nvarchar(128); 
declare @drop_qry nvarchar(255);

while exists (
  select * from sys.assemblies a
  where not exists (select * from sys.assembly_references ar where a.assembly_id = ar.referenced_assembly_id)
  and a.name like N'Demographics%'
)
begin
  
  select @assembly = 
  a.name from sys.assemblies a
  where not exists (
    select * from sys.assembly_references ar
    where a.assembly_id = ar.referenced_assembly_id
  )
  and a.name like N'Demographics%'    

  set @drop_qry = N'drop assembly [' + @assembly + ']';
  execute sp_executesql @drop_qry;
  print 'Dropped assembly ' + @assembly;
  
end;