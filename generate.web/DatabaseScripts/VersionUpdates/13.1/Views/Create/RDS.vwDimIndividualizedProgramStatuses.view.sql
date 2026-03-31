CREATE VIEW rds.vwDimIndividualizedProgramStatuses
AS
	SELECT  rdips.DimIndividualizedProgramStatusId
			, rsy.SchoolYear
			, rdips.IndividualizedProgramTypeCode
			, sssrd.InputCode AS IndividualizedProgramTypeMap
			, rdips.StudentSupportServiceTypeCode
			, sssrd1.InputCode AS StudentSupportServiceTypeMap
			, rdips.ConsentToEvaluationIndicatorCode
			,  CASE rdips.ConsentToEvaluationIndicatorCode 
			    WHEN 'Yes' THEN 1 
				WHEN 'No' THEN 0
				ELSE 0
			  END AS ConsentToEvaluationIndicatorMap
	FROM rds.DimIndividualizedProgramStatuses rdips
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
			ON rdips.IndividualizedProgramTypeCode = sssrd.OutputCode
			AND rsy.SchoolYear = sssrd.SchoolYear
			AND sssrd.TableName = 'RefIndividualizedProgramType'
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON rdips.StudentSupportServiceTypeCode = sssrd1.OutputCode
			AND rsy.SchoolYear = sssrd1.SchoolYear
			AND sssrd1.TableName = 'RefStudentSupportServiceType'

