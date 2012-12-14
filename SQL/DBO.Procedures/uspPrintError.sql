/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Procedures/uspPrintError.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : dbo.uspPrintError
  
  Purpose     : Prints a message (or passes it back to the client) describing an error that was caught in
                the catch section of a TRY-CATCH construct.

  Returns     : The procedure always return zero (0)

  Remarks     : Adapted from sample code in the Adventure Works database delivered with SQL Server 2005.

-------------------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE dbo.uspPrintError
AS
BEGIN

  SET NOCOUNT ON;
  
  PRINT 
    'Error ' + convert(varchar(5), ERROR_NUMBER()) + 
    ', Severity ' + convert(varchar(5), ERROR_SEVERITY()) +
    ', State ' + convert(varchar(5), ERROR_STATE()) +
    ', Procedure ' + isnull(ERROR_PROCEDURE(), '-') +
    ', Line ' + convert(varchar(5), ERROR_LINE())
  ;
  PRINT ERROR_MESSAGE(); 

END
GO