IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwImmigrant_StagingTables]'))
DROP VIEW [Debug].[vwImmigrant_StagingTables]
