CREATE VIEW [RDS].[vwDimIdeaStatuses] 
AS
	SELECT distinct
		  DimIdeaStatusId
		, rsy.SchoolYear
		, SpecialEducationExitReasonCode
		, sssrd1.InputCode AS SpecialEducationExitReasonMap
		, PrimaryDisabilityTypeCode
		, sssrd2.InputCode AS PrimaryDisabilityTypeMap
		, IdeaEducationalEnvironmentCode
		, sssrd3.InputCode AS IdeaEducationalEnvironmentMap
		, IdeaIndicatorCode
		, CASE IdeaIndicatorCode 
			WHEN 'IDEA' THEN 1 
			ELSE -1
		  END AS IdeaIndicatorMap
	FROM rds.DimIdeaStatuses rdis
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdis.SpecialEducationExitReasonCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefSpecialEducationExitReason'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdis.PrimaryDisabilityTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefDisabilityType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdis.IdeaEducationalEnvironmentCode = sssrd3.OutputCode
		AND (sssrd3.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
			OR sssrd3.TableName = 'RefIDEAEducationalEnvironmentEC')
		AND rsy.SchoolYear = sssrd3.SchoolYear