	---------------------------------------------------------------
	-- Populate DimAccessibilityFeatures  ---
	----------------------------------------------------------------
	PRINT 'Populate DimAccessibilityFeatures'
	
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

	------------------------------------------------
	-- Populate DimTitleIIIStatuses			 ---
	------------------------------------------------
	PRINT 'Populate DimTitleIIIStatuses'

	--Drop the constraints for the junk record if they exist
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT IF EXISTS [FK_FactK12StudentAssessments_TitleIIIStatusId];
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT IF EXISTS [FK_FactK12StudentCounts_TitleIIIStatusId];
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT IF EXISTS [FK_FactK12StudentDisciplines_TitleIIIStatusId];

	--clear the DimTitleIIIStatuses table for the junk record if it exists
	DELETE FROM RDS.DimTitleIIIStatuses WHERE DimTitleIIIStatusId <> -1;

	IF NOT EXISTS (SELECT 1 FROM RDS.DimTitleIIIStatuses 
			WHERE ProgramParticipationTitleIIILiepCode = 'MISSING'
			AND TitleIIIImmigrantParticipationStatusCode = 'MISSING'
			AND ProficiencyStatusCode = 'MISSING'
			AND TitleIIIAccountabilityProgressStatusCode = 'MISSING'
			AND TitleIIILanguageInstructionProgramTypeCode = 'MISSING') BEGIN
		SET IDENTITY_INSERT RDS.DimTitleIIIStatuses ON

		INSERT INTO RDS.DimTitleIIIStatuses (
			  DimTitleIIIStatusId
			, ProgramParticipationTitleIIILiepCode
			, ProgramParticipationTitleIIILiepDescription
			, TitleIIIImmigrantParticipationStatusCode
			, TitleIIIImmigrantParticipationStatusDescription
			, TitleIIIImmigrantParticipationStatusEdFactsCode
			, ProficiencyStatusCode
			, ProficiencyStatusDescription
			, ProficiencyStatusEdFactsCode
			, TitleIIIAccountabilityProgressStatusCode
			, TitleIIIAccountabilityProgressStatusDescription
			, TitleIIIAccountabilityProgressStatusEdFactsCode
			, TitleIIILanguageInstructionProgramTypeCode
			, TitleIIILanguageInstructionProgramTypeDescription
			, TitleIIILanguageInstructionProgramTypeEdFactsCode
			, EnglishLearnerExitedStatusCode
			, EnglishLearnerExitedStatusDescription
			, EnglishLearnerExitedStatusEdFactsCode
			, TitleIIIEnglishLearnerParticipationStatusCode
			, TitleIIIEnglishLearnerParticipationStatusDescription
			, TitleIIIEnglishLearnerParticipationStatusEdFactsCode
			)
		VALUES (-1, 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimTitleIIIStatuses OFF
	END

	IF OBJECT_ID('tempdb..#ProgramParticipationTitleIIILiep') IS NOT NULL 
	BEGIN
		DROP TABLE #ProgramParticipationTitleIIILiep
	END

	CREATE TABLE #ProgramParticipationTitleIIILiep (ProgramParticipationTitleIIILiepCode VARCHAR(50), ProgramParticipationTitleIIILiepDescription VARCHAR(200))

	INSERT INTO #ProgramParticipationTitleIIILiep VALUES ('MISSING', 'MISSING')
	INSERT INTO #ProgramParticipationTitleIIILiep
	VALUES 
		('Yes', 'Yes')
		,('No', 'No')

	IF OBJECT_ID('tempdb..#TitleIIIImmigrantParticipationStatus') IS NOT NULL 
	BEGIN
		DROP TABLE #TitleIIIImmigrantParticipationStatus
	END

	CREATE TABLE #TitleIIIImmigrantParticipationStatus (TitleIIIImmigrantParticipationStatusCode VARCHAR(50), TitleIIIImmigrantParticipationStatusDescription VARCHAR(200), TitleIIIImmigrantParticipationStatusEdFactsCode VARCHAR(50))

	INSERT INTO #TitleIIIImmigrantParticipationStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #TitleIIIImmigrantParticipationStatus
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode
			WHEN 'Yes' THEN 'IMMIGNTTTLIII'
			WHEN 'No' THEN 'NONIMMIGNTTTLIII'
			ELSE 'MISSING'
		  END 
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'TitleIIIImmigrantParticipationStatus'

	IF OBJECT_ID('tempdb..#ProficiencyStatus') IS NOT NULL 
	BEGIN
		DROP TABLE #ProficiencyStatus
	END

	CREATE TABLE #ProficiencyStatus (ProficiencyStatusCode VARCHAR(50), ProficiencyStatusDescription VARCHAR(200), ProficiencyStatusEdFactsCode VARCHAR(50))

	INSERT INTO #ProficiencyStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #ProficiencyStatus
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, UPPER(CedsOptionSetCode) AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'ProficiencyStatus'

	IF OBJECT_ID('tempdb..#TitleIIIAccountabilityProgressStatus') IS NOT NULL 
	BEGIN
		DROP TABLE #TitleIIIAccountabilityProgressStatus
	END

	CREATE TABLE #TitleIIIAccountabilityProgressStatus (TitleIIIAccountabilityProgressStatusCode VARCHAR(50), TitleIIIAccountabilityProgressStatusDescription VARCHAR(200), TitleIIIAccountabilityProgressStatusEdFactsCode VARCHAR(50))

	INSERT INTO #TitleIIIAccountabilityProgressStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #TitleIIIAccountabilityProgressStatus
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'TitleIIIAccountabilityProgressStatus'

	IF OBJECT_ID('tempdb..#TitleIIILanguageInstructionProgramType') IS NOT NULL 
	BEGIN
		DROP TABLE #TitleIIILanguageInstructionProgramType
	END

	CREATE TABLE #TitleIIILanguageInstructionProgramType (TitleIIILanguageInstructionProgramTypeCode VARCHAR(50), TitleIIILanguageInstructionProgramTypeDescription VARCHAR(200), TitleIIILanguageInstructionProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #TitleIIILanguageInstructionProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #TitleIIILanguageInstructionProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode
			WHEN 'ContentBasedESL' THEN 'LNGPRGESLSUPP'
			WHEN 'DualLanguage' THEN 'LNGPRGDU'
			WHEN 'NewcomerPrograms' THEN 'LNGPRGNEW'
			WHEN 'Other' THEN 'LNGPRGOTH'
			WHEN 'PullOutESL' THEN 'LNGPRGESLELD'
			WHEN 'TransitionalBilingual' THEN 'LNGPRGBI'
			WHEN 'TwoWayImmersion' THEN 'LNGPRGDU'
			ELSE 'MISSING'
		  END
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'TitleIIILanguageInstructionProgramType'

	IF OBJECT_ID('tempdb..#EnglishLearnerExitedStatus') IS NOT NULL 
	BEGIN
		DROP TABLE #EnglishLearnerExitedStatus
	END

	CREATE TABLE #EnglishLearnerExitedStatus (EnglishLearnerExitedStatusCode VARCHAR(50), EnglishLearnerExitedStatusDescription VARCHAR(200), EnglishLearnerExitedStatusEdFactsCode VARCHAR(50))

	INSERT INTO #EnglishLearnerExitedStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EnglishLearnerExitedStatus
	VALUES
		('Yes', 'Yes', 'Yes')
		,('No', 'No', 'No')

	IF OBJECT_ID('tempdb..#TitleIIIEnglishLearnerParticipationStatus') IS NOT NULL 
	BEGIN
		DROP TABLE #TitleIIIEnglishLearnerParticipationStatus
	END

	CREATE TABLE #TitleIIIEnglishLearnerParticipationStatus (TitleIIIEnglishLearnerParticipationStatusCode VARCHAR(50), TitleIIIEnglishLearnerParticipationStatusDescription VARCHAR(200), TitleIIIEnglishLearnerParticipationStatusEdFactsCode VARCHAR(50))

	INSERT INTO #TitleIIIEnglishLearnerParticipationStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #TitleIIIEnglishLearnerParticipationStatus
	VALUES
		('Yes', 'Yes', 'Yes')
		,('No', 'No', 'No')

	   
	INSERT INTO RDS.DimTitleIIIStatuses (
			  ProgramParticipationTitleIIILiepCode
			, ProgramParticipationTitleIIILiepDescription
			, TitleIIIImmigrantParticipationStatusCode
			, TitleIIIImmigrantParticipationStatusDescription
			, TitleIIIImmigrantParticipationStatusEdFactsCode
			, ProficiencyStatusCode
			, ProficiencyStatusDescription
			, ProficiencyStatusEdFactsCode
			, TitleIIIAccountabilityProgressStatusCode
			, TitleIIIAccountabilityProgressStatusDescription
			, TitleIIIAccountabilityProgressStatusEdFactsCode
			, TitleIIILanguageInstructionProgramTypeCode
			, TitleIIILanguageInstructionProgramTypeDescription
			, TitleIIILanguageInstructionProgramTypeEdFactsCode
			, EnglishLearnerExitedStatusCode
			, EnglishLearnerExitedStatusDescription
			, EnglishLearnerExitedStatusEdFactsCode
			, TitleIIIEnglishLearnerParticipationStatusCode
			, TitleIIIEnglishLearnerParticipationStatusDescription
			, TitleIIIEnglishLearnerParticipationStatusEdFactsCode
		)
	SELECT 
			  a.ProgramParticipationTitleIIILiepCode
			, a.ProgramParticipationTitleIIILiepDescription
			, b.TitleIIIImmigrantParticipationStatusCode
			, b.TitleIIIImmigrantParticipationStatusDescription
			, b.TitleIIIImmigrantParticipationStatusEdFactsCode
			, c.ProficiencyStatusCode
			, c.ProficiencyStatusDescription
			, c.ProficiencyStatusEdFactsCode
			, d.TitleIIIAccountabilityProgressStatusCode
			, d.TitleIIIAccountabilityProgressStatusDescription
			, d.TitleIIIAccountabilityProgressStatusEdFactsCode
			, e.TitleIIILanguageInstructionProgramTypeCode
			, e.TitleIIILanguageInstructionProgramTypeDescription
			, e.TitleIIILanguageInstructionProgramTypeEdFactsCode
			, f.EnglishLearnerExitedStatusCode
			, f.EnglishLearnerExitedStatusDescription
			, f.EnglishLearnerExitedStatusEdFactsCode
			, g.TitleIIIEnglishLearnerParticipationStatusCode
			, g.TitleIIIEnglishLearnerParticipationStatusDescription
			, g.TitleIIIEnglishLearnerParticipationStatusEdFactsCode
	FROM #ProgramParticipationTitleIIILiep a
	CROSS JOIN #TitleIIIImmigrantParticipationStatus b
	CROSS JOIN #ProficiencyStatus c
	CROSS JOIN #TitleIIIAccountabilityProgressStatus d
	CROSS JOIN #TitleIIILanguageInstructionProgramType e
	CROSS JOIN #EnglishLearnerExitedStatus f
	CROSS JOIN #TitleIIIEnglishLearnerParticipationStatus g
	LEFT JOIN RDS.DimTitleIIIStatuses main
		ON a.ProgramParticipationTitleIIILiepCode = main.ProgramParticipationTitleIIILiepCode
		AND b.TitleIIIImmigrantParticipationStatusCode = main.TitleIIIImmigrantParticipationStatusCode
		AND c.ProficiencyStatusCode = main.ProficiencyStatusCode
		AND d.TitleIIIAccountabilityProgressStatusCode = main.TitleIIIAccountabilityProgressStatusCode
		AND e.TitleIIILanguageInstructionProgramTypeCode = main.TitleIIILanguageInstructionProgramTypeCode
		AND f.EnglishLearnerExitedStatusCode = main.EnglishLearnerExitedStatusCode
		AND g.TitleIIIEnglishLearnerParticipationStatusCode = main.TitleIIIEnglishLearnerParticipationStatusCode
	WHERE main.DimTitleIIIStatusId IS NULL

	DROP TABLE #ProgramParticipationTitleIIILiep
	DROP TABLE #TitleIIIImmigrantParticipationStatus
	DROP TABLE #ProficiencyStatus
	DROP TABLE #TitleIIIAccountabilityProgressStatus
	DROP TABLE #TitleIIILanguageInstructionProgramType
	DROP TABLE #EnglishLearnerExitedStatus
	DROP TABLE #TitleIIIEnglishLearnerParticipationStatus

	--Re-add the constraints for the fact tables
	IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactK12StudentAssessments_TitleIIIStatusId')
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_TitleIIIStatusId] 
			FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses]([DimTitleIIIStatusId]);
	END

	IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactK12StudentCounts_TitleIIIStatusId')
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_TitleIIIStatusId] 
			FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses]([DimTitleIIIStatusId]);
	END

	IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FactK12StudentDisciplines_TitleIIIStatusId')
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [FK_FactK12StudentDisciplines_TitleIIIStatusId] 
			FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses]([DimTitleIIIStatusId]);
	END
