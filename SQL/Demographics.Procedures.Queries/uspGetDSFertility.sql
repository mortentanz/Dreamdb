/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSFertility.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSFertility
  
  Purpose     : Gets the fertility rates by origin, age for a specified range of years. Intended for use by
                the population projection model. The procedure returns a single resultset containing observed
                and optionally imputed fertility rates pertaining to groups of women classified by origin, age
                and year.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSFertility', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSFertility
GO

CREATE PROCEDURE Demographics.uspGetDSFertility (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @impute bit = 1
)
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSMothers
  ;
  
  DECLARE @f smallint, @l smallint
  SET @f = coalesce(@firstyear, @ymin)
  IF (@lastyear IS NULL)
    SET @l = CASE WHEN @impute = 0 THEN (@ymax - 1) ELSE @ymax END
  ELSE
    SET @l = @lastyear
  ;

  BEGIN TRY
    IF (@f > @l) RAISERROR(80001, 16, 1, '@firstyear', '@lastyear');
    IF (@f < @ymin) RAISERROR(80002, 16, 1, '@firstyear');
    IF (@impute = 1 AND @l > @ymax) OR (@impute = 0 AND @l > (@ymax - 1)) RAISERROR(80003, 16, 1, '@lastyear');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  SELECT OriginID, f.Age AS Age, f.Frequency AS Frequency
  FROM Demographics.ufnGetDSFertility(@f, @l, @impute) f
  RETURN 0;

END
GO