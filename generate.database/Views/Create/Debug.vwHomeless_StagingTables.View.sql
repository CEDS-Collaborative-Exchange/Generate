CREATE VIEW [debug].[vwHomeless_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.Sex
		, enrollment.GradeLevel
		, enrollment.BirthDate

		, hm.HomelessnessStatus
		, hm.Homelessness_StatusStartDate
		, hm.Homelessness_StatusEndDate
		, hm.HomelessUnaccompaniedYouth

		, hmnr.HomelessNightTimeResidence
		, hmnr.HomelessNightTimeResidence_StartDate
		, hmnr.HomelessNightTimeResidence_EndDate

		, idea.ProgramParticipationBeginDate		AS IDEAProgramParticipationBeginDate
		, idea.ProgramParticipationEndDate			AS IDEAProgramParticipationEndDate
		
		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate

		, mig.MigrantStatus
		, mig.Migrant_StatusStartDate
		, mig.Migrant_StatusEndDate

		, race.RaceType
		, race.RecordStartDateTime					AS RaceStartDate
		, race.RecordEndDateTime					AS RaceEndDate

	FROM Staging.K12Enrollment								enrollment		

	INNER JOIN Staging.PersonStatus							hm
			ON		enrollment.StudentIdentifierState						=	hm.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(hm.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(hm.SchoolIdentifierSea, '')
			AND		hm.Homelessness_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							hmnr
			ON		enrollment.StudentIdentifierState						=	hmnr.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(hmnr.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(hmnr.SchoolIdentifierSea, '')
			AND		hmnr.HomelessNightTimeResidence_StartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
			ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '') 
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
			AND		idea.ProgramParticipationBeginDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.K12PersonRace							race
			ON		enrollment.SchoolYear									=	race.SchoolYear
			AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
			AND		race.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
			AND		el.EnglishLearner_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							mig
			ON		enrollment.StudentIdentifierState						=	mig.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(mig.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(mig.SchoolIdentifierSea, '')
			AND		mig.Migrant_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())


	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	AND hm.HomelessnessStatus = 1
	--AND Students.StudentIdentifierState = '12345678'	
	--AND LEAs.LeaIdentifierSeaAccountability = '123'
	--AND Schools.SchoolIdentifierSea = '456'
	--AND [RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) = '12'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastOrSurname = ''
	--AND enrollment.BirthDate = ''
	--AND idea.ProgramParticipationBeginDate = ''
	--AND idea.ProgramParticipationEndDate = ''
	--AND el.EnglishLearnerStatus = ''	--0 or 1
	--AND el.EnglishLearner_StatusStartDate = ''
	--AND el.EnglishLearner_StatusEndDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
	--AND hm.HomelessnessStatus = ''
	--AND hm.Homelessness_StatusStartDate = ''
	--AND hm.Homelessness_StatusEndDate = ''
	--AND hm.HomelessUnaccompaniedYouth = ''
	--AND hmnr.HomelessNightTimeResidence = ''
	--AND hmnr.HomelessNightTimeResidence_StartDate = ''
	--AND hmnr.HomelessNightTimeResidence_EndDate = ''
	--AND mig.MigrantStatus = ''
	--AND mig.Migrant_StatusStartDate = ''
	--AND mig.Migrant_StatusEndDate = ''