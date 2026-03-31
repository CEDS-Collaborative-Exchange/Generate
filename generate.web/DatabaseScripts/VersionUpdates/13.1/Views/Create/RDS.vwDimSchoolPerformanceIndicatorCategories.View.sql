CREATE VIEW [RDS].[vwDimSchoolPerformanceIndicatorCategories]
AS
	SELECT dspic.DimSchoolPerformanceIndicatorCategoryId
		, rsy.SchoolYear
		, dspic.SchoolPerformanceIndicatorCategoryCode
		, ssrd.InputCode AS [SchoolPerformanceIndicatorCategoryMap]
	FROM RDS.DimSchoolPerformanceIndicatorCategories dspic
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dspic.SchoolPerformanceIndicatorCategoryCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefSchoolPerformanceIndicatorCategories'
		AND rsy.SchoolYear = ssrd.SchoolYear