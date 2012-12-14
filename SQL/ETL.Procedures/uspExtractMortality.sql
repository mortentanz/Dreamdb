/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspExtractMortality.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:47 $
  $Author: mls $

  Procedure   : ETL.uspExtractMortality
  
  Purpose     : Extracts mortality rates (both historic and projected) for use in ETL applications.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspExtractMortality', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspExtractMortality
GO

CREATE PROCEDURE ETL.uspExtractMortality (@projectionid smallint) 
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT (EXISTS (SELECT * FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60401, 16, 1, 'The specified projection does not exist');
    
    IF (0 = (SELECT IsPublished FROM Demographics.Projection WHERE ProjectionID = @projectionid))
    RAISERROR(60401, 16, 2, 'The specified projection is not marked as published');
    
    DECLARE @fid smallint, @eid smallint;
    SELECT @fid = f.ForecastID, @eid = f.EstimationID FROM Demographics.Forecast f
    INNER JOIN Demographics.ProjectionForecast pf ON f.ForecastID = pf.ForecastID
    WHERE pf.ProjectionID = @projectionid AND f.Class = 'Mortality'
    ;

    IF (@eid IS NULL)
    RAISERROR(60401, 16, 3, 'The specified projection does not contain catalog information for mortality');
    ;
    
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
  BEGIN TRY
    DECLARE @fy smallint;
    DECLARE @ocnt tinyint;
    DECLARE @history TABLE (
      OriginID tinyint, GenderID tinyint, Age tinyint, [Year] smallint, Mortality float
    );

    SELECT @fy = min([Year]) - 1 FROM Demographics.ForecastedMortality WHERE ForecastID = @fid
    ;
    
    INSERT @history(OriginID, GenderID, Age, [Year], Mortality)
    EXECUTE Demographics.uspGetEstimatedMortality @eid, DEFAULT, @fy, DEFAULT, DEFAULT, @ocnt output
    ;

    SELECT GenderID, Age, [Year], Mortality
    FROM (
      SELECT GenderID, Age, [Year], Mortality
      FROM @history
      WHERE OriginID = (CASE WHEN @ocnt > 1 THEN 1 ELSE 0 END)
    
      UNION ALL
      
      SELECT GenderID, Age, [Year], Estimate AS Mortality
      FROM Demographics.ForecastedMortality
      WHERE ForecastID = @fid AND OriginID = (CASE WHEN @ocnt > 1 THEN 4 ELSE 0 END) 
    ) result;
    
    RETURN 0;
  
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH
  
END
GO

