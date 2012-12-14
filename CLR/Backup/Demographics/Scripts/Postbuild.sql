/*-------------------------------------------------------------------------------------------------
  $Archive: /CLR.root/CLR/Demographics/Scripts/Postbuild.sql $
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
with permission_set = safe
print 'Deployed the assembly $(AssemblyName)'
go

----------------------------------------
print 'Creating procedures in Demographics schema'
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

/*
------------------------------------------------------
print 'Adding assembly meta-data to database catalogs'
:on error continue
go

execute sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Class library containing calculation intense functions and procedures for Demographics.',
@level0type=N'ASSEMBLY', 
@level0name=N'$(AssemblyName)'
go

------------------------------------------------------
print 'Adding function meta-data to database catalogs'
go
*/