CREATE VIEW [RDS].[vwDimIdeaStatuses] 
AS
	SELECT
		DimIdeaStatusId
		, rsy.SchoolYear
		, rdis.SpecialEducationExitReasonCode
		, ISNULL(sssrd.InputCode, 'MISSING') AS SpecialEducationExitReasonMap
		, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode
		, ISNULL(sssrd2.InputCode, 'MISSING') AS IdeaEducationalEnvironmentForEarlyChildhoodMap
		, rdis.IdeaEducationalEnvironmentForSchoolAgeCode
		, ISNULL(sssrd3.InputCode, 'MISSING') AS IdeaEducationalEnvironmentForSchoolAgeMap
		, IdeaIndicatorCode
		, CASE IdeaIndicatorCode
			WHEN 'Yes' THEN 1
			WHEN 'No' THEN 0
			WHEN 'MISSING' THEN -1
		END AS IdeaIndicatorMap
	FROM rds.DimIdeaStatuses rdis
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdis.SpecialEducationExitReasonCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefSpecialEducationExitReason'
		AND rsy.SchoolYear = sssrd.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefIDEAEducationalEnvironmentEC'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdis.IdeaEducationalEnvironmentForSchoolAgeCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
		AND rsy.SchoolYear = sssrd3.SchoolYear
