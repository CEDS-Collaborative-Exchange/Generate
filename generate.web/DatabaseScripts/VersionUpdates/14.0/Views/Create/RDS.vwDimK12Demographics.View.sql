create VIEW RDS.vwDimK12Demographics 
AS
	SELECT
		  DimK12DemographicId
		, rsy.SchoolYear
		, SexCode
		, sssrd1.InputCode AS SexMap
	FROM rds.DimK12Demographics rdkd
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkd.SexCode = sssrd1.OutputCode
		AND rsy.SchoolYear = sssrd1.SchoolYear
		AND sssrd1.TableName = 'RefSex'