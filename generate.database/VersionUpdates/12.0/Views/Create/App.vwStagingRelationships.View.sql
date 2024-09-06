CREATE view [App].[vwStagingRelationships]
as

select 
	rft.DimFactTypeId, rft.FactTypeCode, 
	r.GenerateReportId, r.ReportCode, r.ReportName,
	gst.StagingTableId, gst.StagingTableName, gsc.StagingColumnId, gsc.StagingColumnName,
	gsc.SSRDRefTableName, gsc.SSRDTableFilter

from app.GenerateReports r
left join App.GenerateReport_FactType frx
	on r.GenerateReportId = frx.GenerateReportId
left join rds.DimFactTypes rft
	on frx.FactTypeId = rft.DimFactTypeId
left join App.GenerateReport_GenerateStagingTablesXREF rgsx
	on rgsx.GenerateReportId = r.GenerateReportId
left join App.GenerateStagingTables gst
	on gst.StagingTableId = rgsx.StagingTableId
left join app.GenerateStagingColumns gsc
	on gst.StagingTableId = gsc.StagingTableId
where r.IsActive = 1 and r.GenerateReportTypeId = 3

