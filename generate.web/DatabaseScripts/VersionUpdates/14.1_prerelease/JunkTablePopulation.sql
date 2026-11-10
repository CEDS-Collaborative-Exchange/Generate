	---------------------------------------------------------------
	-- Populate DimAccessibilityFeatures  ---
	----------------------------------------------------------------

	--clear the DimAccessibilityFeatures table for the junk record if it exists
	DELETE FROM RDS.DimAccessibilityFeatures WHERE DimAccessibilityFeatureId <> -1

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAccessibilityFeatures d WHERE d.DimAccessibilityFeatureId = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.DimAccessibilityFeatures ON

		INSERT INTO [RDS].DimAccessibilityFeatures
			   (DimAccessibilityFeatureId
			   ,AccessibilityFeatureTypeCode
			   ,AccessibilityFeatureTypeDescription
			   ,AccessibilityFeatureApplicationTypeCode
			   ,AccessibilityFeatureApplicationTypeDescription
			   ,AccessibilityFeatureCategoryCode
			   ,AccessibilityFeatureCategoryDescription
			   ,AccessibilityFeatureDeliveryMethodCode
			   ,AccessibilityFeatureDeliveryMethodDescription
			   ,AccessibilityFeatureEmbeddedIndicatorCode
			   ,AccessibilityFeatureEmbeddedIndicatorDescription
			   ,AccessibilityFeaturePausesTheClockIndicatorCode
			   ,AccessibilityFeaturePausesTheClockIndicatorDescription)
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
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				)

		SET IDENTITY_INSERT RDS.DimAccessibilityFeatures OFF

	END

	IF OBJECT_ID('tempdb..#AccessibilityFeatureType') IS NOT NULL
		DROP TABLE #AccessibilityFeatureType

	CREATE TABLE #AccessibilityFeatureType (AccessibilityFeatureTypeCode VARCHAR(50), AccessibilityFeatureTypeDescription VARCHAR(200))

	INSERT INTO #AccessibilityFeatureType VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibilityFeatureType 
	SELECT 
		CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibilityFeatureType'

	IF OBJECT_ID('tempdb..#AccessibilityFeatureApplicationType') IS NOT NULL
		DROP TABLE #AccessibilityFeatureApplicationType

	CREATE TABLE #AccessibilityFeatureApplicationType (AccessibilityFeatureApplicationTypeCode VARCHAR(50), AccessibilityFeatureApplicationTypeDescription VARCHAR(200))

	INSERT INTO #AccessibilityFeatureApplicationType VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibilityFeatureApplicationType 
	SELECT 
		CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibilityFeatureApplicationType'

	IF OBJECT_ID('tempdb..#AccessibilityFeatureCategory') IS NOT NULL
		DROP TABLE #AccessibilityFeatureCategory

	CREATE TABLE #AccessibilityFeatureCategory (AccessibilityFeatureCategoryCode VARCHAR(50), AccessibilityFeatureCategoryDescription VARCHAR(200))

	INSERT INTO #AccessibilityFeatureCategory VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibilityFeatureCategory 
	SELECT 
		CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibilityFeatureCategory'

	IF OBJECT_ID('tempdb..#AccessibilityFeatureDeliveryMethod') IS NOT NULL
		DROP TABLE #AccessibilityFeatureDeliveryMethod

	CREATE TABLE #AccessibilityFeatureDeliveryMethod (AccessibilityFeatureDeliveryMethodCode VARCHAR(50), AccessibilityFeatureDeliveryMethodDescription VARCHAR(200))

	INSERT INTO #AccessibilityFeatureDeliveryMethod VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibilityFeatureDeliveryMethod 
	SELECT 
		CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibilityFeatureDeliveryMethod'

	IF OBJECT_ID('tempdb..#AccessibilityFeatureEmbeddedIndicator') IS NOT NULL
		DROP TABLE #AccessibilityFeatureEmbeddedIndicator

	CREATE TABLE #AccessibilityFeatureEmbeddedIndicator (AccessibilityFeatureEmbeddedIndicatorCode VARCHAR(50), AccessibilityFeatureEmbeddedIndicatorDescription VARCHAR(200))

	INSERT INTO #AccessibilityFeatureEmbeddedIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibilityFeatureEmbeddedIndicator 
	SELECT 
		CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibilityFeatureEmbeddedIndicator'

	IF OBJECT_ID('tempdb..#AccessibilityFeaturePausesTheClockIndicator') IS NOT NULL
		DROP TABLE #AccessibilityFeaturePausesTheClockIndicator

	CREATE TABLE #AccessibilityFeaturePausesTheClockIndicator (AccessibilityFeaturePausesTheClockIndicatorCode VARCHAR(50), AccessibilityFeaturePausesTheClockIndicatorDescription VARCHAR(200))

	INSERT INTO #AccessibilityFeaturePausesTheClockIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibilityFeaturePausesTheClockIndicator 
	SELECT 
		CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibilityFeaturePausesTheClockIndicator'


	INSERT INTO [RDS].DimAccessibilityFeatures
		(AccessibilityFeatureTypeCode
		,AccessibilityFeatureTypeDescription
		,AccessibilityFeatureApplicationTypeCode
		,AccessibilityFeatureApplicationTypeDescription
		,AccessibilityFeatureCategoryCode
		,AccessibilityFeatureCategoryDescription
		,AccessibilityFeatureDeliveryMethodCode
		,AccessibilityFeatureDeliveryMethodDescription
		,AccessibilityFeatureEmbeddedIndicatorCode
		,AccessibilityFeatureEmbeddedIndicatorDescription
		,AccessibilityFeaturePausesTheClockIndicatorCode
		,AccessibilityFeaturePausesTheClockIndicatorDescription)
	SELECT DISTINCT
		  a.AccessibilityFeatureTypeCode
		, a.AccessibilityFeatureTypeDescription
		, b.AccessibilityFeatureApplicationTypeCode
		, b.AccessibilityFeatureApplicationTypeDescription
		, c.AccessibilityFeatureCategoryCode
		, c.AccessibilityFeatureCategoryDescription
		, d.AccessibilityFeatureDeliveryMethodCode
		, d.AccessibilityFeatureDeliveryMethodDescription
		, e.AccessibilityFeatureEmbeddedIndicatorCode
		, e.AccessibilityFeatureEmbeddedIndicatorDescription
		, f.AccessibilityFeaturePausesTheClockIndicatorCode
		, f.AccessibilityFeaturePausesTheClockIndicatorDescription
	FROM #AccessibilityFeatureType a
	CROSS JOIN #AccessibilityFeatureApplicationType b
	CROSS JOIN #AccessibilityFeatureCategory c
	CROSS JOIN #AccessibilityFeatureDeliveryMethod d
	CROSS JOIN #AccessibilityFeatureEmbeddedIndicator e
	CROSS JOIN #AccessibilityFeaturePausesTheClockIndicator f
	LEFT JOIN RDS.DimAccessibilityFeatures main
		ON a.AccessibilityFeatureTypeCode = main.AccessibilityFeatureTypeCode
		AND b.AccessibilityFeatureApplicationTypeCode = main.AccessibilityFeatureApplicationTypeCode
		AND c.AccessibilityFeatureCategoryCode = main.AccessibilityFeatureCategoryCode
		AND d.AccessibilityFeatureDeliveryMethodCode = main.AccessibilityFeatureDeliveryMethodCode
		AND e.AccessibilityFeatureEmbeddedIndicatorCode = main.AccessibilityFeatureEmbeddedIndicatorCode
		AND f.AccessibilityFeaturePausesTheClockIndicatorCode = main.AccessibilityFeaturePausesTheClockIndicatorCode
	WHERE main.DimAccessibilityFeatureId IS NULL

	DROP TABLE #AccessibilityFeatureType
	DROP TABLE #AccessibilityFeatureApplicationType
	DROP TABLE #AccessibilityFeatureCategory
	DROP TABLE #AccessibilityFeatureDeliveryMethod
	DROP TABLE #AccessibilityFeatureEmbeddedIndicator
	DROP TABLE #AccessibilityFeaturePausesTheClockIndicator


--------------------------------------------------
--Populate DimAssessmentStatuses.FormerEnglishLearnerYearStatus
--------------------------------------------------
	-- Existing rows (ProgressLevelCode = 'MISSING') never had this attribute; make the missing case explicit
	-- instead of leaving it NULL, matching how every other code/description/edfactscode triple on this table is set.
	UPDATE RDS.DimAssessmentStatuses
	SET FormerEnglishLearnerYearStatusCode = 'MISSING',
		FormerEnglishLearnerYearStatusDescription = 'MISSING',
		FormerEnglishLearnerYearStatusEdFactsCode = 'MISSING'
	WHERE ProgressLevelCode = 'MISSING'
	  AND FormerEnglishLearnerYearStatusCode IS NULL

	CREATE TABLE #FormerEnglishLearnerYearStatus (Code VARCHAR(50), Description VARCHAR(200), EdFactsCode VARCHAR(50))
	INSERT INTO #FormerEnglishLearnerYearStatus VALUES
		('1YEAR', 'Assessed in the first year after exiting English Learner status', '1YEAR'),
		('2YEAR', 'Assessed in the second year after exiting English Learner status', '2YEAR'),
		('3YEAR', 'Assessed in the third year after exiting English Learner status', '3YEAR'),
		('4YEAR', 'Assessed in the fourth year after exiting English Learner status', '4YEAR'),
		('5YEAR', 'Assessed in the fifth year or later after exiting English Learner status', '5YEAR')

	-- Only ProgressLevelCode = 'MISSING' combinations are reachable from the assessment staging path
	-- (Staging.Staging-to-FactK12StudentAssessment always joins on ProgressLevelCode = 'MISSING'),
	-- so the new attribute only needs to be crossed with the existing AssessedFirstTime values for that slice.
	INSERT INTO RDS.DimAssessmentStatuses (
		ProgressLevelCode, ProgressLevelDescription, ProgressLevelEdFactsCode,
		AssessedFirstTimeCode, AssessedFirstTimeDescription, AssessedFirstTimeEdFactsCode,
		FormerEnglishLearnerYearStatusCode, FormerEnglishLearnerYearStatusDescription, FormerEnglishLearnerYearStatusEdFactsCode
	)
	SELECT DISTINCT
		'MISSING', 'MISSING', 'MISSING',
		aft.AssessedFirstTimeCode, aft.AssessedFirstTimeDescription, aft.AssessedFirstTimeEdFactsCode,
		fely.Code, fely.Description, fely.EdFactsCode
	FROM (
		SELECT DISTINCT AssessedFirstTimeCode, AssessedFirstTimeDescription, AssessedFirstTimeEdFactsCode
		FROM RDS.DimAssessmentStatuses
		WHERE ProgressLevelCode = 'MISSING'
	) aft
	CROSS JOIN #FormerEnglishLearnerYearStatus fely
	LEFT JOIN RDS.DimAssessmentStatuses main
		ON main.ProgressLevelCode = 'MISSING'
		AND main.AssessedFirstTimeCode = aft.AssessedFirstTimeCode
		AND main.FormerEnglishLearnerYearStatusCode = fely.Code
	WHERE main.DimAssessmentStatusId IS NULL

	DROP TABLE #FormerEnglishLearnerYearStatus

	------------------------------------------------------------------------------
	-- Populate DimAccessibleEducationMaterialStatuses   
	------------------------------------------------------------------------------
	--clear the DimAccessibleEducationMaterialStatuses table for the junk record if it exists
	DELETE FROM RDS.DimAccessibleEducationMaterialStatuses WHERE DimAccessibleEducationMaterialStatusId <> -1

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAccessibleEducationMaterialStatuses d WHERE d.DimAccessibleEducationMaterialStatusId = -1) BEGIN
		SET IDENTITY_INSERT rds.DimAccessibleEducationMaterialStatuses ON

			INSERT INTO rds.DimAccessibleEducationMaterialStatuses(
				DimAccessibleEducationMaterialStatusId
				, AccessibleFormatIssuedIndicatorCode
				, AccessibleFormatIssuedIndicatorDescription
				, AccessibleFormatRequiredIndicatorCode
				, AccessibleFormatRequiredIndicatorDescription
				, AccessibleFormatTypeCode
				, AccessibleFormatTypeDescription
			)
			VALUES (
				-1
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
			)

		SET IDENTITY_INSERT rds.DimAccessibleEducationMaterialStatuses OFF
	END
	
	IF OBJECT_ID('tempdb..#AccessibleFormatIssuedIndicatorCode') IS NOT NULL
		DROP TABLE #AccessibleFormatIssuedIndicatorCode

	CREATE TABLE #AccessibleFormatIssuedIndicatorCode (AccessibleFormatIssuedIndicatorCode VARCHAR(50), AccessibleFormatIssuedIndicatorDescription VARCHAR(200))

	INSERT INTO #AccessibleFormatIssuedIndicatorCode VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibleFormatIssuedIndicatorCode
	SELECT 
	 	CedsOptionSetCode
	 	, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibleFormatIssuedIndicator'
	ORDER BY CedsOptionSetCode

	IF OBJECT_ID('tempdb..#AccessibleFormatRequiredIndicatorCode') IS NOT NULL
		DROP TABLE #AccessibleFormatRequiredIndicatorCode

	CREATE TABLE #AccessibleFormatRequiredIndicatorCode (AccessibleFormatRequiredIndicatorCode VARCHAR(50), AccessibleFormatRequiredIndicatorDescription VARCHAR(200))

	INSERT INTO #AccessibleFormatRequiredIndicatorCode VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibleFormatRequiredIndicatorCode 
	SELECT 
	 	CedsOptionSetCode
	 	, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibleFormatRequiredIndicator'
	ORDER BY CedsOptionSetCode

	IF OBJECT_ID('tempdb..#AccessibleFormatTypeCode') IS NOT NULL
		DROP TABLE #AccessibleFormatTypeCode

	CREATE TABLE #AccessibleFormatTypeCode (AccessibleFormatTypeCode VARCHAR(50), AccessibleFormatTypeDescription VARCHAR(200))

	INSERT INTO #AccessibleFormatTypeCode VALUES ('MISSING', 'MISSING')
	INSERT INTO #AccessibleFormatTypeCode 
	SELECT 
	 	CedsOptionSetCode
	 	, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AccessibleFormatType'
	ORDER BY CedsOptionSetCode

	-- Insert into DimAccessibleEducationMaterialStatuses table
	INSERT INTO [RDS].[DimAccessibleEducationMaterialStatuses] (
		[AccessibleFormatIssuedIndicatorCode],
		[AccessibleFormatIssuedIndicatorDescription],
		[AccessibleFormatRequiredIndicatorCode],
		[AccessibleFormatRequiredIndicatorDescription],
		[AccessibleFormatTypeCode],
		[AccessibleFormatTypeDescription]
	)
	SELECT
		a.AccessibleFormatIssuedIndicatorCode,
		a.AccessibleFormatIssuedIndicatorDescription,
		b.AccessibleFormatRequiredIndicatorCode,
		b.AccessibleFormatRequiredIndicatorDescription,
		c.AccessibleFormatTypeCode,
		c.AccessibleFormatTypeDescription
	FROM
		#AccessibleFormatIssuedIndicatorCode a
		CROSS JOIN #AccessibleFormatRequiredIndicatorCode b
		CROSS JOIN #AccessibleFormatTypeCode c
		LEFT JOIN [RDS].[DimAccessibleEducationMaterialStatuses] main
			ON a.AccessibleFormatIssuedIndicatorCode = main.AccessibleFormatIssuedIndicatorCode
			AND b.AccessibleFormatRequiredIndicatorCode = main.AccessibleFormatRequiredIndicatorCode
			AND c.AccessibleFormatTypeCode = main.AccessibleFormatTypeCode
		WHERE main.DimAccessibleEducationMaterialStatusId IS NULL

	-- Drop temp tables
	DROP TABLE #AccessibleFormatIssuedIndicatorCode
	DROP TABLE #AccessibleFormatRequiredIndicatorCode
	DROP TABLE #AccessibleFormatTypeCode

