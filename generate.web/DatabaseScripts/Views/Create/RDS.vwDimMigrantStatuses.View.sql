CREATE VIEW RDS.vwDimMigrantStatuses 
AS
	SELECT
		DimMigrantStatusId
		, rsy.SchoolYear
		, rdms.MigrantStatusCode
		, CASE rdms.MigrantStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS MigrantStatusMap
		, rdms.MigrantEducationProgramEnrollmentTypeCode
		, sssrd1.OutputCode AS MigrantEducationProgramEnrollmentTypeMap
		, rdms.ContinuationOfServicesReasonCode
		, sssrd2.OutputCode AS ContinuationOfServicesReasonMap
		, rdms.MigrantEducationProgramServicesTypeCode
		, sssrd3.OutputCode AS MigrantEducationProgramServicesTypeMap
		, rdms.MigrantPrioritizedForServicesCode
		, CASE rdms.MigrantPrioritizedForServicesCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS MigrantPrioritizedForServicesMap
		, rdms.MEPContinuationOfServicesStatusCode
		, CASE rdms.MEPContinuationOfServicesStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS MEPContinuationOfServicesStatusMap
		, rdms.ConsolidatedMepFundsStatusCode
		, CASE rdms.ConsolidatedMepFundsStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS ConsolidatedMepFundsStatusMap

	FROM rds.DimMigrantStatuses rdms
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdms.MigrantEducationProgramEnrollmentTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefMepEnrollmentType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData sssrd2
		ON rdms.ContinuationOfServicesReasonCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefContinuationOfServices'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData sssrd3
		ON rdms.MigrantEducationProgramServicesTypeCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefMepServiceType'
		AND rsy.SchoolYear = sssrd3.SchoolYear