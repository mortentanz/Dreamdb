/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Reports/uspReportEmigration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspReportEmigration
  
  Purpose     : Returns a result set presenting emigration.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspReportEmigration', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspReportEmigration
GO


CREATE PROCEDURE Demographics.uspReportEmigration (
  @projectionid smallint = null,
  @includehistory bit = 1,
  @includeresidual bit = 0,  
  @languageid int = 1030
)
AS 
BEGIN

  DECLARE @p smallint;
  DECLARE @f smallint;
  
  SELECT @p = coalesce(@projectionid, max(ProjectionID)) FROM Demographics.Projection;
  SELECT @f = min([Year]) FROM Demographics.Emigrants WHERE ProjectionID = @p;

  SELECT * INTO #series
  FROM (
		SELECT OriginID, GenderID, Age, [Year], Persons 
		FROM Demographics.DSEmigrants
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  OriginID <> (CASE WHEN @includeresidual = 0 THEN 0 ELSE -1 END)
		UNION ALL
		SELECT OriginID, GenderID, Age, [Year], Persons AS Persons
		FROM Demographics.Emigrants
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