CREATE VIEW [debug].[vwTitleIIIELOct_StagingTables]
AS
	-- Expected-side base for the Title III EL October fact type (FactTypeId 9; file 141).
	-- REWRITTEN to mirror the population of Staging.[Staging-to-FactK12StudentCounts_TitleIIIELOct]
	-- exactly (target = 316 distinct students for 2027 before the fact view's Open/New school filter,
	-- 315 after it; == RDS.vwTitleIIIELOct_FactTable_141).
	--
	-- Key fixes vs the prior deployed version (which returned only 10 students):
	--   * REMOVED the INNER JOIN to Staging.ProgramParticipationTitleIII entirely — the ELOct fact
	--     proc does NOT reference ProgramParticipationTitleIII at all. Its population is simply K-12
	--     enrolled English learners (EnglishLearnerStatus = 1) as of the October reporting date. The
	--     sparse Title III join + its EnglishLearnerParticipation = 1 filter is what dropped the base
	--     to 10.
	--   * Anchored the EL and IDEA windows on the reporting date the proc computes (closest school day
	--     to Oct 1 of the prior calendar year, with the proc's Sat/Sun adjustment) and replaced the
	--     GETDATE() null-exit default with staging.GetFiscalYearEndDate (= the proc's @SYEndDate).
	--   * Added the proc's population grade filter: entry grade level in the K-12 set
	--     (KG,01..13,UG) via RDS.vwDimGradeLevels.
	--   * Exposed the raw source columns the report dimensions need:
	--       - GradeLevel, HispanicLatinoEthnicity                       (Grade + Race dims)
	--       - ISO_639_2_NativeLanguage                                  (ISO6392LanguageCode dim)
	--       - IDEAIndicator                                             (IdeaIndicator dim)
	--   * Dropped the K12PersonRace join — race is unduplicated via RDS.vwUnduplicatedRaceMap in the
	--     expected view.
	--
	-- Open/New school filter is applied in the expected view (mirrors the fact view), not here, so
	-- this base equals the proc population (316).
	SELECT DISTINCT
		  enrollment.SchoolYear
		, enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.GradeLevel
		, enrollment.HispanicLatinoEthnicity

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusExitDate
		, el.PerkinsEnglishLearnerStatus
		, el.ISO_639_2_NativeLanguage

		, idea.IDEAIndicator
		, idea.ProgramParticipationStartDate	AS IDEAProgramParticipationStartDate
		, idea.ProgramParticipationExitDate		AS IDEAProgramParticipationExitDate

	FROM Staging.K12Enrollment								enrollment

	-- Reporting date = closest school day to Oct 1 of (SchoolYear - 1), matching the proc.
	INNER JOIN (
		SELECT	MAX(sy.SchoolYear)		AS SchoolYear
			,	CASE DATEPART(DW, CAST(CAST(MAX(sy.SchoolYear) - 1 AS CHAR(4)) + '-10-01' AS DATE))
					WHEN 1 THEN DATEADD(day,  1, CAST(CAST(MAX(sy.SchoolYear) - 1 AS CHAR(4)) + '-10-01' AS DATE))
					WHEN 7 THEN DATEADD(day, -1, CAST(CAST(MAX(sy.SchoolYear) - 1 AS CHAR(4)) + '-10-01' AS DATE))
					ELSE CAST(CAST(MAX(sy.SchoolYear) - 1 AS CHAR(4)) + '-10-01' AS DATE)
				END					AS CompareDate
		FROM rds.DimSchoolYearDataMigrationTypes dm
		INNER JOIN rds.DimSchoolYears sy
			ON dm.dimschoolyearid = sy.dimschoolyearid
		WHERE dm.IsSelected = 1
	) compareDate
		ON compareDate.SchoolYear = enrollment.SchoolYear

	-- English learner status = 1, active as of the reporting date (INNER, matches the proc)
	JOIN Staging.PersonStatus								el
		ON		enrollment.SchoolYear									=	el.SchoolYear
		AND		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		compareDate.CompareDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))
		AND		ISNULL(el.EnglishLearnerStatus, 0) = 1

	-- IDEA (LEFT, active as of the reporting date) — for the IdeaIndicator dim
	LEFT JOIN Staging.ProgramParticipationSpecialEducation	idea
		ON		enrollment.SchoolYear									=	idea.SchoolYear
		AND		enrollment.StudentIdentifierState						=	idea.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(idea.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(idea.SchoolIdentifierSea, '')
		AND		compareDate.CompareDate BETWEEN idea.ProgramParticipationStartDate AND ISNULL(idea.ProgramParticipationExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))

	-- Population grade filter: entry grade in the K-12 set (proc restricts to these)
	JOIN RDS.vwDimGradeLevels								glf
		ON		glf.SchoolYear = enrollment.SchoolYear
		AND		glf.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		glf.GradeLevelMap = enrollment.GradeLevel
		AND		glf.GradeLevelCode IN ('KG','01','02','03','04','05','06','07','08','09','10','11','12','13','UG')

	WHERE	compareDate.CompareDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))
