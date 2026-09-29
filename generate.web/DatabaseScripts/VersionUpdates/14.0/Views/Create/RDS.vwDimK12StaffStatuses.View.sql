CREATE VIEW [RDS].[vwDimK12StaffStatuses] AS
	SELECT
		DimK12StaffStatusId
		, rsy.SchoolYear
		, rdkss.SpecialEducationAgeGroupTaughtCode 
		, sssrd1.InputCode AS SpecialEducationAgeGroupTaughtMap
		, rdkss.EdFactsTeacherInexperiencedStatusCode 
		, sssrd2.InputCode AS EdFactsTeacherInexperiencedStatusMap
		, rdkss.EdFactsTeacherOutOfFieldStatusCode 
		, sssrd3.InputCode AS EdFactsTeacherOutOfFieldStatusMap
		, rdkss.ParaprofessionalQualificationStatusCode
		, sssrd4.InputCode AS ParaprofessionalQualificationStatusMap
		, rdkss.HighlyQualifiedTeacherIndicatorCode
		, CASE HighlyQualifiedTeacherIndicatorCode
			WHEN 'HIGHLYQUALIFIED' THEN 1
			WHEN 'NOTHIGHLYQUALIFIED' THEN 0
		END AS HighlyQualifiedTeacherIndicatorMap
		, rdkss.SpecialEducationTeacherQualificationStatusCode
		, sssrd5.InputCode AS SpecialEducationTeacherQualificationStatusMap
		, rdkss.EdFactsCertificationStatusCode
		, sssrd6.InputCode AS EdFactsCertificationStatusMap
		, rdkss.SpecialEducationRelatedServicesPersonnelCode
		, 'MISSING' AS SpecialEducationRelatedServicesPersonnelMap
		, rdkss.CTEInstructorIndustryCertificationCode
		, 'MISSING' AS CTEInstructorIndustryCertificationMap
		, rdkss.SpecialEducationParaprofessionalCode
		, 'MISSING' AS SpecialEducationParaprofessionalMap
		, rdkss.SpecialEducationTeacherCode
		, 'MISSING' AS SpecialEducationTeacherMap
	FROM rds.DimK12StaffStatuses rdkss
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkss.SpecialEducationAgeGroupTaughtCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefSpecialEducationAgeGroupTaught'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdkss.EdFactsTeacherInexperiencedStatusCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefEdFactsTeacherInexperiencedStatus'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdkss.EdFactsTeacherOutOfFieldStatusCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefOutOfFieldStatus'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdkss.ParaprofessionalQualificationStatusCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefParaprofessionalQualification'
		AND rsy.SchoolYear = sssrd4.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd5
		ON rdkss.SpecialEducationTeacherQualificationStatusCode = sssrd5.OutputCode
		AND sssrd5.TableName = 'RefSpecialEducationTeacherQualificationStatus'
		AND rsy.SchoolYear = sssrd5.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd6
		ON rdkss.EdFactsCertificationStatusCode = sssrd6.OutputCode
		AND sssrd6.TableName = 'RefEdFactsCertificationStatus'
		AND rsy.SchoolYear = sssrd6.SchoolYear
