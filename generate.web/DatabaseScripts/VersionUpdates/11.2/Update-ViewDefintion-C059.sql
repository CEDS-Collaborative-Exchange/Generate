-- Update the ViewDefinition since the Wijmo is case sensitive
UPDATE cs
SET [ViewDefinition] = REPLACE([ViewDefinition], 'k12staffclassification', 'k12STAFFCLASSIFICATION')
FROM [App].[CategorySets] cs
INNER JOIN app.GenerateReports gr ON gr.GenerateReportId = cs.GenerateReportId
WHERE [CategorySetCode] = 'CSA'
AND [SubmissionYear] = 2023
AND ReportCode = 'c059'