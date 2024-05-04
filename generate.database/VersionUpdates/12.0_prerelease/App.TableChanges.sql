IF EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.TableTypes') AND name = 'UX_TableTypes')
BEGIN
	ALTER TABLE [App].[TableTypes] DROP CONSTRAINT [UX_TableTypes]
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.TableTypes') AND name = 'UX_TableTypes')
BEGIN
	ALTER TABLE [App].[TableTypes] ADD  CONSTRAINT [UX_TableTypes] UNIQUE NONCLUSTERED 
	(
		[TableTypeAbbrv], [EdFactsTableTypeId]  ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END

DECLARE @AssessmentFactTypeId INT, @GenerateReportId INT
SELECT @AssessmentFactTypeId = DimFactTypeId 
FROM RDS.DimFactTypes 
WHERE FactTypeCode = 'Assessment'

SELECT @GenerateReportId = GenerateReportId
FROM App.GenerateReports
WHERE ReportCode = 'C224'

UPDATE App.GenerateReport_FactType
SET FactTypeId = @AssessmentFactTypeId
WHERE GenerateReportId = @GenerateReportId

SELECT @GenerateReportId = GenerateReportId
FROM App.GenerateReports
WHERE ReportCode = 'C225'

UPDATE App.GenerateReport_FactType
SET FactTypeId = @AssessmentFactTypeId
WHERE GenerateReportId = @GenerateReportId
	