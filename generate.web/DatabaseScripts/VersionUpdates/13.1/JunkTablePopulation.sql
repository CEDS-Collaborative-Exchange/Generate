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


	----------------------------------------------------
	-- Populate DimSchoolPerformanceIndicatorCategories
	----------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimSchoolPerformanceIndicatorCategories d WHERE d.DimSchoolPerformanceIndicatorCategoryId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimSchoolPerformanceIndicatorCategories ON

		INSERT INTO RDS.DimSchoolPerformanceIndicatorCategories (
			[DimSchoolPerformanceIndicatorCategoryId]
			, [SchoolPerformanceIndicatorCategoryCode]
			, [SchoolPerformanceIndicatorCategoryDescription]
			, [SchoolPerformanceIndicatorCategoryEdFactsCode]
		)	
		VALUES (
			-1
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
		)

		SET IDENTITY_INSERT RDS.DimSchoolPerformanceIndicatorCategories OFF
	END

	--Insert the rest of the values
	INSERT INTO [RDS].DimSchoolPerformanceIndicatorCategories (
		[SchoolPerformanceIndicatorCategoryCode]
		, [SchoolPerformanceIndicatorCategoryDescription]
		, [SchoolPerformanceIndicatorCategoryEdFactsCode]
	)	
	VALUES 
		('GRM',	'Graduation Rate Measure', 'GRADRSTAT'),
		('AAM',	'Academic Achievement Measure', 'ACHIVSTAT'),
		('OAM',	'Other Academic Measure', 'OTHESTAT'),
		('IND',	'School Quality and Student Success Measure', 'INDQUALSTAT'),
		('PAELP', 'Progress Achieving English Language Proficiency Measure', 'ENGLANSTA')

	----------------------------------------------------
	-- Populate DimSchoolPerformanceIndicators		 ---
	----------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimSchoolPerformanceIndicators d WHERE d.DimSchoolPerformanceIndicatorId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimSchoolPerformanceIndicators ON

		INSERT INTO [RDS].DimSchoolPerformanceIndicators (
			[DimSchoolPerformanceIndicatorId]
			, [SchoolPerformanceIndicatorTypeCode]
      		, [SchoolPerformanceIndicatorTypeDescription]
      		, [SchoolPerformanceIndicatorTypeEdFactsCode]
		)	
		VALUES (
			-1
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
		)

		SET IDENTITY_INSERT RDS.DimSchoolPerformanceIndicators OFF
	END

	--Insert the rest of the values
	INSERT INTO [RDS].DimSchoolPerformanceIndicators (
		[SchoolPerformanceIndicatorTypeCode]
		, [SchoolPerformanceIndicatorTypeDescription]
		, [SchoolPerformanceIndicatorTypeEdFactsCode]
	)	
	VALUES 
		('GRM01',	'Graduation Rate Measure 1',									'GRM01'),
		('GRM02',	'Graduation Rate Measure 2',									'GRM02'),
		('GRM03',	'Graduation Rate Measure 3',									'GRM03'),
		('AAM01',	'Academic Achievement Measure 1',								'AAM01'),
		('AAM02',	'Academic Achievement Measure 2',								'AAM02'),
		('AAM03',	'Academic Achievement Measure 3',								'AAM03'),
		('AAM04',	'Academic Achievement Measure 4',								'AAM04'),
		('AAM05',	'Academic Achievement Measure 5',								'AAM05'),
		('AAM06',	'Academic Achievement Measure 6',								'AAM06'),
		('OAM01',	'Other Academic Measure 1',										'OAM01'),
		('OAM02',	'Other Academic Measure 2',										'OAM02'),
		('OAM03',	'Other Academic Measure 3',										'OAM03'),
		('OAM04',	'Other Academic Measure 4',										'OAM04'),
		('OAM05',	'Other Academic Measure 5',										'OAM05'),
		('OAM06',	'Other Academic Measure 6',										'OAM06'),
		('IND01',	'School Quality and Student Success Measure 1',					'IND01'),
		('IND02',	'School Quality and Student Success Measure 2',					'IND02'),
		('IND03',	'School Quality and Student Success Measure 3',					'IND03'),
		('IND04',	'School Quality and Student Success Measure 4',					'IND04'),
		('IND05',	'School Quality and Student Success Measure 5',					'IND05'),
		('IND06',	'School Quality and Student Success Measure 6',					'IND06'),			
		('IND07',	'School Quality and Student Success Measure 7',					'IND07'),
		('IND08',	'School Quality and Student Success Measure 8',					'IND08'),
		('IND09',	'School Quality and Student Success Measure 9',					'IND09'),
		('IND10',	'School Quality and Student Success Measure 10',				'IND10'),
		('IND11',	'School Quality and Student Success Measure 11',				'IND11'),
		('IND12',	'School Quality and Student Success Measure 12',				'IND12'),
		('PAELP1',	'Progress Achieving English Language Proficiency Measure 1',	'PAELP1'),
		('PAELP2',	'Progress Achieving English Language Proficiency Measure 2',	'PAELP2')
