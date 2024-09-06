IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[App].[vwReportCode_StagingTables]'))
DROP VIEW [App].[vwReportCode_StagingTables]
