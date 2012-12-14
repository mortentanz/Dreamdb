/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspExtractResidenceDuration.sql $
  $Revision: 2 $
  $Date: 12/20/06 14:20 $
  $Author: mls $

  Procedure   : ETL.uspExtractResidenceDuration
  
  Purpose     : Extracts residence duration data (both historic and projected) for use in ETL applications.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspExtractResidenceDuration', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspExtractResidenceDuration
GO

CREATE PROCEDURE ETL.uspExtractResidenceDuration (@projectionid smallint) 
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT (EXISTS (SELECT * FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60401, 16, 1, 'The specified projection does not exist');
    
    IF (0 = (SELECT IsPublished FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60401, 16, 2, 'The specified projection is not marked as published');
    
    DECLARE @maxduration smallint, @f smallint;
    SELECT @f = min(rd.[Year]), @maxduration = max(d.Years)
    FROM Demographics.ResidenceDuration rd
      INNER JOIN dbo.Duration d ON d.DurationID = rd.DurationID
    WHERE rd.ProjectionID = @projectionid;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  BEGIN TRY
    SELECT GenderID, OriginID, Duration, @maxduration + 1 AS MaxDuration, Age, [Year], sum(Persons) AS Persons
    FROM (
      SELECT 
        rd.GenderID, rd.OriginID, 
        Duration = CASE 
          WHEN  rd.DurationID = -1 THEN NULL
          WHEN (rd.DurationID > @maxduration) THEN @maxduration + 1
          ELSE rd.DurationID 
        END, 
        rd.Age, rd.[Year], rd.Persons
      FROM Socioeconomics.vRASResidenceDuration rd
      WHERE rd.[Year] < @f
      UNION ALL
      SELECT 
        rd.GenderID, o.OriginID, 
        Duration = CASE 
          WHEN rd.DurationID > @maxduration THEN @maxduration + 1
          ELSE rd.DurationID
        END,
        rd.Age, rd.[Year], rd.Persons
      FROM Demographics.ResidenceDuration rd
        INNER JOIN Demographics.Origin do ON rd.OriginID = do.OriginID
        INNER JOIN Socioeconomics.Origin o ON o.TypeID = do.TypeID AND o.NationalityID = do.NationalityID
      WHERE ProjectionID = @projectionid
    ) AS result
    GROUP BY [Year], GenderID, OriginID, Age, Duration
    HAVING sum(Persons) > 1E-8
    ORDER BY [Year], GenderID, OriginID, Age, Duration
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH  

END
GO