CREATE VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C219] 
AS
	SELECT
        f.SchoolYear
        , f.K12StudentStudentIdentifierState
		, f.NeglectedOrDelinquentStatusCode
		, f.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		, f.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode

    FROM  debug.vwNeglectedOrDelinquent_FactTable f
    WHERE f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '2'
		AND ISNULL(f.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode, '') <> ''
