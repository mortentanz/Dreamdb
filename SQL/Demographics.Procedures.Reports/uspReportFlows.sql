/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Reports/uspReportFlows.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspReportFlows
  
  Purpose     : Returns a result set presenting demographic flows in a projection.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspReportFlows', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspReportFlows
GO


CREATE PROCEDURE Demographics.uspReportFlows (
  @projectionid smallint = null,
  @includehistory bit = 1,
  @includeresidual bit = 0,
  @languageid int = 1030 
) AS
BEGIN

  SET NOCOUNT ON;
  
  DECLARE @p smallint;
  DECLARE @f smallint;
  
  SELECT @p = coalesce(@projectionid, max(ProjectionID)) FROM Demographics.Projection;
  SELECT @f = min([Year]) FROM Demographics.Births WHERE ProjectionID = @p;    

  SELECT 
    p.OriginID, p.GenderID, p.[Year], p.Persons, b.Births, d.Deaths, i.Immigrants, e.Emigrants
  INTO #series
  FROM (
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Persons 
		FROM Demographics.vPopulationHistory
		WHERE [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END)
		GROUP BY OriginID, GenderID, [Year]
		UNION ALL
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Persons
		FROM Demographics.[Population]
		WHERE ProjectionID = @p
		GROUP BY OriginID, GenderID, [Year]
	) AS p
	
  LEFT JOIN (
		SELECT ChildOriginID AS OriginID, ChildGenderID AS GenderID, [Year], sum(Persons) AS Births 
		FROM Demographics.DSBirths
		WHERE [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END)
		GROUP BY ChildOriginID, ChildGenderID, [Year]
		UNION ALL
		SELECT ChildOriginID AS OriginID, ChildGenderID AS GenderID, [Year], sum(Persons) AS Births
		FROM Demographics.Births
		WHERE ProjectionID = @p
		GROUP BY ChildOriginID, ChildGenderID, [Year]
	) AS b ON (p.[Year] = b.[Year] AND p.OriginID = b.OriginID AND p.GenderID = b.GenderID)
	
	LEFT JOIN (
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Deaths 
		FROM Demographics.DSDeaths
		WHERE [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END)
		GROUP BY OriginID, GenderID, [Year]
		UNION ALL
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Deaths
		FROM Demographics.Deaths
		WHERE ProjectionID = @p
		GROUP BY OriginID, GenderID, [Year]
	) AS d ON (p.[Year] = d.[Year] AND p.OriginID = d.OriginID AND p.GenderID = d.GenderID)
	
	LEFT JOIN (
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Immigrants 
		FROM Demographics.DSImmigrants
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  OriginID <> (CASE WHEN @includeresidual = 0 THEN 0 ELSE -1 END)
		GROUP BY OriginID, GenderID, [Year]
		UNION ALL
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Immigrants
		FROM Demographics.Immigrants
		WHERE ProjectionID = @p
		GROUP BY OriginID, GenderID, [Year]
	) AS i ON (p.[Year] = i.[Year] AND p.OriginID = i.OriginID AND p.GenderID = i.GenderID)
	
	LEFT JOIN (
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Emigrants
		FROM Demographics.DSEmigrants
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  OriginID <> (CASE WHEN @includeresidual = 0 THEN 0 ELSE -1 END)
		GROUP BY OriginID, GenderID, [Year]
		UNION ALL
		SELECT OriginID, GenderID, [Year], sum(Persons) AS Emigrants
		FROM Demographics.Emigrants
		WHERE ProjectionID = @p
		GROUP BY OriginID, GenderID, [Year]
	) AS e ON (p.[Year] = e.[Year] AND p.OriginID = e.OriginID AND p.GenderID = e.GenderID)

	IF (@languageid = 1030)
	BEGIN
		SELECT 
			s.OriginID, 
			o.TextDa AS Oprindelse,
			ot.TextDa AS OprindelsesType,
			n.TextDa AS Nationalitet,
			c.TextDa AS Statsborgerskab,
			g.TextDa AS [Køn],
			[Year] AS [År], 
		  Persons AS [Befolkning primo],
      Births AS [Fødte],
      Deaths AS [Døde],
      Immigrants As [Indvandrere],
      Emigrants As [Udvandrere],
      isnull(Births,0) - isnull(Deaths,0) AS [Fødselsoverskud],
      isnull(Immigrants,0) - isnull(Emigrants,0) AS [Nettoindvandring],
      isnull(Births,0) - isnull(Deaths,0) + isnull(Immigrants,0) - isnull(Emigrants,0) AS [Befolkningstilvækst]
		FROM #series s
		INNER JOIN Demographics.Origin o ON s.OriginID = o.OriginID
		INNER JOIN dbo.OriginType ot ON o.TypeID = ot.TypeID
		INNER JOIN dbo.Nationality n ON o.NationalityID = n.NationalityID
		INNER JOIN dbo.Citizenship c ON o.CitizenshipID = c.CitizenshipID
		INNER JOIN dbo.Gender g ON s.GenderID = g.GenderID
	END
	ELSE
	BEGIN
		SELECT
			s.OriginID, 
			o.TextEn AS Origin,
			ot.TextEn AS OriginType,
			n.TextEn AS Nationality,
			c.TextEn AS Citizenship,
			g.TextEn AS Gender,
			[Year], 
			Persons AS [Population primo],
      Births AS [Newborn],
      Deaths AS [Deaths],
      Immigrants As [Immigrants],
      Emigrants As [Emigrants],
      isnull(Births,0) - isnull(Deaths,0) AS [Birthsurplus],
      isnull(Immigrants,0) - isnull(Emigrants,0) AS [Netmigration],
      isnull(Births,0) - isnull(Deaths,0) + isnull(Immigrants,0) - isnull(Emigrants,0) AS [Populationaccumulation]
		FROM #series s
		INNER JOIN Demographics.Origin o ON s.OriginID = o.OriginID
		INNER JOIN dbo.OriginType ot ON o.TypeID = ot.TypeID
		INNER JOIN dbo.Nationality n ON o.NationalityID = n.NationalityID
		INNER JOIN dbo.Citizenship c ON o.CitizenshipID = c.CitizenshipID
		INNER JOIN dbo.Gender g ON s.GenderID = g.GenderID
	END

END 
GO