CREATE VIEW [Staging].[vwMigrantEducationProgram_StagingTables_121]
AS
	-- FS121 - Migrant Education Program, broken out (SEA-level) across 5 category sets:
	--   CSA: GradeLevel, Race
	--   CSB: GradeLevel, MigrantPrioritizedForServices
	--   CSC: GradeLevel, EnglishLearnerStatus
	--   CSD: GradeLevel, IdeaIndicator
	--   CSE: GradeLevel, ConsolidatedMepFundsStatus, MobilityStatus12MO
	--
	-- Mirrors Staging.[Staging-to-FactK12StudentCounts_MigrantEducationProgram] exactly (see _054 view for
	-- the shared pattern notes). Population = ALL K12Enrollment at Open/New schools (1991 distinct).
	--
	-- Faithful-to-the-proc dimension behavior (and the resulting semantic gaps - see findings report):
	--   * GradeLevel           : REAL breakout (Entry Grade Level).
	--   * EnglishLearnerStatus : REAL breakout (LEP / NLEP / MISSING) - proc reads PersonStatus EL.
	--   * Race                 : CONSTANT 'MISSING' - the proc hard-codes RaceId = -1 (never resolves race).
	--   * IdeaIndicator        : CONSTANT 'IDEA' - the proc's IDEA dim join is UNCORRELATED to the student's
	--                            actual special-ed participation (joins the single IdeaIndicatorCode='Yes'
	--                            member for every enrollment), so every student resolves to 'IDEA'.
	--   * MigrantPrioritizedForServices : CONSTANT 'MISSING' - sub-code pinned MISSING by the proc.
	--   * ConsolidatedMepFundsStatus    : FAN-OUT - the proc does NOT constrain this sub-code, so each
	--                            student fans across all of YES / NO / NA / MISSING. Reproduced identically
	--                            here (no constraint on ConsolidatedMepFundsStatusCode in the dim join).
	--   * MobilityStatus12MO   : NO SOURCE - the proc sets MigrantStudentQualifyingArrivalDateId and
	--                            LastQualifyingMoveDateId to -1 and there is no mobility column on the fact.
	--                            Exposed here as constant 'MISSING' to match; the fact view must expose the
	--                            same constant column for the actual side (see findings - fact-view fix).
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode							AS GradeLevel
		, drace.RaceEdFactsCode								AS Race
		, dms.MigrantPrioritizedForServicesEdFactsCode		AS MigrantPrioritizedForServices
		, dels.EnglishLearnerStatusEdFactsCode				AS EnglishLearnerStatus
		, dis.IdeaIndicatorEdFactsCode						AS IdeaIndicator
		, dms.ConsolidatedMEPFundsStatusEdFactsCode			AS ConsolidatedMepFundsStatus
		, CAST('MISSING' AS VARCHAR(50))					AS MobilityStatus12MO

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

	-- Race: proc sets RaceId = -1 for every row -> constant MISSING member
	JOIN RDS.DimRaces										drace
		ON		drace.DimRaceId = -1

	-- English learner (two-step; REAL breakout)
	LEFT JOIN RDS.vwDimEnglishLearnerStatuses				rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses						dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

	-- IDEA indicator: UNCORRELATED 'Yes' member (mirrors the proc's uncorrelated join) -> constant 'IDEA'
	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		rdis.IdeaIndicatorCode = 'Yes'
		AND		rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
		AND		rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
	JOIN RDS.DimIdeaStatuses								dis
		ON		dis.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)

	-- Migrant dim (two-step). ConsolidatedMepFundsStatus is intentionally NOT constrained -> 4-way fan,
	-- exactly as the proc leaves it. The other sub-codes are pinned to MISSING as the proc does.
	LEFT JOIN RDS.vwDimMigrantStatuses						rdms
		ON		rdms.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
		AND		rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING'
		AND		rdms.ContinuationOfServicesReasonCode = 'MISSING'
		AND		rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
		AND		rdms.MigrantPrioritizedForServicesCode = 'MISSING'
	JOIN RDS.DimMigrantStatuses								dms
		ON		dms.DimMigrantStatusId = ISNULL(rdms.DimMigrantStatusId, -1)
