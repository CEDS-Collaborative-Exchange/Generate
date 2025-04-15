CREATE VIEW [RDS].[vwDimAssessments] 
AS
	SELECT
		DimAssessmentId
		, rsy.SchoolYear
		, AssessmentIdentifierState
		, AssessmentFamilyShortName
		, AssessmentTitle
		, AssessmentShortName
		, AssessmentTypeCode
		, ISNULL(sssrd1.InputCode, 'MISSING') AS AssessmentTypeMap
		, AssessmentAcademicSubjectCode
		, ISNULL(sssrd2.InputCode, 'MISSING') AS AssessmentAcademicSubjectMap
		, AssessmentTypeAdministeredCode
		, ISNULL(sssrd3.InputCode, 'MISSING') AS AssessmentTypeAdministeredMap
		, AssessmentTypeAdministeredToEnglishLearnersCode
		, ISNULL(sssrd4.InputCode, 'MISSING') AS AssessmentTypeAdministeredToEnglishLearnersMap
	FROM rds.DimAssessments rda
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rda.AssessmentTypeCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefAssessmentType'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rda.AssessmentAcademicSubjectCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefAcademicSubject'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rda.AssessmentTypeAdministeredCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefAssessmentTypeAdministered'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rda.AssessmentTypeAdministeredToEnglishLearnersCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefAssessmentTypeAdministeredToEnglishLearners'
		AND rsy.SchoolYear = sssrd4.SchoolYear

