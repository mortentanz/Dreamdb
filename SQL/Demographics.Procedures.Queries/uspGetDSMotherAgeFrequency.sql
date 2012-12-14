/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSMotherAgeFrequency.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSMotherAgeFrequency
  
  Purpose     : Determines the share of births by age of mothers. Shares may be determined in an origin
								specific manner (@orgin=1), and annually (@mean=0) or across the specified period. The age
								of mothers is bounded by default implying that births given by younger mothers are assigned to
								the group having @minage and vice versa for older mothers.
								
	Remarks			: The number of columns in the result set depends on the specified parameters.								
  
-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSMotherAgeFrequency', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSMotherAgeFrequency
GO

CREATE PROCEDURE Demographics.uspGetDSMotherAgeFrequency (
	@firstyear smallint = 1981,
	@lastyear smallint = null,
	@maxage tinyint = 49,
	@minage tinyint = 14,
	@origin bit = 0,
	@mean bit = 1
)
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSChildren
  ;

  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  SET @l = coalesce(@lastyear, @ymax)
  ;

  BEGIN TRY
    IF (@f > @l) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear');
    IF (@f < @ymin) RAISERROR(80002, 16, 1, '@firstyear');
    IF (@l > @ymax) RAISERROR(80003, 16, 1, '@lastyear');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH;

	-- Contruct temporary table holding input data
	SELECT OriginID, MotherAge, [Year], sum(Persons) AS Persons
	INTO #births
	FROM (
		SELECT 
			OriginID, 
			MotherAge = CASE 
				WHEN MotherAge < @minage THEN @minage
				WHEN MotherAge > @maxage THEN @maxage
				ELSE MotherAge
			END,
			[Year],
			Persons
		FROM Demographics.DSChildren
		WHERE [Year] BETWEEN @f AND @l AND Age = 0 AND MotherAge IS NOT NULL
	) b
	GROUP BY OriginID, MotherAge, [Year]
	ORDER BY [Year], OriginID, MotherAge
	;
	
	-- Calculate result based on input parameters.
	IF (@origin = 1) AND (@mean = 0)
	BEGIN
		SELECT b.OriginID, b.MotherAge, b.[Year], convert(float, b.Persons) / t.Persons AS Frequency
		FROM #births b
		JOIN (
			SELECT OriginID, [Year], sum(Persons) AS Persons
			FROM #births
			GROUP BY OriginID, [Year]	
		) t
		ON (b.OriginID = t.OriginID AND b.[Year] = t.[Year])
		RETURN 0;
	END

	IF (@origin = 1) AND (@mean = 1)
	BEGIN
		SELECT b.OriginID, b.MotherAge, convert(float, b.Persons) / t.Persons AS Frequency
		FROM (
			SELECT OriginID, MotherAge, sum(Persons) AS Persons
			FROM #births
			GROUP BY OriginID, MotherAge
		) b
		JOIN (
			SELECT OriginID, sum(Persons) AS Persons
			FROM #births
			GROUP BY OriginID
		) t
		ON (b.OriginID = t.OriginID)
		RETURN 0;
	END

	IF (@origin = 0) AND (@mean = 0)
	BEGIN
		SELECT b.MotherAge, b.[Year], convert(float, b.Persons) / t.Persons AS Frequency
		FROM (
			SELECT MotherAge, [Year], sum(Persons) AS Persons
			FROM #births
			GROUP BY MotherAge, [Year]
		) b
		JOIN (
			SELECT [Year], sum(Persons) AS Persons
			FROM #births
			GROUP BY [Year]	
		) t
		ON (b.[Year] = t.[Year])
		RETURN 0;
	END

	IF (@origin = 0) AND (@mean = 1)
	BEGIN
		SELECT b.MotherAge, convert(float, b.Persons) / t.Persons AS Frequency
		FROM (
			SELECT MotherAge, sum(Persons) AS Persons
			FROM #births
			GROUP BY MotherAge
		) b
		LEFT JOIN (
			SELECT sum(Persons) AS Persons
			FROM #births
		) t
		ON b.MotherAge IS NOT NULL
		ORDER BY MotherAge
		RETURN 0;
	END;

END
GO