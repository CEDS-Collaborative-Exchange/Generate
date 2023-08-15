set nocount off;
begin try
	begin transaction
	
	delete from 
	app.CategorySet_Categories where CategorySetId in ( select CategorySetId
	from app.CategorySets cs 
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'datapopulation')


if not exists (
	select 1 from 
	app.CategorySet_Categories csc
	inner join app.CategorySets cs on csc.CategorySetId = cs.CategorySetId
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'datapopulation'
	)
begin

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX')
	from app.CategorySets cs where CategorySetCode = 'studentsex'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC')
	from app.CategorySets cs where CategorySetCode = 'studentrace'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA')
	from app.CategorySets cs where CategorySetCode = 'studentdisability'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISCIPLINEACTION')
	from app.CategorySets cs where CategorySetCode = 'studentdiscipline'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'ECODIS')
	from app.CategorySets cs where CategorySetCode = 'studentsubpopulation'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'HOMELSENRLSTAT')
	from app.CategorySets cs where CategorySetCode = 'studentsubpopulation'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'MIGRNTSTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentsubpopulation'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'LEPONLY')
	from app.CategorySets cs where CategorySetCode = 'studentsubpopulation'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'TITLEISCHSTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABIDEASTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'TITLEISCHSTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sex'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sex'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABIDEASTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sex'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'TITLEISCHSTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1grade'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABIDEASTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1grade'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'GRADELVL')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1grade'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'TITLEISCHSTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sexgrade'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABIDEASTATUS')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sexgrade'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'GRADELVL')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sexgrade'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'SEX')
	from app.CategorySets cs where CategorySetCode = 'studentswdtitle1sexgrade'
end

	delete from 
	app.CategorySet_Categories where CategorySetId in ( select CategorySetId
	from app.CategorySets cs 
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'sppaprreport')

if not exists (
	select 1 from 
	app.CategorySet_Categories csc
	inner join app.CategorySets cs on csc.CategorySetId = cs.CategorySetId
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'sppaprreport'
	)
begin

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'RACEETHNIC')
	from app.CategorySets cs 
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'sppaprreport'

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'DISABCATIDEA')
	from app.CategorySets cs 
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'sppaprreport'

end


if not exists (
	select 1 from 
	app.CategorySet_Categories csc
	inner join app.CategorySets cs on csc.CategorySetId = cs.CategorySetId
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	inner join app.Categories c on csc.CategoryId = c.CategoryId and c.CategoryCode = 'REMOVALLENSUS'
	where t.ReportTypeCode = 'sppaprreport' and r.ReportCode in ('indicator4a', 'indicator4b')
	)
begin

	insert into app.CategorySet_Categories
	(CategorySetId, CategoryId) 
	select cs.CategorySetId, (select CategoryId from app.Categories where CategoryCode = 'REMOVALLENSUS')
	from app.CategorySets cs 
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where t.ReportTypeCode = 'sppaprreport' and r.ReportCode in ('indicator4a', 'indicator4b')

end



	commit transaction

end try
begin catch

	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end

	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()

	declare @sev as int
	set @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

end catch

set nocount on;