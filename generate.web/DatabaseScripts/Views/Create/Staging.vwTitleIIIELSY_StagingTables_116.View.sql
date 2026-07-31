CREATE VIEW [Staging].[vwTitleIIIELSY_StagingTables_116]
AS
	-- FS116 - Title III Students Served, broken out by Grade Level, Title III Language Instruction
	-- Program Type, and Race.
	-- Mirrors RDS.vwTitleIIIELSY_FactTable_116 (fact type TitleIIIELSY = 10, EnglishLearnerStatus = LEP,
	-- Open/New schools). Population from debug.vwTitleIIIELSY_StagingTables (= the fact proc's population,
	-- 199 distinct students for 2027). Each dimension is a two-step join: RDS.vwDim<X> (raw -> Map/Code)
	-- then the RDS.Dim<X> table (-> EdFactsCode), exposing one column per report DimensionFieldName.
	-- VALIDATED 2026-07-30: distinct-student totals and every per-dimension breakout match the fact side
	-- exactly (Grade 17 buckets, LIEP 6 buckets, Race 7 buckets; total 199).
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode								AS GradeLevel
		, dt3.TitleIIILanguageInstructionProgramTypeEdFactsCode	AS TitleIIILanguageInstructionProgramType
		, drace.RaceEdFactsCode									AS Race

	FROM [debug].[vwTitleIIIELSY_StagingTables]				s

	-- Grade (Entry Grade Level, LEFT + -1)
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	LEFT JOIN RDS.DimGradeLevels							dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	-- Title III status (LIEP program type). Keyed exactly as the fact proc keys #vwTitleIIIStatuses:
	-- immigrant-participation (from raw TitleIIIImmigrantStatus), LIEP type, proficiency, and
	-- accountability progress, with ProgramParticipationTitleIIILiepCode = 'MISSING'.
	LEFT JOIN RDS.vwDimTitleIIIStatuses						rdt3
		ON		rdt3.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.TitleIIIImmigrantStatus AS INT), -1) = ISNULL(CAST(rdt3.TitleIIIImmigrantParticipationStatusMap AS SMALLINT), -1)
		AND		ISNULL(s.TitleIIILanguageInstructionProgramType, 'MISSING') = ISNULL(rdt3.TitleIIILanguageInstructionProgramTypeMap, rdt3.TitleIIILanguageInstructionProgramTypeCode)
		AND		ISNULL(s.Proficiency_TitleIII, 'MISSING') = ISNULL(rdt3.ProficiencyStatusMap, rdt3.ProficiencyStatusCode)
		AND		ISNULL(s.TitleIIIAccountabilityProgressStatus, 'MISSING') = ISNULL(rdt3.TitleIIIAccountabilityProgressStatusMap, rdt3.TitleIIIAccountabilityProgressStatusCode)
		AND		rdt3.ProgramParticipationTitleIIILiepCode = 'MISSING'
	JOIN RDS.DimTitleIIIStatuses							dt3
		ON		dt3.DimTitleIIIStatusId = ISNULL(rdt3.DimTitleIIIStatusId, -1)

	-- Race (unduplicated + Hispanic/Latino override)
	LEFT JOIN RDS.vwUnduplicatedRaceMap						spr
		ON		spr.SchoolYear = s.SchoolYear
		AND		spr.StudentIdentifierState = s.StudentIdentifierState
		AND		(spr.SchoolIdentifierSea = s.SchoolIdentifierSea
				OR spr.LeaIdentifierSeaAccountability = s.LEAIdentifierSeaAccountability)
	LEFT JOIN RDS.vwDimRaces									rdr
		ON		rdr.SchoolYear = s.SchoolYear
		AND		ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						WHEN s.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END
	JOIN RDS.DimRaces										drace
		ON		drace.DimRaceId = ISNULL(rdr.DimRaceId, -1)

	-- school operational status Open/New (mirrors the fact view)
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
