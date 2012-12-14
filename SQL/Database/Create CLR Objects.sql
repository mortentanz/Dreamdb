/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create CLR Objects.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $
  
  SQLCMD script for custom deployment of CLR programmability objects on FMDREAM1.

-----------------------------------------------------------------------------------------------------------*/
:setvar sdkpath C:\Windows\Microsoft.NET\Framework\v2.0.50727\

print 'Creating assemblies from release build'
go

-- DBO CLR Objects ------------------------------------------------------------------------------------------
:setvar AssemblyName DBO.Programmability
:setvar AssemblyBits CLR\DBO\bin\Release\DBO.Programmability.dll

create assembly [$(AssemblyName)]
from '$(solutions)$(AssemblyBits)'
with permission_set = external_access
print ' -> Created the assembly $(AssemblyName)'
go

create function dbo.ufnFileExists(@filename nvarchar(255))
returns bit
external name [$(AssemblyName)].[Dreamdb.dbo.Programmability.UserDefinedFunctions].[ufnFileExists]
go
print ' -> Created dbo.ufnFileExists'
go

create function dbo.ufnGetDirectoryContents(@path nvarchar(255), @pattern nvarchar(255), @recurse bit)
returns table (
  [Path] nvarchar(255), 
  [Name] nvarchar(255), 
  [Extension] nvarchar(10), 
  [Size] bigint, 
  [Created] datetime, 
  [Accessed] datetime, 
  [Modified] datetime, 
  [IsReadOnly] bit
)
external name [$(AssemblyName)].[Dreamdb.dbo.Programmability.UserDefinedFunctions].[ufnGetDirectoryContents]
go
print ' -> Created dbo.ufnGetDirectoryContents'
go  

create function dbo.ufnGetFileInformation(@filename nvarchar(255))
returns table (
  [Path] nvarchar(255), 
  [Name] nvarchar(255), 
  [Extension] nvarchar(10), 
  [Size] bigint, 
  [Created] datetime, 
  [Accessed] datetime, 
  [Modified] datetime, 
  [IsReadOnly] bit
)
external name [$(AssemblyName)].[Dreamdb.dbo.Programmability.UserDefinedFunctions].[ufnGetFileInformation]
go
print ' -> Created dbo.ufnGetFileInformation'
go

create function dbo.ufnIsValidCaption(@caption nvarchar(100))
returns bit
external name [$(AssemblyName)].[Dreamdb.dbo.Programmability.UserDefinedFunctions].[ufnIsValidCaption]
go
print ' -> Created dbo.ufnIsValidCaption'
go

-- ETL CLR Objects ------------------------------------------------------------------------------------------
:setvar AssemblyName ETL.Programmability
:setvar AssemblyBits CLR\ETL\bin\Release\ETL.Programmability.dll

create assembly [$(AssemblyName)]
from '$(solutions)$(AssemblyBits)'
with permission_set = external_access
go
print ' -> Created the assembly $(AssemblyName)'
go

create function ETL.ufnParseDSTabSource(@path nvarchar(255), @pattern nvarchar(255))
returns table (
  [Content] nvarchar(10), 
  [Origin] nvarchar(8), 
  [Age] tinyint, 
  [Year] smallint, 
  [Male] int, 
  [Female] int, 
  [Total] int
)
external name [$(AssemblyName)].[Dreamdb.ETL.Programmability.UserDefinedFunctions].[ufnParseDSTabSource]
go
print ' -> Created ETL.ufnParseDSTabSource'
go

create function ETL.ufnParseHMDLifeSource(@path nvarchar(255), @pattern nvarchar(255))
returns table (
  [Setname] nvarchar(30), 
  [Country] nvarchar(20), 
  [Gender] nvarchar(10), 
  [Modified] datetime, 
  [Version] nvarchar(20), 
  [Age] tinyint, 
  [Year] smallint, 
  [Rate] float, 
  [Frequency] float, 
  [AverageLived] float, 
  [Survivors] int, 
  [Deaths] int, 
  [YearsLived] int, 
  [YearsRemaining] int, 
  [LifeExpectancy] float
)
external name [$(AssemblyName)].[Dreamdb.ETL.Programmability.UserDefinedFunctions].[ufnParseHMDLifeSource]
go
print ' -> Created ETL.ufnParseHMDLifeSource'
go


-- Demographics CLR Objects----------------------------------------------------------------------------------
:setvar AssemblyName Demographics.Programmability
:setvar AssemblyBits CLR\Demographics\bin\Release\Demographics.Programmability.dll

create assembly [$(AssemblyName)]
from '$(solutions)$(AssemblyBits)'
with permission_set = safe
print ' -> Created the assembly $(AssemblyName)'
go

create procedure Demographics.uspGetRemainingLifeTime (
  @id smallint,
  @estimation bit = 1,
  @maleinfantsurvivalrate float = 0.111,
  @femaleinfantsurvivalrate float = 0.112,
  @maxage tinyint = null
) AS
external name [$(AssemblyName)].[Dreamdb.Demographics.Programmability.StoredProcedures].[uspGetRemainingLifeTime]
go
print ' -> Created Demographics.uspGetRemainingLifeTime'
go