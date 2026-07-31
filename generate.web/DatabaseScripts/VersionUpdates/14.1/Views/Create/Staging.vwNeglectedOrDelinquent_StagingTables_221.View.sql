CREATE VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_221]
AS
	-- FS221 - At-Risk or Delinquent, Subpart 2 (LEA), academic/CTE outcomes attained up to 90 days
	-- AFTER exiting the program. LEA-level. One report dimension:
	-- EdFactsAcademicOrCareerAndTechnicalOutcomeExitType (+ LEA breakout).
	--
	-- Expected-side population for RunEndToEndTest. Mirrors the actual migration
	-- Staging.[Staging-to-FactK12StudentCounts_NeglectedOrDelinquent] exactly so expected == actual
	-- (see Staging.vwNeglectedOrDelinquent_StagingTables_218 for the full recipe notes). This view
	-- exposes the outcome EXIT-type EdFacts code as the report dimension and the LEA identifier for the
	-- LEA-level breakout, and filters to Subpart2.
	--   * report filters mirrored from RDS.vwNeglectedOrDelinquent_FactTable_221:
	--       NeglectedOrDelinquentStatusCode = 'Yes' AND NeglectedOrDelinquentProgramEnrollmentSubpartCode = 'Subpart2'.
	SELECT DISTINCT
		  ske.StudentIdentifierState
		, ske.LEAIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ISNULL(dcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode, 'MISSING')	AS EdFactsAcademicOrCareerAndTechnicalOutcomeExitType

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

	--cte outcome indicators dim (supplies the academic/CTE outcome EXIT-type EdFacts code)
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
		AND	rdnds.NeglectedOrDelinquentProgramEnrollmentSubpartCode = 'Subpart2'
