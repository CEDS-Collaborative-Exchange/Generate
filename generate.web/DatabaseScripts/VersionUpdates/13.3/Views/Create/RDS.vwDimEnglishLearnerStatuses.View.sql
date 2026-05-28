CREATE VIEW rds.vwDimEnglishLearnerStatuses 
AS
	SELECT
		DimEnglishLearnerStatusId
		, rsy.SchoolYear
		, rdels.EnglishLearnerStatusCode
		, CASE rdels.EnglishLearnerStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		END AS EnglishLearnerStatusMap
		, rdels.PerkinsEnglishLearnerStatusCode
		, CASE rdels.PerkinsEnglishLearnerStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		END AS PerkinsEnglishLearnerStatusMap
	FROM rds.DimEnglishLearnerStatuses rdels
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
