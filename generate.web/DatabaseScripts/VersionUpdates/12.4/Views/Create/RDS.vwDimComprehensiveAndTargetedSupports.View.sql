CREATE VIEW RDS.vwDimComprehensiveAndTargetedSupports
AS
	SELECT
		cts.DimComprehensiveAndTargetedSupportId
		, sy.SchoolYear
		, cts.AdditionalTargetedSupportAndImprovementStatusCode
		, ssrd2.InputCode AS [AdditionalTargetedSupportAndImprovementStatusMap]
		, cts.ComprehensiveSupportAndImprovementStatusCode
		, ssrd3.InputCode AS [ComprehensiveSupportAndImprovementStatusMap]
		, cts.TargetedSupportAndImprovementStatusCode
		, ssrd4.InputCode AS [TargetedSupportAndImprovementStatusMap]
	FROM RDS.DimComprehensiveAndTargetedSupports cts
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM Staging.SourceSystemReferenceData) sy
	LEFT JOIN Staging.SourceSystemReferenceData ssrd2
		ON cts.AdditionalTargetedSupportAndImprovementStatusCode = ssrd2.OutputCode
		AND ssrd2.TableName = 'RefAdditionalTargetedSupportAndImprovementStatus'
		AND sy.SchoolYear = ssrd2.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData ssrd3
		ON cts.ComprehensiveSupportAndImprovementStatusCode = ssrd3.OutputCode
		AND ssrd3.TableName = 'RefComprehensiveSupportAndImprovementStatus'
		AND sy.SchoolYear = ssrd3.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData ssrd4
		ON cts.TargetedSupportAndImprovementStatusCode = ssrd4.OutputCode
		AND ssrd4.TableName = 'RefTargetedSupportAndImprovementStatus'
		AND sy.SchoolYear = ssrd4.SchoolYear
