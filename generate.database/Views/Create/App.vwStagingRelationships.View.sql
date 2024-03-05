CREATE view [App].[vwStagingRelationships]
as

select 
	rg. ReportGroupId, rg.ReportGroup, 
	r.GenerateReportId, r.ReportCode, r.ReportName,
	gst.StagingTableId, gst.StagingTableName, gsc.StagingColumnId, gsc.StagingColumnName,
	gsc.SSRDRefTableName, gsc.SSRDTableFilter

from app.GenerateReports r
left join app.GenerateReportGroups_ReportsXREF rgrx
	on r.GenerateReportId = rgrx.GenerateReportId
left join app.GenerateReportGroups rg
	on rgrx.ReportGroupId = rg.ReportGroupId
left join App.GenerateReport_GenerateStagingTablesXREF rgsx
	on rgsx.GenerateReportId = r.GenerateReportId
left join App.GenerateStagingTables gst
	on gst.StagingTableId = rgsx.StagingTableId
left join app.GenerateStagingColumns gsc
	on gst.StagingTableId = gsc.StagingTableId
where r.IsActive = 1 and r.GenerateReportTypeId = 3

