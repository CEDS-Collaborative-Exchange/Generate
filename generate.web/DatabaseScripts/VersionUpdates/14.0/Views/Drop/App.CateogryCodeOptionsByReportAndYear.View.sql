IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[App].[CateogryCodeOptionsByReportAndYear]'))
    DROP VIEW [App].[CateogryCodeOptionsByReportAndYear]
