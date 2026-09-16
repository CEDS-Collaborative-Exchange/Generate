CREATE VIEW [RDS].[vwDimK12CourseStatuses] 
AS
	Select 
	rdkd.DimK12CourseStatusId,
	rsy.SchoolYear,
	rdkd.CourseLevelCharacteristicCode,
	sssrd1.InputCode AS CourseLevelCharacteristicMap,
	sssrd1.TableName
	From rds.DimK12CourseStatuses rdkd
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkd.CourseLevelCharacteristicCode = sssrd1.OutputCode
		AND rsy.SchoolYear = sssrd1.SchoolYear		
		AND sssrd1.TableName = 'RefCourseLevelCharacteristic'
