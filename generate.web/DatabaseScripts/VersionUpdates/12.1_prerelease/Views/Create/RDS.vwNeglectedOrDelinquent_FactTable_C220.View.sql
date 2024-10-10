CREATE VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C220] 
AS
	WITH excludedLeas AS (
		SELECT DISTINCT LEAIdentifierSea
		FROM Staging.K12Organization sko
			LEFT JOIN Staging.SourceSystemReferenceData sssrd
				ON sko.SchoolYear = sssrd.SchoolYear
				AND sko.LEA_OperationalStatus = sssrd.InputCode
				AND sssrd.Tablename = 'RefOperationalStatus'
				AND sssrd.TableFilter = '000174'
		WHERE LEA_IsReportedFederally = 0
			OR sssrd.OutputCode in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
	)
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
		,f.LeaIdentifierSea
    FROM  debug.vwNeglectedOrDelinquent_FactTable f
	LEFT JOIN excludedLeas el ON el.LeaIdentifierSea= f.LeaIdentifierSea
    WHERE f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '1'
		AND ISNULL(f.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode, '') <> ''
		AND f.LeaIdentifierSea IS NOT NULL
		AND EL.LeaIdentifierSea IS NULL




