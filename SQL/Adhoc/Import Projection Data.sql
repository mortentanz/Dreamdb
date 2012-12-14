/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/Adhoc/Import Projection Data.sql $
  $Revision: 1 $
  $Date: 12/19/06 14:40 $
  $Author: mls $
  
  SQLCMD script for importing projection results from Dreamdev into the production database. The SQLCMD 
  script "Import Projection Catalog" should be executed before this script!

-----------------------------------------------------------------------------------------------------------*/
BEGIN TRY
	DROP TABLE #projectionmap
END TRY
BEGIN CATCH
	PRINT 'No temporary table required drop.'
END CATCH

SELECT 
	d.ProjectionID AS DevId, 
	p.ProjectionID,
	d.Title, d.Caption, d.Revision
INTO #projectionmap	
FROM Dreamdev.Demographics.Projection d
INNER JOIN Demographics.Projection p ON (p.Title = d.Title)

INSERT Demographics.Births (ProjectionID, ChildOriginID, ChildGenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.ChildOriginID, d.ChildGenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.Births d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.Children (ProjectionID, OriginID, GenderID, Age, MotherAge, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.GenderID, d.Age, d.MotherAge, d.[Year], d.Persons
FROM Dreamdev.Demographics.Children d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.Deaths (ProjectionID, OriginID, GenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.GenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.Deaths d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.Emigrants (ProjectionID, OriginID, GenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.GenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.Emigrants d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.Heirs (ProjectionID, GenderID, Age, MotherAge, [Year], Persons)
SELECT m.ProjectionID, d.GenderID, d.Age, d.MotherAge, d.[Year], d.Persons
FROM Dreamdev.Demographics.Heirs d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.Immigrants (ProjectionID, OriginID, GenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.GenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.Immigrants d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.Mothers (ProjectionID, OriginID, ChildGenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.ChildGenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.Mothers d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.[Population] (ProjectionID, OriginID, GenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.GenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.[Population] d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

INSERT Demographics.ResidenceDuration (ProjectionID, OriginID, DurationID, GenderID, Age, [Year], Persons)
SELECT m.ProjectionID, d.OriginID, d.DurationID, d.GenderID, d.Age, d.[Year], d.Persons
FROM Dreamdev.Demographics.ResidenceDuration d
INNER JOIN #projectionmap m ON m.DevID = d.ProjectionID

BEGIN TRY
	DROP TABLE #projectionmap
END TRY
BEGIN CATCH
	PRINT 'No temporary table required drop.'
END CATCH
GO