-- Insert relationships between reports and staging tables for additional combinations

insert into app.GenerateReport_GenerateStagingTablesXREF (GenerateReportId, StagingTableId) 
	values (40, 18), (40, 51), (40, 17), (40,19), (40,36), (40,39)

insert into app.GenerateReport_GenerateStagingTablesXREF (GenerateReportId, StagingTableId) 
	values (65, 18), (65, 51), (65, 17), (65,19), (65,36), (65,39)

insert into app.GenerateReport_GenerateStagingTablesXREF (GenerateReportId, StagingTableId) 
	values (45, 18), (45, 51), (45, 17), (45,19), (45,36), (45,39)

insert into app.GenerateReport_GenerateStagingTablesXREF (GenerateReportId, StagingTableId) 
	values (58, 18), (58, 51), (58, 17), (58,36)

insert into app.GenerateReport_GenerateStagingTablesXREF (GenerateReportId, StagingTableId) 
	values (54, 18), (54, 51), (54, 17), (54,19), (54,39)