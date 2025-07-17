CREATE VIEW rds.vwDimNOrDStatuses 
AS
	SELECT
		  rdnods.DimNOrDStatusId
		, rsy.SchoolYear

		, rdnods.NeglectedOrDelinquentStatusCode
		, case 
				when rdnods.NeglectedOrDelinquentStatusCode = 'Yes' then 1
				when rdnods.NeglectedOrDelinquentStatusCode = 'No' then 0
				else NULL 
			end as NeglectedOrDelinquentStatusMap

		, rdnods.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		, sssrd5.InputCode as NeglectedOrDelinquentProgramEnrollmentSubpartMap

		, rdnods.NeglectedOrDelinquentLongTermStatusCode
		, case 
				when rdnods.NeglectedOrDelinquentLongTermStatusCode = 'NDLONGTERM' then 1
				when rdnods.NeglectedOrDelinquentLongTermStatusCode = 'NISSING' then 0
				else NULL 
			end as NeglectedOrDelinquentLongTermStatusMap

		, rdnods.NeglectedOrDelinquentProgramTypeCode
		, sssrd.InputCode AS NeglectedOrDelinquentProgramTypeMap
		
		, rdnods.NeglectedProgramTypeCode
		, sssrd1.InputCode AS NeglectedProgramTypeMap
		
		, rdnods.DelinquentProgramTypeCode
		, sssrd2.InputCode AS DelinquentProgramTypeMap

		, rdnods.NeglectedOrDelinquentAcademicAchievementIndicatorCode
		, sssrd4.InputCode as NeglectedOrDelinquentAcademicAchievementIndicatorMap

		, rdnods.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
		, sssrd3.InputCode as NeglectedOrDelinquentAcademicOutcomeIndicatorMap
		
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
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdnods.NeglectedOrDelinquentAcademicOutcomeIndicatorCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefNeglectedOrDelinquentAcademicOutcomeIndicator'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdnods.NeglectedOrDelinquentAcademicAchievementIndicatorCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefNeglectedOrDelinquentAcademicAchievementIndicator'
		AND rsy.SchoolYear = sssrd4.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd5
		ON rdnods.NeglectedOrDelinquentProgramEnrollmentSubpartCode = sssrd5.OutputCode
		AND sssrd5.TableName = 'RefNeglectedOrDelinquentProgramEnrollmentSubpart'
		AND rsy.SchoolYear = sssrd5.SchoolYear
