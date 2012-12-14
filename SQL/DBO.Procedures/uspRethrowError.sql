/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Procedures/uspRethrowError.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : dbo.uspPrintError
  
  Purpose     : Prints a message (or passes it back to the client) describing an error that was caught in
                the catch section of a TRY-CATCH construct.

  Returns     : The procedure always return zero (0)

  Remarks     : Adapted from sample code in the Adventure Works database delivered with SQL Server 2005.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('dbo.uspRethrowError', 'P') IS NOT NULL
DROP PROCEDURE dbo.uspRethrowError
GO

CREATE PROCEDURE dbo.uspRethrowError
AS
BEGIN

  SET NOCOUNT ON;
  
  DECLARE @msg nvarchar(4000);
  DECLARE @number int;
  DECLARE @severity int;
  DECLARE @state int;
  DECLARE @line int;
  DECLARE @proc nvarchar(128);
  
  SELECT @msg = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + ERROR_MESSAGE();
  SELECT
    @number = ERROR_NUMBER(),
    @severity = ERROR_SEVERITY(),
    @state = ERROR_STATE(),
    @proc = isnull(ERROR_PROCEDURE(), '-'),
    @line = ERROR_LINE()
  ;    
    
  RAISERROR(@msg, @severity, 1, @number, @severity, @state, @proc, @line);

END
GO