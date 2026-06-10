CREATE VIEW [RDS].[vwDimSchoolPerformanceIndicatorCategories]
AS
	SELECT dspic.DimSchoolPerformanceIndicatorCategoryId
		, rsy.SchoolYear
		, dspic.SchoolPerformanceIndicatorCategoryCode
		, ssrd.InputCode AS [SchoolPerformanceIndicatorCategoryMap]
	FROM RDS.DimSchoolPerformanceIndicatorCategories dspic
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dspic.SchoolPerformanceIndicatorCategoryCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSchoolPerformanceIndicatorCategories'
		AND rsy.SchoolYear = ssrd.SchoolYear