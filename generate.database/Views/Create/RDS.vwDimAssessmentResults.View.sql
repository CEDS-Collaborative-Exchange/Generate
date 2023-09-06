CREATE VIEW [RDS].[vwDimAssessmentResults] 
AS
	SELECT
		DimAssessmentResultId
		, rsy.SchoolYear
		, AssessmentScoreMetricTypeCode
		, sssrd1.OutputCode AS AssessmentScoreMetricTypeMap
	FROM rds.DimAssessmentResults rdar
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdar.AssessmentScoreMetricTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefScoreMetricType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
