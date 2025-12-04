CREATE VIEW [RDS].[vwDimPsEnrollmentStatuses]
AS
	SELECT
		DimPsEnrollmentStatusId
		, rsy.SchoolYear
		, PostsecondaryExitOrWithdrawalTypeCode
		, sssrd.InputCode AS PostsecondaryExitOrWithdrawalTypeMap
		, PostSecondaryEnrollmentStatusCode
		, sssrd2.InputCode AS PostSecondaryEnrollmentStatusMap
		, PostSecondaryEnrollmentActionCode
		, sssrd3.InputCode AS PostSecondaryEnrollmentActionMap
	FROM rds.DimPsEnrollmentStatuses rdpes
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdpes.PostsecondaryExitOrWithdrawalTypeCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefPSExitOrWithdrawalType'
		AND rsy.SchoolYear = sssrd.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdpes.PostSecondaryEnrollmentStatusCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefPostSecondaryEnrollmentStatus'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdpes.PostSecondaryEnrollmentActionCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefPostSecondaryEnrollmentAction'
		AND rsy.SchoolYear = sssrd3.SchoolYear
