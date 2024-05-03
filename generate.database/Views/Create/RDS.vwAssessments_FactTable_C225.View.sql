CREATE VIEW [RDS].[vwAssessment_FactTable_C225] 
AS
    SELECT DISTINCT 
          f.SchoolYear
        , f.LeaIdentifierSea
        , f.K12StudentStudentIdentifierState
        , f.AssessmentAcademicSubjectCode
        , CASE
            WHEN ata.ProficientOrAboveLevel <= ata.PerformanceLevels THEN 'PROFICIENT'
            ELSE 'NOTPROFICIENT'
        END AS PROFICIENCYSTATUS
    FROM  debug.vwAssessments_FactTable f
    JOIN  App.ToggleAssessments ata
        ON RIGHT(f.AssessmentPerformanceLevelLabel, 1) = ata.PerformanceLevels
        AND f.AssessmentAcademicSubjectCode = ata.Subject
        AND f.AssessmentTitle = ata.AssessmentName
        AND f.AssessmentTypeAdministeredCode = ata.AssessmentTypeCode
        AND f.GradeLevelEdFactsCode = ata.Grade
    WHERE f.NeglectedOrDelinquentProgramTypeCode <> 'MISSING'
        AND f.AssessmentAcademicSubjectCode IN ('01166', '13373')
        AND f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '2'
