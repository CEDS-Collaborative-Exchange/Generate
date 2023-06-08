CREATE VIEW [RDS].[vwDimTitleIIIStatuses] AS
	SELECT
		  rdt3s.DimTitleIIIStatusId
		, rsy.SchoolYear
		, rdt3s.ProgramParticipationTitleIIILiepCode
		, rdt3s.ProficiencyStatusCode
		, sssrd3.OutputCode AS ProficiencyStatusMap
	FROM rds.DimTitleIIIStatuses rdt3s
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdt3s.ProficiencyStatusCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefTitleIIIProfessionalDevelopmentType'
		AND rsy.SchoolYear = sssrd3.SchoolYear
