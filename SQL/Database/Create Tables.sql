/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Database/Create Tables.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $
-----------------------------------------------------------------------------------------------------------*/
print 'Creating tables in $(dbname)..'
go

:r $(sqlroot)DBO.Tables.Dimensions\Duration.sql
:r $(sqlroot)DBO.Tables.Dimensions\Education.sql
:r $(sqlroot)DBO.Tables.Dimensions\Gender.sql
:r $(sqlroot)DBO.Tables.Dimensions\OriginType.sql
:r $(sqlroot)DBO.Tables.Dimensions\Permit.sql
:r $(sqlroot)DBO.Tables.Dimensions\Registration.sql
:r $(sqlroot)DBO.Tables.Dimensions\Development.sql
:r $(sqlroot)DBO.Tables.Dimensions\Hemisphere.sql
:r $(sqlroot)DBO.Tables.Dimensions\Country.sql
:r $(sqlroot)DBO.Tables.Dimensions\Region.sql
:r $(sqlroot)DBO.Tables.Dimensions\RegionCountry.sql
:r $(sqlroot)DBO.Tables.Dimensions\Citizenship.sql
:r $(sqlroot)DBO.Tables.Dimensions\CitizenshipRegion.sql
:r $(sqlroot)DBO.Tables.Dimensions\Nationality.sql
:r $(sqlroot)DBO.Tables.Dimensions\NationalityRegion.sql
print ' -> Created dimension tables for dbo'
go

:r $(sqlroot)Demographics.Tables.Dimensions\Origin.sql
:r $(sqlroot)Socioeconomics.Tables.Dimensions\Origin.sql
:r $(sqlroot)Socioeconomics.Tables.Dimensions\StatusType.sql
:r $(sqlroot)Socioeconomics.Tables.Dimensions\StatusTree.sql
:r $(sqlroot)Socioeconomics.Tables.Dimensions\Status.sql
:r $(sqlroot)Socioeconomics.Tables.Dimensions\StatusDefinition.sql
print ' -> Created schema specific dimension tables for Demographics and Socioeconomics'
go

:r $(sqlroot)ETL.Tables.Dimensions\DSDimension.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSCitizenship.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSCountry.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSDevelopment.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSDuration.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSEducation.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSHemisphere.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSOrigin.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSOriginType.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSPermit.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSRegion.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSRegistration.sql
:r $(sqlroot)ETL.Tables.Dimensions\DSStatus.sql
print ' -> Created dimension lookup tables for ETL'
go

:r $(sqlroot)DBO.Tables.Logs\ErrorLog.sql
:r $(sqlroot)ETL.Tables.Audits\ExecutionAudit.sql
:r $(sqlroot)ETL.Tables.Audits\EventAudit.sql
print ' -> Created tables supporting logging and auditing'
go

:r $(sqlroot)Demographics.Tables.Catalog\DSCatalog.sql
:r $(sqlroot)Demographics.Tables.Catalog\HMDCatalog.sql
:r $(sqlroot)Socioeconomics.Tables.Catalog\RASCatalog.sql
:r $(sqlroot)Socioeconomics.Tables.Catalog\EducationCatalog.sql
:r $(sqlroot)Demographics.Tables.Catalog\Projection.sql
:r $(sqlroot)Demographics.Tables.Catalog\Estimation.sql
:r $(sqlroot)Demographics.Tables.Catalog\Forecast.sql
:r $(sqlroot)Demographics.Tables.Catalog\ProjectionForecast.sql
print ' -> Created catalog tables'
go

:r $(sqlroot)Demographics.Tables.Facts\DSBirths.sql
:r $(sqlroot)Demographics.Tables.Facts\DSChildren.sql
:r $(sqlroot)Demographics.Tables.Facts\DSDeaths.sql
:r $(sqlroot)Demographics.Tables.Facts\DSEmigrants.sql
:r $(sqlroot)Demographics.Tables.Facts\DSImmigrants.sql
:r $(sqlroot)Demographics.Tables.Facts\DSMothers.sql
:r $(sqlroot)Demographics.Tables.Facts\DSParents.sql
:r $(sqlroot)Demographics.Tables.Facts\DSPopulation.sql
:r $(sqlroot)Demographics.Tables.Facts\DSPermits.sql
:r $(sqlroot)Demographics.Tables.Facts\HMDLife.sql
:r $(sqlroot)Socioeconomics.Tables.Facts\RAS.sql
:r $(sqlroot)Socioeconomics.Tables.Facts\EducationEnrollment.sql
:r $(sqlroot)Socioeconomics.Tables.Facts\EducationLevel.sql
print ' -> Created fact tables for primary source data'
go

:r $(sqlroot)Demographics.Tables.Estimates\EstimatedFertility.sql
:r $(sqlroot)Demographics.Tables.Estimates\EstimatedMortality.sql
:r $(sqlroot)Demographics.Tables.Estimates\EstimatedImmigration.sql
:r $(sqlroot)Demographics.Tables.Estimates\EstimatedEmigration.sql
print ' -> Created catalog and fact tables for inference based estimations'
go

:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedBirthNaturalization.sql
:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedBirthOrigin.sql
:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedEmigration.sql
:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedFertility.sql
:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedImmigration.sql
:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedMortality.sql
:r $(sqlroot)Demographics.Tables.Forecasts\ForecastedNaturalization.sql
print ' -> Created tables for forecasted and exogenous specification in projections'
go

:r $(sqlroot)Demographics.Tables.Results\Births.sql
:r $(sqlroot)Demographics.Tables.Results\Children.sql
:r $(sqlroot)Demographics.Tables.Results\Deaths.sql
:r $(sqlroot)Demographics.Tables.Results\Emigrants.sql
:r $(sqlroot)Demographics.Tables.Results\Heirs.sql
:r $(sqlroot)Demographics.Tables.Results\Immigrants.sql
:r $(sqlroot)Demographics.Tables.Results\Mothers.sql
:r $(sqlroot)Demographics.Tables.Results\Population.sql
:r $(sqlroot)Demographics.Tables.Results\ResidenceDuration.sql
print ' -> Created tables for demographic projection results'
go