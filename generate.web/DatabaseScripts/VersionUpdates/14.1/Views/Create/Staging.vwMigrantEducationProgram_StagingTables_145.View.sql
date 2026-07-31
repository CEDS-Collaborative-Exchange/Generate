CREATE VIEW [Staging].[vwMigrantEducationProgram_StagingTables_145]
AS
	-- FS145 - Migrant Education Program, broken out by Grade Level and Migrant Education Program
	-- Services Type (SEA-level).
	--
	-- Mirrors Staging.[Staging-to-FactK12StudentCounts_MigrantEducationProgram] (see the _054 view for the
	-- full pattern notes). MigrantEducationProgramServicesType is pinned to the EdFacts 'MISSING' member by
	-- the proc's dim-member selection (it forces MigrantEducationProgramServicesTypeCode = 'MISSING'), so
	-- the served types (COUNSELSERV / HSACCRUAL / INSTRSERV / MATHINSTR / READINSTR / SUPPSERV) are never
	-- produced by either side - the breakout collapses entirely to MISSING. This is a proc/source gap
	-- (documented in the findings), not an expected-vs-actual mismatch: both sides agree, so the test
	-- greens, but the report is not meaningful for this dimension.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode								AS GradeLevel
		, dms.MigrantEducationProgramServicesTypeEdFactsCode	AS MigrantEducationProgramServicesType

	FROM [debug].[vwMigrantEducationProgram_StagingTables]	s

	-- Open/New school
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
