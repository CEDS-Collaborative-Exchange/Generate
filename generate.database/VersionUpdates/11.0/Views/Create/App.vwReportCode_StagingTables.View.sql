CREATE VIEW [App].[vwReportCode_StagingTables]
AS

SELECT DISTINCT r.ReportCode, st.StagingTableName, rg.ReportGroup
FROM App.GenerateReport_GenerateStagingTablesXREF rgstx
inner join App.GenerateReports r
	on rgstx.GenerateReportId = r.GenerateReportId
inner JOIN App.GenerateReportGroups_ReportsXREF AS rgrx 
	ON r.GenerateReportId = rgrx.GenerateReportId
inner join App.GenerateReportGroups AS rg 
	on rg.ReportGroupId = rgrx.ReportGroupId
inner JOIN App.GenerateStagingTables AS st ON rgstx.StagingTableId = st.StagingTableId