/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Socioeconomics.Procedures.Reports/uspReportPopulation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : Socioeconomics.uspReportPopulation
  
  Purpose     : Returns a result set presenting population at the socioeconomics origin specification.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Socioeconomics.uspReportPopulation', 'P') IS NOT NULL
DROP PROCEDURE Socioeconomics.uspReportPopulation
GO

CREATE PROCEDURE Socioeconomics.uspReportPopulation (
  @projectionid smallint = null,
  @languageid int = 1030 
)
AS
BEGIN

  DECLARE @p smallint;
  DECLARE @f smallint;
  
  SELECT @p = coalesce(@projectionid, max(ProjectionID)) FROM Demographics.Projection;
  SELECT @f = min([Year]) FROM Demographics.[Population] WHERE ProjectionID = @p;

  SELECT * INTO #series
  FROM (
		SELECT OriginID, GenderID, Age, [Year], Persons FROM Socioeconomics.vPopulationHistory
		WHERE [Year] < @f
		UNION ALL
		SELECT so.OriginID, p.GenderID, p.Age, p.[Year], sum(p.Persons) AS Persons
		FROM Demographics.[Population] p
			INNER JOIN Demographics.Origin o ON p.OriginID = o.OriginID
			INNER JOIN Socioeconomics.Origin so ON 
				(so.TypeID = 1 AND o.TypeID = 1)  OR (so.TypeID = o.TypeID AND so.NationalityID = o.NationalityID)
		WHERE ProjectionID = @p
		GROUP BY so.OriginID, p.GenderID, p.Age, p.[Year]
	) AS s;

	IF (@languageid = 1030)
	BEGIN
		SELECT 
			so.Label AS [Oprindelse symbol],
			so.TextDa AS [Oprindelse],
			g.Label AS [Køn symbol],
			g.TextDa AS [Køn],
			Age AS Alder, [Year] AS [År], Persons AS Personer
		FROM #series s
			INNER JOIN Socioeconomics.Origin so ON s.OriginID = so.OriginID
			INNER JOIN dbo.Gender g ON g.GenderID = s.GenderID
	END
	ELSE
	BEGIN
		SELECT 
			so.Label AS [Origin label],
			so.TextEn AS Origin,
			g.Label AS [Gender label],
			g.TextEn AS [Gender],
			Age, [Year], Persons
		FROM #series s
			INNER JOIN Socioeconomics.Origin so ON s.OriginID = so.OriginID
			INNER JOIN dbo.Gender g ON g.GenderID = s.GenderID
	END

END
GO
