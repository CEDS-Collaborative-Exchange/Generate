CREATE VIEW [debug].[vwGraduatesCompleters_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.Sex
		, enrollment.HispanicLatinoEthnicity
		, enrollment.GradeLevel
		, enrollment.HighSchoolDiplomaType

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate

		, ecoDis.EconomicDisadvantageStatus
		, ecoDis.EconomicDisadvantage_StatusStartDate
		, ecoDis.EconomicDisadvantage_StatusEndDate
				
		, homeless.HomelessnessStatus
		, homeless.Homelessness_StatusStartDate
		, homeless.Homelessness_StatusEndDate
				
		, migrant.MigrantStatus
		, migrant.ProgramParticipationStartDate
		, migrant.ProgramParticipationExitDate
				
		, idea.IDEAIndicator
		, idea.ProgramParticipationBeginDate
		, idea.ProgramParticipationEndDate
				
		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment
	LEFT JOIN Staging.Migrant								migrant
		ON		enrollment.StudentIdentifierState						=	migrant.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(migrant.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(migrant.SchoolIdentifierSea, '')
		AND		ISNULL(migrant.ProgramParticipationExitDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

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
	AND ISNULL(enrollment.HighSchoolDiplomaType, '') <> ''
