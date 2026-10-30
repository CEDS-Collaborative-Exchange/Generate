CREATE PROCEDURE [RDS].[Migrate_DimDates_PsStudents]
	  @selectedDate AS DATETIME = NULL
	, @dimSchoolYearId AS SMALLINT 
	, @dataCollectionId AS INT = NULL
AS
BEGIN

	SELECT
		  s.DimPsStudentId
		, pi.PersonId AS PersonId
		, sy.DimSchoolYearId
		, ISNULL(d.DimDateId, -1) AS DimCountDateId
		, ISNULL(@selectedDate, sy.SessionEndDate) AS CountDate
		, sy.SchoolYear
		, sy.SessionBeginDate
		, sy.SessionEndDate
		, s.RecordStartDateTime
		, s.RecordEndDateTime
	FROM rds.DimPsStudents s
	JOIN dbo.PersonIdentifier pi 
		ON s.StudentIdentifierState = pi.Identifier
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefPersonIdentificationSystem rpis 
		ON pi.RefPersonIdentificationSystemId = rpis.RefPersonIdentificationSystemId
		AND rpis.Code = 'State'
	JOIN dbo.RefPersonIdentifierType rpit 
		ON rpis.RefPersonIdentifierTypeId = rpit.RefPersonIdentifierTypeId 
		AND rpit.Code = '001075'
	JOIN dbo.PersonDetail pd 
		ON ISNULL(s.FirstName, '') = ISNULL(pd.FirstName, '') 
		AND ISNULL(s.LastName, '') = ISNULL(pd.LastName, '') 
		AND ISNULL(s.MiddleName, '') = ISNULL(pd.MiddleName, '') 
		AND ISNULL(s.BirthDate, '') = ISNULL(pd.Birthdate, '') 
		AND pi.PersonId = pd.PersonId
	LEFT JOIN dbo.RefSex rs
		ON pd.RefSexId = rs.RefSexId
		AND rs.Code = s.SexCode
	JOIN rds.DimSchoolYears sy
		ON sy.DimSchoolYearId = @dimSchoolYearId
	LEFT JOIN rds.DimDates d
		ON d.DateValue = ISNULL(@selectedDate, sy.SessionEndDate)
	WHERE s.DimPsStudentId <> -1
		AND (
				(@selectedDate IS NOT NULL 
					AND @selectedDate BETWEEN s.RecordStartDateTime AND ISNULL(s.RecordEndDateTime, GETDATE()))
			OR
				(@selectedDate IS NULL
					AND s.RecordStartDateTime <= sy.SessionEndDate
					AND ISNULL(s.RecordEndDateTime, GETDATE()) >= sy.SessionBeginDate)
			)

END