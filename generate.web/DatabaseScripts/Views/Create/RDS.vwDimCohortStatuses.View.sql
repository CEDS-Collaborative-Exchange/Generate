CREATE VIEW rds.vwDimCohortStatuses 
AS
	SELECT
		  DimCohortStatusId
		, rsy.SchoolYear
		, rdcs.EdFactsCohortGraduationStatusCode
		, CASE rdcs.EdFactsCohortGraduationStatusCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS EdFactsCohortGraduationStatusMap
	FROM rds.DimCohortStatuses rdcs
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
