CREATE VIEW Staging.vwMembership_StagingTables_C226
AS
    SELECT 
        *
    FROM [debug].[vwMembership_StagingTables]
    WHERE EconomicDisadvantageStatus = 1
	