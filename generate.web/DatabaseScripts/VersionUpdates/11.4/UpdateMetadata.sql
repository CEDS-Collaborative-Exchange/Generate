declare @categoryId as int, @generateReportId as int

select @generateReportId = GenerateReportId from app.GenerateReports where ReportCode = 'studentswdtitle1'
select @categoryId = CategoryId from app.Categories where CategoryCode = 'DISABSTATIDEA'

Update co set CategoryId = @categoryId from app.CategorySets cs
inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
inner join app.Categories c on csc.CategoryId = c.CategoryId
left join app.Category_Dimensions cd on cd.CategoryId = c.CategoryId
left join app.Dimensions d on cd.DimensionId = d.DimensionId
left join app.CategoryOptions co on c.CategoryId = co.CategoryId and cs.CategorySetId = co.CategorySetId
where c.CategoryCode = 'DISABIDEASTATUS'
and cs.GenerateReportId = @generateReportId

update csc set csc.CategoryId = @categoryId from app.CategorySets cs
inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
inner join app.Categories c on csc.CategoryId = c.CategoryId
where c.CategoryCode = 'DISABIDEASTATUS'
and cs.GenerateReportId = @generateReportId