IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[debug].[vwMembership_StagingTables]'))
DROP VIEW [debug].[vwMembership_StagingTables]
