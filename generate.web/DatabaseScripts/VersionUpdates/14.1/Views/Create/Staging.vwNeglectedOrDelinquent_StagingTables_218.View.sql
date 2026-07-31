CREATE VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_218]
AS
	-- FS218 - Neglected or Delinquent, Subpart 1 (State Agency), academic/CTE outcomes attained
	-- WHILE enrolled. SEA-level. One report dimension: EdFactsAcademicOrCareerAndTechnicalOutcomeType.
	--
	-- Expected-side population for RunEndToEndTest. Mirrors the actual migration
	-- Staging.[Staging-to-FactK12StudentCounts_NeglectedOrDelinquent] exactly so expected == actual:
	--   * same K12Enrollment -> K12Organization (LEA_IsReportedFederally = 1) -> DimSchoolYears -> DimSeas
	--     -> ProgramParticipationNOrD join (student + org + program-start within enrollment window),
	--   * NOrDStatus resolved through RDS.vwDimNOrDStatuses on the same status / subpart / program-type /
	--     achievement / outcome indicator maps the fact proc uses (supplies StatusCode + SubpartCode),
	--   * the academic/CTE outcome-type EdFacts code resolved through RDS.vwDimCteOutcomeIndicators
	--     (matched on OutcomeType + OutcomeExitType + Perkins post-program placement = MISSING) to get the
	--     DimCteOutcomeIndicatorId, then RDS.DimCteOutcomeIndicators for its EdFacts code -- exactly the
	--     path debug.vwNeglectedOrDelinquent_FactTable reads via Fact.CteOutcomeIndicatorId,
	--   * LEA operational-status exclusion (Closed / FutureAgency / Inactive / MISSING),
	--   * report filters mirrored from RDS.vwNeglectedOrDelinquent_FactTable_218:
	--       NeglectedOrDelinquentStatusCode = 'Yes' AND NeglectedOrDelinquentProgramEnrollmentSubpartCode = 'Subpart1'.
	SELECT DISTINCT
		  ske.StudentIdentifierState
		, ske.LEAIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ISNULL(dcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode, 'MISSING')	AS EdFactsAcademicOrCareerAndTechnicalOutcomeType

	FROM Staging.K12Enrollment							ske

	JOIN Staging.K12Organization						sko
		ON		ISNULL(ske.LeaIdentifierSeaAccountability, '')	= ISNULL(sko.LeaIdentifierSea, '')
		AND		ISNULL(ske.SchoolIdentifierSea, '')				= ISNULL(sko.SchoolIdentifierSea, '')
		AND		sko.LEA_IsReportedFederally = 1

	JOIN RDS.DimSchoolYears								rsy
		ON		ske.SchoolYear = rsy.SchoolYear

	JOIN RDS.DimSeas									rds
		ON		ske.EnrollmentEntryDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, staging.GetFiscalYearEndDate(ske.SchoolYear))

	--neglected or delinquent (raw staging)
	JOIN Staging.ProgramParticipationNOrD				sppnord
		ON		ske.SchoolYear										= sppnord.SchoolYear
		AND		ske.StudentIdentifierState							= sppnord.StudentIdentifierState
		AND		ISNULL(ske.LeaIdentifierSeaAccountability, '')		= ISNULL(sppnord.LeaIdentifierSeaAccountability, '')
		AND		ISNULL(ske.SchoolIdentifierSea, '')					= ISNULL(sppnord.SchoolIdentifierSea, '')
		AND		sppnord.ProgramParticipationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear))

	--neglected or delinquent status dim (supplies StatusCode + SubpartCode)
	JOIN RDS.vwDimNOrDStatuses							rdnds
		ON		rdnds.SchoolYear = ske.SchoolYear
		AND		ISNULL(TRY_CAST(sppnord.NeglectedOrDelinquentStatus AS SMALLINT), -1)			= ISNULL(rdnds.NeglectedOrDelinquentStatusMap, -1)
		AND		ISNULL(TRY_CAST(sppnord.NeglectedOrDelinquentLongTermStatus AS SMALLINT), -1)	= ISNULL(rdnds.NeglectedOrDelinquentLongTermStatusMap, -1)
		AND		ISNULL(sppnord.NeglectedOrDelinquentProgramType, 'MISSING')						= ISNULL(rdnds.NeglectedOrDelinquentProgramTypeMap, rdnds.NeglectedOrDelinquentProgramTypeCode)
		AND		ISNULL(sppnord.NeglectedProgramType, 'MISSING')									= ISNULL(rdnds.NeglectedProgramTypeMap, rdnds.NeglectedProgramTypeCode)
		AND		ISNULL(sppnord.DelinquentProgramType, 'MISSING')									= ISNULL(rdnds.DelinquentProgramTypeMap, rdnds.DelinquentProgramTypeCode)
		AND		ISNULL(sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart, 'MISSING')			= ISNULL(rdnds.NeglectedOrDelinquentProgramEnrollmentSubpartMap, rdnds.NeglectedOrDelinquentProgramEnrollmentSubpartCode)
		AND		ISNULL(TRY_CAST(sppnord.NeglectedOrDelinquentAcademicAchievementIndicator AS SMALLINT), -1)	= ISNULL(rdnds.NeglectedOrDelinquentAcademicAchievementIndicatorMap, -1)
		AND		ISNULL(TRY_CAST(sppnord.NeglectedOrDelinquentAcademicOutcomeIndicator AS SMALLINT), -1)		= ISNULL(rdnds.NeglectedOrDelinquentAcademicOutcomeIndicatorMap, -1)

	--cte outcome indicators dim (supplies the academic/CTE outcome-type EdFacts code)
	LEFT JOIN RDS.vwDimCteOutcomeIndicators				rdcoi
		ON		rdcoi.SchoolYear = ske.SchoolYear
		AND		ISNULL(sppnord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, 'MISSING')		= ISNULL(rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap, rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode)
		AND		ISNULL(sppnord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, 'MISSING')	= ISNULL(rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap, rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode)
		AND		ISNULL(rdcoi.PerkinsPostProgramPlacementIndicatorCode, 'MISSING') = 'MISSING'

	LEFT JOIN RDS.DimCteOutcomeIndicators				dcoi
		ON		dcoi.DimCteOutcomeIndicatorId = ISNULL(rdcoi.DimCteOutcomeIndicatorId, -1)

	--lea operational status
	LEFT JOIN Staging.SourceSystemReferenceData			sssrd
		ON		sko.SchoolYear			= sssrd.SchoolYear
		AND		sko.LEA_OperationalStatus	= sssrd.InputCode
		AND		sssrd.Tablename			= 'RefOperationalStatus'
		AND		sssrd.TableFilter		= '000174'

	WHERE	sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart IS NOT NULL
		AND	sppnord.NeglectedOrDelinquentStatus = 1
		AND	sssrd.OutputCode NOT IN ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
		AND	rdnds.NeglectedOrDelinquentStatusCode = 'Yes'
		AND	rdnds.NeglectedOrDelinquentProgramEnrollmentSubpartCode = 'Subpart1'
