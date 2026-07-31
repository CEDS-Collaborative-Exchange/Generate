CREATE VIEW [Staging].[vwTitleIIIELOct_StagingTables_141]
AS
	-- FS141 - Title III EL Enrolled (October count), broken out by Grade Level, Native Language
	-- (ISO 639-2), Race, and IDEA Indicator. Org levels SEA / LEA / School.
	-- Mirrors RDS.vwTitleIIIELOct_FactTable_141 (fact type TitleIIIELOct = 9, EnglishLearnerStatus = LEP
	-- as of the Oct reporting date, K-12 grades, Open/New schools). Population from
	-- debug.vwTitleIIIELOct_StagingTables (= the proc population, 316); Open/New here brings it to 315.
	-- Each dimension is a two-step RDS.vwDim<X> -> RDS.Dim<X> join.
	--
	-- VALIDATED 2026-07-30: Grade, Race, and IdeaIndicator breakouts match the fact side exactly
	-- (total 315; Grade 15 buckets, Race 7 buckets, Idea IDEA 30 / MISSING 285).
	--
	-- LANGUAGE CAVEAT (category set CSB): the ISO6392LanguageCode column below is built CORRECTLY (one
	-- language per student via the MIN(DimLanguageId) + non-empty-map de-dup). However the ELOct fact
	-- proc's #vwLanguages OMITS the "isnull(Iso6392LanguageMap,'') <> ''" guard that the ELSY proc has,
	-- so on the ACTUAL side every null-native-language student fans across ~95 language codes (each
	-- language shows ~169 students). Until the proc is fixed (add that guard to #vwLanguages), CSB will
	-- NOT match. CSA/CSC/CSD (Grade/Language-excluded/Race/Idea) are unaffected.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode				AS GradeLevel
		, dl.Iso6392LanguageCodeEdFactsCode		AS ISO6392LanguageCode
		, drace.RaceEdFactsCode					AS Race
		, dis.IdeaIndicatorEdFactsCode			AS IdeaIndicator

	FROM [debug].[vwTitleIIIELOct_StagingTables]			s

	-- Grade (Entry Grade Level, LEFT + -1)
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	LEFT JOIN RDS.DimGradeLevels							dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	-- Native language (ISO 639-2), de-duplicated (see LANGUAGE CAVEAT above)
	LEFT JOIN (
		SELECT MIN(DimLanguageId) AS DimLanguageId, SchoolYear, Iso6392LanguageMap
		FROM RDS.vwDimLanguages
		WHERE ISNULL(Iso6392LanguageMap, '') <> ''
		GROUP BY SchoolYear, Iso6392LanguageMap
	)												rdvl
		ON		rdvl.SchoolYear = s.SchoolYear
		AND		ISNULL(s.ISO_639_2_NativeLanguage, 'MISSING') = ISNULL(rdvl.Iso6392LanguageMap, 'MISSING')
	LEFT JOIN RDS.DimLanguages						dl
		ON		dl.DimLanguageId = ISNULL(rdvl.DimLanguageId, -1)

	-- IDEA indicator (LEFT + -1; environments + exit reason = MISSING, as the proc keys it)
	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.IDEAIndicator AS SMALLINT), -1) = ISNULL(CAST(rdis.IdeaIndicatorMap AS SMALLINT), -1)
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
		AND		rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
		AND		rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
	JOIN RDS.DimIdeaStatuses								dis
		ON		dis.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)

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
