/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Adhoc/Import Projection Catalog.sql $
  $Revision: 3 $
  $Date: 12/21/06 12:11 $
  $Author: mls $
  
  SQLCMD script for importing projectin and forecast catalog information from the Dremdev database. 
  Forecasts are cataloged by hand here but will be maintained by the Data Access Layer (Dream.Data) once
  implemented.

-----------------------------------------------------------------------------------------------------------*/
INSERT Demographics.Projection (Title, Caption, Revision, Created, Modified, LoginName, UserName)
SELECT Title, Caption, Revision, Created, Modified, LoginName, UserName
FROM Dreamdev.Demographics.Projection
WHERE Caption IS NOT NULL AND IsPUblished = 1
ORDER BY ProjectionID

-- Objects for populating estimation based forecasts (mortality specifically)
DECLARE @estimationid smallint;
DECLARE @estimates TABLE (
	OriginID tinyint,
	GenderID tinyint,
	Age tinyint,
	[Year] smallint,
	Mortality float
);

DECLARE @forecastid smallint;
DECLARE @revision tinyint;
DECLARE @created datetime;
DECLARE @modified datetime;

DECLARE @title varchar(100);
DECLARE @caption varchar(100);
DECLARE @texten varchar(600);
DECLARE @textda varchar(600);

-- Define mortality forecasts and catalog projection dependencies.
EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Mortality', 'Mortality forecast for 2006 projection baseline', '2006', NULL, 2, 1, 1, 
'Lee-Carter estimation based forecast of mortality rates as used in the 2006 projection.',
'Lee-Carter estimerede dødelighedsrater som anvendt i 2006 fremskrivningen.'

-- Get estimation and estimates for baseline mortality forecast..
SELECT @estimationid = EstimationID FROM Demographics.Estimation WHERE Caption = 'Baseline'
INSERT @estimates
EXECUTE Demographics.uspGetEstimatedMortality @estimationid, 2006, 2106
-- Populate table of forecast parameters
INSERT Demographics.ForecastedMortality
SELECT @forecastid AS ForecastID, OriginID, GenderID, Age, [Year], Mortality AS Estimate
FROM @estimates
DELETE FROM @estimates

-- Associate projections with forecast
EXECUTE Demographics.uspDefineProjectionForecast 1, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 3, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 4, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 5, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 6, @forecastid, 0


EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Mortality', 'Mortality reference forecast for 2006 projection baseline', '2006_Alt65', NULL, 2, 1, 1, 
'Reference Lee-Carter estimation based forecast of mortality rates on sample ranging from 1965 onwards.',
'Reference Lee-Carter estimerede dødelighedsrater på sample fra 1965 og frem.'


-- Get estimation and estimates for alternative mortality forecast..
SELECT @estimationid = EstimationID FROM Demographics.Estimation WHERE Caption = 'Alt65'
INSERT @estimates
EXECUTE Demographics.uspGetEstimatedMortality @estimationid, 2006, 2106
-- Populate table of forecast parameters
INSERT Demographics.ForecastedMortality
SELECT @forecastid AS ForecastID, OriginID, GenderID, Age, [Year], Mortality AS Estimate
FROM @estimates
DELETE FROM @estimates

-- Associate projection with forecast
EXECUTE Demographics.uspDefineProjectionForecast 2, @forecastid, 0


-- Insert fertility forecast information and catalog projection dependencies
EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Fertility', 'Fertility forecast for 2006 projection baseline.', '2006', NULL, 1, 1, 1, 
'Cubic-spline estimation based forecast of fertility rates as used in the 2006 projection.',
'Cubic-spline estimerede fertilitetsrater som anvendt i 2006 fremskrivningen.'

EXECUTE Demographics.uspDefineProjectionForecast 1, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 2, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 3, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 4, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 5, @forecastid, 0

EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Fertility', 'Total fertilty rate alternative to 2006 projection baseline.', '2006_Altfer', 1, NULL, 1, 1, 
'ALternative fertility forecast to 2006 projection, total fertility rate increase by 0.1.',
'Alternativ fertilitets fremskrivning til 2006 fremskrivningen, total fertilitetsrate øget med 0.1.'

EXECUTE Demographics.uspDefineProjectionForecast 6, @forecastid, 0


-- Insert immigration forecast information and catalog projection dependencies
EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Immigration', 'Immigration level forecast for 2006 projection baseline.', '2006', NULL, 4, 1, 1, 
'Constant immigration levels as assumed in the 2006 projection.',
'Konstante invandringsniveauer som antaget i 2006 fremskrivningen.'

EXECUTE Demographics.uspDefineProjectionForecast 1, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 2, @forecastid, 0
EXECUTE Demographics.uspDefineProjectionForecast 6, @forecastid, 0

EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Immigration', 'Alternative immigration for 2006 projection with increase of 5000 persons.', 
'2006_immigration', 1, 5, 1, 1, 
'Level increase from 2006 projection in immigration by 5000 persons annually.',
'Øget indvandring fra 2006 fremskrivningen på 5000 personer årligt.'

EXECUTE Demographics.uspDefineProjectionForecast 5, @forecastid, 0

EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Immigration', 'Alternative immigration for 2006 with increase of 5000 persons from less developed countries.', 
'2006_immigration_il', 1, 6, 1, 1, 
'Level increase from 2006 projection by 5000 persons from less developed countries annually.',
'Øget indvandring fra 2006 fremskrivningen på 5000 personer årligt fra mindre udviklede lande.'

EXECUTE Demographics.uspDefineProjectionForecast 3, @forecastid, 0

EXECUTE Demographics.uspInsertForecast
@forecastid output, @revision output, @created, @modified, 0, 
'Immigration', 'Alternative immigration for 2006 with increase of 5000 persons from more developed countries.', 
'2006_immigration_im', 1, 7, 1, 1, 
'Level increase from 2006 projection by 5000 persons from more developed countries annually.',
'Øget indvandring fra 2006 fremskrivningen på 5000 personer årligt fra mere udviklede lande.'

EXECUTE Demographics.uspDefineProjectionForecast 4, @forecastid, 0
GO


-- Publish projections
DECLARE @projectionid smallint;
DECLARE @title varchar(100);

DECLARE projectioncursor CURSOR FORWARD_ONLY FOR 
SELECT ProjectionID, Title FROM Demographics.Projection WHERE IsPublished = 0
;

OPEN projectioncursor;
FETCH NEXT FROM projectioncursor INTO @projectionid, @title;

WHILE @@fetch_status = 0
BEGIN

	BEGIN TRY
		EXECUTE Demographics.uspPublishProjection @projectionid, DEFAULT, 0;
		PRINT 'Published projection titled "' + @title + '"';
	END TRY
	BEGIN CATCH
		PRINT 'Failed to publish projection titled "' + @title + '"';
		EXECUTE dbo.uspPrintError;
	END CATCH

	FETCH NEXT FROM projectioncursor INTO @projectionid, @title;

END
CLOSE projectioncursor;
DEALLOCATE projectioncursor;
GO