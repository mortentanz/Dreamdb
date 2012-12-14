/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Functions/ufnGetDSNaturalized.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Function  : Demographics.ufnGetDSNaturalized
  
  Purpose   : Returns net number of naturalized persons by origin, gender, and age for a specified range of 
              years. Naturalization is in Dreamdb defined as exits from an origin class.

  Returns   : Imputed net number of naturalized persons to exiting from an origin category classified by 13 
              origins, gender, age and year. Note that age is reported ultimo current year.
              
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

  Errors    : In the event of input errors, the function returns an empty resultset.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.ufnGetDSNaturalized', 'TF') IS NOT NULL
DROP FUNCTION Demographics.ufnGetDSNaturalized
GO

CREATE FUNCTION Demographics.ufnGetDSNaturalized (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
RETURNS @naturalized TABLE (
  OriginID tinyint,
  GenderID tinyint,
  Age tinyint,
  [Year] smallint,
  Persons int
)
AS
BEGIN

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSPopulation

  DECLARE @fy smallint, @ly smallint
  SET @fy = coalesce(@firstyear, @ymin)
  SET @ly = coalesce(@lastyear, case when @impute = 1 then @ymax else @ymax - 1 end)

  DECLARE @f smallint, @l smallint
  IF (isnull(@impute, 0) = 1)
  BEGIN
    SET @l = @ly - 1
    SET @f = case when @fy = @ly then @l else @fy end
  END
  ELSE
  BEGIN
    SET @f = @fy
    SET @l = @ly
  END
  
  IF 
    (@fy > @ly) OR 
    (@fy < @ymin) OR 
    ((@impute = 1 AND @ly > @ymax) OR (@impute = 0 AND @ly > (@ymax - 1)))
    RETURN
  ;
  
  WITH naturalized AS 
  (
    SELECT n.OriginID, n.GenderID, n.Age, n.[Year], sum(n.Persons) AS Persons
    FROM
    (
      SELECT p.OriginID, p.GenderID, p.Age + 1 AS Age, p.[Year], p.Persons
      FROM Demographics.DSPopulation p
      
      UNION ALL
      
      SELECT u.OriginID, u.GenderID, u.Age, u.[Year] - 1 AS [Year], - u.Persons AS Persons
      FROM Demographics.DSPopulation u

      UNION ALL
      
      SELECT b.ChildOriginID AS OriginID, b.ChildGenderID AS GenderID, 0 AS Age, b.[Year], b.Persons AS Persons
      FROM Demographics.DSBirths b

      UNION ALL
      
      SELECT i.OriginID, i.GenderID, i.Age, i.[Year], i.Persons AS Persons
      FROM Demographics.DSImmigrants i

      UNION ALL
      
      SELECT e.OriginID, e.GenderID, e.Age, e.[Year], - e.Persons AS Persons
      FROM Demographics.DSEmigrants e

      UNION ALL

      SELECT d.OriginID, d.GenderID, d.Age, d.[Year], - d.Persons AS Persons
      FROM Demographics.DSDeaths d
    ) AS n
    GROUP BY n.OriginID, n.GenderID, n.Age, n.[Year]
    HAVING sum(n.Persons) <> 0 AND n.[Year] BETWEEN @f AND @l
  )


  INSERT INTO @naturalized
  SELECT OriginID, GenderID, Age, [Year], Persons
  FROM 
  (

    SELECT OriginID, GenderID, Age, [Year], Persons
    FROM naturalized
    WHERE
      [Year] BETWEEN @fy AND CASE WHEN @impute = 1 THEN (@ly - 1) ELSE @ly END

    UNION ALL
    
    SELECT OriginID, GenderID, Age, [Year] = @ly, Persons
    FROM naturalized
    WHERE [Year] = CASE WHEN @impute = 1 THEN @l ELSE NULL END

  ) as allvalues
  
  ORDER BY [Year], OriginID, GenderID, Age

  RETURN

END
GO