CREATE VIEW RDS.vwDimSubgroups
AS
	SELECT ds.DimSubgroupId
		, rsy.SchoolYear
		, ds.SubgroupCode
		, ssrd.InputCode AS [SubgroupMap]
	FROM RDS.DimSubgroups ds
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON ds.SubgroupCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSubgroup'
		AND rsy.SchoolYear = ssrd.SchoolYear