CREATE VIEW [RDS].[vwDimIndicatorStatuses]
AS
	SELECT dis.DimIndicatorStatusId
		, rsy.SchoolYear
		, dis.IndicatorStatusCode
		, ssrd.InputCode AS [IndicatorStatusMap]
	FROM RDS.DimIndicatorStatuses dis
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON dis.IndicatorStatusCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefIndicatorStatuses'
		AND rsy.SchoolYear = ssrd.SchoolYear
