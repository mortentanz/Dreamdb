/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Reports/uspReportDeaths.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspReportDeaths
  
  Purpose     : Returns a result set presenting number of deaths.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspReportDeaths', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspReportDeaths
GO

CREATE PROCEDURE Demographics.uspReportDeaths (
  @projectionid smallint = null,
  @includehistory bit = 1,
  @languageid int = 1030 
)
AS 
BEGIN

SET NOCOUNT ON;

  DECLARE @p smallint;
  DECLARE @f smallint;
  
  SELECT @p = coalesce(@projectionid, max(ProjectionID)) FROM Demographics.Projection;
  SELECT @f = min([Year]) FROM Demographics.Deaths WHERE ProjectionID = @p;

  SELECT * INTO #series
  FROM (
		SELECT OriginID, GenderID, Age, [Year], Persons 
		FROM Demographics.DSDeaths
		WHERE [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END)
		UNION ALL
		SELECT OriginID, GenderID, Age, [Year], Persons AS Persons
		FROM Demographics.Deaths
		WHERE ProjectionID = @p
	) AS s;

	IF (@languageid = 1030)
	BEGIN
		SELECT 
			#series.OriginID, 
			o.TextDa AS Oprindelse,
			ot.TextDa AS OprindelsesType,
			n.TextDa AS Nationalitet,
			c.TextDa AS Statsborgerskab,
			g.TextDa AS [Køn],
			Age AS Alder, [Year] AS [År], Persons AS Personer
		FROM #series
		INNER JOIN Demographics.Origin o ON #series.OriginID = o.OriginID
		INNER JOIN dbo.OriginType ot ON o.TypeID = ot.TypeID
		INNER JOIN dbo.Nationality n ON o.NationalityID = n.NationalityID
		INNER JOIN dbo.Citizenship c ON o.CitizenshipID = c.CitizenshipID
		INNER JOIN dbo.Gender g ON #series.GenderID = g.GenderID
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
			Age, [Year], Persons AS Persons
		FROM #series
		INNER JOIN Demographics.Origin o ON #series.OriginID = o.OriginID
		INNER JOIN dbo.OriginType ot ON o.TypeID = ot.TypeID
		INNER JOIN dbo.Nationality n ON o.NationalityID = n.NationalityID
		INNER JOIN dbo.Citizenship c ON o.CitizenshipID = c.CitizenshipID
		INNER JOIN dbo.Gender g ON #series.GenderID = g.GenderID
	END


END
GO
