/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/DBO.Procedures/uspLogError.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : dbo.uspLogError
  
  Purpose     : Prints a message (or passes it back to the client) describing an error that was caught in
                the catch section of a TRY-CATCH construct.

  Returns     : The procedure returns zero (0) on normal completion or -1 in the event of an unknown error
                preventing the addition of an error log entry.

  Params      : @errorlogid (output)
                Used for obtaining the identifier for the error log entry, a value of 0 indicates that
                the error was not logged successfully.

  Remarks     : Adapted from sample code in the Adventure Works database delivered with SQL Server 2005.

-------------------------------------------------------------------------------------------------------------*/
IF object_id('dbo.uspLogError', 'P') IS NOT NULL
DROP PROCEDURE dbo.uspLogError
GO

CREATE PROCEDURE dbo.uspLogError (
  @errorlogid int = 0 OUTPUT
)
AS
BEGIN

  SET NOCOUNT ON;
  
  SET @errorlogid = 0;
  
  BEGIN TRY
  
    IF ERROR_NUMBER() IS NULL
    RETURN;
  
    IF XACT_STATE() = -1
    BEGIN
      PRINT 'Cannot log error since the current transaction is in an uncommitable state. Rollback the'
          + ' transaction before executing uspLogError in order to successfully log error information.';
      RETURN;
    END

    INSERT dbo.ErrorLog 
    (
      UserName, LoginName, ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    VALUES
    (
      convert(sysname, CURRENT_USER),
      convert(sysname, SYSTEM_USER),
      ERROR_NUMBER(),
      ERROR_SEVERITY(),
      ERROR_STATE(),
      ERROR_PROCEDURE(),
      ERROR_LINE(),
      ERROR_MESSAGE(),
    );
  
    SET @errorlogid = @@identity;
  
  END TRY
  BEGIN CATCH
    PRINT 'An error occurred in stored procedure uspLogError: ';
    EXECUTE dbo.uspPrintError;
    RETURN -1;
  END CATCH
  
END
GO
