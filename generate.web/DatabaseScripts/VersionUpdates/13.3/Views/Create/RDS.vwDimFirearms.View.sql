CREATE VIEW [RDS].[vwDimFirearms] 
AS
	SELECT
		DimFirearmId
		, rsy.SchoolYear
		, rdf.FirearmTypeCode
		, sssrd.InputCode AS FirearmTypeMap
	FROM rds.DimFirearms rdf
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdf.FirearmTypeCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefFirearmType'
		AND rsy.SchoolYear = sssrd.SchoolYear
