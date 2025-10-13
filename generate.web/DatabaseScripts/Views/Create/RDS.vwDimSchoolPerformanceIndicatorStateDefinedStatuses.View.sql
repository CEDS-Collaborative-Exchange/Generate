CREATE VIEW [RDS].[vwDimSchoolPerformanceIndicatorStateDefinedStatuses]
AS
	SELECT dspisds.DimSchoolPerformanceIndicatorStateDefinedStatusId
		, rsy.SchoolYear
		, dspisds.SchoolPerformanceIndicatorStateDefinedStatusCode
		, ssrd.InputCode AS [SchoolPerformanceIndicatorStateDefinedStatusMap]
	FROM RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses dspisds
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dspisds.SchoolPerformanceIndicatorStateDefinedStatusCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSchoolPerformanceIndicatorStateDefinedStatuses'
		AND rsy.SchoolYear = ssrd.SchoolYear
