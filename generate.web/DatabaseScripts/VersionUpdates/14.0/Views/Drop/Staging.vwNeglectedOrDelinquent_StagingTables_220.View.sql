IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Staging].[vwNeglectedOrDelinquent_StagingTables_220]'))
DROP VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_220]
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Staging].[vwNeglectedOrDelinquent_StagingTables_C220]'))
DROP VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_C220]
