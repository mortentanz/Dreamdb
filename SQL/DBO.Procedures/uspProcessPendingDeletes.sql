/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Procedures/uspProcessPendingDeletes.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : dbo.uspProcessPendingDeletes
  
  Purpose     : Deletes any orphaned projection result in a cleanup batch. Implemented for ensuring better
								delete response times on Demographics.Projection than would have been attained using 
								declarative referential integrity (of foreign key relationships).

-----------------------------------------------------------------------------------------------------------*/
IF object_id('dbo.uspProcessPendingDeletes', 'P') IS NOT NULL
DROP PROCEDURE dbo.uspProcessPendingDeletes
GO

CREATE PROCEDURE dbo.uspProcessPendingDeletes AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM Demographics.Births
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection);
	
	DELETE FROM Demographics.Children
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)

	DELETE FROM Demographics.Deaths
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)

	DELETE FROM Demographics.Emigrants
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)

	DELETE FROM Demographics.Heirs
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)

	DELETE FROM Demographics.Immigrants
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)

	DELETE FROM Demographics.Mothers
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)
	
	DELETE FROM Demographics.[Population]
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)
	
	DELETE FROM Demographics.ResidenceDuration
	WHERE ProjectionID NOT IN (SELECT ProjectionID FROM Demographics.Projection)

END
GO