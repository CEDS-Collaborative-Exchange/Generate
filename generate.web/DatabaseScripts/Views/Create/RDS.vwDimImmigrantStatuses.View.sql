CREATE VIEW rds.vwDimImmigrantStatuses 
AS
	SELECT
		DimImmigrantStatusId
		, rsy.SchoolYear
		, rdis.TitleIIIImmigrantStatusCode
		, CASE rdis.TitleIIIImmigrantStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		END AS TitleIIIImmigrantStatusMap
		, rdis.TitleIIIImmigrantParticipationStatusCode
		, CASE rdis.TitleIIIImmigrantParticipationStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		END AS TitleIIIImmigrantParticipationStatusMap
	FROM rds.DimImmigrantStatuses rdis
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
