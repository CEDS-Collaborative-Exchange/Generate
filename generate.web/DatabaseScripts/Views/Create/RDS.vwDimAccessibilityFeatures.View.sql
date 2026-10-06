CREATE VIEW [RDS].[vwDimAccessibilityFeatures] 
AS
	SELECT
		DimAccessibilityFeatureId
		, rsy.SchoolYear
   		, AccessibilityFeatureTypeCode
		, sssrd1.InputCode AS AccessibilityFeatureTypeMap
		, AccessibilityFeatureApplicationTypeCode
		, sssrd2.InputCode AS AccessibilityFeatureApplicationTypeMap
		, AccessibilityFeatureCategoryCode
		, sssrd3.InputCode AS AccessibilityFeatureCategoryMap
		, AccessibilityFeatureDeliveryMethodCode
		, sssrd4.InputCode AS AccessibilityFeatureDeliveryMethodMap
		, AccessibilityFeatureEmbeddedIndicatorCode
		, sssrd5.InputCode AS AccessibilityFeatureEmbeddedIndicatorMap
		, AccessibilityFeaturePausesTheClockIndicatorCode
		, sssrd6.InputCode AS AccessibilityFeaturePausesTheClockIndicatorMap
	FROM rds.DimAccessibilityFeatures rdaf
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdaf.AccessibilityFeatureTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'AccessibilityFeatureType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdaf.AccessibilityFeatureApplicationTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefAccessibilityFeatureApplicationType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdaf.AccessibilityFeatureCategoryCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefAccessibilityFeatureCategory'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdaf.AccessibilityFeatureDeliveryMethodCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefAccessibilityFeatureDeliveryMethod'
		AND rsy.SchoolYear = sssrd4.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd5
		ON rdaf.AccessibilityFeatureEmbeddedIndicatorCode = sssrd5.OutputCode
		AND sssrd5.TableName = 'RefAccessibilityFeatureEmbeddedIndicator'
		AND rsy.SchoolYear = sssrd5.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd6
		ON rdaf.AccessibilityFeaturePausesTheClockIndicatorCode = sssrd6.OutputCode
		AND sssrd6.TableName = 'RefAccessibilityFeaturePausesTheClockIndicator'
		AND rsy.SchoolYear = sssrd6.SchoolYear
