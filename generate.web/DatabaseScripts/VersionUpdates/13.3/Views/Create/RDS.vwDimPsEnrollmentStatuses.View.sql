CREATE VIEW RDS.vwDimPsEnrollmentStatuses
AS
	SELECT
		  rdpes.[DimPsEnrollmentStatusId]
		, rsy.SchoolYear
		, PostsecondaryExitOrWithdrawalTypeCode
		, sssrd.InputCode AS PostsecondaryExitOrWithdrawalTypeMap
		, PostSecondaryEnrollmentStatusCode
		, sssrd2.InputCode AS PostSecondaryEnrollmentStatusMap
		, PostSecondaryEnrollmentActionCode
		, sssrd3.InputCode AS PostSecondaryEnrollmentActionMap
	FROM rds.DimPsEnrollmentStatuses rdpes
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdpes.PostsecondaryExitOrWithdrawalTypeCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefPSExitOrWithdrawalType'
		AND rsy.SchoolYear = sssrd.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdpes.PostSecondaryEnrollmentStatusCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefPostSecondaryEnrollmentStatus'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData sssrd3
		ON rdpes.[PostsecondaryEnrollmentActionCode] = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefPSEnrollmentAction'
		AND rsy.SchoolYear = sssrd3.SchoolYear		