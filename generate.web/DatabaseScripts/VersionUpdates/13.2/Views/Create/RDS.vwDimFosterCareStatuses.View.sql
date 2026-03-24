CREATE VIEW rds.vwDimFosterCareStatuses 
AS
	SELECT
		  DimFosterCareStatusId
		, rsy.SchoolYear
		, rdfcs.ProgramParticipationFosterCareCode
		, CASE rdfcs.ProgramParticipationFosterCareCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS ProgramParticipationFosterCareMap
	FROM rds.DimFosterCareStatuses rdfcs
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
