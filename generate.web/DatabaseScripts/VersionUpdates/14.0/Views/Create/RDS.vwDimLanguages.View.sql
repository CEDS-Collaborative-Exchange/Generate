CREATE VIEW [RDS].[vwDimLanguages]
AS
	SELECT
		  DimLanguageId
		, rsy.SchoolYear
		, Iso6392LanguageCodeCode
		, sssrd.InputCode AS Iso6392LanguageMap
	FROM rds.DimLanguages rdl
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdl.Iso6392LanguageCodeCode = sssrd.OutputCode
		AND sssrd.TableName = 'refLanguage'
		AND rsy.SchoolYear = sssrd.SchoolYear
