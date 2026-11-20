CREATE VIEW [RDS].[vwDimSchoolPerformanceIndicatorStateDefinedStatuses]
AS
	SELECT dspisds.DimSchoolPerformanceIndicatorStateDefinedStatusId
		, rsy.SchoolYear
		, dspisds.SchoolPerformanceIndicatorStateDefinedStatusCode
		, ssrd.InputCode AS [SchoolPerformanceIndicatorStateDefinedStatusMap]
	FROM RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses dspisds
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dspisds.SchoolPerformanceIndicatorStateDefinedStatusCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSchoolPerformanceIndicatorStateDefinedStatuses'
		AND rsy.SchoolYear = ssrd.SchoolYear
