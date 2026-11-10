IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwSignificantDisproportionality_ChildCount]'))
DROP VIEW [RDS].[vwSignificantDisproportionality_ChildCount]
