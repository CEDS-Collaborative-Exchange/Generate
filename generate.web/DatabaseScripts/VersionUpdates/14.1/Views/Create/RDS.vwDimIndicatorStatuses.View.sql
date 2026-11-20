CREATE VIEW [RDS].[vwDimIndicatorStatuses]
AS
	SELECT dis.DimIndicatorStatusId
		, rsy.SchoolYear
		, dis.IndicatorStatusCode
		, ssrd.InputCode AS [IndicatorStatusMap]
	FROM RDS.DimIndicatorStatuses dis
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dis.IndicatorStatusCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefIndicatorStatuses'
		AND rsy.SchoolYear = ssrd.SchoolYear
