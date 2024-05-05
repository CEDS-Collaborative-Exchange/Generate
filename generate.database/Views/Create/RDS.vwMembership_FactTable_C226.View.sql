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
    WHERE fact.EconomicDisadvantageStatusCode = 'Yes'