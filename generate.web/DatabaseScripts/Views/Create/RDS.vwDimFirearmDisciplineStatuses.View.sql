CREATE VIEW [RDS].[vwDimFirearmDisciplineStatuses] 
AS
	SELECT
		DimFirearmDisciplineStatusId
		, rsy.SchoolYear
		, rdfds.DisciplineMethodForFirearmsIncidentsCode
		, sssrd.InputCode AS DisciplineMethodForFirearmsIncidentsMap
		, rdfds.IdeaDisciplineMethodForFirearmsIncidentsCode
		, sssrd2.InputCode AS IdeaDisciplineMethodForFirearmsIncidentsMap
	FROM rds.DimFirearmDisciplineStatuses rdfds
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdfds.DisciplineMethodForFirearmsIncidentsCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefDisciplineMethodFirearms'
		AND rsy.SchoolYear = sssrd.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdfds.IdeaDisciplineMethodForFirearmsIncidentsCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefIdeaDisciplineMethodFirearm'
		AND rsy.SchoolYear = sssrd2.SchoolYear
