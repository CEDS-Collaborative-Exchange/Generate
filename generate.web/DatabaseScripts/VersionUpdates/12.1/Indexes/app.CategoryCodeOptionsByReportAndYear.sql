IF (OBJECT_ID('iux_CategoryCodeOptionsByReportAndYear') IS NOT NULL)
BEGIN
    CREATE UNIQUE CLUSTERED INDEX iux_CategoryCodeOptionsByReportAndYear
    ON app.CategoryCodeOptionsByReportAndYear (ReportCode, SubmissionYear, CategorySetCode, TableTypeId, CategoryCode, CategoryOptionCode);
END

IF (OBJECT_ID('ix_CategoryCodeOptionsByReportAndYear_ReportCode_SubmissionYear_CategoryCode') IS NOT NULL)
BEGIN
    CREATE NONCLUSTERED INDEX ix_CategoryCodeOptionsByReportAndYear_ReportCode_SubmissionYear_CategoryCode
    ON app.CategoryCodeOptionsByReportAndYear (ReportCode, SubmissionYear, TableTypeAbbrv, CategoryCode);
END