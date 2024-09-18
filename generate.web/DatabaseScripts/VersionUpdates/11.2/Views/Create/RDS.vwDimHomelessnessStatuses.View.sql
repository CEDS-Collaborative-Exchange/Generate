CREATE VIEW [RDS].[vwDimHomelessnessStatuses] 
AS
	SELECT																					
		DimHomelessnessStatusId
		, rsy.SchoolYear
		, rdhs.HomelessnessStatusCode
		, CASE rdhs.HomelessnessStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS HomelessnessStatusMap
		, rdhs.HomelessPrimaryNighttimeResidenceCode
		, ISNULL(sssrd.InputCode, 'MISSING')  AS HomelessPrimaryNighttimeResidenceMap
		, rdhs.HomelessServicedIndicatorCode
		, CASE rdhs.HomelessServicedIndicatorCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS HomelessServicedIndicatorMap
		, rdhs.HomelessUnaccompaniedYouthStatusCode
		, CASE rdhs.HomelessUnaccompaniedYouthStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS HomelessUnaccompaniedYouthStatusMap
	FROM rds.DimHomelessnessStatuses rdhs
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		ON rdhs.HomelessPrimaryNighttimeResidenceCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefHomelessNighttimeResidence'
		AND rsy.SchoolYear = sssrd.SchoolYear		
