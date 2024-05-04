CREATE VIEW [Debug].[vwAssessment_StagingTables] 
AS
	SELECT		DISTINCT 
				enrollment.StudentIdentifierState
				,enrollment.LEAIdentifierSeaAccountability
				,enrollment.SchoolIdentifierSea
				,enrollment.FirstName
				,enrollment.LastOrSurname
				,enrollment.MiddleName
				,enrollment.Sex
				,enrollment.BirthDate

				,assess.AssessmentTitle									AS 'Assessment-AssessmentTitle'
				,assess.AssessmentIdentifier							AS 'Assessment-AssessmentIdentifier'
				,assess.AssessmentAdministrationStartDate				AS 'Assessment-AssessmentAdministrationStartDate'
				,assess.AssessmentAdministrationFinishDate				AS 'Assessment-AssessmentAdministrationFinishDate'
				,assess.AssessmentAcademicSubject						AS 'Assessment-AssessmentAcademicSubject'
				,assess.AssessmentPurpose								AS 'Assessment-AssessmentPurpose'
				,assess.AssessmentPerformanceLevelIdentifier			AS 'Assessment-AssessmentPerformanceLevelIdentifier'
				,assess.AssessmentTypeAdministered						AS 'Assessment-AssessmentTypeAdministered'
				,assess.AssessmentTypeAdministeredToEnglishLearners		AS 'Assessment-AssessmentTypeAdministeredToEnglishLearners'

				,results.GradeLevelWhenAssessed							AS 'Results-GradeLevelWhenAssessed'
				,results.AssessmentAdministrationStartDate				AS 'Results-AssessmentAdministrationStartDate'
				,results.AssessmentIdentifier							AS 'Results-AssessmentIdentifier'
				,results.AssessmentPerformanceLevelIdentifier			AS 'Results-AssessmentPerformanceLevelIdentifier'
				,results.AssessmentRegistrationParticipationIndicator	AS 'Results-AssessmentRegistrationParticipationIndicator'
				,results.AssessmentRegistrationReasonNotCompleting		AS 'Results-AssessmentRegistrationReasonNotCompleting'
				,results.AssessmentRegistrationReasonNotTested			AS 'Results-AssessmentRegistrationReasonNotTested'

				,race.RaceType
				,race.RecordStartDateTime
				,race.RecordEndDateTime

				,programparticipation.IDEAIndicator
				,programparticipation.ProgramParticipationBeginDate		AS IDEAProgramParticipationBeginDate
				,programparticipation.ProgramParticipationEndDate		AS IDEAProgramParticipationEndDate
				
				,el.EnglishLearnerStatus
				,el.EnglishLearner_StatusStartDate
				,el.EnglishLearner_StatusEndDate

				,econ.EconomicDisadvantageStatus
				,econ.EconomicDisadvantage_StatusStartDate
				,econ.EconomicDisadvantage_StatusEndDate

				,migr.MigrantStatus
				,migr.Migrant_StatusStartDate
				,migr.Migrant_StatusEndDate

				,home.HomelessnessStatus
				,home.Homelessness_StatusStartDate
				,home.Homelessness_StatusEndDate

				,foster.ProgramType_FosterCare
				,foster.FosterCare_ProgramParticipationStartDate
				,foster.FosterCare_ProgramParticipationEndDate

				,mil.MilitaryConnectedStudentIndicator
				,mil.MilitaryConnected_StatusStartDate
				,mil.MilitaryConnected_StatusEndDate

	FROM Staging.K12Enrollment								enrollment		

	INNER JOIN Staging.AssessmentResult						results
			ON		enrollment.StudentIdentifierState						=	results.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(results.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(results.SchoolIdentifierSea, '')

	LEFT JOIN Staging.Assessment							assess
			ON		results.AssessmentIdentifier								= assess.AssessmentIdentifier
			AND		ISNULL(results.AssessmentTitle, '')							= ISNULL(assess.AssessmentTitle, '')
			AND		ISNULL(results.AssessmentAcademicSubject, '')				= ISNULL(assess.AssessmentAcademicSubject, '') 
			AND		ISNULL(results.AssessmentPerformanceLevelIdentifier, '')	= ISNULL(assess.AssessmentPerformanceLevelIdentifier, '') 

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	programparticipation
			ON		enrollment.StudentIdentifierState						=	programparticipation.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(programparticipation.LEAIdentifierSeaAccountability, '') 
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(programparticipation.SchoolIdentifierSea, '')
			AND		programparticipation.ProgramParticipationBeginDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.IdeaDisabilityType					ideaDisability
			ON		enrollment.StudentIdentifierState						=	ideaDisability.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ideaDisability.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ideaDisability.SchoolIdentifierSea, '')
			AND 	ideaDisability.IsPrimaryDisability = 1
			AND		ideaDisability.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

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

	LEFT JOIN Staging.PersonStatus							econ
			ON		enrollment.StudentIdentifierState						=	econ.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(econ.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(econ.SchoolIdentifierSea, '')
			AND		econ.EconomicDisadvantage_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							migr
			ON		enrollment.StudentIdentifierState						=	migr.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(migr.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(migr.SchoolIdentifierSea, '')
			AND		migr.Migrant_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							home
			ON		enrollment.StudentIdentifierState						=	home.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(home.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(home.SchoolIdentifierSea, '')
			AND		home.Homelessness_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							foster
			ON		enrollment.StudentIdentifierState						=	foster.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(foster.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(foster.SchoolIdentifierSea, '')
			AND		foster.FosterCare_ProgramParticipationStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							mil
			ON		enrollment.StudentIdentifierState						=	mil.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(mil.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(mil.SchoolIdentifierSea, '')
			AND		mil.MilitaryConnected_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	AND assess.AssessmentAdministrationStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())
	--AND enrollment.StudentIdentifierState = '12345678'	
	--AND enrollment.LeaIdentifierSeaAccountability = '123'
	--AND enrollment.SchoolIdentifierSea = '456'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastOrSurname = ''
	--AND enrollment.BirthDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
	--AND programparticipation.ProgramParticipationBeginDate = ''
	--AND programparticipation.ProgramParticipationEndDate = ''
	--AND el.EnglishLearnerStatus = ''	--0 or 1
	--AND el.EnglishLearner_StatusStartDate = ''
	--AND el.EnglishLearner_StatusEndDate = ''
	--AND econ.EconomicDisadvantageStatus = ''	--0 or 1
	--AND econ.EconomicDisadvantage_StatusStartDate = ''
	--AND econ.EconomicDisadvantage_StatusEndDate = ''
	--AND migr.MigrantStatus = ''	--0 or 1
	--AND migr.Migrant_StatusStartDate = ''
	--AND migr.Migrant_StatusEndDate = ''
	--AND home.HomelessnessStatus = ''	--0 or 1
	--AND home.Homelessness_StatusStartDate = ''
	--AND home.Homelessness_StatusEndDate = ''
	--AND foster.ProgramType_FosterCare = ''	--0 or 1
	--AND foster.FosterCare_ProgramParticipationStartDate = ''
	--AND foster.FosterCare_ProgramParticipationEndDate = ''
	--AND mil.MilitaryConnectedStudentIndicator = ''	--Unknown, ActiveDuty, NationalGuardOrReserve, NotMilitaryConnected
	--AND mil.MilitaryConnected_StatusStartDate = ''
	--AND mil.MilitaryConnected_StatusEndDate = ''
	