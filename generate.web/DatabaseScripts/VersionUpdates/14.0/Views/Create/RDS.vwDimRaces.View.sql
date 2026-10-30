CREATE VIEW [RDS].[vwDimRaces]
AS
	SELECT
		  DimRaceId
		, rsy.SchoolYear
		, RaceCode
		, case 
			when RaceCode = 'HispanicorLatinoEthnicity' then 'HispanicorLatinoEthnicity' 
			else sssrd.InputCode end
		  as RaceMap
	FROM rds.DimRaces rdr
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdr.RaceCode = sssrd.OutputCode
		AND sssrd.TableName = 'refRace'
		AND rsy.SchoolYear = sssrd.SchoolYear