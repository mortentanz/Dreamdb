/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Adhoc/Insert Immigration Estimates.sql $
  $Revision: 1 $
  $Date: 12/19/06 11:38 $
  $Author: mls $
  
  SQLCMD script for inserting estimation results into the database. Estimations are cataloged using the
  stored procedure Demographics.uspInsertEstimation. This procedure returns a new surrogate primary key
  for the estimation, that is used when inserting the actual estimates data.

-----------------------------------------------------------------------------------------------------------*/
:setvar filepath F:\Data\Facts\Demographics\Dream\Estimations\Immigration\
:setvar estimation Baseline
--:setvar estimation SHOCK_5000
--:setvar estimation SHOCK_5000_IL
--:setvar estimation SHOCK_5000_IM

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


SET @class = 'Immigration';
SET @revision = NULL;
SET @replace = 0;

IF '$(estimation)' = 'Baseline'
BEGIN
	SET @title = 'Baseline 2006';
	SET @caption = 'Baseline';
	SET @firstyear = 2006;
	SET @lastyear = 2106;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Assumed immigration levels in baseline projection as of 2006.';
	SET @textda = 'Antagne niveauer for indvandring i 2006 fremskrivningen.';
	SET @params = NULL;
END
IF '$(estimation)' = '5000_I'
BEGIN
	SET @title = '5000 additional immigrants than in 2006 projection';
	SET @caption = '$(estimation)';
	SET @firstyear = 2006;
	SET @lastyear = 2106;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Shock to 2006 baseline assuming a level increase of 5000 immigrants.'
	SET @textda = 'Stød til indvandringen i 2006 fremskrivningen på yderligere 5000 indvandrere.'
	SET @params = NULL;
END

IF '$(estimation)' = '5000_IL'
BEGIN
	SET @title = '5000 additional immigrants from less developed countries than in 2006 projection';
	SET @caption = '$(estimation)';
	SET @firstyear = 2006;
	SET @lastyear = 2106;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Shock to 2006 baseline assuming a level increase of 5000 immigrants from less developed countries.'
	SET @textda = 'Stød til indvandringen i 2006 fremskrivningen på yderligere 5000 indvandrere fra mindre udviklede lande.'
	SET @params = NULL;
END

IF '$(estimation)' = '5000_IM'
BEGIN
	SET @title = '5000 additional immigrants from more developed countries than in 2006 projection';
	SET @caption = '$(estimation)';
	SET @firstyear = 2006;
	SET @lastyear = 2106;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Shock to 2006 baseline assuming a level increase of 5000 immigrants from less developed countries.'
	SET @textda = 'Stød til indvandringen i 2006 fremskrivningen på yderligere 5000 indvandrere fra mere udviklede lande.'
	SET @params = NULL;
END

SET @lastsampleyear = NULL;
EXECUTE Demographics.uspInsertEstimation
@estimationid output, @revision output, @created output, @modified output, @replace,
@class, @title, @caption, @firstyear, @lastyear, @lastsampleyear,
@isreadonly, @ispublished, @texten, @textda, @params
;

INSERT INTO Demographics.EstimatedImmigration (EstimationID, OriginID, GenderID, Age, [Year], Estimate)
SELECT @estimationid, OriginID = OriginID + 1, GenderID, Age, [Year], Estimate
FROM OPENROWSET ( 
	BULK '$(filepath)$(estimation).txt',  
	FORMATFILE = '$(filepath)Immigration.format.xml',
	FIRSTROW = 2
) b
GO