/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspExtractChildren.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : ETL.uspExtractChildren
  
  Purpose     : Extracts residence duration data (both historic and projected) for use in ETL applications.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspExtractChildren', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspExtractChildren
GO

CREATE PROCEDURE ETL.uspExtractChildren (@projectionid smallint) 
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
		DECLARE @camax tinyint;
		DECLARE @mamax tinyint;
		DECLARE @f smallint;

		SELECT @camax = max(Age), @mamax = max(MotherAge), @f = min([Year]) 
		FROM Demographics.Children WHERE ProjectionID = @projectionid

		SELECT OriginID, GenderID, Age, MotherAge, [Year], Persons
		FROM (
			SELECT ch.OriginID, ch.GenderID, ch.Age, ch.MotherAge, ch.[Year], ch.Persons
			FROM Socioeconomics.vChildrenHistory ch
			WHERE ch.MotherAge < @mamax + 1 AND ch.Age < @camax + 1 AND ch.[Year] < @f
			
			UNION ALL
			
			SELECT so.OriginID, c.GenderID, c.Age, c.MotherAge, c.[Year], sum(c.Persons) AS Persons
			FROM Demographics.Children c
				INNER JOIN Demographics.Origin do ON c.OriginID = do.OriginID
				INNER JOIN Socioeconomics.Origin so ON 
					(so.TypeID = 1 AND do.TypeID = 1) OR (so.TypeID = do.TypeID AND so.NationalityID = do.NationalityID)
			WHERE c.ProjectionID = @projectionid
			GROUP BY so.OriginID, c.GenderID, c.Age, c.MotherAge, c.[Year]
			HAVING sum(c.Persons) > 1E-8
		) AS r

		RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

END
GO