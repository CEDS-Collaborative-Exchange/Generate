IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimAssessmentResults]'))
DROP VIEW [RDS].[vwDimAssessmentResults]