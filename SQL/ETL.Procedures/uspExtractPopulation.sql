/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspExtractPopulation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : ETL.uspExtractPopulation
  
  Purpose     : Extracts population data (both historic and projected) for use in ETL applications.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspExtractPopulation', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspExtractPopulation
GO

CREATE PROCEDURE ETL.uspExtractPopulation (@projectionid smallint) 
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT (EXISTS (SELECT * FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60401, 16, 1, 'The specified projection does not exist');
    
    IF (0 = (SELECT IsPublished FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60401, 16, 2, 'The specified projection is not marked as published');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    DECLARE @f smallint;
    SELECT @f = min([Year]) FROM Demographics.[Population] WHERE ProjectionID = @projectionid;

    SELECT OriginID, GenderID, Age, [Year], Persons
    FROM (
      SELECT OriginID, GenderID, Age, [Year], Persons
      FROM Socioeconomics.vPopulationHistory
      WHERE [Year] < @f
      UNION ALL
      SELECT o.OriginID, p.GenderID, p.Age, p.[Year], sum(p.Persons) AS Persons
      FROM Demographics.[Population] p
        INNER JOIN Demographics.Origin do ON p.OriginID = do.OriginID
        INNER JOIN Socioeconomics.Origin o ON 
          (o.TypeID = 1 AND do.TypeID = 1) OR (o.TypeID = do.TypeID AND o.NationalityID = do.NationalityID)
      WHERE p.ProjectionID = @projectionid
      GROUP BY p.[Year], o.OriginID, p.GenderID, p.Age
      HAVING sum(p.Persons) > 1E-8
    ) AS result
    ORDER BY [Year], OriginID, GenderID, Age
    ;
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH

END
GO