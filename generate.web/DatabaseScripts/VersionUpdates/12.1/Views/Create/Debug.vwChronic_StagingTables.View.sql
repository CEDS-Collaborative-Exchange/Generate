CREATE VIEW [debug].[vwChronic_StagingTables] 
AS
	SELECT DISTINCT	
		enrollment.SchoolYear
		, enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.Sex
		, enrollment.HispanicLatinoEthnicity
		, enrollment.NumberOfSchoolDays
		, enrollment.NumberOfDaysAbsent
		, enrollment.AttendanceRate
		
		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate
				
		, ecoDis.EconomicDisadvantageStatus
		, ecoDis.EconomicDisadvantage_StatusStartDate
		, ecoDis.EconomicDisadvantage_StatusEndDate
				
		, homeless.HomelessnessStatus
		, homeless.Homelessness_StatusStartDate
		, homeless.Homelessness_StatusEndDate
				
		, sec504.Section504Status
				
		, idea.IDEAIndicator
		, idea.ProgramParticipationBeginDate
		, idea.ProgramParticipationEndDate
				
		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment
	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
			AND		ISNULL(el.EnglishLearner_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.PersonStatus							ecoDis
			ON		enrollment.StudentIdentifierState						=	ecoDis.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ecoDis.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ecoDis.SchoolIdentifierSea, '')
			AND		ISNULL(ecoDis.EconomicDisadvantage_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.PersonStatus							homeless
			ON		enrollment.StudentIdentifierState						=	homeless.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(homeless.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(homeless.SchoolIdentifierSea, '')
			AND		ISNULL(homeless.Homelessness_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.Disability							sec504
			ON		enrollment.SchoolYear									=	sec504.SchoolYear
			AND		enrollment.StudentIdentifierState						=	sec504.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(sec504.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(sec504.SchoolIdentifierSea, '')
			AND		ISNULL(sec504.Disability_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
			ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
			AND		ISNULL(idea.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.K12PersonRace							race
			ON		enrollment.SchoolYear									=	race.SchoolYear
			AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
			AND		ISNULL(race.RecordEndDateTime, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	WHERE 1 = 1
	AND	
		CAST((CASE WHEN enrollment.NumberOfSchoolDays = '0' THEN 0
				WHEN enrollment.NumberOfDaysAbsent = '0' THEN 1
				ELSE CAST(enrollment.NumberOfSchoolDays - enrollment.NumberOfDaysAbsent  AS decimal(5,2)) / CAST(enrollment.NumberOfSchoolDays AS decimal(5,2))
			END) AS decimal(5,4)) <= 0.9



