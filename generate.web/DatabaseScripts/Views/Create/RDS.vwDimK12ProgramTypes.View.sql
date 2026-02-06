CREATE VIEW rds.vwDimK12ProgramTypes
AS
	SELECT
		  DimK12ProgramTypeId
		, rsy.SchoolYear
		, ProgramTypeCode
		, sssrd.InputCode AS ProgramTypeMap
	FROM rds.DimK12ProgramTypes rdkpt
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdkpt.ProgramTypeCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefProgramType'
		AND rsy.SchoolYear = sssrd.SchoolYear
