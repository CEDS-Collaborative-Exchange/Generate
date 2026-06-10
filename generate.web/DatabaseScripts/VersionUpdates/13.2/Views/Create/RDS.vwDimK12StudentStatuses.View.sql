CREATE VIEW [RDS].[vwDimK12StudentStatuses] 
AS
	SELECT DISTINCT
		  DimK12StudentStatusId
		, rsy.SchoolYear

--have to find these
		, MobilityStatus12moCode
		, CASE MobilityStatus12moCode
			WHEN 'QAD' THEN 1 
			ELSE -1
		  END AS MobilityStatus12moMap
		, MobilityStatusSYCode	
		, CASE MobilityStatusSYCode
			WHEN 'QMRSY' THEN 1 
			ELSE -1
		  END AS MobilityStatusSYMap
		, ReferralStatusCode	
		, CASE ReferralStatusCode
			WHEN 'ReferralServices' THEN 1 
			ELSE -1
		  END AS ReferralStatusMap
		, MobilityStatus36moCode
		, CASE MobilityStatus36moCode
			WHEN 'QAD36' THEN 1 
			ELSE -1
		  END AS MobilityStatus36moMap
--

		, DiplomaCredentialTypeCode
		, sssrd1.InputCode AS DiplomaCredentialTypeMap
	FROM rds.DimK12StudentStatuses rdkss
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkss.DiplomaCredentialTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefHighSchoolDiplomaType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
