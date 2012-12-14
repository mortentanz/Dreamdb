/*-----------------------------------------------------------------------------------------------------------
  $Archive: /SQL.root/SQL/ETL.Procedures/uspExtractRAS.sql $
  $Revision: 1 $
  $Date: 12/21/06 16:00 $
  $Author: mls $

  Procedure   : ETL.uspExtractRAS
  
  Purpose     : Extracts RAS data for a specified dataset, data and status revision for use in ETL 
								applications.
                
-----------------------------------------------------------------------------------------------------------*/
IF object_id('ETL.uspExtractRAS', 'P') IS NOT NULL
DROP PROCEDURE ETL.uspExtractRAS
GO

CREATE PROCEDURE ETL.uspExtractRAS (
	@setname varchar(30), 
	@datarevision char(1),
	@statusrevision tinyint
) AS 
BEGIN	

	SET NOCOUNT ON;

	DECLARE @maxduration smallint;

	SELECT @maxduration = max(r.DurationID)
	FROM Socioeconomics.RAS r
	INNER JOIN Socioeconomics.RASCatalog rc ON r.DatasetID = rc.DatasetID
	WHERE rc.Setname = @setname AND rc.DataRevision = @datarevision AND r.DurationID < 32767
	;

	WITH bystatus AS (
		SELECT 
			s.StatusID, r.EducationID, r.RegistrationID, r.DurationID, r.OriginID, r.GenderID, r.Age, r.[Year],
			sum(convert(int, sd.Weight * r.Persons)) AS Persons
		FROM Socioeconomics.RAS r
		INNER JOIN Socioeconomics.RASCatalog rc ON r.DatasetID = rc.DatasetID
		INNER JOIN Socioeconomics.StatusDefinition sd ON r.NodeID = sd.NodeID
		INNER JOIN Socioeconomics.Status s ON s.StatusID = sd.StatusID
		WHERE rc.Setname = @setname AND rc.DataRevision = @datarevision AND s.Revision = @statusrevision
		GROUP BY 
			s.StatusID, r.EducationID, r.RegistrationID, r.DurationID, r.OriginID, r.GenderID, r.Age, r.[Year]
		HAVING sum(convert(int, sd.Weight * r.Persons)) <> 0
	)

	SELECT 
		StatusID, EducationID, RegistrationID, 
		DurationID, @maxduration AS MaxDuration, OriginID, GenderID, Age, [Year], Persons
	FROM (

			SELECT StatusID, EducationID, RegistrationID, DurationID, OriginID, GenderID, Age, [Year], Persons
			FROM bystatus WHERE DurationID < @maxduration
			
			UNION ALL

			SELECT 
				StatusID, EducationID, RegistrationID, 
				@maxduration AS DurationID, OriginID, GenderID, Age, [Year], sum(Persons) AS Persons
			FROM bystatus
			WHERE DurationID >= @maxduration
			GROUP BY StatusID, EducationID, RegistrationID, OriginID, GenderID, Age, [Year]

	) as fixed
	ORDER BY [Year], StatusID, EducationID, RegistrationID, DurationID, OriginID, GenderID, Age

END
GO