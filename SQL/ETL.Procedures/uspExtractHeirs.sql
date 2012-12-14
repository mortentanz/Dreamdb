/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspExtractHeirs.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : ETL.uspExtractHeirs
  
  Purpose     : Extracts residence duration data (both historic and projected) for use in ETL applications.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspExtractHeirs', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspExtractHeirs
GO

CREATE PROCEDURE ETL.uspExtractHeirs(@projectionid smallint)
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
		DECLARE @mamin tinyint;
		DECLARE @mamax tinyint;
		DECLARE @f smallint;

		SELECT @mamin = min(MotherAge), @mamax = max(MotherAge), @f = min([Year]) 
		FROM Demographics.Heirs WHERE ProjectionID = @projectionid

		SELECT GenderID, Age, MotherAge, [Year], Persons
		FROM (
			SELECT hh.GenderID, hh.Age, hh.MotherAge, hh.[Year], hh.Persons
			FROM Socioeconomics.vHeirsHistory hh
			WHERE hh.MotherAge BETWEEN @mamin AND @mamax AND hh.[Year] < @f
			
			UNION ALL
			
			SELECT h.GenderID, h.Age, h.MotherAge, h.[Year], h.Persons
			FROM Demographics.Heirs h
			WHERE h.ProjectionID = @projectionid AND h.Persons > 1E-8
		) AS r
		ORDER BY [Year], GenderID, MotherAge, Age
		RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

END
GO