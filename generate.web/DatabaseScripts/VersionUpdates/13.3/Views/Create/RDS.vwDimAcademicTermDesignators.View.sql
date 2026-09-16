CREATE VIEW RDS.vwDimAcademicTermDesignators AS
	SELECT
		  DimAcademicTermDesignatorId
		, rsy.SchoolYear
		, AcademicTermDesignatorCode
		, sssrd1.InputCode				AS 'AcademicTermDesignatorMap'
	FROM rds.DimAcademicTermDesignators rdatd
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdatd.AcademicTermDesignatorCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefAcademicTermDesignator'
		AND rsy.SchoolYear = sssrd1.SchoolYear
