IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Get_YearToYearEnvironmentCountReportData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Get_YearToYearEnvironmentCountReportData]

