declare @fileColumnId as int, @dimensionId as int

select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Filler' and ColumnLength = 15

Update fsfc set FileColumnId = @fileColumnId from app.GenerateReports r
inner join app.FileSubmissions fs on r.GenerateReportId = fs.GenerateReportId
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
where r.ReportCode = 'c129' and SubmissionYear in ('2023','2024') and SequenceNumber in (7)

select @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Filler1' and ColumnLength = 15

Update fsfc set FileColumnId = @fileColumnId from app.GenerateReports r
inner join app.FileSubmissions fs on r.GenerateReportId = fs.GenerateReportId
inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
where r.ReportCode = 'c129' and SubmissionYear in ('2023','2024') and SequenceNumber in (8)

select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'VirtualSchStatus'
Update app.FileColumns set DimensionId = @dimensionId where ColumnName = 'VirtualSchoolStatus'