CREATE VIEW RDS.vwMembership_FactTable_226
AS
    SELECT  
        SchoolYear
		, fact.StateANSICode
		, fact.StateAbbreviationCode
		, fact.StateAbbreviationDescription
		, fact.SeaOrganizationIdentifierSea
		, fact.SeaOrganizationName
        , fact.K12StudentStudentIdentifierState
        , fact.LeaIdentifierSea
        , fact.SchoolIdentifierSea
        , fact.NameOfInstitution
    FROM [debug].[vwMembership_FactTable] fact
    WHERE fact.EconomicDisadvantageStatusEdFactsCode = 'ECODIS'
    AND fact.SchoolOperationalStatus NOT IN ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
	AND fact.SchoolReportedFederally <> 0
    AND fact.SchoolTypeCode <> 'Reportable'
