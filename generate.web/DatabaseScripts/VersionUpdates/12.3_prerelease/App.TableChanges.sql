--Add FS222 to metadata table
if not exists (select 1 from app.GenerateReport_FactType where GenerateReportId = 136)
begin
	insert into app.GenerateReport_FactType
	values (136, 12)
end
