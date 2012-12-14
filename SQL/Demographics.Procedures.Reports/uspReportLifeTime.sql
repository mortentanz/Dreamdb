/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Reports/uspReportLifeTime.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspReportLifeTime
  
  Purpose     : Returns a result set presenting the expected remaining lifetime of the population.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspReportLifeTime', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspReportLifeTime
GO

CREATE PROCEDURE Demographics.uspReportLifeTime (
  @projectionid smallint = null,
  @estimationid smallint = null,
	@firstyear smallint = null,
	@lastyear smallint = null,
	@maxage tinyint = 110,
  @languageid int = 1030 
)
AS 
BEGIN

	SET NOCOUNT ON;

  DECLARE @id smallint;
  
  DECLARE @estimation bit;
  
	IF ((@estimationid IS NULL AND @projectionid IS NULL) OR (@projectionid IS NULL))
	BEGIN
		SET @estimation = 1;
		SELECT @id = coalesce(@estimationid, max(EstimationID)) 
		FROM Demographics.Estimation 
		WHERE Class = 'Mortality';
	END
	ELSE
	BEGIN
		SET @estimation = 0;
		SELECT @id = f.ForecastID
		FROM Demographics.Forecast f
		INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
		WHERE f.Class = 'Mortality' AND pf.ProjectionID = @projectionid;
	END

	CREATE TABLE #series (
		OriginID tinyint,
		GenderID tinyint,
		Age tinyint,
		[Year] smallint,
		ExpectedLifeTime float
	);

  INSERT #series
	EXECUTE Demographics.uspGetRemainingLifeTime @id, @estimation, DEFAULT, DEFAULT, @maxage;

	DECLARE @f smallint;
	DECLARE @l smallint;
	
	SELECT 
		@f = coalesce(@firstyear, min([Year])), 
		@l = coalesce(@lastyear, max([Year]))	
	FROM #series;

	IF (@languageid = 1030)
	BEGIN
		SELECT 
			#series.OriginID, 
			o.TextDa AS Oprindelse,
			ot.TextDa AS OprindelsesType,
			n.TextDa AS Nationalitet,
			c.TextDa AS Statsborgerskab,
			g.TextDa AS [Køn],
			Age AS Alder, [Year] AS [År], ExpectedLifeTime AS [Restlevetid]
		FROM #series
		INNER JOIN Demographics.Origin o ON #series.OriginID = o.OriginID
		INNER JOIN dbo.OriginType ot ON o.TypeID = ot.TypeID
		INNER JOIN dbo.Nationality n ON o.NationalityID = n.NationalityID
		INNER JOIN dbo.Citizenship c ON o.CitizenshipID = c.CitizenshipID
		INNER JOIN dbo.Gender g ON #series.GenderID = g.GenderID
		WHERE [Year] BETWEEN @f AND @l
	END
	ELSE
	BEGIN
		SELECT
			#series.OriginID, 
			o.TextEn AS Origin,
			ot.TextEn AS OriginType,
			n.TextEn AS Nationality,
			c.TextEn AS Citizenship,
			g.TextEn AS Gender,
			Age, [Year], ExpectedLifeTime AS [Remaining life time]
		FROM #series
		INNER JOIN Demographics.Origin o ON #series.OriginID = o.OriginID
		INNER JOIN dbo.OriginType ot ON o.TypeID = ot.TypeID
		INNER JOIN dbo.Nationality n ON o.NationalityID = n.NationalityID
		INNER JOIN dbo.Citizenship c ON o.CitizenshipID = c.CitizenshipID
		INNER JOIN dbo.Gender g ON #series.GenderID = g.GenderID
		WHERE [Year] BETWEEN @f AND @l
	END

END
GO