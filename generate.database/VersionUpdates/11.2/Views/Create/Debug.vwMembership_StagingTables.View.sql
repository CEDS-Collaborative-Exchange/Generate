CREATE VIEW [debug].[vwMembership_StagingTables] 
AS
/*  This is used for both Membership and Free and Reduced Lunch */
	SELECT DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.Sex
		, enrollment.GradeLevel
		, enrollment.BirthDate
		, enrollment.EnrollmentEntryDate
		, enrollment.EnrollmentExitDate

		, race.RaceType
		, race.RecordStartDateTime					AS RaceStartDate
		, race.RecordEndDateTime					AS RaceEndDate

		, pStatus.EligibilityStatusForSchoolFoodServicePrograms   --FRL
		, pStatus.NationalSchoolLunchProgramDirectCertificationIndicator  --FRL

	FROM Staging.K12Enrollment									enrollment          

	LEFT JOIN Staging.K12PersonRace							race
			ON		enrollment.SchoolYear									=	race.SchoolYear
			AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
			AND		race.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus 							pStatus
			ON      enrollment.StudentIdentifierState                     	=	pStatus.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(pStatus.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(pStatus.SchoolIdentifierSea, '')
		
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND enrollment.StudentIdentifierState  = '12345678'     
	--AND enrollment.LEAIdentifierSeaAccountability = '073606000'
	--AND enrollment.SchoolIdentifierSea = '073606460'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastOrSurname = ''
	--AND enrollment.BirthDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
	--AND Pstatus.EligibilityStatusForSchoolFoodServicePrograms = ''
	--AND Pstatus.NationalSchoolLunchProgramDirectCertificationIndicator = ''
