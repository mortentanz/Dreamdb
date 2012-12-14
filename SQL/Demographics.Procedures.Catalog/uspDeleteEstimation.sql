/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspDeleteEstimation.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspDeleteEstimation
  
  Purpose     : Deletes an estimation from the database.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspDeleteEstimation', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspDeleteEstimation
GO

CREATE PROCEDURE Demographics.uspDeleteEstimation (
  @estimationid smallint,
  @unconditional bit = 0
) 
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

    IF (@estimationid IS NULL) RAISERROR(80005, 16, 1, '@estimationid');
    IF (NOT EXISTS (SELECT * FROM Demographics.Estimation WHERE EstimationID = @estimationid)) 
    RAISERROR(60309, 16, 2);
    
    DECLARE @r bit;
    DECLARE @p bit;
    SELECT @r = IsReadOnly, @p = IsPublished FROM Demographics.Estimation WHERE EstimationID = @estimationid
    
    IF (@p = 1) RAISERROR(60309, 16, 1, 'The estimation is marked published');
    IF (@r = 1 AND @unconditional = 0) RAISERROR(60309, 16, 2, 'The estimation is marked readonly');
  
    DELETE FROM Demographics.Estimation
    WHERE EstimationID = @estimationid;
    RETURN 0;

  END TRY
  BEGIN CATCH
    IF @@trancount > 0 ROLLBACK;
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN (CASE WHEN ERROR_NUMBER() IN (80005, 60105, 60109) THEN -1 ELSE 1 END);
  END CATCH

END
GO