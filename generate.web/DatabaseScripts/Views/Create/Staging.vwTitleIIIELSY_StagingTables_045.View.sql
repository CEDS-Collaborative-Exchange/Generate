CREATE VIEW [Staging].[vwTitleIIIELSY_StagingTables_045]
AS
	-- FS045 - Title III Immigrant, broken out by English Learner Status, Native Language
	-- (ISO 639-2), and Title III Immigrant Status.
	-- Same fact type / population as FS116 (TitleIIIELSY = 10, EnglishLearnerStatus = LEP, Open/New
	-- schools; 199 distinct students for 2027) — only the exposed dimensions differ. Population from
	-- debug.vwTitleIIIELSY_StagingTables. Each dimension is a two-step RDS.vwDim<X> -> RDS.Dim<X> join.
	-- VALIDATED 2026-07-30 against RDS.FactK12StudentCounts (fact type 10) joined to the same dims:
	-- totals and every breakout match (EL LEP = 199; Immigrant MISSING 75 / PART 124; Language ara 1 /
	-- eng 68 / MISSING 119 / rus 3 / spa 6 / swe 2; total 199).
	--
	-- NOTE (fact-side prerequisite for the e2e test): RDS.vwTitleIIIELSY_FactTable_045 currently reads
	-- debug.vwTitleI_FactTable (a copy/paste bug) and exposes no dimension EdFacts-code columns. It must
	-- be repointed to debug.vwTitleIIIELSY_FactTable and surface EnglishLearnerStatusEdFactsCode,
	-- Iso6392LanguageCodeEdFactsCode, and TitleIIIImmigrantStatusEdFactsCode for the actual side to match.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dels.EnglishLearnerStatusEdFactsCode		AS EnglishLearnerStatus
		, dl.Iso6392LanguageCodeEdFactsCode			AS ISO6392LanguageCode
		, dimm.TitleIIIImmigrantStatusEdFactsCode	AS TitleIIIImmigrantStatus

	FROM [debug].[vwTitleIIIELSY_StagingTables]		s

	-- English learner status (LEFT + -1; PerkinsEnglishLearnerStatusCode = MISSING as the proc keys it)
	LEFT JOIN RDS.vwDimEnglishLearnerStatuses		rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses				dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

	-- Native language (ISO 639-2). The proc de-duplicates RDS.vwDimLanguages via MIN(DimLanguageId)
	-- and drops empty maps (isnull(Iso6392LanguageMap,'') <> '') to avoid the MISSING-language fan-out;
	-- reproduced here. Null native language falls to DimLanguageId -1 = 'MISSING'.
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

	-- Title III immigrant status (LEFT + -1; keyed on immigrant status + immigrant-participation status)
	LEFT JOIN RDS.vwDimImmigrantStatuses			rdimm
		ON		rdimm.SchoolYear = s.SchoolYear
		AND		ISNULL(s.TitleIIIImmigrantStatus, -1) = ISNULL(CAST(rdimm.TitleIIIImmigrantStatusMap AS SMALLINT), -1)
		AND		ISNULL(s.TitleIIIImmigrantParticipationStatus, -1) = ISNULL(CAST(rdimm.TitleIIIImmigrantParticipationStatusMap AS SMALLINT), -1)
	JOIN RDS.DimImmigrantStatuses					dimm
		ON		dimm.DimImmigrantStatusId = ISNULL(rdimm.DimImmigrantStatusId, -1)

	-- school operational status Open/New (mirrors the fact view)
	JOIN Staging.K12Organization					scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
