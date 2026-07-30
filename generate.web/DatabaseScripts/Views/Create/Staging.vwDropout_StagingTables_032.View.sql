CREATE VIEW [Staging].[vwDropout_StagingTables_032]
AS
	-- FS032 - Dropouts (DG522) broken out by 8 demographic dimensions.
	-- Expected-side population for RunEndToEndTest: the count of dropouts (ExitOrWithdrawalType ->
	-- RefExitOrWithdrawalType OutputCode 01927, already applied by debug.vwDropout_StagingTables) at
	-- operational (Open/New) schools, exposing each student's 8 dimensions as the report's EdFacts codes.
	--
	-- Mirrors Staging.[Staging-to-FactK12StudentCounts_Dropout]: overlap status windows are applied in
	-- the debug base; grade is EXIT grade level; each status dim is two-step vwDim -> Dim for the EdFacts
	-- code with the proc's dim-member-selection '...Code = MISSING' sub-conditions; race unduplicated.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, ddemo.SexEdFactsCode							AS Sex
		, dgl.GradeLevelEdFactsCode						AS GradeLevel
		, drace.RaceEdFactsCode							AS Race
		, dhs.HomelessnessStatusEdFactsCode				AS HomelessnessStatus
		, dis.IdeaIndicatorEdFactsCode					AS IdeaIndicator
		, deds.EconomicDisadvantageStatusEdFactsCode	AS EconomicDisadvantageStatus
		, dels.EnglishLearnerStatusEdFactsCode			AS EnglishLearnerStatus
		, dms.MigrantStatusEdFactsCode					AS MigrantStatus

	FROM [debug].[vwDropout_StagingTables]					s

	-- Sex (inner)
	JOIN RDS.vwDimK12Demographics							rdkd
		ON		rdkd.SchoolYear = s.SchoolYear
		AND		ISNULL(s.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
	JOIN RDS.DimK12Demographics								ddemo
		ON		ddemo.DimK12DemographicId = rdkd.DimK12DemographicId

	-- Grade: EXIT grade level (dropout is by exit grade); LEFT + -1 NA fallback like the fact proc
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Exit Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	JOIN RDS.DimGradeLevels									dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

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

	-- Migrant
	LEFT JOIN RDS.vwDimMigrantStatuses						rdms
		ON		rdms.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
		AND		rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING'
		AND		rdms.ContinuationOfServicesReasonCode = 'MISSING'
		AND		rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
		AND		rdms.MigrantPrioritizedForServicesCode = 'MISSING'
		AND		rdms.MEPContinuationOfServicesStatusCode = 'MISSING'
		AND		rdms.ConsolidatedMEPFundsStatusCode = 'MISSING'
	JOIN RDS.DimMigrantStatuses								dms
		ON		dms.DimMigrantStatusId = ISNULL(rdms.DimMigrantStatusId, -1)

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

	-- school operational status Open/New
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
