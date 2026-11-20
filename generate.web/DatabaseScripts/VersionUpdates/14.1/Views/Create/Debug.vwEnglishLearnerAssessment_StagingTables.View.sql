CREATE VIEW [Debug].[vwEnglishLearnerAssessment_StagingTables] 
AS
	SELECT		DISTINCT 
				enrollment.StudentIdentifierState
				, enrollment.LEAIdentifierSeaAccountability
				, enrollment.SchoolIdentifierSea
				, enrollment.FirstName
				, enrollment.LastOrSurname
				, enrollment.MiddleName
				, enrollment.Sex
				, enrollment.BirthDate
				, enrollment.SchoolYear

				, assess.AssessmentIdentifier							AS 'Assessment-AssessmentIdentifier'
				, assess.AssessmentAcademicSubject						AS 'Assessment-AssessmentAcademicSubject'
				, assess.AssessmentTypeAdministeredToEnglishLearners	AS 'Assessment-AssessmentTypeAdministeredToEnglishLearners'

				, results.AssessmentAcademicSubject						AS 'Results-AssessmentAcademicSubject'
				, results.AssessmentIdentifier							AS 'Results-AssessmentIdentifier'
				, results.AssessmentRegistrationParticipationIndicator	AS 'Results-AssessmentRegistrationParticipationIndicator'

				, programparticipation.IDEAIndicator
				, programparticipation.ProgramParticipationStartDate	AS IDEAProgramParticipationBeginDate
				, programparticipation.ProgramParticipationExitDate		AS IDEAProgramParticipationEndDate
				
				, el.EnglishLearnerStatus
				, el.EnglishLearner_StatusStartDate
				, el.EnglishLearner_StatusExitDate

				, titleIII.TitleIIILanguageInstructionProgramType
				, titleIII.ProgramParticipationStartDate				AS 'TITLEIIIProgramParticipationBeginDate'
				, titleIII.ProgramParticipationExitDate					AS 'TITLEIIIProgramParticipationEndDate'

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
		AND		programparticipation.ProgramParticipationStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.PersonStatus							el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		el.EnglishLearner_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))

	LEFT JOIN Staging.ProgramParticipationTitleIII			titleIII
		ON		enrollment.StudentIdentifierState						=	titleIII.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(titleIII.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(titleIII.SchoolIdentifierSea, '')
		AND		ISNULL(titleIII.ProgramParticipationExitDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	AND results.AssessmentAdministrationStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '6/30/' + convert(varchar,enrollment.SchoolYear))
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
	


