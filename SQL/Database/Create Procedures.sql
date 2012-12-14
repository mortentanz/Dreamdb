/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Procedures.sql $
  $Revision: 2 $
  $Date: 12/21/06 16:02 $
  $Author: mls $
  
-----------------------------------------------------------------------------------------------------------*/
print 'Creating procedures in $(dbname)..'
go

:r $(sqlroot)DBO.Procedures\uspPrintError.sql
:r $(sqlroot)DBO.Procedures\uspLogError.sql
:r $(sqlroot)DBO.Procedures\uspRethrowError.sql
:r $(sqlroot)DBO.Procedures\uspProcessPendingDeletes.sql
print ' -> Created procedures for dbo'
go

:r $(sqlroot)ETL.Procedures\uspAuditEvent.sql
:r $(sqlroot)ETL.Procedures\uspAuditExecution.sql
:r $(sqlroot)ETL.Procedures\uspAuditExecutionCompletion.sql
:r $(sqlroot)ETL.Procedures\uspInsertDSDimension.sql
:r $(sqlroot)ETL.Procedures\uspExtractPopulation.sql
:r $(sqlroot)ETL.Procedures\uspExtractResidenceDuration.sql
:r $(sqlroot)ETL.Procedures\uspExtractChildren.sql
:r $(sqlroot)ETL.Procedures\uspExtractHeirs.sql
:r $(sqlroot)ETL.Procedures\uspExtractMortality.sql
:r $(sqlroot)ETL.Procedures\uspExtractRAS.sql
print ' -> Created procedures supporting ETL operations'
go

:r $(sqlroot)Demographics.Procedures.Catalog\uspInsertDSDataset.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspInsertHMDDataset.sql
:r $(sqlroot)Socioeconomics.Procedures.Catalog\uspInsertRASDataset.sql
print ' -> Created procedures for ETL catalog operations of file sourced facts'
go

:r $(sqlroot)Demographics.Procedures.Catalog\uspInsertEstimation.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspUpdateEstimation.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspDeleteEstimation.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspInsertForecast.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspUpdateForecast.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspDefineForecastEstimation.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspDeleteForecast.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspInsertProjection.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspUpdateProjection.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspDeleteProjection.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspPublishProjection.sql
:r $(sqlroot)Demographics.Procedures.Catalog\uspDefineProjectionForecast.sql
print ' -> Created procedures for catalog operations in Demographics'
go

:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSBirths.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSChildren.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSDeaths.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSEmigrants.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSEmigration.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSFertility.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSImmigrants.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSImmigration.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSMortality.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSChildOriginFrequency.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSMothers.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSNaturalization.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSNaturalizationMean.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSPopulation.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSPopulationFromFlows.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSBoyShare.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSDurationFrequency.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetDSMotherAgeFrequency.sql
:r $(sqlroot)Demographics.Procedures.Queries\uspGetEstimatedMortality.sql
print ' -> Created procedures supporting parameterized select queries in Demographics'
go

:r $(sqlroot)Demographics.Procedures.Reports\uspReportBirths.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportDeaths.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportDependencyRatios.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportEmigration.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportFlows.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportImmigration.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportLifeTime.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportMothers.sql
:r $(sqlroot)Demographics.Procedures.Reports\uspReportPopulation.sql
:r $(sqlroot)Socioeconomics.Procedures.Reports\uspReportPopulation.sql
print ' -> Created procedures for reporting projection results'
go