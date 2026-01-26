CREATE VIEW [RDS].[vwDimMigrants] 
AS
	SELECT DISTINCT
		  rdm.DimMigrantId
		, rsy.SchoolYear
		, rdm.ContinuationOfServicesReasonCode
		, sssrd1.InputCode AS ContinuationOfServicesReasonMap
		, rdm.MepServicesTypeCode
		, sssrd2.InputCode AS MepServicesTypeMap
		, rdm.MepEnrollmentTypeCode
		, sssrd3.InputCode AS MepEnrollmentTypeMap
		, rdm.ConsolidatedMepFundsStatusCode
		, CASE rdm.ConsolidatedMepFundsStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS ConsolidatedMepFundsStatusMap
		, rdm.MigrantPrioritizedForServicesCode
		, CASE rdm.MigrantPrioritizedForServicesCode
			WHEN 'PS' THEN 1 
			WHEN 'MISSING' THEN NULL
		  END AS MigrantPrioritizedForServicesMap
	FROM rds.DimMigrants rdm
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdm.ContinuationOfServicesReasonCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefContinuationOfServices'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdm.MepServicesTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefMepServiceType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdm.MepEnrollmentTypeCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefMepEnrollmentType'
		AND rsy.SchoolYear = sssrd3.SchoolYear