CREATE VIEW RDS.vwMembership_FactTable_c226
AS
    SELECT  
          SchoolYear
		, StateANSICode
		, StateAbbreviationCode
		, StateAbbreviationDescription
		, SeaOrganizationIdentifierSea
		, SeaOrganizationName
        , K12StudentStudentIdentifierState
        , LeaIdentifierSea
        , SchoolIdentifierSea
        , NameOfInstitution
    FROM [debug].[vwMembership_FactTable] fact
    INNER JOIN rds.DimK12Schools rdks
        ON fact.DimK12SchoolId = rdks.DimK12SchoolId
    WHERE fact.EconomicDisadvantageStatusCode = 'Yes'
    AND rdks.SchoolOperationalStatus NOT IN ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
    AND fact.SchoolTypeCode <> 'Reportable'