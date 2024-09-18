CREATE VIEW [Debug].[vwChildCount_StagingTables] AS

	SELECT		DISTINCT 
				enrollment.Student_Identifier_State
				,enrollment.LEA_Identifier_State
				,enrollment.School_Identifier_State
				,enrollment.FirstName
				,enrollment.LastName
				,enrollment.MiddleName
				,enrollment.Sex
				,enrollment.BirthDate
				,[RDS].[Get_Age] (enrollment.BirthDate, Toggle.ChildCountDate) AS CalculatedAge 

				,idea.IDEAIndicator
				,idea.IDEA_StatusStartDate
				,idea.IDEA_StatusEndDate
				,idea.PrimaryDisabilityType

				,programparticipation.ProgramParticipationBeginDate		AS IDEAProgramParticipationBeginDate
				,programparticipation.ProgramParticipationEndDate		AS IDEAProgramParticipationEndDate
				,programparticipation.IDEAEducationalEnvironmentForEarlyChildhood
				,programparticipation.IDEAEducationalEnvironmentForSchoolAge
				
				,el.EnglishLearnerStatus
				,el.EnglishLearner_StatusStartDate
				,el.EnglishLearner_StatusEndDate

				,race.RaceType
				,race.RecordStartDateTime
				,race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment		
	----Join to get the child count date, uses the Day/Month and gets the year from the last migration that was run
	INNER JOIN (
		SELECT max(sy.Schoolyear) AS SchoolYear, CAST(CAST(max(sy.Schoolyear) - 1 AS CHAR(4)) + '-' + CAST(MONTH(tr.ResponseValue) AS VARCHAR(2)) + '-' + CAST(DAY(tr.ResponseValue) AS VARCHAR(2)) AS DATE) AS ChildCountDate
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		CROSS JOIN rds.DimSchoolYearDataMigrationTypes dm
		INNER JOIN rds.dimschoolyears sy
				on dm.dimschoolyearid = sy.dimschoolyearid	
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'
		AND dm.IsSelected = 1
		GROUP BY tr.ResponseValue
	) toggle on toggle.SchoolYear = enrollment.SchoolYear

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	programparticipation
			ON		enrollment.Student_Identifier_State				=	programparticipation.Student_Identifier_State
			AND		ISNULL(enrollment.LEA_Identifier_State, '')		=	ISNULL(programparticipation.LEA_Identifier_State, '') 
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(programparticipation.School_Identifier_State, '')
			AND		(programparticipation.ProgramParticipationBeginDate  <= toggle.ChildCountDate 
				AND ISNULL(programparticipation.ProgramParticipationEndDate, GETDATE()) > toggle.ChildCountDate)
			AND		programparticipation.ProgramParticipationBeginDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							idea
			ON		enrollment.Student_Identifier_State				=	idea.Student_Identifier_State
			AND		ISNULL(enrollment.Lea_Identifier_State, '')		=	ISNULL(idea.Lea_Identifier_State, '')
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(idea.School_Identifier_State, '')
			AND		(idea.IDEA_StatusStartDate  <= Toggle.ChildCountDate 
				AND ISNULL(idea.IDEA_StatusEndDate, GETDATE()) > Toggle.ChildCountDate)
			AND		idea.IDEA_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonRace							race
			ON		enrollment.SchoolYear							=	race.SchoolYear
			AND		enrollment.Student_Identifier_State				=	race.Student_Identifier_State
			AND		(race.OrganizationType = 'SEA'
				OR (enrollment.LEA_Identifier_State = race.OrganizationIdentifier
					AND race.OrganizationType = 'LEA')
				OR (enrollment.School_Identifier_State = race.OrganizationIdentifier
					AND race.OrganizationType = 'K12School'))
			AND		(race.RecordStartDateTime  <= Toggle.ChildCountDate 
				AND ISNULL(race.RecordEndDateTime, GETDATE()) > Toggle.ChildCountDate)
			AND		race.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.Student_Identifier_State				=	el.Student_Identifier_State
			AND		ISNULL(enrollment.LEA_Identifier_State, '')		=	ISNULL(el.LEA_Identifier_State, '')
			AND		ISNULL(enrollment.School_Identifier_State, '')	=	ISNULL(el.School_Identifier_State, '')
			AND		(el.EnglishLearner_StatusStartDate  <= Toggle.ChildCountDate 
				AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE()) > Toggle.ChildCountDate)
			AND		el.EnglishLearner_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND Students.StateStudentIdentifier = '12345678'	
	--AND LEAs.LeaIdentifierState = '123'
	--AND Schools.SchoolIdentifierState = '456'
	--AND [RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) = '12'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastName = ''
	--AND enrollment.BirthDate = ''
	--AND idea.IDEAIndicator = ''	--0 or 1
	--AND idea.IDEA_StatusStartDate = ''
	--AND idea.IDEA_StatusEndDate = ''
	--AND idea.PrimaryDisabilityType = ''
	--AND programparticipation.ProgramParticipationBeginDate = ''
	--AND programparticipation.ProgramParticipationEndDate = ''
	--AND programparticipation.IDEAEducationalEnvironmentForSchoolAge = ''
	--AND programparticipation.IDEAEducationalEnvironmentForSchoolAge = ''
	--AND el.EnglishLearnerStatus = ''	--0 or 1
	--AND el.EnglishLearner_StatusStartDate = ''
	--AND el.EnglishLearner_StatusEndDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
