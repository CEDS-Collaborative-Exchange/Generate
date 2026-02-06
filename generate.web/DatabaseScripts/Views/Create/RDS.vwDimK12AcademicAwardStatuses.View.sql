create VIEW RDS.vwDimK12AcademicAwardStatuses
AS
	SELECT
		  DimK12AcademicAwardStatusId
		, rsy.SchoolYear
		, HighSchoolDiplomaTypeCode
		, sssrd1.InputCode AS HighSchoolDiplomaTypeMap
	FROM rds.DimK12AcademicAwardStatuses rdkaas
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkaas.HighSchoolDiplomaTypeCode = sssrd1.OutputCode
		AND rsy.SchoolYear = sssrd1.SchoolYear
		AND sssrd1.TableName = 'RefHighSchoolDiplomaType'
