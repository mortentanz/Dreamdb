/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSChildOriginFrequency.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSChildOriginFrequency
  
  Purpose     : Gets frequencies of children classified by mothers and own origin for a specified range of
                years. Intended for the population projection model. The procedure returns a single resultset
                containing frequencies of children in groups classified by origins.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSChildOriginFrequency', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSChildOriginFrequency
GO

CREATE PROCEDURE Demographics.uspGetDSChildOriginFrequency (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @residual bit = 0,
  @mean bit = 1
)
AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) FROM Demographics.DSParents
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
  END CATCH
  ;

	DECLARE @o tinyint;
	SET @o = CASE WHEN @residual = 1 THEN 255 ELSE 0 END;

  IF(@mean = 0)
  BEGIN;
  
		WITH children AS (
			SELECT MotherOriginID, ChildOriginID, [Year], Children
			FROM Demographics.vDSChildOrigin
			WHERE [Year] BETWEEN @f AND @l AND ChildOriginID <> @o AND MotherOriginID <> @o
		)
  	SELECT c.MotherOriginID, c.ChildOriginID, c.[Year], convert(float, c.Children) / t.Children AS Frequency
		FROM children c
		JOIN (
			SELECT MotherOriginID, [Year], sum(Children) AS Children
			FROM children
			GROUP BY MotherOriginID, [Year]
		) t
		ON (c.MotherOriginID = t.MotherOriginID AND c.[Year] = t.[Year])
		RETURN 0;
  
  END
  ELSE
  BEGIN;

		WITH children AS (
			SELECT MotherOriginID, ChildOriginID, sum(Children) AS Children
			FROM Demographics.vDSChildOrigin
			WHERE [Year] BETWEEN @f AND @l AND ChildOriginID <> @o AND MotherOriginID <> @o
			GROUP BY MotherOriginID, ChildOriginID
		)
		SELECT c.MotherOriginID, c.ChildOriginID, convert(float, c.Children) / t.Children AS Frequency
		FROM children c
		JOIN (
			SELECT MotherOriginID, sum(Children) AS Children
			FROM children
			GROUP BY MotherOriginID
		) t
		ON (c.MotherOriginID = t.MotherOriginID)
		RETURN 0;
  
  END
  
END
GO