/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSPopulationFromFlows.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSPopulationFromFlows
  
  Purpose     : Calculates the number of persons in groups classified by origin, gender and age in a given
                year from the primo stock in the previous years corrected for flows occuring over the course
                of that year. Intended for use with the population projection model. Persons belonging to the
                groups with 'Residual' for origin specification are added to appropriate groups having 
                'Danes from more developed countries with Danish citizenship' as origin specification. 

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSPopulationFromFlows', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSPopulationFromFlows
GO

CREATE PROCEDURE Demographics.uspGetDSPopulationFromFlows (
  @year smallint = null,
  @impute bit = 1
)
AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @ymin smallint, @ymax smallint
  SELECT @ymin = min([Year]), @ymax = max([Year]) + 1 FROM Demographics.DSPopulation
  ;

  DECLARE @y smallint
  SET @y = coalesce(@year, @ymax) - 1
  ;

  BEGIN TRY
    IF (@y < @ymin) RAISERROR(80002, 16, 1, '@year')
    IF (@y > @ymax) RAISERROR(80003, 16, 1, '@year')
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  SELECT OriginID, GenderID, convert(tinyint, Age) AS Age, SUM(Persons) AS Persons
  FROM
  (
    SELECT OriginID, GenderID, Age + 1 AS Age, Persons
    FROM Demographics.DSPopulation
    WHERE [Year] = @y
    
    UNION ALL
    
    SELECT ChildOriginID, ChildGenderID AS GenderID, 0 AS Age, SUM(Persons) AS Persons
    FROM Demographics.DSBirths
    WHERE [Year] = @y
    GROUP BY ChildOriginID, ChildGenderID
    
    UNION ALL
    
    SELECT OriginID, GenderID, Age, Persons
    FROM Demographics.DSImmigrants
    WHERE [Year] = @y
    
    UNION ALL
    
    SELECT OriginID, GenderID, Age, - Persons AS Persons
    FROM Demographics.DSDeaths
    WHERE [Year] = @y
    
    UNION ALL
    
    SELECT OriginID, GenderID, Age, - Persons AS Persons
    FROM Demographics.DSEmigrants
    WHERE [Year] = @y
    
    UNION ALL
    
    SELECT OriginID, GenderID, Age, - Persons AS Persons
    FROM Demographics.ufnGetDSNaturalized(@y, @y, @impute)
    
  ) AS fromflows

  GROUP BY OriginID, GenderID, Age
  ORDER BY OriginID, GenderID, Age
  
  RETURN 0;

END
GO