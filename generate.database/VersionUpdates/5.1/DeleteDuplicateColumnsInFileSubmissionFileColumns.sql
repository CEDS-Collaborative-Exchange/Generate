-- This delete any instances of the same column (with different Ids) existing for a file submission record in App.FileSubmission_FileColumns

IF OBJECT_ID(N'tempdb..#metadata') IS NOT NULL DROP TABLE #metadata
IF OBJECT_ID(N'tempdb..#dups') IS NOT NULL DROP TABLE #dups
IF OBJECT_ID(N'tempdb..#Ids') IS NOT NULL DROP TABLE #Ids
IF OBJECT_ID(N'tempdb..#MinMax') IS NOT NULL DROP TABLE #MinMax


select 
r.GenerateReportId, r.ReportCode, r.IsActive,
fs.FileSubmissionId, fs.FileSubmissionDescription, fs.OrganizationLevelId, fs.SubmissionYear,
fsfc.FileColumnId, fsfc.SequenceNumber, fsfc.StartPosition, fsfc.EndPosition, fc.ColumnLength, fc.ColumnName, fc.DisplayName
into #metadata
from app.generatereports r
left join app.filesubmissions fs
	on r.generatereportid = fs.GenerateReportId
	and fs.SubmissionYear = 2022
left join app.FileSubmission_FileColumns fsfc
	on fs.FileSubmissionId = fsfc.FileSubmissionId
left join app.FileColumns fc
	on fsfc.FileColumnId = fc.FileColumnId
--where r.reportcode in ('c007') and fs.OrganizationLevelId = 1 --sea
order by r.GenerateReportId, r.ReportCode, fs.FileSubmissionDescription, fs.OrganizationLevelId, fsfc.SequenceNumber, fc.ColumnName

--select * from #metadata

select
GenerateReportId, ReportCode, IsActive,
FileSubmissionId, FileSubmissionDescription, OrganizationLevelId, SubmissionYear,
SequenceNumber, StartPosition, EndPosition, ColumnLength, ColumnName, DisplayName, count(*) CountOf
into #dups
from #metadata
group by GenerateReportId, ReportCode, IsActive,
FileSubmissionId, FileSubmissionDescription, OrganizationLevelId, SubmissionYear,
SequenceNumber, StartPosition, EndPosition, ColumnLength, ColumnName, DisplayName
having count(*) > 1

--select * from #dups

select 
m.GenerateReportId, m.ReportCode, m.IsActive,
m.FileSubmissionId, m.FileSubmissionDescription, m.OrganizationLevelId, m.SubmissionYear,
m.FileColumnId, m.SequenceNumber, m.StartPosition, m.EndPosition, m.ColumnLength, m.ColumnName, m.DisplayName
into #Ids
from #metadata m
inner join #dups d
on m.GenerateReportId = d.GenerateReportId
and m.ReportCode = d.ReportCode
and m.IsActive = d.IsActive
and m.filesubmissionid = d.FileSubmissionId
and m.FileSubmissionDescription = d.FileSubmissionDescription
and m.OrganizationLevelId = d.OrganizationLevelId
and m.SubmissionYear = d.SubmissionYear
and m.SequenceNumber = d.SequenceNumber
and m.StartPosition = d.StartPosition
and m.EndPosition = d.EndPosition
and m.ColumnLength = d.ColumnLength
and m.ColumnName = d.ColumnName
and m.DisplayName = d.DisplayName
order by m.GenerateReportId, m.ReportCode, m.FileSubmissionDescription, m.OrganizationLevelId, m.SequenceNumber, m.ColumnName, m.FileColumnId

select 
GenerateReportId, ReportCode, IsActive,
FileSubmissionId, FileSubmissionDescription, OrganizationLevelId, SubmissionYear,
SequenceNumber, StartPosition, EndPosition, ColumnLength, ColumnName, DisplayName, min(FileColumnId) 'MinId', max(FileColumnId) 'MaxId'
into #MinMax
from #Ids
group by GenerateReportId, ReportCode, IsActive,
FileSubmissionId, FileSubmissionDescription, OrganizationLevelId, SubmissionYear,
SequenceNumber, StartPosition, EndPosition, ColumnLength, ColumnName, DisplayName
order by GenerateReportId, ReportCode, FileSubmissionDescription, OrganizationLevelId, SequenceNumber, ColumnName

--select * from #MinMax

delete fsfc
--select *
from app.generatereports r
left join app.filesubmissions fs
	on r.generatereportid = fs.GenerateReportId
	and fs.SubmissionYear = 2022
left join app.FileSubmission_FileColumns fsfc
	on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join #Ids I
	on fsfc.FileSubmissionId = I.FileSubmissionId
inner join #MinMax D
on r.GenerateReportId = d.GenerateReportId
and r.ReportCode = d.ReportCode
and r.IsActive = d.IsActive
and fs.filesubmissionid = d.FileSubmissionId
and fs.FileSubmissionDescription = d.FileSubmissionDescription
and fs.OrganizationLevelId = d.OrganizationLevelId
and fs.SubmissionYear = d.SubmissionYear
and fsfc.SequenceNumber = d.SequenceNumber
and fsfc.StartPosition = d.StartPosition
and fsfc.EndPosition = d.EndPosition
and fsfc.FileColumnId = I.FileColumnId
where I.FileColumnId <> d.MinId







