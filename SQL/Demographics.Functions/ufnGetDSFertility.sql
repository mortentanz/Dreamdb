/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Functions/ufnGetDSFertility.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Function  : Demographics.ufnGetDSFertility
  
  Purpose   : Calculates fertitlity rates for groups of women classified by origin and age for a specified
              range of years.
              
  Returns   : A resultset containing fertitlity rates for groups of women.
              
  Params    : @firstyear
              The first year in the range of years to return (defaults to 1981). If null is specified, data
              for the first available year is included as well (1980).

              @lastyear
              The last year in the range of years to return. If null is specified (the default), data up to
              the most recent available year is included.

              @impute
              States if the last year in the range should be imputed. If set (1), the function will stipulate
              that the number of naturalized persons from any group of persons classified by origin, gender,
              and age in the last year is the same as the numbers that may be determined for the previous
              year. Since the number naturalized persons is used for determining the exposure to risk when
              determining rates, this effectively expands the range of available years in the database by 
              one.

  Errors    : In the event of input errors, the function returns an empty result set
              
-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.ufnGetDSFertility', 'TF') IS NOT NULL
DROP FUNCTION Demographics.ufnGetDSFertility
GO

CREATE FUNCTION Demographics.ufnGetDSFertility (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
) 
RETURNS @fertility TABLE (
  OriginID tinyint,
  Age tinyint,
  [Year] smallint,
  Frequency float
) 
AS
BEGIN

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSMothers

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
  
  INSERT INTO @fertility
  SELECT m.OriginID, m.Age, m.[Year], cast(m.Persons as float) / exposed.Persons AS Frequency
  FROM 
  (
    SELECT OriginID, Age, [Year], sum(Persons) AS Persons
    FROM Demographics.DSMothers
    WHERE [Year] BETWEEN @f AND @l
    GROUP BY OriginID, Age, [Year]
  ) m
  
  INNER JOIN 
  (
    SELECT OriginID, Age, [Year], sum(Persons) AS Persons
    FROM 
    (
      SELECT p.OriginID, p.Age + 1 AS Age, p.[Year], p.Persons AS Persons
      FROM Demographics.DSPopulation p
      WHERE p.GenderID = 1 AND p.[Year] BETWEEN @f AND @l
      
      UNION ALL
      
      SELECT i.OriginID, i.Age, i.[Year], 0.5 * i.Persons AS Persons
      FROM Demographics.DSImmigrants i
      WHERE i.GenderID = 1 AND i.[Year] BETWEEN @f AND @l
      
      UNION ALL
      
      SELECT e.OriginID, e.Age, e.[Year], - 0.5 * e.Persons AS Persons
      FROM Demographics.DSEmigrants e
      WHERE e.GenderID = 1 AND e.[Year] BETWEEN @f AND @l

      UNION ALL
      
      SELECT d.OriginID, d.Age, d.[Year], - 0.5 * d.Persons AS Persons
      FROM Demographics.DSDeaths d
      WHERE d.GenderID = 1 AND d.[Year] BETWEEN @f AND @l

      UNION ALL
      
      SELECT n.OriginID, n.Age, n.[Year], - 0.5 * n.Persons AS Persons
      FROM Demographics.ufnGetDSNaturalized(@f, @l, @impute) n
      WHERE n.GenderID = 1

    ) exposedparts

    GROUP BY OriginID, Age, [Year]
    HAVING sum(Persons) <> 0
  
  ) exposed
  
  ON 
  (
    m.OriginID = exposed.OriginID AND
    m.Age = exposed.Age AND
    m.[Year] = exposed.[Year]
  )
  ORDER BY [Year], OriginID, Age

  RETURN

END 
GO