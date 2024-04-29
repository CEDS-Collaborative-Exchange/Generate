CREATE VIEW [debug].[vwTitleIIIELOct_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.HispanicLatinoEthnicity
		, enrollment.GradeLevel

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate
		, sssrd.OutputCode as NativeLanguage

		, idea.IDEAIndicator
		, idea.ProgramParticipationBeginDate
		, idea.ProgramParticipationEndDate
				
		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

	FROM Staging.K12Enrollment								enrollment
	--Join to get the report date
	INNER JOIN (
		SELECT max(sy.Schoolyear) AS SchoolYear, CAST(CAST(max(sy.Schoolyear) - 1 AS CHAR(4)) + '-' + '10-01' AS DATE) AS CompareDate
		FROM rds.DimSchoolYearDataMigrationTypes dm
		INNER JOIN rds.dimschoolyears sy
				on dm.dimschoolyearid = sy.dimschoolyearid	
		WHERE dm.IsSelected = 1
	) compareDate on compareDate.SchoolYear = enrollment.SchoolYear

	JOIN Staging.PersonStatus								el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		compareDate.CompareDate BETWEEN el.EnglishLearner_StatusStartDate and ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

	JOIN Staging.ProgramParticipationTitleIII			titleIII
		ON		enrollment.StudentIdentifierState						=	titleIII.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(titleIII.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(titleIII.SchoolIdentifierSea, '')
		AND		ISNULL(titleIII.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
		ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
		AND		compareDate.CompareDate BETWEEN idea.ProgramParticipationBeginDate and ISNULL(idea.ProgramParticipationEndDate, GETDATE())

	LEFT JOIN Staging.K12PersonRace							race
		ON		enrollment.SchoolYear									=	race.SchoolYear
		AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
		AND		compareDate.CompareDate BETWEEN race.RecordStartDateTime and ISNULL(race.RecordEndDateTime, GETDATE())

	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		ON sssrd.SchoolYear = enrollment.SchoolYear
		AND sssrd.TableName = 'RefLanguage'
		AND el.ISO_639_2_NativeLanguage = sssrd.InputCode

	WHERE 1 = 1
	AND el.EnglishLearnerStatus = 1
	AND titleIII.EnglishLearnerParticipation = 1
