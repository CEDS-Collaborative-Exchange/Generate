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
