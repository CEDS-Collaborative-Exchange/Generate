CREATE VIEW [RDS].[vwAssessment_FactTable_C225] 
AS
    SELECT 
          f.SchoolYear
        , f.K12StudentStudentIdentifierState
		, f.StateANSICode
		, f.StateAbbreviationCode
		, f.StateAbbreviationDescription
		, f.SeaOrganizationIdentifierSea
		, f.SeaOrganizationName
        , f.LeaIdentifierSea
        , f.LeaOrganizationName
        , f.AssessmentAcademicSubjectCode
		, CASE f.AssessmentAcademicSubjectEdFactsCode
            WHEN 'Math' THEN 'M'
            ELSE f.AssessmentAcademicSubjectEdFactsCode
          END AS AssessmentAcademicSubjectEdFactsCode
		, ata.ProficientOrAboveLevel
		, ata.PerformanceLevels
		, RIGHT(f.AssessmentPerformanceLevelLabel, 1) AS AssessmentPerformanceLevelLabel
        , CASE
            WHEN ata.ProficientOrAboveLevel <= RIGHT(f.AssessmentPerformanceLevelLabel, 1) THEN 'PROFICIENT'
            ELSE 'NOTPROFICIENT'
        END AS ProficiencyStatusEdFactsCode
    FROM  debug.vwAssessment_FactTable f
    JOIN  App.ToggleAssessments ata
        ON f.AssessmentAcademicSubjectEdFactsCode = ata.Subject
        AND f.AssessmentTitle = ata.AssessmentName
        AND f.AssessmentTypeAdministeredCode = ata.AssessmentTypeCode
        AND f.GradeLevelEdFactsCode = ata.Grade
    WHERE f.AssessmentAcademicSubjectCode IN ('01166', '13373')
		AND f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '2'
