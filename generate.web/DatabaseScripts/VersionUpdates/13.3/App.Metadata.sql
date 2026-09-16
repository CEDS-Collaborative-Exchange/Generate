--Update app.ToggleAssessments set PerformanceLevels = 6

declare @generateReportId as int

IF NOT EXISTS(select 1 from app.GenerateConfigurations where GenerateConfigurationCategory = 'Metadata' and GenerateConfigurationKey = 'SchoolYear')
BEGIN
	INSERT INTO [App].[GenerateConfigurations]
			   ([GenerateConfigurationCategory]
			   ,[GenerateConfigurationKey]
			   ,[GenerateConfigurationValue])
		 VALUES('Metadata', 'SchoolYear', '2026')
END


select @generateReportId = GenerateReportId from app.GenerateReports where ReportCode = '059'

delete from app.CategoryOptions where CategorySetId in (select CategorySetId from app.CategorySets where SubmissionYear = 2026 and GenerateReportId = @generateReportId and TableTypeId = 290 and OrganizationLevelId in (1, 2))
delete from app.CategoryOptions where CategorySetId in (select CategorySetId from app.CategorySets where SubmissionYear = 2026 and GenerateReportId = @generateReportId and CategorySetCode = 'TOT' and OrganizationLevelId = 3)
delete from app.CategorySets where SubmissionYear = 2026 and GenerateReportId = @generateReportId and TableTypeId = 290 and OrganizationLevelId in (1, 2)
delete from app.CategorySets where SubmissionYear = 2026 and GenerateReportId = @generateReportId and CategorySetCode = 'TOT' and OrganizationLevelId = 3
delete from app.CategorySet_Categories where CategorySetId in (select CategorySetId from app.CategorySets where SubmissionYear = 2026 and GenerateReportId = @generateReportId and CategorySetCode = 'CSA' and OrganizationLevelId = 3)
Update app.CategorySets set TableTypeId = 290 where SubmissionYear = 2026 and GenerateReportId = @generateReportId and OrganizationLevelId = 3