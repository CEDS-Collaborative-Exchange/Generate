	------------------------------------------------
	-- Populate DimNOrDStatuses			 ---
	------------------------------------------------

	CREATE TABLE #NeglectedOrDelinquentProgramType (NeglectedOrDelinquentProgramTypeCode VARCHAR(50), NeglectedOrDelinquentProgramTypeDescription VARCHAR(200), NeglectedOrDelinquentProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #NeglectedOrDelinquentProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #NeglectedOrDelinquentProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode
			WHEN 'AdultCorrection' THEN 'ADLTCORR'
			WHEN 'AtRiskPrograms' THEN 'ATRISK'
			WHEN 'JuvenileCorrection' THEN 'JUVCORR'
			WHEN 'JuvenileDetention' THEN 'JUVDET'
			WHEN 'NeglectedPrograms' THEN 'NEGLECT'
			WHEN 'OtherPrograms' THEN 'OTHER'
		END
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'


	CREATE TABLE #NeglectedProgramType (NeglectedProgramTypeCode VARCHAR(50), NeglectedProgramTypeDescription VARCHAR(200), NeglectedProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #NeglectedProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #NeglectedProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'NeglectedProgramType'

	CREATE TABLE #DelinquentProgramType (DelinquentProgramTypeCode VARCHAR(50), DelinquentProgramTypeDescription VARCHAR(200), DelinquentProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #DelinquentProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #DelinquentProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'DelinquentProgramType'

	--Insert the default row for N or D Status = NO
	INSERT INTO RDS.DimNOrDStatuses (
		[NeglectedOrDelinquentStatusCode]
		, [NeglectedOrDelinquentStatusDescription]
		, [NeglectedOrDelinquentProgramTypeCode]
		, [NeglectedOrDelinquentProgramTypeDescription]
		, [NeglectedOrDelinquentProgramTypeEdFactsCode]
		, [NeglectedOrDelinquentLongTermStatusCode]
		, [NeglectedOrDelinquentLongTermStatusDescription]
		, [NeglectedOrDelinquentLongTermStatusEdFactsCode]
		, [NeglectedOrDelinquentProgramEnrollmentSubpartCode]
		, [NeglectedOrDelinquentProgramEnrollmentSubpartDescription]
		, [NeglectedProgramTypeCode]
		, [NeglectedProgramTypeDescription]
		, [NeglectedProgramTypeEdFactsCode]
		, [DelinquentProgramTypeCode]
		, [DelinquentProgramTypeDescription]
		, [DelinquentProgramTypeEdFactsCode]
		, [NeglectedOrDelinquentAcademicAchievementIndicatorCode]
		, [NeglectedOrDelinquentAcademicAchievementIndicatorDescription]
		, [NeglectedOrDelinquentAcademicOutcomeIndicatorCode]
		, [NeglectedOrDelinquentAcademicOutcomeIndicatorDescription]
	)
	VALUES('No', 'No', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

	INSERT INTO RDS.DimNOrDStatuses (
		[NeglectedOrDelinquentStatusCode]
		, [NeglectedOrDelinquentStatusDescription]
		, [NeglectedOrDelinquentProgramTypeCode]
		, [NeglectedOrDelinquentProgramTypeDescription]
		, [NeglectedOrDelinquentProgramTypeEdFactsCode]
		, [NeglectedOrDelinquentLongTermStatusCode]
		, [NeglectedOrDelinquentLongTermStatusDescription]
		, [NeglectedOrDelinquentLongTermStatusEdFactsCode]
		, [NeglectedOrDelinquentProgramEnrollmentSubpartCode]
		, [NeglectedOrDelinquentProgramEnrollmentSubpartDescription]
		, [NeglectedProgramTypeCode]
		, [NeglectedProgramTypeDescription]
		, [NeglectedProgramTypeEdFactsCode]
		, [DelinquentProgramTypeCode]
		, [DelinquentProgramTypeDescription]
		, [DelinquentProgramTypeEdFactsCode]
		, [NeglectedOrDelinquentAcademicAchievementIndicatorCode]
		, [NeglectedOrDelinquentAcademicAchievementIndicatorDescription]
		, [NeglectedOrDelinquentAcademicOutcomeIndicatorCode]
		, [NeglectedOrDelinquentAcademicOutcomeIndicatorDescription]
	)
	SELECT 		
		NorD.CedsOptionSetCode
		, NorD.CedsOptionSetDescription
		, ndpt.NeglectedOrDelinquentProgramTypeCode
		, ndpt.NeglectedOrDelinquentProgramTypeDescription
		, ndpt.NeglectedOrDelinquentProgramTypeEdFactsCode
		, NorDLongTerm.CedsOptionSetCode	
		, NorDLongTerm.CedsOptionSetDescription
		, NorDLongTerm.EdFactsCode	
		, NorDSubpart.CedsOptionSetCode	
		, NorDSubpart.CedsOptionSetDescription
		, npt.NeglectedProgramTypeCode
		, npt.NeglectedProgramTypeDescription
		, npt.NeglectedProgramTypeEdFactsCode
		, dpt.DelinquentProgramTypeCode
		, dpt.DelinquentProgramTypeDescription
		, dpt.DelinquentProgramTypeEdFactsCode
		, NorDAcademicAchievement.CedsOptionSetCode	
		, NorDAcademicAchievement.CedsOptionSetDescription
		, NorDAcademicOutcome.CedsOptionSetCode	
		, NorDAcademicOutcome.CedsOptionSetDescription
	FROM (VALUES('Yes', 'N or D student'),('MISSING', 'MISSING')) NorD(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN (VALUES('NDLONGTERM', 'Long-Term N or D Students', 'NDLONGTERM'),('MISSING', 'MISSING', 'MISSING')) NorDLongTerm(CedsOptionSetCode, CedsOptionSetDescription, EdFactsCode)
	CROSS JOIN (VALUES('Subpart1', 'Subpart 1'),('Subpart2', 'Subpart 2'),('MISSING', 'MISSING')) NorDSubpart(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN (VALUES('Yes', 'Yes'),('No', 'No'),('MISSING', 'MISSING')) NorDAcademicAchievement(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN (VALUES('Yes', 'Yes'),('No', 'No'),('MISSING', 'MISSING')) NorDAcademicOutcome(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN #NeglectedOrDelinquentProgramType ndpt
	CROSS JOIN #NeglectedProgramType npt
	CROSS JOIN #DelinquentProgramType dpt
	LEFT JOIN RDS.DimNOrDStatuses dnds
		ON NorD.CedsOptionSetCode = dnds.NeglectedOrDelinquentStatusCode
		AND ndpt.NeglectedOrDelinquentProgramTypeCode = dnds.NeglectedOrDelinquentProgramTypeCode
		AND NorDLongTerm.CedsOptionSetCode = dnds.NeglectedOrDelinquentLongTermStatusCode
		AND NorDSubpart.CedsOptionSetCode = dnds.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		AND npt.NeglectedProgramTypeCode = dnds.NeglectedProgramTypeCode
		AND dpt.DelinquentProgramTypeCode = dnds.DelinquentProgramTypeCode
		AND NorDAcademicAchievement.CedsOptionSetCode = dnds.NeglectedOrDelinquentAcademicAchievementIndicatorCode
		AND NorDAcademicOutcome.CedsOptionSetCode = dnds.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
	WHERE dnds.DimNOrDStatusId IS NULL
	AND NorD.CedsOptionSetCode = 'Yes'

	DROP TABLE #NeglectedOrDelinquentProgramType
	DROP TABLE #NeglectedProgramType
	DROP TABLE #DelinquentProgramType


