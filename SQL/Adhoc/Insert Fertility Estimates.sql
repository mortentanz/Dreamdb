/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Adhoc/Insert Fertility Estimates.sql $
  $Revision: 1 $
  $Date: 12/19/06 11:39 $
  $Author: mls $
  
  SQLCMD script for inserting estimation results into the database. Estimations are cataloged using the
  stored procedure Demographics.uspInsertEstimation. This procedure returns a new surrogate primary key
  for the estimation, that is used when inserting the actual estimates data.

-----------------------------------------------------------------------------------------------------------*/
:setvar filepath F:\Data\Facts\Demographics\Dream\Estimations\Fertility\
:setvar filename Fertility.1980.2005.2120.R1.txt
:setvar estimation Baseline

DECLARE @estimationid smallint;
DECLARE @revision tinyint;
DECLARE @created datetime;
DECLARE @modified datetime;
DECLARE @replace bit;

DECLARE @class varchar(20);
DECLARE @title varchar(100);
DECLARE @caption varchar(100);
DECLARE @firstyear smallint;
DECLARE @lastyear smallint;
DECLARE @lastsampleyear smallint;

DECLARE @isreadonly bit;
DECLARE @ispublished bit;
DECLARE @texten varchar(600);
DECLARE @textda varchar(600);
DECLARE @params xml;


SET @class = 'Fertility';
SET @revision = NULL;
SET @replace = 0;

IF('$(estimation)' = 'Baseline')
BEGIN
	SET @title = 'Fertility estimation of 2006';
	SET @caption = NULL;
	SET @firstyear = 1980;
	SET @lastyear = 2120;
	SET @lastsampleyear = 2005;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Fertility estimation based on the cubic spline method.';
	SET @textda = 'Fertilitet estimeret på basis af cubic spline metoden.';
	SET @params = NULL;
END


EXECUTE Demographics.uspInsertEstimation
@estimationid output, @revision output, @created output, @modified output, @replace,
@class, @title, @caption, @firstyear, @lastyear, @lastsampleyear,
@isreadonly, @ispublished, @texten, @textda, @params
;

INSERT Demographics.EstimatedFertility (EstimationID, OriginID, Age, [Year], Estimate)
SELECT @estimationid, OriginID, Age, [Year], Estimate
FROM OPENROWSET (
 	BULK '$(filepath)$(filename)',  
	FORMATFILE = '$(filepath)Fertility.format.xml',
	FIRSTROW = 2
) b
