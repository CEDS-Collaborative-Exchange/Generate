IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwChildCount_StagingTables]'))
DROP VIEW [Debug].[vwChildCount_StagingTables]
