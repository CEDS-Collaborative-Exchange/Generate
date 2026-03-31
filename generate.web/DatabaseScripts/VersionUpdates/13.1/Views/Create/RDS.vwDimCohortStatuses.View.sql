CREATE VIEW rds.vwDimCohortStatuses 
AS
	SELECT
		  DimCohortStatusId
		, rsy.SchoolYear
		, rdcs.CohortStatusCode
		, CASE rdcs.CohortStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS CohortStatusMap
	FROM rds.DimCohortStatuses rdcs
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
