	----------------------------------------------------
	-- Populate DimCteOutcomeIndicators ---
	----------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimCteOutcomeIndicators d WHERE d.DimCteOutcomeIndicatorId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimCteOutcomeIndicators ON

		INSERT INTO [RDS].DimCteOutcomeIndicators
           ([DimCteOutcomeIndicatorId]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode]
		   ,[PerkinsPostProgramPlacementIndicatorCode]
		   ,[PerkinsPostProgramPlacementIndicatorDescription])
			VALUES (
				  -1
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				)

		SET IDENTITY_INSERT RDS.DimCteOutcomeIndicators OFF
	END

	CREATE TABLE #EdFactsAcademicOrCareerAndTechnicalOutcomeType (EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode VARCHAR(50), EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription VARCHAR(200), EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsAcademicOrCareerAndTechnicalOutcomeType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsAcademicOrCareerAndTechnicalOutcomeType 
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

	CREATE TABLE #EdFactsAcademicOrCareerAndTechnicalOutcomeExitType (EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode VARCHAR(50), EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription VARCHAR(200), EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsAcademicOrCareerAndTechnicalOutcomeExitType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

	CREATE TABLE #PerkinsPostProgramPlacementIndicator (PerkinsPostProgramPlacementIndicatorCode VARCHAR(50), PerkinsPostProgramPlacementIndicatorDescription VARCHAR(200))

	INSERT INTO #PerkinsPostProgramPlacementIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #PerkinsPostProgramPlacementIndicator
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'PerkinsPostProgramPlacementIndicator'

	INSERT INTO RDS.DimCteOutcomeIndicators
		   ([EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription]
		   ,[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode]
		   ,[PerkinsPostProgramPlacementIndicatorCode]
		   ,[PerkinsPostProgramPlacementIndicatorDescription])
	SELECT DISTINCT
		  a.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		, a.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription
		, a.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode
		, b.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		, b.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription
		, b.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
		, c.PerkinsPostProgramPlacementIndicatorCode
		, c.PerkinsPostProgramPlacementIndicatorDescription
	FROM #EdFactsAcademicOrCareerAndTechnicalOutcomeType a
	CROSS JOIN #EdFactsAcademicOrCareerAndTechnicalOutcomeExitType b
	CROSS JOIN #PerkinsPostProgramPlacementIndicator c
	LEFT JOIN RDS.DimCteOutcomeIndicators main
		ON a.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = main.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		AND b.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = main.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		AND c.PerkinsPostProgramPlacementIndicatorCode = main.PerkinsPostProgramPlacementIndicatorCode
	WHERE main.DimCteOutcomeIndicatorId IS NULL

	DROP TABLE #EdFactsAcademicOrCareerAndTechnicalOutcomeType
	DROP TABLE #EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
	DROP TABLE #PerkinsPostProgramPlacementIndicator
