CREATE VIEW [RDS].[vwDimCteOutcomeIndicators] 
AS
	SELECT
		DimCteOutcomeIndicatorId
		, rsy.SchoolYear
		, rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		, sssrd1.InputCode AS EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap
		, rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		, sssrd2.InputCode AS EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap
		, rdcoi.PerkinsPostProgramPlacementIndicatorCode
		, sssrd3.InputCode AS PerkinsPostProgramPlacementIndicatorMap
	FROM rds.DimCteOutcomeIndicators rdcoi
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdcoi.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdcoi.PerkinsPostProgramPlacementIndicatorCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefPerkinsPostProgramPlacementIndicatorCode'
		AND rsy.SchoolYear = sssrd3.SchoolYear
