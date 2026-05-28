CREATE VIEW [debug].[vwMigrantEducationProgram_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.BirthDate

--File spec rules: Performance Period (MEP) - The 12-month period beginning September 1 and ending August 31
--Determine the date to use for Age calculation
		, [RDS].[Get_Age] (enrollment.BirthDate, CompareDate) AS CalculatedAge 

		, idea.IdeaIndicator
		, idea.ProgramParticipationBeginDate		AS IDEAProgramParticipationBeginDate
		, idea.ProgramParticipationEndDate			AS IDEAProgramParticipationEndDate
		
		, race.RaceType
		, race.RecordStartDateTime
		, race.RecordEndDateTime

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusEndDate
				
	FROM Staging.K12Enrollment								enrollment		
	--Join to get the compare date for the Age calculation
	INNER JOIN (
		SELECT max(sy.Schoolyear) AS SchoolYear, CAST(CAST(max(sy.Schoolyear) - 1 AS CHAR(4)) + '-' + '09-01' AS DATE) AS CompareDate
		FROM rds.DimSchoolYearDataMigrationTypes dm
		INNER JOIN rds.dimschoolyears sy
				on dm.dimschoolyearid = sy.dimschoolyearid	
		WHERE dm.IsSelected = 1
	) compareDate on compareDate.SchoolYear = enrollment.SchoolYear

	INNER JOIN Staging.Migrant 								Migrant
		ON		enrollment.StudentIdentifierState						=	Migrant.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(Migrant.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(Migrant.SchoolIdentifierSea, '')
		AND		ISNULL(migrant.ProgramParticipationExitDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate
	
	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
		ON		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '') 
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
		AND		ISNULL(idea.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.K12PersonRace							race
		ON		enrollment.SchoolYear									=	race.SchoolYear
		AND		enrollment.StudentIdentifierState						=	race.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(race.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(race.SchoolIdentifierSea, '')
		AND		ISNULL(race.RecordEndDateTime, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	LEFT JOIN Staging.PersonStatus							el
		ON		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		ISNULL(el.EnglishLearner_StatusEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	WHERE 1 = 1
	AND migrant.MigrantStatus = 1
