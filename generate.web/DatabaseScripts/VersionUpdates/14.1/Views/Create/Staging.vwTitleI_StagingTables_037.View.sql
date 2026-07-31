CREATE VIEW [Staging].[vwTitleI_StagingTables_037]
AS
	-- FS037 - Title I participation, broken out by English Learner, Homelessness, IDEA Indicator,
	-- Migrant Status, Race. Mirrors RDS.vwTitleI_FactTable_037 (Title I participants at Open/New schools).
	-- Requires the debug.vwTitleI_StagingTables EL/Homeless/IDEA/Migrant dim windows to be aligned to
	-- the titleI fact proc's overlap window (see the base view's 14.1 edits).
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dels.EnglishLearnerStatusEdFactsCode			AS EnglishLearnerStatus
		, dhs.HomelessnessStatusEdFactsCode				AS HomelessnessStatus
		, dis.IdeaIndicatorEdFactsCode					AS IdeaIndicator
		, dms.MigrantStatusEdFactsCode					AS MigrantStatus
		, drace.RaceEdFactsCode							AS Race

	FROM [debug].[vwTitleI_StagingTables]					s

	-- English learner
	LEFT JOIN RDS.vwDimEnglishLearnerStatuses				rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses						dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

	-- Homelessness (status only; nighttime/unaccompanied/serviced = MISSING per the fact proc)
	LEFT JOIN RDS.vwDimHomelessnessStatuses					rdhs
		ON		rdhs.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
		AND		rdhs.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
		AND		rdhs.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
		AND		rdhs.HomelessServicedIndicatorCode = 'MISSING'
	JOIN RDS.DimHomelessnessStatuses						dhs
		ON		dhs.DimHomelessnessStatusId = ISNULL(rdhs.DimHomelessnessStatusId, -1)

	-- IDEA indicator (environments + exit reason MISSING per the fact proc)
	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
		AND		rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
		AND		rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
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

	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
