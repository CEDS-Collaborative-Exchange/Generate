CREATE VIEW [App].[vwReportCode_StagingTables]
AS

SELECT DISTINCT r.GenerateReportId, r.ReportCode, st.StagingTableId, st.StagingTableName, rft.DimFactTypeId, rft.FactTypeCode
FROM App.GenerateReport_GenerateStagingTablesXREF rgstx
inner join App.GenerateReports r
	on rgstx.GenerateReportId = r.GenerateReportId
inner JOIN App.GenerateReport_FactType AS ftrx 
	ON r.GenerateReportId = ftrx.GenerateReportId
inner join rds.DimFactTypes AS rft 
	on rft.DimFactTypeId = ftrx.FactTypeId
inner JOIN App.GenerateStagingTables AS st ON rgstx.StagingTableId = st.StagingTableId