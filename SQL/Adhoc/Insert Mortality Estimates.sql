/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Adhoc/Insert Mortality Estimates.sql $
  $Revision: 1 $
  $Date: 12/19/06 11:38 $
  $Author: mls $
  
  SQLCMD script for inserting estimation results into the database. Estimations are cataloged using the
  stored procedure Demographics.uspInsertEstimation. This procedure returns a new surrogate primary key
  for the estimation, that is used when inserting the actual estimates data.

-----------------------------------------------------------------------------------------------------------*/
:setvar filepath F:\Data\Facts\Demographics\Dream\Estimations\Mortality\
:setvar estimation Baseline
:setvar revision R1

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


SET @class = 'Mortality';
SET @revision = NULL;
SET @replace = 0;

IF('$(estimation)' = 'Baseline')
BEGIN
	SET @title = 'Mortality estimation of 2006';
	SET @caption = 'Baseline';
	SET @firstyear = 1990;
	SET @lastyear = 2120;
	SET @lastsampleyear = 2005;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Baseline mortality estimation for the 2006 projection based on the Lee-Carter method.';
	SET @textda = 'Grundestimation af dødelighed til 2006 fremskrivningen baseret på Lee-Carter metoden.';
	SET @params = NULL;
END
IF('$(estimation)' = 'Alt65')
BEGIN
	SET @title = 'Reference mortality estimation of 2006';
	SET @caption = 'Alt65';
	SET @firstyear = 1965;
	SET @lastyear = 2120;
	SET @lastsampleyear = 2005;
	SET @isreadonly = 1;
	SET @ispublished = 1;
	SET @texten = 'Reference mortality estimation for the 2006 projection based on the Lee-Carter method on a longer sample.';
	SET @textda = 'Referenceestimation af dødelighed til 2006 fremskrivningen baseret på Lee-Carter metoden over en længere sample.';
	SET @params = NULL;
END

EXECUTE Demographics.uspInsertEstimation
@estimationid output, @revision output, @created output, @modified output, @replace,
@class, @title, @caption, @firstyear, @lastyear, @lastsampleyear,
@isreadonly, @ispublished, @texten, @textda, @params
;

INSERT Demographics.EstimatedMortality (EstimationID, OriginID, GenderID, Age, [Year], Estimate)
SELECT @estimationid, 0 AS OriginID, GenderID, Age, [Year], Estimate
FROM OPENROWSET (
 	BULK '$(filepath)$(estimation).$(revision).txt',
	FORMATFILE = '$(filepath)Mortality.format.xml',
	FIRSTROW = 2
) b
GO