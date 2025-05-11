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

	CREATE TABLE #NeglectedOrDelinquentLongTermStatus (NeglectedOrDelinquentLongTermStatusCode VARCHAR(50), 
	NeglectedOrDelinquentLongTermStatusDescription VARCHAR(100), NeglectedOrDelinquentLongTermStatusEdFactsCode VARCHAR(50))

	INSERT INTO #NeglectedOrDelinquentLongTermStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #NeglectedOrDelinquentLongTermStatus VALUES ('NDLONGTERM', 'Long-Term N or D Students', 'NDLONGTERM')
	   

	INSERT INTO RDS.DimNOrDStatuses
		(
			  NeglectedOrDelinquentProgramTypeCode
			, NeglectedOrDelinquentProgramTypeDescription
			, NeglectedOrDelinquentProgramTypeEdFactsCode
			, NeglectedProgramTypeCode
			, NeglectedProgramTypeDescription
			, NeglectedProgramTypeEdFactsCode
			, DelinquentProgramTypeCode
			, DelinquentProgramTypeDescription
			, DelinquentProgramTypeEdFactsCode
			, NeglectedOrDelinquentLongTermStatusCode
			, NeglectedOrDelinquentLongTermStatusDescription
			, NeglectedOrDelinquentLongTermStatusEdFactsCode
		)
	SELECT ndpt.NeglectedOrDelinquentProgramTypeCode
		, ndpt.NeglectedOrDelinquentProgramTypeDescription
		, ndpt.NeglectedOrDelinquentProgramTypeEdFactsCode
		, npt.NeglectedProgramTypeCode
		, npt.NeglectedProgramTypeDescription
		, npt.NeglectedProgramTypeEdFactsCode
		, dpt.DelinquentProgramTypeCode
		, dpt.DelinquentProgramTypeDescription
		, dpt.DelinquentProgramTypeEdFactsCode
		, longterm.NeglectedOrDelinquentLongTermStatusCode
		, longterm.NeglectedOrDelinquentLongTermStatusDescription
		, longterm.NeglectedOrDelinquentLongTermStatusEdFactsCode
	FROM #NeglectedOrDelinquentProgramType ndpt
	CROSS JOIN #NeglectedProgramType npt
	CROSS JOIN #DelinquentProgramType dpt
	CROSS JOIN #NeglectedOrDelinquentLongTermStatus longterm
	LEFT JOIN RDS.DimNOrDStatuses main
		ON npt.NeglectedProgramTypeCode = main.NeglectedProgramTypeCode
		AND dpt.DelinquentProgramTypeCode = main.DelinquentProgramTypeCode
		AND longterm.NeglectedOrDelinquentLongTermStatusCode = main.NeglectedOrDelinquentLongTermStatusCode
	WHERE main.DimNOrDStatusId IS NULL

	DROP TABLE #NeglectedOrDelinquentProgramType
	DROP TABLE #NeglectedProgramType
	DROP TABLE #DelinquentProgramType
	DROP TABLE #NeglectedOrDelinquentLongTermStatus

