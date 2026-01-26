CREATE VIEW [RDS].[vwDimAssessmentStatuses] 
AS
	SELECT
		DimAssessmentStatusId
		, rsy.SchoolYear
		, ProgressLevelCode
		, sssrd1.InputCode				AS ProgressLevelMap
		, AssessedFirstTimeCode
		, CASE AssessedFirstTimeCode
			WHEN 'Yes' THEN 1
			WHEN 'No' THEN 0
			ELSE -1
		  END							AS AssessedFirstTimeMap
	FROM rds.DimAssessmentStatuses rdas
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdas.ProgressLevelCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefProgressCode'
		AND rsy.SchoolYear = sssrd1.SchoolYear
