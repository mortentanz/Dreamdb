/*-------------------------------------------------------------------------------------------------
  $Archive: /CLR.root/CLR/DBO/Scripts/Postbuild.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:48 $
  $Author: mls $

  SQLCMD script implementing custom deployment of CLR based programmability objects. We want to
  ensure that user-defined functions, procedures etc. are cataloged in appropriate database 
  schemas in order to maintain the conceptual distinction of database objects.
  
  The deploy script is called in the Post-build event commandline using invokation of the SQLCMD
  script interpreter. The arguments passed in are as follow:
  
  sqlcmd.exe -S localhost -d Dreamdb -E 
  -v Config $(ConfigurationName) 
  -v AssemblyBits $(TargetPath) 
  -v AssemblyName $(TargetName) 
  -i $(ProjectDir)\Scripts\Deploy.sql

  TargetPath
  
-------------------------------------------------------------------------------------------------*/
:on error exit

------------------------------------------------------------------------
print 'Creating assembly $(AssemblyName) from $(ConfigurationName) bits'
go

-- Any assembly referenced by this assembly are automatically cataloged by the SQLCLR host
create assembly [$(AssemblyName)]
from '$(AssemblyBits)'
with permission_set = external_access
print 'Deployed the assembly $(AssemblyName)'
go

----------------------------------------
print 'Creating functions in dbo schema'
go

create function dbo.ufnFileExists(@filename nvarchar(255))
returns bit
external name [$(AssemblyName)].[Dreamdb.dbo.Programmability.UserDefinedFunctions].[ufnFileExists]
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

create function dbo.ufnIsValidCaption(@caption nvarchar(100))
returns bit
external name [$(AssemblyName)].[Dreamdb.dbo.Programmability.UserDefinedFunctions].[ufnIsValidCaption]
go

------------------------------------------------------
print 'Adding assembly meta-data to database catalogs'
:on error continue
go

execute sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Class library containing functions and procedures for dbo.',
@level0type=N'ASSEMBLY', 
@level0name=N'$(AssemblyName)'
go

------------------------------------------------------
print 'Adding function meta-data to database catalogs'
go

execute sp_addextendedproperty
@name = N'MS_Description',
@value = N'States whether the specified file exists.',
@level0type=N'SCHEMA', @level0name=N'dbo',
@level1type=N'FUNCTION', @level1name=N'ufnFileExists'
go

execute sp_addextendedproperty
@name = N'MS_Description',
@value = N'The fully qualified filename relative to the server to search for.',
@level0type=N'SCHEMA', @level0name=N'dbo',
@level1type=N'FUNCTION', @level1name=N'ufnFileExists',
@level2type=N'PARAMETER', @level2name=N'@filename'
go

execute sp_addextendedproperty
@name = N'MS_Description',
@value = N'Gets information on files matching a wildcard pattern in a specified directory or directory tree.',
@level0type=N'SCHEMA', @level0name=N'dbo',
@level1type=N'FUNCTION', @level1name=N'ufnGetFileInformation'
go

execute sp_addextendedproperty
@name = N'MS_Description',
@value = N'The fully qualified name (relative to server) of the file to return information for.',
@level0type=N'SCHEMA', @level0name=N'dbo',
@level1type=N'FUNCTION', @level1name=N'ufnGetFileInformation',
@level2type=N'PARAMETER', @level2name=N'@filename'
go