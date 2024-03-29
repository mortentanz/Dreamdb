/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Reports/uspReportDependencyRatios.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspReportDependencyRatios
  
  Purpose     : Returns a result set presenting (demographic) dependency ratios.

-----------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspReportDependencyRatios', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspReportDependencyRatios
GO

CREATE PROCEDURE Demographics.uspReportDependencyRatios (
  @projectionid smallint = null,
  @includehistory bit = 1,
  @languageid int = 1030 
) AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @p smallint;
  DECLARE @f smallint;
  
  SELECT @p = coalesce(@projectionid, max(ProjectionID)) FROM Demographics.Projection;
  SELECT @f = min([Year]) FROM Demographics.Births WHERE ProjectionID = @p;
  
  SELECT 
    a.[Year], a.Adults, c.Children, o.Old, vo.VeryOld
  INTO #series
  FROM (
		SELECT [Year], sum(Persons) AS Adults 
		FROM Demographics.vPopulationHistory
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  Age > 14 AND Age < 65
		GROUP BY [Year]
		UNION ALL
		SELECT [Year], sum(Persons) AS Adults
		FROM Demographics.[Population]
		WHERE 
		  ProjectionID = @p AND
		  Age > 14 AND Age < 65
		GROUP BY [Year]
	) AS a
	
	LEFT JOIN (
	  SELECT [Year], sum(Persons) AS Children 
		FROM Demographics.vPopulationHistory
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  Age < 14
		GROUP BY [Year]
		UNION ALL
		SELECT [Year], sum(Persons) AS Children
		FROM Demographics.[Population]
		WHERE 
		  ProjectionID = @p AND
		  Age < 14
		GROUP BY [Year]
	) AS c ON a.[Year]=c.[Year]
	
	LEFT JOIN (
	  SELECT [Year], sum(Persons) AS Old 
		FROM Demographics.vPopulationHistory
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  Age > 64
		GROUP BY [Year]
		UNION ALL
		SELECT [Year], sum(Persons) AS Old
		FROM Demographics.[Population]
		WHERE 
		  ProjectionID = @p AND
		  Age > 64
		GROUP BY [Year]
	) AS o ON a.[Year]=o.[Year]
	
	LEFT JOIN (
	  SELECT [Year], sum(Persons) AS VeryOld 
		FROM Demographics.vPopulationHistory
		WHERE 
		  [Year] < (CASE WHEN @includehistory = 1 THEN @f ELSE 0 END) AND
		  Age > 79
		GROUP BY [Year]
		UNION ALL
		SELECT [Year], sum(Persons) AS VeryOld
		FROM Demographics.[Population]
		WHERE 
		  ProjectionID = @p AND
		  Age > 79
		GROUP BY [Year]
	) AS vo ON a.[Year]=vo.[Year]
	
	IF (@languageid = 1030)
	BEGIN
		SELECT 
			[Year] AS [År], 
		  Children / Adults AS [Børnekvoten],
      Old / Adults AS [Ældrekvoten 65+],
      VeryOld / Adults AS [Ældrekvoten 80+],
      (Children + Old) / Adults AS [Forsøgerkvoten]
		FROM #series s
	END
	ELSE
	BEGIN
		SELECT
			[Year], 
		  Children / Adults AS [Child-ratio],
      Old / Adults AS [Elder-ratio 65+],
      VeryOld / Adults AS [Elder-ratio 80+],
      (Children + Old) / Adults AS [Provider-ratio]
		FROM #series s
	END

END 
GO