IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNationalAssessments]'))
DROP VIEW [RDS].[vwNationalAssessments]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwStateAssessments]'))
DROP VIEW [RDS].[vwStateAssessments]