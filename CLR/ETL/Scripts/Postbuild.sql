/*-------------------------------------------------------------------------------------------------
  $Archive: /CLR.root/CLR/ETL/Scripts/Postbuild.sql $
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
print 'Creating functions in ETL schema'
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

------------------------------------------------------
print 'Adding assembly meta-data to database catalogs'
:on error continue
go

execute sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Class library containing functions and procedures for ETL operations.',
@level0type=N'ASSEMBLY', 
@level0name=N'$(AssemblyName)'
go

if exists (select * from sys.assemblies where name = N'ETL.Text')
execute sp_addextendedproperty
@name = N'MS_Description', 
@value = N'Class library implementing classes supporting text-based ETL operations.',
@level0type=N'ASSEMBLY', 
@level0name=N'ETL.Text'
go

------------------------------------------------------
print 'Adding function meta-data to database catalogs'
go

