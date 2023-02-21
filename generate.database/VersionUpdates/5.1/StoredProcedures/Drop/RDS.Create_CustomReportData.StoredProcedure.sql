IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Create_CustomReportData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Create_CustomReportData]

