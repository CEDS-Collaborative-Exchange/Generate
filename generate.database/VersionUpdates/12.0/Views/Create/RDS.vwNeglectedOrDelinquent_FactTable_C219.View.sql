CREATE VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C219] 
AS
	SELECT
        f.SchoolYear
        , f.K12StudentStudentIdentifierState
		, f.NeglectedOrDelinquentStatusCode
		, f.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		, f.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode
		, f.StateANSICode
		, f.StateAbbreviationCode
		, f.StateAbbreviationDescription
		, f.SeaOrganizationIdentifierSea
		, f.SeaOrganizationName
		, f.LeaIdentifierSea
		, f.LeaOrganizationName

    FROM  debug.vwNeglectedOrDelinquent_FactTable f
    WHERE f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '2'
		AND ISNULL(f.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode, '') <> ''

