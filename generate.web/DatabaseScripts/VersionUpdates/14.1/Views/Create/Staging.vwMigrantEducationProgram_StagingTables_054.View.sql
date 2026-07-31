CREATE VIEW [Staging].[vwMigrantEducationProgram_StagingTables_054]
AS
	-- FS054 - Migrant Education Program, broken out by Grade Level, Migrant Prioritized for Services,
	-- and Continuation of Services Reason (all category sets are SEA-level).
	--
	-- Mirrors Staging.[Staging-to-FactK12StudentCounts_MigrantEducationProgram] exactly so the expected
	-- distinct-student counts match RDS.vwMigrantEducationProgram_FactTable_054:
	--   * Population = ALL K12Enrollment at Open/New schools (the proc LEFT-joins migrant; it does NOT
	--     filter to migrant students). Open/New resolved via RDS.DimK12Schools (= the fact view's
	--     SchoolOperationalStatus IN ('Open','New')); yields 1991 distinct students.
	--   * Grade = Entry Grade Level, LEFT + -1 NA fallback.
	--   * Migrant dim two-step (vwDimMigrantStatuses -> DimMigrantStatuses) matched on MigrantStatusMap
	--     with the proc's 4 sub-code '= MISSING' conditions (EnrollmentType / ContinuationOfServicesReason
	--     / ServicesType / PrioritizedForServices). NOTE: because the proc pins those sub-codes to MISSING
	--     and never reads any raw program-detail value, MigrantPrioritizedForServices and
	--     ContinuationOfServicesReason always resolve to the EdFacts 'MISSING' member here and in the fact.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode							AS GradeLevel
		, dms.MigrantPrioritizedForServicesEdFactsCode		AS MigrantPrioritizedForServices
		, dms.ContinuationOfServicesReasonCode				AS ContinuationOfServicesReason

	FROM [debug].[vwMigrantEducationProgram_StagingTables]	s

	-- Open/New school (mirrors proc DimK12Schools resolution + fact view SchoolOperationalStatus filter)
	JOIN RDS.DimK12Schools									sch
		ON		sch.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		s.EnrollmentEntryDate BETWEEN sch.RecordStartDateTime
					AND ISNULL(sch.RecordEndDateTime, staging.GetFiscalYearEndDate(s.SchoolYear))
		AND		sch.SchoolOperationalStatus IN ('Open','New')

	-- Grade: Entry Grade Level (LEFT + -1 NA fallback)
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	JOIN RDS.DimGradeLevels									dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	-- Migrant dim (two-step). Sub-codes pinned to MISSING exactly as the fact proc does.
	LEFT JOIN RDS.vwDimMigrantStatuses						rdms
		ON		rdms.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
		AND		rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING'
		AND		rdms.ContinuationOfServicesReasonCode = 'MISSING'
		AND		rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
		AND		rdms.MigrantPrioritizedForServicesCode = 'MISSING'
	JOIN RDS.DimMigrantStatuses								dms
		ON		dms.DimMigrantStatusId = ISNULL(rdms.DimMigrantStatusId, -1)
