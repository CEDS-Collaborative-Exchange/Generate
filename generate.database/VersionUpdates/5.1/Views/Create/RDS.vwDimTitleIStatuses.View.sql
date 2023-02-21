create VIEW RDS.vwDimTitleIStatuses
AS
	SELECT
		rdtis.DimTitleIStatusId
		, rsy.SchoolYear
		, rdtis.TitleIInstructionalServicesCode
		, sssrd1.InputCode AS TitleIInstructionalServicesMap
		, TitleIProgramTypeCode
		, sssrd2.InputCode AS TitleIProgramTypeMap
		, TitleISchoolStatusCode
		, sssrd3.InputCode AS TitleISchoolStatusMap
		, TitleISupportServicesCode
		, sssrd4.InputCode AS TitleISupportServicesMap
	FROM rds.DimTitleIStatuses rdtis
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdtis.TitleIInstructionalServicesCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefTitleIInstructionalServices'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdtis.TitleIProgramTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefTitleIProgramType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdtis.TitleISchoolStatusCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefTitleISchoolStatus'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdtis.TitleISupportServicesCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefK12LeaTitleISupportService'
		AND rsy.SchoolYear = sssrd4.SchoolYear
