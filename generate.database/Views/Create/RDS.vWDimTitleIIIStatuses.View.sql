CREATE VIEW [RDS].[vwDimTitleIIIStatuses] AS
	SELECT
		  rdt3s.DimTitleIIIStatusId
		, rsy.SchoolYear
		, rdt3s.TitleIIIProgramParticipationCode
		, CASE rdt3s.TitleIIIProgramParticipationCode
			WHEN 'Yes' THEN 1 
			WHEN 'No' THEN 0
			ELSE -1
		  END AS TitleIIIProgramParticipationMap
		, rdt3s.FormerEnglishLearnerYearStatusCode
		, '?' AS FormerEnglishLearnerYearStatusMap
		, rdt3s.ProficiencyStatusCode
		, sssrd3.OutputCode AS ProficiencyStatusMap
	FROM rds.DimTitleIIIStatuses rdt3s
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdt3s.ProficiencyStatusCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefTitleIIIProfessionalDevelopmentType'
		AND rsy.SchoolYear = sssrd3.SchoolYear
