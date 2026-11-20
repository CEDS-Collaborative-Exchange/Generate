CREATE VIEW [RDS].[vwDimSchoolPerformanceIndicators]
AS
	SELECT dspi.DimSchoolPerformanceIndicatorId
		, rsy.SchoolYear
		, dspi.SchoolPerformanceIndicatorTypeCode
		, ssrd.InputCode AS [SchoolPerformanceIndicatorTypeMap]
	FROM RDS.DimSchoolPerformanceIndicators dspi
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dspi.SchoolPerformanceIndicatorTypeCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSchoolPerformanceIndicators'
		AND rsy.SchoolYear = ssrd.SchoolYear
