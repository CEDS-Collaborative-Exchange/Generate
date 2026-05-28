CREATE VIEW RDS.vwDimSubgroups
AS
	SELECT ds.DimSubgroupId
		, rsy.SchoolYear
		, ds.SubgroupCode
		, ssrd.InputCode AS [SubgroupMap]
	FROM RDS.DimSubgroups ds
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON ds.SubgroupCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSubgroup'
		AND rsy.SchoolYear = ssrd.SchoolYear