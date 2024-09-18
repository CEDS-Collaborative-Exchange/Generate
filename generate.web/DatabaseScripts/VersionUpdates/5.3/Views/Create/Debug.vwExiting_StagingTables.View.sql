CREATE VIEW [Debug].[vwExiting_StagingTables] AS

	SELECT		DISTINCT 
				enrollment.Student_Identifier_State
				,enrollment.LEA_Identifier_State
				,enrollment.School_Identifier_State
				,enrollment.FirstName
				,enrollment.LastName
				,enrollment.MiddleName
--				,enrollment.Sex
				,enrollment.BirthDate
				,[RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) AS CalculatedAge 

				,idea.IDEAIndicator
				,idea.IDEA_StatusStartDate
				,idea.IDEA_StatusEndDate
				,idea.PrimaryDisabilityType

				,programparticipation.ProgramParticipationBeginDate		AS IDEAProgramParticipationBeginDate
				,programparticipation.ProgramParticipationEndDate		AS IDEAProgramParticipationEndDate
				,programparticipation.SpecialEducationExitReason
				,programparticipation.IDEAEducationalEnvironmentForSchoolAge
				
				,el.EnglishLearnerStatus
				,el.EnglishLearner_StatusStartDate
				,el.EnglishLearner_StatusEndDate

				,race.RaceType
				,race.RecordStartDateTime
				,race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment		
	LEFT JOIN Staging.ProgramParticipationSpecialEducation	programparticipation
			ON		enrollment.Student_Identifier_State				=	programparticipation.Student_Identifier_State
			AND		ISNULL(enrollment.LEA_Identifier_State, '')		=	ISNULL(programparticipation.LEA_Identifier_State, '') 
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(programparticipation.School_Identifier_State, '')
			AND		programparticipation.ProgramParticipationEndDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							idea
			ON		enrollment.Student_Identifier_State				=	idea.Student_Identifier_State
			AND		ISNULL(enrollment.Lea_Identifier_State, '')		=	ISNULL(idea.Lea_Identifier_State, '')
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(idea.School_Identifier_State, '')
			AND		programparticipation.ProgramParticipationEndDate  BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate, GETDATE())

	LEFT JOIN Staging.PersonRace							race
			ON		enrollment.SchoolYear							=	race.SchoolYear
			AND		enrollment.Student_Identifier_State				=	race.Student_Identifier_State
			AND		(race.OrganizationType = 'SEA'
				OR (enrollment.LEA_Identifier_State = race.OrganizationIdentifier
					AND race.OrganizationType = 'LEA')
				OR (enrollment.School_Identifier_State = race.OrganizationIdentifier
					AND race.OrganizationType = 'K12School'))
			AND		programparticipation.ProgramParticipationEndDate  BETWEEN race.RecordStartDateTime AND ISNULL(race.RecordEndDateTime, GETDATE())

	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.Student_Identifier_State				=	el.Student_Identifier_State
			AND		ISNULL(enrollment.LEA_Identifier_State, '')		=	ISNULL(el.LEA_Identifier_State, '')
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(el.School_Identifier_State, '')
			AND		programparticipation.ProgramParticipationEndDate  BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

	--Join to get the child count date for the age calculation
	JOIN App.ToggleQuestions		toggle 		ON		toggle.EmapsQuestionAbbrv	=	'CHDCTDTE'		
	JOIN App.ToggleResponses		dates		ON		toggle.ToggleQuestionId		=	dates.ToggleQuestionId
	
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND Students.StateStudentIdentifier = '12345678'	
	--AND LEAs.LeaIdentifierState = '123'
	--AND Schools.SchoolIdentifierState = '456'
	--AND [RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) = '12'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastName = ''
	--AND enrollment.BirthDate = ''
	--AND idea.IDEAIndicator = ''
	--AND idea.IDEA_StatusStartDate = ''
	--AND idea.IDEA_StatusEndDate = ''
	--AND idea.PrimaryDisabilityType = ''
	--AND programparticipation.ProgramParticipationBeginDate = ''
	--AND programparticipation.ProgramParticipationEndDate = ''
	--AND programparticipation.SpecialEducationExitReason = ''
	--AND programparticipation.IDEAEducationalEnvironmentForSchoolAge = ''
	--AND el.EnglishLearnerStatus = ''
	--AND el.EnglishLearner_StatusStartDate = ''
	--AND el.EnglishLearner_StatusEndDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
