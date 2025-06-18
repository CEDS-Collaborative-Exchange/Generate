IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwAssessments_StagingTables]'))
DROP VIEW [Debug].[vwAssessments_StagingTables]
