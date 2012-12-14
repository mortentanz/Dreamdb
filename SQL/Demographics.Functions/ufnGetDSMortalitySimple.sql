/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Functions/ufnGetDSMortalitySimple.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Function  : Demographics.ufnGetDSMortalitySimple
  
  Purpose   : Calculates simple mortality rates (not specific to origins) for groups of persons classified
              by gender and age for a specified range of years.
              
  Returns   : A resultset containing mortality rates for groups of persons.
              
  Params    : @firstyear
              The first year in the range of years to return (defaults to 1981). If null is specified, data
              for the first available year is included as well (1980).

              @lastyear
              The last year in the range of years to return. If null is specified (the default), data up to
              the most recent available year is included.

  Errors    : In the event of input errors, the function returns an empty result set
              
-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.ufnGetDSMortalitySimple', 'TF') IS NOT NULL
DROP FUNCTION Demographics.ufnGetDSMortalitySimple
GO

CREATE FUNCTION Demographics.ufnGetDSMortalitySimple (
  @firstyear smallint = 1981,
  @lastyear smallint = null
)
RETURNS @mortality TABLE (
  GenderID tinyint,
  Age tinyint,
  [Year] smallint,
  Frequency float
)
AS
BEGIN

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSDeaths

  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  SET @l = coalesce(@lastyear, @ymax)

  IF (@f > @l) OR (@f < @ymin) OR (@l > @ymax)
  RETURN;

  INSERT INTO @mortality
  SELECT d.GenderID, d.Age, d.[Year], cast(d.Persons as float) / exposed.Persons AS Frequency
  FROM 
  (
    SELECT GenderID, Age, [Year], sum(Persons) AS Persons
    FROM Demographics.DSDeaths
    WHERE [Year] BETWEEN @f AND @l
    GROUP BY GenderID, Age, [Year]
  ) d
  
  INNER JOIN 
  (
    SELECT GenderID, Age, [Year], sum(Persons) AS Persons
    FROM 
    (
      SELECT GenderID, Age + 1 AS Age, [Year], cast(sum(Persons) as float) AS Persons
      FROM Demographics.DSPopulation p
      WHERE [Year] BETWEEN @f AND @l
      GROUP BY GenderID, Age, [Year]

      UNION ALL

      SELECT GenderID, Age, [Year], 0.5 * cast(sum(Persons) as float) AS Persons
      FROM Demographics.DSImmigrants i
      INNER JOIN Demographics.Origin o on i.OriginID = o.OriginID
      WHERE 
        o.TypeID = 2 AND o.CitizenshipID = 2 -- (Immigrants with Danish citizenship)
        AND [Year] BETWEEN @f AND @l
      GROUP BY GenderID, Age, [Year]

      UNION ALL

      SELECT ChildGenderID AS GenderID, 0 AS Age, [Year], 0.5 * cast(sum(Persons) as float) AS Persons
      FROM Demographics.DSBirths b
      WHERE [Year] BETWEEN @f AND @l
      GROUP BY ChildGenderID, [Year]

    ) exposedoperands

    GROUP BY GenderID, Age, [Year]
  
  ) exposed
  ON 
  (
    d.GenderID = exposed.GenderID AND
    d.Age = exposed.Age AND
    d.[Year] = exposed.[Year]
  )
  ORDER BY d.[Year], d.GenderID, d.Age

  RETURN

END
GO