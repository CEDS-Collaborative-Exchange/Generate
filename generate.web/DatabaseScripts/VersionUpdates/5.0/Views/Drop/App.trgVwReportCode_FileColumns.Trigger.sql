IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[App].[trgVwReportCode_FileColumns]'))
DROP VIEW [App].[trgVwReportCode_FileColumns]