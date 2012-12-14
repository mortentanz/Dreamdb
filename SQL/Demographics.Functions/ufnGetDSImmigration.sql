/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Functions/ufnGetDSImmigration.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Function  : Demographics.ufnGetDSImmigration
  
  Purpose   : Calculates immigration frequencies.
              
  Returns   : Immigration frequencies (immigrants related to primo population stock) by 13 origins, gender, 
              age and year. Note that age is reported ultimo current year.
              
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
IF object_id('Demographics.ufnGetDSImmigration', 'TF') IS NOT NULL
DROP FUNCTION Demographics.ufnGetDSImmigration
GO

CREATE FUNCTION Demographics.ufnGetDSImmigration (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
RETURNS @immigration TABLE (
  OriginID tinyint,
  GenderID tinyint,
  Age tinyint,
  [Year] smallint,
  Frequency float
)
AS
BEGIN

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSImmigrants

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

  INSERT INTO @immigration
  SELECT
    i.OriginID, 
    i.GenderID, 
    i.Age, 
    i.[Year],
    convert(float, i.Persons) / exposed.Persons AS Frequency
  FROM Demographics.DSImmigrants i
  INNER MERGE JOIN Demographics.ufnGetDSExposedToRisk(@f, @l, @impute) exposed
  ON 
  (
    i.OriginID = exposed.OriginID AND
    i.GenderID =  exposed.GenderID AND
    i.Age = exposed.Age AND
    i.[Year] = exposed.[Year]
  )
  RETURN

END
GO