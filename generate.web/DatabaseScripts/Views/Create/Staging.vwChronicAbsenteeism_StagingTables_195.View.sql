CREATE VIEW [Staging].[vwChronicAbsenteeism_StagingTables_195]
AS
	-- FS195 - Chronic Absenteeism (DG695) broken out by 7 demographic dimensions.
	-- Expected-side population for RunEndToEndTest: the count of chronically-absent students
	-- (attended <= 90% of enrolled days) at operational (Open/New) schools, exposing each
	-- student's 7 dimensions as the report's EdFacts codes.
	--
	-- Mirrors Staging.[Staging-to-FactK12StudentCounts_ChronicAbsenteeism] so expected == actual:
	--   * chronic-absentee filter (attendance rate <= 0.9),
	--   * Sex inner via vwDimK12Demographics -> DimK12Demographics,
	--   * Homeless/IDEA/504/EconDis/EL LEFT + -1 NA fallback, each two-step vwDim -> Dim table,
	--     replicating the proc's dim-member-selection '...Code = MISSING' sub-conditions,
	--   * Race unduplicated (vwUnduplicatedRaceMap) with the Hispanic/Latino override,
	--   * school operational status Open/New (the only school filter the FS195 fact view adds).
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, ddemo.SexEdFactsCode							AS Sex
		, drace.RaceEdFactsCode							AS Race
		, dhs.HomelessnessStatusEdFactsCode				AS HomelessnessStatus
		, dis.IdeaIndicatorEdFactsCode					AS IdeaIndicator
		, dds.Section504StatusEdFactsCode				AS Section504Status
		, deds.EconomicDisadvantageStatusEdFactsCode	AS EconomicDisadvantageStatus
		, dels.EnglishLearnerStatusEdFactsCode			AS EnglishLearnerStatus

	FROM [debug].[vwChronicAbsenteeism_StagingTables]		s

	-- Sex (inner, mirrors the proc)
	JOIN RDS.vwDimK12Demographics							rdkd
		ON		rdkd.SchoolYear = s.SchoolYear
		AND		ISNULL(s.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
	JOIN RDS.DimK12Demographics								ddemo
		ON		ddemo.DimK12DemographicId = rdkd.DimK12DemographicId

	-- Homelessness
	LEFT JOIN RDS.vwDimHomelessnessStatuses					rdhs
		ON		rdhs.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
		AND		rdhs.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
		AND		rdhs.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
		AND		rdhs.HomelessServicedIndicatorCode = 'MISSING'
	JOIN RDS.DimHomelessnessStatuses						dhs
		ON		dhs.DimHomelessnessStatusId = ISNULL(rdhs.DimHomelessnessStatusId, -1)

	-- IDEA disability
	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
		AND		rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
		AND		rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
	JOIN RDS.DimIdeaStatuses								dis
		ON		dis.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)

	-- Section 504 (from the debug base's date-windowed value)
	LEFT JOIN RDS.vwDimDisabilityStatuses					rdds
		ON		rdds.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.Section504Status AS SMALLINT), -1) = ISNULL(rdds.Section504StatusMap, -1)
		AND		rdds.DisabilityStatusCode = 'MISSING'
		AND		rdds.DisabilityConditionTypeCode = 'MISSING'
		AND		rdds.DisabilityDeterminationSourceTypeCode = 'MISSING'
	JOIN RDS.DimDisabilityStatuses							dds
		ON		dds.DimDisabilityStatusId = ISNULL(rdds.DimDisabilityStatusId, -1)

	-- Economic disadvantage
	LEFT JOIN RDS.vwDimEconomicallyDisadvantagedStatuses	rdeds
		ON		rdeds.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(rdeds.EconomicDisadvantageStatusMap, -1)
		AND		rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode = 'MISSING'
		AND		rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'MISSING'
	JOIN RDS.DimEconomicallyDisadvantagedStatuses			deds
		ON		deds.DimEconomicallyDisadvantagedStatusId = ISNULL(rdeds.DimEconomicallyDisadvantagedStatusId, -1)

	-- English learner
	LEFT JOIN RDS.vwDimEnglishLearnerStatuses				rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses						dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

	-- Race (unduplicated + Hispanic/Latino override), map -> DimRaces for the EdFacts code
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

	-- school operational status Open/New (only school filter the FS195 fact view applies)
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')

	-- chronic absentee: attended <= 90% of enrolled days
	WHERE	CAST((CASE WHEN s.NumberOfDaysInAttendance = '0' THEN 0
					WHEN s.NumberOfDaysAbsent = '0' THEN 1
					ELSE CAST(s.NumberOfDaysInAttendance AS decimal(5,2)) / CAST(s.NumberOfDaysInAttendance + s.NumberOfDaysAbsent AS decimal(5,2))
				END) AS decimal(5,4)) <= 0.9
