CREATE VIEW rds.vwDimK12EnrollmentStatuses
AS
	SELECT
		  [DimK12EnrollmentStatusId]
		, rsy.SchoolYear
		, EnrollmentStatusCode                
		, sssrd1.InputCode AS EnrollmentStatusMap         
		, EntryTypeCode                
		, sssrd2.InputCode AS EntryTypeMap        
		, ExitOrWithdrawalTypeCode                
		, sssrd3.InputCode AS ExitOrWithdrawalTypeMap         
		, AdjustedExitOrWithdrawalTypeCode                
		, sssrd4.InputCode AS AdjustedExitOrWithdrawalTypeMap         
		, ExitOrWithdrawalStatusCode
		, sssrd5.InputCode AS ExitOrWithdrawalStatusMap         
	FROM rds.DimK12EnrollmentStatuses rdkes
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkes.EnrollmentStatusCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefEnrollmentStatus'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdkes.EntryTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefEntryType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdkes.ExitOrWithdrawalTypeCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefExitOrWithdrawalType'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdkes.AdjustedExitOrWithdrawalTypeCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefAdjustedExitOrWithdrawalType'
		AND rsy.SchoolYear = sssrd4.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd5
		ON rdkes.ExitOrWithdrawalStatusCode = sssrd5.OutputCode
		AND sssrd5.TableName = 'RefExitOrWithdrawalStatus'
		AND rsy.SchoolYear = sssrd5.SchoolYear