CREATE VIEW [RDS].[vwAssessment_FactTable_C224] 
AS
    SELECT 
        f.SchoolYear
        , f.K12StudentStudentIdentifierState
        , f.AssessmentAcademicSubjectCode
		, f.AssessmentAcademicSubjectEdFactsCode
		, ata.ProficientOrAboveLevel
		, ata.PerformanceLevels
		, RIGHT(f.AssessmentPerformanceLevelLabel, 1)
        , CASE
            WHEN ata.ProficientOrAboveLevel <= RIGHT(f.AssessmentPerformanceLevelLabel, 1) THEN 'PROFICIENT'
            ELSE 'NOTPROFICIENT'
        END AS PROFICIENCYSTATUS
    FROM  debug.vwAssessment_FactTable f
    JOIN  App.ToggleAssessments ata
        ON f.AssessmentAcademicSubjectEdFactsCode = ata.Subject
        AND f.AssessmentTitle = ata.AssessmentName
        AND f.AssessmentTypeAdministeredCode = ata.AssessmentTypeCode
        AND f.GradeLevelEdFactsCode = ata.Grade
    WHERE f.AssessmentAcademicSubjectCode IN ('01166', '13373')
		AND f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '1'
