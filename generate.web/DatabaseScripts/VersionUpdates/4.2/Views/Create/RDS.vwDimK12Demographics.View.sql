create VIEW RDS.vwDimK12Demographics 
AS
	SELECT
		  DimK12DemographicId
		, rsy.SchoolYear
		, EconomicDisadvantageStatusCode
		, CASE EconomicDisadvantageStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS EconomicDisadvantageStatusMap
		, HomelessnessStatusCode
		, CASE HomelessnessStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS HomelessnessStatusMap
		, EnglishLearnerStatusCode
		, CASE EnglishLearnerStatusCode
			WHEN 'LEPP' THEN 2 
			WHEN 'LEP' THEN 1 
			WHEN 'NLEP' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS EnglishLearnerStatusMap
		, MigrantStatusCode
		, CASE MigrantStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS MigrantStatusMap
		, MilitaryConnectedStudentIndicatorCode
		, ISNULL(sssrd1.InputCode, 'MISSING') AS MilitaryConnectedStudentIndicatorMap
		, HomelessPrimaryNighttimeResidenceCode
		, ISNULL(sssrd2.InputCode, 'MISSING') AS HomelessPrimaryNighttimeResidenceMap
		, HomelessUnaccompaniedYouthStatusCode
		, CASE HomelessUnaccompaniedYouthStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS HomelessUnaccompaniedYouthStatusMap
	FROM rds.DimK12Demographics rdkd
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkd.MilitaryConnectedStudentIndicatorCode = sssrd1.OutputCode
		AND rsy.SchoolYear = sssrd1.SchoolYear
		AND sssrd1.TableName = 'RefMilitaryConnectedStudentIndicator'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdkd.HomelessPrimaryNighttimeResidenceCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefHomelessNighttimeResidence'
		AND rsy.SchoolYear = sssrd2.SchoolYear