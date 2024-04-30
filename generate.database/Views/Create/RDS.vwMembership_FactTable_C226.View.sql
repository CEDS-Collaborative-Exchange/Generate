CREATE VIEW RDS.vwMembership_FactTable_c226
AS
    SELECT  
        K12StudentStudentIdentifierState,
        rdl.LeaIdentifierSea,
        SchoolIdentifierSea
    FROM RDS.vwMemebership_FactTable fact
    WHERE rdeds.EconomicDisadvantageStatusCode = 'Yes'