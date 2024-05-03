CREATE VIEW rds.vwDimNOrDStatuses 
AS
	SELECT
		  rdnods.DimNOrDStatusId
		, rsy.SchoolYear

		, rdnods.NeglectedOrDelinquentStatusCode
		, sssrd8.InputCode as NeglectedOrDelinquentStatusMap

		, rdnods.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		, sssrd7.InputCode as NeglectedOrDelinquentProgramEnrollmentSubpartMap

		, rdnods.NeglectedOrDelinquentLongTermStatusCode
		, rdnods.NeglectedOrDelinquentLongTermStatusEdFactsCode

		, rdnods.NeglectedOrDelinquentProgramTypeCode
		, sssrd.InputCode AS NeglectedOrDelinquentProgramTypeMap
		
		, rdnods.NeglectedProgramTypeCode
		, sssrd.InputCode AS NeglectedProgramTypeMap
		
		, rdnods.DelinquentProgramTypeCode
		, sssrd2.InputCode AS DelinquentProgramTypeMap

		, rdnods.NeglectedOrDelinquentAcademicAchievementIndicatorCode
		, sssrd4.InputCode as NeglectedOrDelinquentAcademicAchievementIndicatorMap

		, rdnods.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
		, sssrd3.InputCode as NeglectedOrDelinquentAcademicOutcomeIndicatorMap
		
		, rdnods.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		, sssrd5.InputCode as EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap
		
		, rdnods.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		, sssrd6.InputCode as EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap



	FROM rds.DimNOrDStatuses rdnods
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdnods.NeglectedOrDelinquentProgramTypeCode = sssrd.OutputCode
		AND sssrd.TableName = 'RefNeglectedOrDelinquentProgramType'
		AND rsy.SchoolYear = sssrd.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdnods.NeglectedProgramTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefNeglectedProgramType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdnods.DelinquentProgramTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefDelinquentProgramType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdnods.NeglectedOrDelinquentAcademicAchievementIndicatorCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefNeglectedOrDelinquentAcademicAchievementIndicator'
		AND rsy.SchoolYear = sssrd4.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdnods.NeglectedOrDelinquentAcademicOutcomeIndicatorCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefNeglectedOrDelinquentAcademicOutcomeIndicator'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd5
		ON rdnods.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = sssrd5.OutputCode
		AND sssrd5.TableName = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode'
		AND rsy.SchoolYear = sssrd5.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd6
		ON rdnods.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = sssrd6.OutputCode
		AND sssrd6.TableName = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode'
		AND rsy.SchoolYear = sssrd6.SchoolYear

	LEFT JOIN staging.SourceSystemReferenceData sssrd7
		ON rdnods.NeglectedOrDelinquentProgramEnrollmentSubpartCode = sssrd7.OutputCode
		AND sssrd7.TableName = 'RefNeglectedOrDelinquentProgramEnrollmentSubpart'
		AND rsy.SchoolYear = sssrd7.SchoolYear

	LEFT JOIN staging.SourceSystemReferenceData sssrd8
		ON rdnods.NeglectedOrDelinquentStatusCode = sssrd8.OutputCode
		AND sssrd8.TableName = 'RefNeglectedOrDelinquentStatusCode'
		AND rsy.SchoolYear = sssrd8.SchoolYear

