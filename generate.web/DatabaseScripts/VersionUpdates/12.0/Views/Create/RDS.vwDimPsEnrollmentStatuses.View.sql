CREATE VIEW RDS.vwDimPsEnrollmentStatuses
AS
	SELECT
		  [DimPsEnrollmentStatusId]
		, rsy.SchoolYear
		, [PostsecondaryExitOrWithdrawalTypeCode]                
		, sssrd.InputCode AS [PostsecondaryExitOrWithdrawalTypeMap]         
	FROM rds.DimPsEnrollmentStatuses rdpes
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdpes.[PostsecondaryExitOrWithdrawalTypeCode] = sssrd.OutputCode
		AND sssrd.TableName = 'RefPSExitOrWithdrawalType'
		AND rsy.SchoolYear = sssrd.SchoolYear
