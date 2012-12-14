/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Queries/uspGetDSChildren.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspGetDSChildren
  
  Purpose     : Gets number of persons by age of mothers for a specified range of years. Intended for the 
                population projection model. The procedure returns a single resultset containing numbers of 
                persons in groups classified by origin, gender and age.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('Demographics.uspGetDSChildren', 'P') IS NOT NULL
DROP PROCEDURE Demographics.uspGetDSChildren
GO

CREATE PROCEDURE Demographics.uspGetDSChildren (
  @firstyear smallint = 1981,
  @lastyear smallint = null,
  @fornewborn bit = 1
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
  END CATCH

  IF (@fornewborn = 1)
  BEGIN
    SELECT OriginID, Age, MotherAge, [Year], sum(Persons) AS Persons
    FROM Demographics.DSChildren
    WHERE [Year] BETWEEN @f AND @l AND Age = 0
    GROUP BY OriginID, Age, MotherAge, [Year]
    ORDER BY OriginID, Age, MotherAge, [Year]
  END
  ELSE
  BEGIN
    SELECT OriginID, Age, MotherAge, [Year], sum(Persons) AS Persons
    FROM Demographics.DSChildren
    WHERE [Year] BETWEEN @f AND @l
    GROUP BY OriginID, Age, MotherAge, [Year]
    ORDER BY OriginID, Age, MotherAge, [Year]
  END    
  RETURN 0;  
  
END
GO  