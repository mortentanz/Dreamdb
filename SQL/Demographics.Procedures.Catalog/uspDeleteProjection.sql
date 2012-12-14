/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspDeleteProjection.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspDeleteProjection
  
  Purpose     : Deletes a projection from the database.
                
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspDeleteProjection', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspDeleteProjection
GO

CREATE PROCEDURE Demographics.uspDeleteProjection (
  @projectionid smallint,
  @unconditional bit = 0
) 
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY
    IF (@projectionid IS NULL) RAISERROR(80005, 16, 1, '@projectionid');
    IF (NOT EXISTS (SELECT * FROM Demographics.Projection WHERE ProjectionID = @projectionid)) 
      RAISERROR(60105, 16, 2);
    
    DECLARE @r bit;
    DECLARE @p bit;
    SELECT @r = IsReadOnly, @p = IsPublished FROM Demographics.Projection WHERE ProjectionID = @projectionid 
    
    IF (@p = 1) RAISERROR(60109, 16, 1, 'The projection is published');
    IF (@r = 1 AND @unconditional = 0) RAISERROR(60109, 16, 2, 'The projection is readonly');
  
    DELETE FROM Demographics.Projection
    WHERE ProjectionID = @projectionid;
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