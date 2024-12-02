CREATE VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C220] 
AS
	SELECT
        f.SchoolYear
        , f.K12StudentStudentIdentifierState
		, f.NeglectedOrDelinquentStatusCode
		, f.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		, f.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
		, f.StateANSICode
		, f.StateAbbreviationCode
		, f.StateAbbreviationDescription
		, f.SeaOrganizationIdentifierSea
		, f.SeaOrganizationName

    FROM  debug.vwNeglectedOrDelinquent_FactTable f
    WHERE f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '1'
		AND ISNULL(f.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode, '') <> ''
