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
    INNER JOIN rds.DimK12Schools rdks
        ON fact.DimK12SchoolId = rdks.DimK12SchoolId
    WHERE fact.EconomicDisadvantageStatusCode = 'Yes'
    AND rdks.SchoolOperationalStatus NOT IN ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
    AND fact.SchoolTypeCode <> 'Reportable'