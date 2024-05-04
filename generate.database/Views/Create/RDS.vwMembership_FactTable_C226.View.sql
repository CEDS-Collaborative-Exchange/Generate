CREATE VIEW RDS.vwMembership_FactTable_c226
AS
    SELECT  
        K12StudentStudentIdentifierState,
        LeaIdentifierSea,
        SchoolIdentifierSea
    FROM [debug].[vwMembership_FactTable] fact
    WHERE fact.EconomicDisadvantageStatusCode = 'Yes'