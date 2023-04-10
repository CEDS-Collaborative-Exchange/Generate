CREATE VIEW rds.vwDimEnglishLearnerStatuses 
AS
	SELECT
		  DimEnglishLearnerStatusId
		, rsy.SchoolYear
		, rdels.EnglishLearnerStatusCode
		, CASE rdels.EnglishLearnerStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS EnglishLearnerStatusMap
		, rdels.PerkinsLEPStatusCode
		, CASE rdels.PerkinsLEPStatusCode 
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS PerkinsLEPStatusMap
		, rdels.TitleIIIAccountabilityProgressStatusCode
		, sssrd1.OutputCode AS TitleIIIAccountabilityProgressStatusMap
		, rdels.TitleIIILanguageInstructionProgramTypeCode
		, sssrd2.OutputCode AS TitleIIILanguageInstructionProgramTypeMap
	FROM rds.DimEnglishLearnerStatuses rdels
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdels.TitleIIIAccountabilityProgressStatusCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefTitleIIIAccountability'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdels.TitleIIILanguageInstructionProgramTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefTitleIIILanguageInstructionProgramType'
		AND rsy.SchoolYear = sssrd2.SchoolYear