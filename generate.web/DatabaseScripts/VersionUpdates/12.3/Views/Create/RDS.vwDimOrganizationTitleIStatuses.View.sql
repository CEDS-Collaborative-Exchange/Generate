	CREATE VIEW [RDS].[vwDimOrganizationTitleIStatuses]
	AS
		SELECT
			  rdot1s.DimOrganizationTitleIStatusId
			, rsy.SchoolYear
			, rdot1s.TitleIInstructionalServicesCode
			, sssrd1.InputCode AS TitleIInstructionalServicesMap
			, rdot1s.TitleIProgramTypeCode
			, sssrd2.InputCode AS TitleIProgramTypeMap
			, rdot1s.TitleISchoolStatusCode
			, sssrd3.InputCode AS TitleISchoolStatusMap
			, rdot1s.TitleISupportServicesCode
			, sssrd4.InputCode AS TitleISupportServicesMap
		FROM rds.DimOrganizationTitleIStatuses rdot1s
		CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON rdot1s.TitleISupportServicesCode = sssrd1.OutputCode
			AND sssrd1.TableName = 'RefTitleIInstructionServices'
			AND rsy.SchoolYear = sssrd1.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd2
			ON rdot1s.TitleIProgramTypeCode = sssrd2.OutputCode
			AND sssrd2.TableName = 'RefTitleIProgramType'
			AND rsy.SchoolYear = sssrd2.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd3
			ON rdot1s.TitleISchoolStatusCode = sssrd3.OutputCode
			AND sssrd3.TableName = 'RefTitleISchoolStatus'
			AND rsy.SchoolYear = sssrd3.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd4
			ON rdot1s.TitleISupportServicesCode = sssrd4.OutputCode
			AND sssrd4.TableName = 'RefK12LeaTitleISupportService'
			AND rsy.SchoolYear = sssrd4.SchoolYear
