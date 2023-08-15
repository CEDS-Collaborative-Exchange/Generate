declare @categoryId as int, @previousLepId as int, @dimensionId as int

select @categoryId = CategoryId from app.Categories Where CategoryCode = 'LEPDISC'

	
		Update csc set categoryid = @categoryId
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
		inner join app.Categories c on c.CategoryId = csc.CategoryId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines' and c.CategoryCode = 'LEPBOTH'

		
		select @previousLepId = CategoryId from app.Categories Where CategoryCode = 'LEPBOTH'

		Update co set CategoryId = @categoryId
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines'  and co.CategoryOptionCode = 'MISSING' and cs.CategorySetCode = 'CSD'  and co.CategoryId = @previousLepId

		Update co set CategoryId = @categoryId, CategoryOptionName = 'English learner'
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines' and co.CategoryOptionCode = 'LEP'

		Update co set CategoryId = @categoryId, CategoryOptionName = 'Non–English learner'
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines'  and co.CategoryOptionCode = 'NLEP'

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'DisciplineELStatus'

		Update fc set DisplayName = 'English Learner Status (Both)'
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
		inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('c005','c006','c007','c088','c143') and ColumnName = 'LEPStatusID' and SubmissionYear = '2017-18'

		Update fc set DimensionId = @dimensionId
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
		inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('c005','c006','c007','c088','c143') and ColumnName = 'LEPStatusID'