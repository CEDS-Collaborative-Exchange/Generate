IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[App].[trgVwReportCode_FileColumns]'))
DROP TRIGGER [App].[trgVwReportCode_FileColumns]