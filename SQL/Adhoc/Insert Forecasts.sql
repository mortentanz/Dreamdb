/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Adhoc/Insert Forecasts.sql $
  $Revision: 1 $
  $Date: 12/19/06 11:48 $
  $Author: mls $
  
  SQLCMD script for inserting 'forecasts' covering adhoc assumptions with respect to origin, and 
  naturalization attributes of newborn children and age distribution for mothers. Should only be exuted
  once, since the adhoc approach is to be replaced by execution of stored procedures (implying dynamic
  materialization of forecast parameters for these projection elements).

-----------------------------------------------------------------------------------------------------------*/
:setvar filepath F:\Data\Facts\Demographics\Dream\Forecasts\Birth\

IF object_id('ETL.ufnGetOriginFromOldClassification', 'FN') IS NOT NULL
DROP FUNCTION ETL.ufnGetOriginFromOldClassification
GO

CREATE FUNCTION ETL.ufnGetOriginFromOldClassification(@id tinyint) RETURNS tinyint AS 
BEGIN

	DECLARE @result tinyint;
	SET @result = CASE
		WHEN @id < 8 THEN @id + 1
		WHEN @id = 8 OR @id = 9 THEN @id + 3
		WHEN @id = 10 OR @id = 11 THEN @id - 1
		ELSE null
	END;
	RETURN @result;

END
GO

DECLARE @forecastid smallint
DECLARE @revision tinyint
DECLARE @created datetime
DECLARE @modified datetime

SET @revision = 1;

EXECUTE Demographics.uspInsertForecast 
@forecastid output, @revision, @created, @modified, 0,
'Birth', 'Ad hoc birth assumptions', default, default, default, 1, 1,
'Ad hoc distributions of boy share, origin and naturalization of newborn children as used in projection up to 2006.',
'Ad hoc fordelingsantagelser for drenges andel, oprindelse og naturalisering af nyfødte som benyttes i fremskrivninger op til 2006.',
default

INSERT INTO Demographics.ForecastedBirthOrigin (ForecastID, MotherOriginID, FatherOriginID, [Year], Estimate)
SELECT 
	@forecastid, 
	MotherOriginID = ETL.ufnGetOriginFromOldClassification(MotherOriginID),
	FatherOriginID = ETL.ufnGetOriginFromOldClassification(FatherOriginID),
	[Year], 
	Estimate
FROM OPENROWSET ( 
	BULK '$(filepath)BirthOrigin.R1.txt',  
	FORMATFILE = '$(filepath)BirthForecast.format.xml',
	FIRSTROW = 2
) b

INSERT INTO Demographics.ForecastedBirthNaturalization (ForecastID, MotherOriginID, FatherOriginID, [Year], Estimate)
SELECT 
	@forecastid, 
	MotherOriginID = ETL.ufnGetOriginFromOldClassification(MotherOriginID),
	FatherOriginID = ETL.ufnGetOriginFromOldClassification(FatherOriginID),
	[Year], 
	Estimate
FROM OPENROWSET ( 
	BULK '$(filepath)BirthNaturalization.R1.txt',  
	FORMATFILE = '$(filepath)BirthForecast.format.xml',
	FIRSTROW = 2
) b
GO

IF object_id('ETL.ufnGetOriginFromOldClassification', 'FN') IS NOT NULL
DROP FUNCTION ETL.ufnGetOriginFromOldClassification
GO