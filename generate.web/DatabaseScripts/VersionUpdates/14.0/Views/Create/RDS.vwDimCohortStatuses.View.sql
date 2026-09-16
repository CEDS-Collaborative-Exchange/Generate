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
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
