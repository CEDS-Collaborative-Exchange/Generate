CREATE VIEW [Debug].[vwChildCount_StagingTables] 
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
				,[RDS].[Get_Age] (enrollment.BirthDate, Toggle.ChildCountDate) AS CalculatedAge 

				,ideaDisability.IdeaDisabilityTypeCode

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
			ON		enrollment.StudentIdentifierState						=	programparticipation.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(programparticipation.LEAIdentifierSeaAccountability, '') 
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(programparticipation.SchoolIdentifierSea, '')
			AND		(programparticipation.ProgramParticipationBeginDate  <= toggle.ChildCountDate 
				AND ISNULL(programparticipation.ProgramParticipationEndDate, GETDATE()) > toggle.ChildCountDate)
			AND		programparticipation.ProgramParticipationBeginDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.IdeaDisabilityType					ideaDisability
			ON		enrollment.StudentIdentifierState						=	ideaDisability.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ideaDisability.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(ideaDisability.SchoolIdentifierSea, '')
			AND 	ideaDisability.IsPrimaryDisability = 1
			AND		(ideaDisability.RecordStartDateTime  <= Toggle.ChildCountDate 
				AND ISNULL(ideaDisability.RecordStartDateTime, GETDATE()) > Toggle.ChildCountDate)
			AND		ideaDisability.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.K12PersonRace							race
			ON		enrollment.SchoolYear									=	race.SchoolYear
			AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(ideaDisability.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')	=	ISNULL(ideaDisability.SchoolIdentifierSea, '')
			AND		(race.RecordStartDateTime  <= Toggle.ChildCountDate 
				AND ISNULL(race.RecordEndDateTime, GETDATE()) > Toggle.ChildCountDate)
			AND		race.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	LEFT JOIN Staging.PersonStatus							el
			ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
			AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
			AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
			AND		(el.EnglishLearner_StatusStartDate  <= Toggle.ChildCountDate 
				AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE()) > Toggle.ChildCountDate)
			AND		el.EnglishLearner_StatusStartDate  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND Students.StudentIdentifierState = '12345678'	
	--AND LEAs.LeaIdentifierSeaAccountability = '123'
	--AND Schools.SchoolIdentifierSea = '456'
	--AND [RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) = '12'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastOrSurname = ''
	--AND enrollment.BirthDate = ''
	--AND ideaDisability.IdeaDisabilityTypeCode = ''
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
