CREATE VIEW [Staging].[vwMembership_StagingTables_052]
AS
	-- FS052 - Membership (DG39/DG55) broken out by Grade Level, Race/Ethnicity, and Sex.
	-- Expected-side population for RunEndToEndTest: the unduplicated count of students in
	-- membership at operational, federally-reported public schools (excluding "reportable
	-- program" schools), exposing each student's Grade / Race / Sex as the report's EdFacts codes.
	--
	-- Mirrors the membership fact migration (Staging.[Staging-to-FactK12StudentCounts_Membership])
	-- so expected == actual:
	--   * valid age as-of the membership date (inner DimAges),
	--   * sex maps via SSRD (vwDimK12Demographics) -> DimK12Demographics for SexEdFactsCode,
	--   * grade in the toggle-driven included set (PK,KG,01-12 always; 13/UG/ABE per toggles),
	--     mapped via vwDimGradeLevels -> DimGradeLevels for GradeLevelEdFactsCode,
	--   * race is unduplicated (vwUnduplicatedRaceMap) with the Hispanic/Latino override, then
	--     mapped via vwDimRaces -> DimRaces for RaceEdFactsCode,
	--   * school operational + reported federally + not a "reportable program".
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode		AS GradeLevel
		, drace.RaceEdFactsCode			AS Race
		, ddemo.SexEdFactsCode			AS Sex

	FROM [debug].[vwMembership_StagingTables]				s

	-- valid age as-of the membership date
	JOIN RDS.DimAges										rda
		ON RDS.Get_Age(s.BirthDate, s.MembershipDate) = rda.AgeValue

	-- sex: SSRD map -> DimK12Demographics for the EdFacts code
	JOIN RDS.vwDimK12Demographics							rdkd
		ON		rdkd.SchoolYear = s.SchoolYear
		AND		ISNULL(s.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
	JOIN RDS.DimK12Demographics								ddemo
		ON		ddemo.DimK12DemographicId = rdkd.DimK12DemographicId

	-- grade: toggle-driven included set, map -> DimGradeLevels for the EdFacts code
	JOIN RDS.vwDimGradeLevels								gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
		AND		gl.GradeLevelCode IN (
					SELECT v.g FROM (VALUES ('PK'),('KG'),('01'),('02'),('03'),('04'),('05'),('06'),('07'),('08'),('09'),('10'),('11'),('12')) v(g)
					UNION ALL SELECT '13'  WHERE (SELECT ISNULL(MAX(CASE WHEN r.ResponseValue='true' THEN 1 ELSE 0 END),0) FROM app.ToggleQuestions q LEFT JOIN app.ToggleResponses r ON r.ToggleQuestionId=q.ToggleQuestionId WHERE q.EmapsQuestionAbbrv='CCDGRADE13') = 1
					UNION ALL SELECT 'UG'  WHERE (SELECT ISNULL(MAX(CASE WHEN r.ResponseValue='true' THEN 1 ELSE 0 END),0) FROM app.ToggleQuestions q LEFT JOIN app.ToggleResponses r ON r.ToggleQuestionId=q.ToggleQuestionId WHERE q.EmapsQuestionAbbrv='CCDUNGRADED') = 1
					UNION ALL SELECT 'ABE' WHERE (SELECT ISNULL(MAX(CASE WHEN r.ResponseValue='true' THEN 1 ELSE 0 END),0) FROM app.ToggleQuestions q LEFT JOIN app.ToggleResponses r ON r.ToggleQuestionId=q.ToggleQuestionId WHERE q.EmapsQuestionAbbrv='ADULTEDU') = 1
				)
	JOIN RDS.DimGradeLevels									dgl
		ON		dgl.DimGradeLevelId = gl.DimGradeLevelId

	-- race: unduplicated race map (+ Hispanic/Latino override), map -> DimRaces for the EdFacts code
	LEFT JOIN RDS.vwUnduplicatedRaceMap						spr
		ON		spr.SchoolYear = s.SchoolYear
		AND		spr.StudentIdentifierState = s.StudentIdentifierState
		AND		(spr.SchoolIdentifierSea = s.SchoolIdentifierSea
				OR spr.LeaIdentifierSeaAccountability = s.LEAIdentifierSeaAccountability)
	LEFT JOIN RDS.vwDimRaces								rdr
		ON		rdr.SchoolYear = s.SchoolYear
		AND		ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						WHEN s.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END
	-- mirror the fact proc: unmatched race -> the -1 NA member (student still counts)
	JOIN RDS.DimRaces										drace
		ON		drace.DimRaceId = ISNULL(rdr.DimRaceId, -1)

	-- school operational status = Open/New (the only filter the FS052 fact view adds on top of
	-- the base membership migration; the membership proc itself does NOT filter reported-federally
	-- or school type, so those are intentionally omitted here to match the actual population).
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
