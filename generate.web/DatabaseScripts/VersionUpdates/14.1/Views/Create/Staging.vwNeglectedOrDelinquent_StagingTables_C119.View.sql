CREATE VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_C119] 
AS
SELECT A.* FROM
[debug].[vwNeglectedOrDelinquent_StagingTables] A
INNER JOIN RDS.vwDimNOrDStatuses B on B.DimNOrDStatusId= A.NOrDStatusId
AND NeglectedOrDelinquentProgramTypeCode <> 'MISSING' AND A.SeaId <> -1
AND IIF(a.K12SchoolId > 0, a.K12SchoolId, a.LeaId) <> -1