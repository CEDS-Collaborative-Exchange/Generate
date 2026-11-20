IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNationalAssessments]'))
DROP VIEW [RDS].[vwNationalAssessments]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BI].[vwStateAssessments]'))
DROP VIEW [BI].[vwStateAssessments]