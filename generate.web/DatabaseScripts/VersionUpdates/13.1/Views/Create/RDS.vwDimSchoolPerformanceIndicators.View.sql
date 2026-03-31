CREATE VIEW [RDS].[vwDimSchoolPerformanceIndicators]
AS
	SELECT dspi.DimSchoolPerformanceIndicatorId
		, rsy.SchoolYear
		, dspi.SchoolPerformanceIndicatorTypeCode
		, ssrd.InputCode AS [SchoolPerformanceIndicatorTypeMap]
	FROM RDS.DimSchoolPerformanceIndicators dspi
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dspi.SchoolPerformanceIndicatorTypeCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSchoolPerformanceIndicators'
		AND rsy.SchoolYear = ssrd.SchoolYear
