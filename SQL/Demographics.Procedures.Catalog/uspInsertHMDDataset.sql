/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Demographics.Procedures.Catalog/uspInsertHMDDataset.sql $
  $Revision: 1 $
  $Date: 12/18/06 15:46 $
  $Author: mls $

  Procedure   : Demographics.uspInsertHMDDataset
  
  Purpose     : Inserts identification of a HMD dataset in the HMDCatalog and returns a dataset id.                 
              
  Returns     : The procedure return zero (0) if successful and a non-zero value otherwise

-----------------------------------------------------------------------------------------------------------*/
IF object_id(N'Demographics.uspInsertHMDDataset', N'P') IS NOT NULL
DROP PROCEDURE Demographics.uspInsertHMDDataset
GO

CREATE PROCEDURE Demographics.uspInsertHMDDataset (
  @datasetid smallint = 0 output,
  @setname varchar(30),
  @country varchar(20),
  @gender varchar(8),
  @modified datetime,
  @version varchar(20),
  @firstyear smallint,
  @lastyear smallint,
  @dateloaded datetime = null,
  @texten varchar(400) = null,
  @textda varchar(400) = null
)
AS
BEGIN
  
  BEGIN TRY
    IF (@setname IS NULL) RAISERROR(80005, 16, 1, '@setname');
    IF (@country IS NULL) RAISERROR(80005, 16, 2, '@country');
    IF (@gender IS NULL) RAISERROR(80005, 16, 3, '@gender');
    IF (@modified IS NULL) RAISERROR(80005, 16, 4, '@modified');
    IF (@version IS NULL) RAISERROR(80005, 16, 5, '@version');
    IF (@firstyear IS NULL) RAISERROR(80005, 16, 6, '@firstyear');
    IF (@lastyear IS NULL) RAISERROR(80005, 16, 7, '@lastyear');
    SET @dateloaded = isnull(@dateloaded, getdate());
    SET @texten = isnull(@texten, 'Description is pending.');
    SET @textda = isnull(@textda, 'Beskrivelse mangler.');
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN -1;
  END CATCH

  BEGIN TRY
    INSERT Demographics.HMDCatalog VALUES (
      @setname, @country, @gender, @modified, @version, @firstyear, @lastyear, @dateloaded, @texten, @textda
    );
    SET @datasetid = scope_identity();
    RETURN 0;
  END TRY
  BEGIN CATCH
    EXECUTE dbo.uspLogError;
    EXECUTE dbo.uspRethrowError;
    RETURN 1;
  END CATCH

END
GO