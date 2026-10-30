CREATE PROCEDURE [RDS].[Migrate_DimSchoolYears_PsStudents]
	@factTypeCode AS VARCHAR(50),
	@migrationType AS VARCHAR(50),
	@selectedSchoolYear AS INT,
	@isPriorYear AS BIT, 
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT
AS
BEGIN

	SELECT DISTINCT
		s.DimPsStudentId,
		pi.PersonId AS PersonId,
		sy.DimSchoolYearId,
		d.DimDateId,
		sy.SessionEndDate AS CountDate,
		sy.SchoolYear,
		sy.SessionBeginDate,
		sy.SessionEndDate
	FROM rds.DimPsStudents s
	JOIN dbo.PersonIdentifier pi 
		ON s.StudentIdentifierState = pi.Identifier 
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefPersonIdentificationSystem rpis ON pi.RefPersonIdentificationSystemId = rpis.RefPersonIdentificationSystemId
		AND rpis.Code = 'State'
	JOIN dbo.RefPersonIdentifierType rpit ON rpis.RefPersonIdentifierTypeId = rpit.RefPersonIdentifierTypeId 
		AND rpit.Code = '001075'
	JOIN dbo.PersonDetail pd 
		ON pi.PersonId = pd.PersonId
		AND ISNULL(s.FirstName, 'MISSING') = ISNULL(pd.FirstName, 'MISSING')
		AND ISNULL(s.MiddleName, 'MISSING') = ISNULL(pd.MiddleName, 'MISSING')
		AND ISNULL(s.LastName, 'MISSING') = ISNULL(pd.LastName, 'MISSING')
		AND ISNULL(s.BirthDate, '1900-01-01') = ISNULL(pd.Birthdate, '1900-01-01')
		AND s.RecordStartDateTime <= ISNULL(pd.RecordEndDateTime, GETDATE())
		AND ISNULL(s.RecordEndDateTime, GETDATE()) >= pd.RecordStartDateTime
		AND pi.DataCollectionId = pd.DataCollectionId
	LEFT JOIN dbo.RefSex rs
		ON pd.RefSexId = rs.RefSexId
		AND rs.Code = s.SexCode
	JOIN rds.DimSchoolYears sy  
		ON sy.DimSchoolYearId = @selectedSchoolYear
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR (s.RecordStartDateTime <= sy.SessionEndDate
				AND ISNULL(s.RecordEndDateTime, GETDATE()) >= sy.SessionBeginDate))
	JOIN rds.DimDates d
		ON sy.SessionEndDate = d.DateValue
	WHERE sy.DimSchoolYearId <> -1 
		AND s.DimPsStudentId <> -1

END