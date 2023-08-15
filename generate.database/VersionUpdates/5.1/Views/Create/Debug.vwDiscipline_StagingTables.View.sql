CREATE VIEW [Debug].[vwDiscipline_StagingTables] AS

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

				,discipline.IncidentIdentifier
				,discipline.DisciplinaryActionStartDate
				,discipline.DisciplinaryActionEndDate
				,discipline.DurationOfDisciplinaryAction
				,discipline.DisciplinaryActionTaken
				,discipline.DisciplineMethodOfCwd
				,discipline.IdeaInterimRemoval
				,discipline.IdeaInterimRemovalReason
				,discipline.EducationalServicesAfterRemoval

				,discipline.DisciplineMethodFirearm
				,discipline.IDEADisciplineMethodFirearm
				,discipline.FirearmType
			
				,idea.IDEAIndicator
				,idea.IDEA_StatusStartDate
				,idea.IDEA_StatusEndDate
				,idea.PrimaryDisabilityType

				,programparticipation.ProgramParticipationBeginDate		AS IDEAProgramParticipationBeginDate
				,programparticipation.ProgramParticipationEndDate		AS IDEAProgramParticipationEndDate
				
				,el.EnglishLearnerStatus
				,el.EnglishLearner_StatusStartDate
				,el.EnglishLearner_StatusEndDate

				,race.RaceType
				,race.RecordStartDateTime
				,race.RecordEndDateTime

	FROM Staging.Discipline									discipline
	JOIN Staging.K12Enrollment								enrollment		
			ON		discipline.Student_Identifier_State				=	enrollment.Student_Identifier_State
			AND		ISNULL(discipline.LEA_Identifier_State, '')		=	ISNULL(enrollment.LEA_Identifier_State, '')
			AND		ISNULL(discipline.School_Identifier_State, '')	=	ISNULL(enrollment.School_Identifier_State, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	programparticipation
			ON		enrollment.Student_Identifier_State				=	programparticipation.Student_Identifier_State
			AND		ISNULL(enrollment.LEA_Identifier_State, '')		=	ISNULL(programparticipation.LEA_Identifier_State, '') 
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(programparticipation.School_Identifier_State, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN programparticipation.ProgramParticipationBeginDate AND ISNULL(programparticipation.ProgramParticipationEndDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							idea
			ON		enrollment.Student_Identifier_State				=	idea.Student_Identifier_State
			AND		ISNULL(enrollment.Lea_Identifier_State, '')		=	ISNULL(idea.Lea_Identifier_State, '')
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(idea.School_Identifier_State, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate, GETDATE())

	LEFT JOIN Staging.PersonRace							race
			ON		enrollment.SchoolYear							=	race.SchoolYear
			AND		enrollment.Student_Identifier_State				=	race.Student_Identifier_State
			AND		(race.OrganizationType = 'SEA'
				OR (enrollment.LEA_Identifier_State = race.OrganizationIdentifier
					AND race.OrganizationType = 'LEA')
				OR (enrollment.School_Identifier_State = race.OrganizationIdentifier
					AND race.OrganizationType = 'K12School'))
			AND		discipline.DisciplinaryActionStartDate  BETWEEN race.RecordStartDateTime AND ISNULL(race.RecordEndDateTime, GETDATE())

	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.Student_Identifier_State				=	el.Student_Identifier_State
			AND		ISNULL(enrollment.LEA_Identifier_State, '')		=	ISNULL(el.LEA_Identifier_State, '')
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(el.School_Identifier_State, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

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
	--AND discipline.IncidentIdentifier = ''
	--AND discipline.DisciplinaryActionStartDate = ''
	--AND discipline.DisciplinaryActionEndDate = ''
	--AND discipline.DurationOfDisciplinaryAction = ''
	--AND discipline.DisciplinaryActionTaken = ''
	--AND discipline.DisciplineMethodOfCwd = ''
	--AND discipline.IdeaInterimRemoval = ''
	--AND discipline.IdeaInterimRemovalReason = ''
	--AND discipline.EducationalServicesAfterRemoval = ''
	--AND discipline.DisciplineMethodFirearm = ''
	--AND discipline.IDEADisciplineMethodFirearm = ''
	--AND discipline.FirearmType = ''
	--AND idea.IDEAIndicator = ''
	--AND idea.IDEA_StatusStartDate = ''
	--AND idea.IDEA_StatusEndDate = ''
	--AND idea.PrimaryDisabilityType = ''
	--AND programparticipation.ProgramParticipationBeginDate = ''
	--AND programparticipation.ProgramParticipationEndDate = ''
	--AND el.EnglishLearnerStatus = ''
	--AND el.EnglishLearner_StatusStartDate = ''
	--AND el.EnglishLearner_StatusEndDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
