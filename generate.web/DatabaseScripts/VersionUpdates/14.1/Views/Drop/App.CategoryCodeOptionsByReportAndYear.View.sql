IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[App].[CategoryCodeOptionsByReportAndYear]'))
    DROP VIEW [App].[CategoryCodeOptionsByReportAndYear]
