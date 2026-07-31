CREATE VIEW [debug].[vwMigrantEducationProgram_StagingTables]
AS
	-- Expected-side population base for the Migrant Education Program count reports (FS054/FS121/FS145).
	--
	-- IMPORTANT: this base was rewritten to mirror the fact proc
	-- Staging.[Staging-to-FactK12StudentCounts_MigrantEducationProgram]. The previous version
	-- INNER-joined Staging.Migrant with MigrantStatus = 1 and returned 0 rows, because
	-- Staging.Migrant is EMPTY - the migrant flag actually lives on Staging.PersonStatus.MigrantStatus.
	-- The fact proc does NOT filter to migrant students: it reads ALL K12Enrollment and LEFT-joins
	-- Staging.PersonStatus for both the migrant flag and the English-learner status (each on its own
	-- StatusStartDate BETWEEN enrollment-span window). Open/New school restriction is applied by the
	-- per-report expected views (via RDS.DimK12Schools, matching the fact view's SchoolOperationalStatus
	-- IN ('Open','New') filter and the proc's DimK12Schools resolution).
	SELECT DISTINCT
		  enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.SchoolYear
		, enrollment.EnrollmentEntryDate
		, enrollment.EnrollmentExitDate
		, enrollment.GradeLevel
		, migrant.MigrantStatus
		, el.EnglishLearnerStatus

	FROM Staging.K12Enrollment								enrollment

	-- migratory status (mirrors the fact proc's PersonStatus 'migrant' join + window)
	LEFT JOIN Staging.PersonStatus							migrant
		ON		enrollment.SchoolYear									=	migrant.SchoolYear
		AND		enrollment.StudentIdentifierState						=	migrant.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(migrant.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(migrant.SchoolIdentifierSea, '')
		AND		migrant.Migrant_StatusStartDate BETWEEN enrollment.EnrollmentEntryDate
					AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))

	-- english learner (mirrors the fact proc's PersonStatus 'el' join + window)
	LEFT JOIN Staging.PersonStatus							el
		ON		enrollment.SchoolYear									=	el.SchoolYear
		AND		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		el.EnglishLearner_StatusStartDate BETWEEN enrollment.EnrollmentEntryDate
					AND ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear))
