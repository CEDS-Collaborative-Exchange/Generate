CREATE VIEW [Staging].[vwHomeless_StagingTables_118]
AS
	-- FS118 - Homeless Enrolled, broken out by English Learner, Grade Level, Homeless Primary Nighttime
	-- Residence, Homeless Unaccompanied Youth Status, IDEA Indicator, Migrant Status, Race.
	-- Mirrors RDS.vwHomeless_FactTable_118: homeless-ENROLLED students (HomelessnessStatusEdFactsCode
	-- = 'HOMELSENRL') at operational (Open/New) schools. The homeless combined dim supplies the
	-- nighttime-residence + unaccompanied-youth breakouts.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dels.EnglishLearnerStatusEdFactsCode					AS EnglishLearnerStatus
		, dgl.GradeLevelEdFactsCode								AS GradeLevel
		, dhs.HomelessPrimaryNighttimeResidenceEdFactsCode		AS HomelessPrimaryNighttimeResidence
		, dhs.HomelessUnaccompaniedYouthStatusEdFactsCode		AS HomelessUnaccompaniedYouthStatus
		, dis.IdeaIndicatorEdFactsCode							AS IdeaIndicator
		, dms.MigrantStatusEdFactsCode							AS MigrantStatus
		, drace.RaceEdFactsCode									AS Race

	FROM [debug].[vwHomeless_StagingTables]					s

	-- homeless combined dim (status + nighttime residence + unaccompanied youth + serviced)
	LEFT JOIN RDS.vwDimHomelessnessStatuses					rdhs
		ON		rdhs.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
		AND		ISNULL(s.HomelessNightTimeResidence, 'MISSING') = ISNULL(rdhs.HomelessPrimaryNighttimeResidenceMap, rdhs.HomelessPrimaryNighttimeResidenceCode)
		AND		ISNULL(CAST(s.HomelessUnaccompaniedYouth AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessUnaccompaniedYouthStatusMap AS SMALLINT), -1)
		AND		ISNULL(CAST(s.HomelessServicedIndicator AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessServicedIndicatorMap AS SMALLINT), -1)
	JOIN RDS.DimHomelessnessStatuses						dhs
		ON		dhs.DimHomelessnessStatusId = ISNULL(rdhs.DimHomelessnessStatusId, -1)

	-- Grade (Entry, LEFT + -1)
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	LEFT JOIN RDS.DimGradeLevels							dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	-- IDEA indicator (exit reason + environments MISSING; indicator determines the EdFacts code)
	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
		AND		ISNULL(s.IDEAEducationalEnvironmentForEarlyChildhood, 'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
		AND		ISNULL(s.IDEAEducationalEnvironmentForSchoolAge, 'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, rdis.IdeaEducationalEnvironmentForSchoolAgeCode)
	JOIN RDS.DimIdeaStatuses								dis
		ON		dis.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)

	-- Migrant
	LEFT JOIN RDS.vwDimMigrantStatuses						rdms
		ON		rdms.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
		AND		rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING'
		AND		rdms.ContinuationOfServicesReasonCode = 'MISSING'
		AND		rdms.MEPContinuationOfServicesStatusCode = 'MISSING'
		AND		rdms.ConsolidatedMEPFundsStatusCode = 'MISSING'
		AND		rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
		AND		rdms.MigrantPrioritizedForServicesCode = 'MISSING'
	JOIN RDS.DimMigrantStatuses								dms
		ON		dms.DimMigrantStatusId = ISNULL(rdms.DimMigrantStatusId, -1)

	-- English learner
	LEFT JOIN RDS.vwDimEnglishLearnerStatuses				rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses						dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

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

	-- school operational + homeless-ENROLLED (mirrors the FS118 fact view)
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
	WHERE	dhs.HomelessnessStatusEdFactsCode = 'HOMELSENRL'
