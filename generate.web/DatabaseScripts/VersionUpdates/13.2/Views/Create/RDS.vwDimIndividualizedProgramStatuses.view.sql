CREATE VIEW RDS.vwDimIndividualizedProgramStatuses
AS
	SELECT  rdips.DimIndividualizedProgramStatusId
			, rsy.SchoolYear
			, rdips.IndividualizedProgramTypeCode
			, ISNULL(sssrd.InputCode, 'MISSING') AS IndividualizedProgramTypeMap
			, rdips.StudentSupportServiceTypeCode
			, ISNULL(sssrd1.InputCode, 'MISSING') AS StudentSupportServiceTypeMap
			, rdips.ConsentToEvaluationIndicatorCode
			,  CASE rdips.ConsentToEvaluationIndicatorCode 
			    WHEN 'Yes' THEN 1 
				WHEN 'No' THEN 0
				ELSE 0
			  END AS ConsentToEvaluationIndicatorMap
	FROM rds.DimIndividualizedProgramStatuses rdips
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
			ON rdips.IndividualizedProgramTypeCode = sssrd.OutputCode
			AND rsy.SchoolYear = sssrd.SchoolYear
			AND sssrd.TableName = 'RefIndividualizedProgramType'
	LEFT JOIN Staging.SourceSystemReferenceData sssrd1
			ON rdips.StudentSupportServiceTypeCode = sssrd1.OutputCode
			AND rsy.SchoolYear = sssrd1.SchoolYear
			AND sssrd1.TableName = 'RefStudentSupportServiceType'