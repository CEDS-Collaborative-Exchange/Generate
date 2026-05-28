	CREATE VIEW [RDS].[vwDimCharterSchoolStatuses] 
	AS
		SELECT
			  DimCharterSchoolStatusId
			, rsy.SchoolYear
			, rdcss.AppropriationMethodCode
			, sssrd.InputCode AS AppropriationMethodMap
		FROM rds.DimCharterSchoolStatuses rdcss
		CROSS JOIN (select sy.SchoolYear
    				from rds.DimSchoolYearDataMigrationTypes dm
	    				inner join rds.dimschoolyears sy
			    			on dm.dimschoolyearid = sy.dimschoolyearid
					where IsSelected = 1
					and dm.DataMigrationTypeId = 3
				) AS rsy
		LEFT JOIN staging.SourceSystemReferenceData sssrd
			ON rdcss.AppropriationMethodCode = sssrd.OutputCode
			AND sssrd.TableName = 'RefCharterSchoolAppropriationMethod'
			AND rsy.SchoolYear = sssrd.SchoolYear