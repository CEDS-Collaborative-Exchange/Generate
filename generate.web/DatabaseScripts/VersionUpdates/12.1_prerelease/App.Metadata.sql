DECLARE @GenerateReportId INT

SELECT @GenerateReportId =  [GenerateReportId]
FROM [Generate].[App].[GenerateReports]
WHERE [ReportCode] = 'C059'

Update [App].[CategorySets]
Set [ViewDefinition] = REPLACE([ViewDefinition], 'k12staffclassification','k12STAFFCLASSIFICATION')
where CategorySetCode = 'CSA'
and ([OrganizationLevelId] = 1 or [OrganizationLevelId] = 2)
and [GenerateReportId] = @GenerateReportId

