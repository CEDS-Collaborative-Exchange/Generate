--add relationships for Staging.IdeaDisabilityType table to the XREF table

--143
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 9 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (9, 13)
end

--089
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 12 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (12, 13)
end

--088
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 14 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (14, 13)
end

--009
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 15 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (15, 13)
end

--007
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 16 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (16, 13)
end

--006
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 17 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (17, 13)
end

--005
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 18 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (18, 13)
end

--002
if not exists (select * from app.GenerateReport_GenerateStagingTablesXREF 
	where GenerateReportId = 19 and StagingTableId = 13)
begin
	insert into app.GenerateReport_GenerateStagingTablesXREF
	values (19, 13)
end

