IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[App].[trgVwReportCode_CategoryOptions]'))
DROP VIEW [App].[trgVwReportCode_CategoryOptions]