CREATE VIEW [debug].[vwTitleIIIELSY_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.SchoolYear
		,enrollment.StudentIdentifierState
		,enrollment.LEAIdentifierSeaAccountability
		,enrollment.SchoolIdentifierSea
		,enrollment.FirstName
		,enrollment.LastOrSurname
		,enrollment.MiddleName
		,enrollment.GradeLevel
		,enrollment.BirthDate
		,[RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) AS CalculatedAge 

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate
		, sssrd.OutputCode as TitleIIILanguageInstructionProgramType

		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment

	JOIN Staging.PersonStatus								el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		ISNULL(el.EnglishLearner_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	JOIN Staging.ProgramParticipationTitleIII			titleIII
		ON		enrollment.StudentIdentifierState						=	titleIII.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(titleIII.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(titleIII.SchoolIdentifierSea, '')
		AND		ISNULL(titleIII.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.K12PersonRace							race
		ON		enrollment.SchoolYear									=	race.SchoolYear
		AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
		AND		ISNULL(race.RecordEndDateTime, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		ON sssrd.SchoolYear = enrollment.SchoolYear
		AND sssrd.TableName = 'RefTitleIIILanguageInstructionProgramType'
		AND titleIII.TitleIIILanguageInstructionProgramType = sssrd.InputCode

	--Join to get the child count date for the age calculation
	JOIN App.ToggleQuestions		toggle 		ON		toggle.EmapsQuestionAbbrv	=	'MEMBERDTE'		
	JOIN App.ToggleResponses		dates		ON		toggle.ToggleQuestionId		=	dates.ToggleQuestionId

	WHERE 1 = 1
	AND el.EnglishLearnerStatus = 1
	AND titleIII.EnglishLearnerParticipation = 1
