IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimAssessmentStatuses]'))
DROP VIEW [RDS].[vwDimAssessmentStatuses]