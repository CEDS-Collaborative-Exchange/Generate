CREATE VIEW [RDS].[vwDimAssessmentResults] 
AS
	SELECT
		DimAssessmentResultId
		, rsy.SchoolYear
		, AssessmentScoreMetricTypeCode
		, sssrd1.InputCode AS AssessmentScoreMetricTypeMap
	FROM rds.DimAssessmentResults rdar
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdar.AssessmentScoreMetricTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefScoreMetricType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
