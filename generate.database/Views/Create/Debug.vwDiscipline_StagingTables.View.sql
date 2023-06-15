CREATE VIEW [Debug].[vwDiscipline_StagingTables] AS

	SELECT		DISTINCT 
				enrollment.StudentIdentifierState
				,enrollment.LEAIdentifierSeaAccountability
				,enrollment.SchoolIdentifierSea
				,enrollment.FirstName
				,enrollment.LastOrSurname
				,enrollment.MiddleName
				,enrollment.Sex
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
			
				,ideaDisability.IdeaDisabilityType

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
			ON		discipline.StudentIdentifierState						=	enrollment.StudentIdentifierState
			AND		ISNULL(discipline.LeaIdentifierSeaAccountability, '')	=	ISNULL(enrollment.LeaIdentifierSeaAccountability, '')
			AND		ISNULL(discipline.SchoolIdentifierSea, '')				=	ISNULL(enrollment.SchoolIdentifierSea, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	programparticipation
			ON		enrollment.StudentIdentifierState						=	programparticipation.StudentIdentifierState
			AND		ISNULL(enrollment.LeaIdentifierSeaAccountability, '')	=	ISNULL(programparticipation.LeaIdentifierSeaAccountability, '') 
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(programparticipation.SchoolIdentifierSea, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN programparticipation.ProgramParticipationBeginDate AND ISNULL(programparticipation.ProgramParticipationEndDate, GETDATE())

	LEFT JOIN Staging.IdeaDisabilityType					ideaDisability
			ON		enrollment.StudentIdentifierState						=	ideaDisability.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ideaDisability.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ideaDisability.SchoolIdentifierSea, '')
			AND 	ideaDisability.IsPrimaryDisability = 1
			AND		discipline.DisciplinaryActionStartDate BETWEEN ideaDisability.RecordStartDateTime AND ISNULL(ideaDisability.RecordEndDateTime, GETDATE())

	LEFT JOIN Staging.K12PersonRace							race
			ON		enrollment.SchoolYear									=	race.SchoolYear
			AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ideaDisability.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ideaDisability.SchoolIdentifierSea, '')
			AND		discipline.DisciplinaryActionStartDate  BETWEEN race.RecordStartDateTime AND ISNULL(race.RecordEndDateTime, GETDATE())

	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
			AND		ISNULL(enrollment.LeaIdentifierSeaAccountability, '')	=	ISNULL(el.LeaIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
			AND		discipline.DisciplinaryActionStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

	--Join to get the child count date for the age calculation
	JOIN App.ToggleQuestions		toggle 		ON		toggle.EmapsQuestionAbbrv	=	'CHDCTDTE'		
	JOIN App.ToggleResponses		dates		ON		toggle.ToggleQuestionId		=	dates.ToggleQuestionId
	
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND Students.StudentIdentifierState = '12345678'	
	--AND LEAs.LeaIdentifierSeaAccountability = '123'
	--AND Schools.SchoolIdentifierSea = '456'
	--AND [RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) = '12'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastOrSurname = ''
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
	--AND ideaDisability.IdeaDisabilityTypeCode = ''
	--AND programparticipation.ProgramParticipationBeginDate = ''
	--AND programparticipation.ProgramParticipationEndDate = ''
	--AND el.EnglishLearnerStatus = ''
	--AND el.EnglishLearner_StatusStartDate = ''
	--AND el.EnglishLearner_StatusEndDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
