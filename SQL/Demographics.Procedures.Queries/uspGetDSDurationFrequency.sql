/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSDurationFrequency.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSDurationFrequency
  
  Purpose     : Gets the origin, gender, and age specific distribution of immigrants across durations.
								Optionally annual distributions are returned, so the @mean parameter implies that an extra
								column is returned in the result set.
  
-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSDurationFrequency', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSDurationFrequency
GO

CREATE PROCEDURE Demographics.uspGetDSDurationFrequency (
  @firstyear smallint = 2000,
  @lastyear smallint = null,
  @durations tinyint = 15,		-- By default we assume that durations from 0 through 15+ are to be returned
  @residual bit = 0,
  @mean bit = 1
) AS 
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @maxduration smallint;
		DECLARE @f smallint;
		DECLARE @l smallint;

		SELECT 
			@maxduration = max(DurationID),
			@f = min([Year]),
			@l = max([Year])
		FROM Socioeconomics.RAS 
		WHERE DurationID < 32767;

		IF (@durations > @maxduration + 1) SET @durations = @maxduration + 1;
		SET @lastyear = coalesce(@lastyear, @l);				

		IF (@durations < 2) RAISERROR(80010, 16, 1, 'The number of durations excluding top group and residual must exceed 2');
		IF (@firstyear > @lastyear) RAISERROR(80001, 16, 2, '@firstyear', '@lastyear');
		IF (@firstyear < @f) RAISERROR(80002, 16, 3, '@firstyear');		
		IF (@lastyear > @l)	RAISERROR(80003, 16, 4, '@lastyear');
		
	END TRY
	BEGIN CATCH
		EXECUTE dbo.uspLogError;
		EXECUTE dbo.uspRethrowError;
		RETURN -1;
	END CATCH;

	WITH ras AS (
		SELECT 
			OriginID, GenderID, 
			DurationID = CASE 
			WHEN rd.DurationID = -1 AND @residual = 0 THEN 32767
			WHEN rd.DurationID >= @durations THEN 32767
			ELSE rd.DurationID
			END,
			Age, [Year], Persons
		FROM Socioeconomics.vRASResidenceDuration rd
		WHERE [Year] BETWEEN @firstyear AND @lastyear
	),
	durations AS (
		SELECT OriginID, GenderID, DurationID, Age, [Year], sum(Persons) AS Persons
		FROM ras
		GROUP BY OriginID, GenderID, DurationID, Age, [Year]
		HAVING sum(Persons) > 0
	)
	SELECT OriginID, GenderID, DurationID, Age, [Year], Persons AS Persons
	INTO #result
	FROM durations
	;

	IF (@mean = 0)
	BEGIN
		SELECT n.OriginID, n.GenderID, n.DurationID, n.Age, n.[Year], convert(float, n.Persons) / d.Persons AS Frequency
		FROM #result n
		LEFT JOIN (
			SELECT OriginID, GenderID, Age, [Year], sum(Persons) AS Persons
			FROM #result
			GROUP BY OriginID, GenderID, Age, [Year]
		) d
		ON (n.OriginID = d.OriginID AND n.GenderID = d.GenderID AND n.Age = d.Age AND n.[Year] = d.[Year])
	END
	ELSE
	BEGIN
		SELECT n.OriginID, n.GenderID, n.DurationID, n.Age, convert(float, n.Persons) / d.Persons AS Frequency
		FROM (
			SELECT OriginID, GenderID, DurationID, Age, sum(Persons) AS Persons
			FROM #result
			GROUP BY OriginID, GenderID, DurationID, Age
		) n
		LEFT JOIN (
			SELECT OriginID, GenderID, Age, sum(Persons) AS Persons
			FROM #result
			GROUP BY OriginID, GenderID, Age
		) d
		ON (n.OriginID = d.OriginID AND n.GenderID = d.GenderID AND n.Age = d.Age)
		ORDER BY Age, GenderID, OriginID, DurationID
	END

	RETURN 0;

END
GO