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
				,enrollment.SchoolYear

				,assess.AssessmentTitle									AS 'Assessment-AssessmentTitle'
				,assess.AssessmentIdentifier							AS 'Assessment-AssessmentIdentifier'
				,assess.AssessmentAcademicSubject						AS 'Assessment-AssessmentAcademicSubject'
				,assess.AssessmentAdministrationFinishDate				AS 'Assessment-AssessmentAdministrationFinishDate'
				,assess.AssessmentType									AS 'Assessment-AssessmentType'		
				,assess.AssessmentPurpose								AS 'Assessment-AssessmentPurpose'
				,assess.AssessmentPerformanceLevelIdentifier			AS 'Assessment-AssessmentPerformanceLevelIdentifier'
				,assess.AssessmentTypeAdministered						AS 'Assessment-AssessmentTypeAdministered'
				,assess.AssessmentTypeAdministeredToEnglishLearners		AS 'Assessment-AssessmentTypeAdministeredToEnglishLearners'

				,results.AssessmentTypeAdministered						AS 'Results-AssessmentTypeAdministered'
				,results.GradeLevelWhenAssessed							AS 'Results-GradeLevelWhenAssessed'
				,results.AssessmentAdministrationStartDate				AS 'Results-AssessmentAdministrationStartDate'
				,results.AssessmentAcademicSubject						AS 'Results-AssessmentAcademicSubject'
				,results.AssessmentIdentifier							AS 'Results-AssessmentIdentifier'
				,results.AssessmentPerformanceLevelIdentifier			AS 'Results-AssessmentPerformanceLevelIdentifier'
				,results.AssessmentRegistrationParticipationIndicator	AS 'Results-AssessmentRegistrationParticipationIndicator'
				,results.AssessmentRegistrationReasonNotCompleting		AS 'Results-AssessmentRegistrationReasonNotCompleting'
				,results.AssessmentRegistrationReasonNotTested			AS 'Results-AssessmentRegistrationReasonNotTested'
				,results.AssessmentScoreMetricType						AS 'Results-AssessmentScoreMetricType'

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

				, nord.NeglectedOrDelinquentStatus
				, nord.NeglectedOrDelinquentProgramEnrollmentSubpart
				, nord.ProgramParticipationBeginDate				AS 'NorDProgramParticipationBeginDate'
				, nord.ProgramParticipationEndDate					AS 'NorDProgramParticipationEndDate'

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
		AND		programparticipation.ProgramParticipationBeginDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.IdeaDisabilityType					ideaDisability
		ON		enrollment.StudentIdentifierState						=	ideaDisability.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ideaDisability.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ideaDisability.SchoolIdentifierSea, '')
		AND 	ideaDisability.IsPrimaryDisability = 1
		AND		ideaDisability.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.K12PersonRace							race
		ON		enrollment.SchoolYear									=	race.SchoolYear
		AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
		AND		race.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate,'6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		el.EnglishLearner_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							econ
		ON		enrollment.StudentIdentifierState						=	econ.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(econ.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(econ.SchoolIdentifierSea, '')
		AND		econ.EconomicDisadvantage_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate,'6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							migr
		ON		enrollment.StudentIdentifierState						=	migr.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(migr.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(migr.SchoolIdentifierSea, '')
		AND		migr.Migrant_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							home
		ON		enrollment.StudentIdentifierState						=	home.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(home.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(home.SchoolIdentifierSea, '')
		AND		home.Homelessness_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							foster
		ON		enrollment.StudentIdentifierState						=	foster.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(foster.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(foster.SchoolIdentifierSea, '')
		AND		foster.FosterCare_ProgramParticipationStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							mil
		ON		enrollment.StudentIdentifierState						=	mil.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(mil.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(mil.SchoolIdentifierSea, '')
		AND		mil.MilitaryConnected_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.ProgramParticipationNorD				nord
		ON		enrollment.StudentIdentifierState						=	nord.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(nord.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(nord.SchoolIdentifierSea, '')

	WHERE 1 = 1
	AND results.AssessmentAdministrationStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))


