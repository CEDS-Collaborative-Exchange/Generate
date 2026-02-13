CREATE VIEW RDS.vwDimComprehensiveAndTargetedSupports
AS
	SELECT
		cts.DimComprehensiveAndTargetedSupportId
		, rsy.SchoolYear
		, cts.AdditionalTargetedSupportAndImprovementStatusCode
		, ssrd2.InputCode AS [AdditionalTargetedSupportAndImprovementStatusMap]
		, cts.ComprehensiveSupportAndImprovementStatusCode
		, ssrd3.InputCode AS [ComprehensiveSupportAndImprovementStatusMap]
		, cts.TargetedSupportAndImprovementStatusCode
		, ssrd4.InputCode AS [TargetedSupportAndImprovementStatusMap]
	FROM RDS.DimComprehensiveAndTargetedSupports cts
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN Staging.SourceSystemReferenceData ssrd2
		ON cts.AdditionalTargetedSupportAndImprovementStatusCode = ssrd2.OutputCode
		AND ssrd2.TableName = 'RefAdditionalTargetedSupportAndImprovementStatus'
		AND rsy.SchoolYear = ssrd2.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData ssrd3
		ON cts.ComprehensiveSupportAndImprovementStatusCode = ssrd3.OutputCode
		AND ssrd3.TableName = 'RefComprehensiveSupportAndImprovementStatus'
		AND rsy.SchoolYear = ssrd3.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData ssrd4
		ON cts.TargetedSupportAndImprovementStatusCode = ssrd4.OutputCode
		AND ssrd4.TableName = 'RefTargetedSupportAndImprovementStatus'
		AND rsy.SchoolYear = ssrd4.SchoolYear
