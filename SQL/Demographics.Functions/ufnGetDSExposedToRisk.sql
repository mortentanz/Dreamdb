/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Functions/ufnGetDSExposedToRisk.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Function  : Demographics.ufnGetDSExposedToRisk
  
  Purpose   : Gets the primo stock corrected for exogenous flows for use in determination of frequencies
              
  Returns   : A resultset containing number of persons exposed to risk of change classified by origin,
              gender, and age for the specfied range of years.
              
  Params    : @firstyear
              The first year in the range of years to return (defaults to 1981). If null is specified, data
              for the first available year is included as well (1980).

              @lastyear
              The last year in the range of years to return. If null is specified (the default), data up to
              the most recent available year is included.

              @impute
              States if the last year in the range should be imputed. If set (1), we will assume that the 
              number of naturalized persons from any group of persons classified by origin, gender,
              and age in the last year is the same as the numbers that may be determined for the previous
              year. This effectively expands the range of available years in the database by one.

  Errors    : In the event of input errors, the function returns an empty resultset
              
-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.ufnGetDSExposedToRisk', 'TF') IS NOT NULL
DROP FUNCTION Demographics.ufnGetDSExposedToRisk
GO

CREATE FUNCTION Demographics.ufnGetDSExposedToRisk (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
RETURNS @exposed TABLE (
  OriginID tinyint,
  GenderID tinyint,
  Age tinyint,
  [Year] smallint,
  Persons float
)
AS
BEGIN

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSPopulation

  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  IF (@lastyear IS NULL)
    SET @l = CASE WHEN @impute = 0 THEN (@ymax - 1) ELSE @ymax END
  ELSE
    SET @l = @lastyear
  ;

  IF (@f > @l) OR (@f < @ymin) OR 
    ((@impute = 1 AND @l > @ymax) OR (@impute = 0 AND @l > (@ymax - 1)))
    RETURN
  ;

  INSERT INTO @exposed
  SELECT OriginID, GenderID, Age, [Year], sum(Persons) AS Persons
  FROM (
  
    SELECT p.OriginID, p.GenderID, p.Age + 1 AS Age, p.[Year], p.Persons AS Persons
    FROM Demographics.DSPopulation p
    
    UNION ALL
    
    SELECT b.ChildOriginID AS OriginID, b.ChildGenderID AS GenderID, 0 AS Age, b.[Year], 0.5 * b.Persons AS Persons
    FROM Demographics.DSBirths b

    UNION ALL
    
    SELECT i.OriginID, i.GenderID, i.Age, i.[Year], 0.5 * i.Persons AS Persons
    FROM Demographics.DSImmigrants i
    WHERE i.OriginID IN (
      SELECT OriginID FROM Demographics.Origin 
      WHERE TypeID = 2 AND CitizenshipID = 2    -- Immigrants with Danish citizenship
    )

    UNION ALL
    
    SELECT n.OriginID, n.GenderID, n.Age, n.[Year], - 0.5 * n.Persons AS Persons
    FROM Demographics.ufnGetDSNaturalized(@f, @l, @impute) n
    WHERE n.OriginID IN (
      SELECT OriginID FROM Demographics.Origin
      WHERE CitizenshipID = 1                   -- Persons exiting Danish citizenships
    )
    
  ) AS correctedprimo
  
  GROUP BY OriginID, GenderID, Age, [Year]
  HAVING sum(Persons) <> 0 AND [Year] BETWEEN @f AND @l
  ORDER BY [Year], OriginID, GenderID, Age
  
  RETURN

END
GO