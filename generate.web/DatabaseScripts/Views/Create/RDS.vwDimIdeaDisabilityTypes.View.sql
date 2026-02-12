CREATE VIEW rds.vwDimIdeaDisabilityTypes 
AS
	SELECT
		DimIdeaDisabilityTypeId
		, rsy.SchoolYear
		, rdidt.IdeaDisabilityTypeCode
		, sssrd.InputCode AS IdeaDisabilityTypeMap
	FROM rds.DimIdeaDisabilityTypes rdidt
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdidt.IdeaDisabilityTypeCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefIDEADisabilityType'
		AND rsy.SchoolYear = sssrd.SchoolYear



