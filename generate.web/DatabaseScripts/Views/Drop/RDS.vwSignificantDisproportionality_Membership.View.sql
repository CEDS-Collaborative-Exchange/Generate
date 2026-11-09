IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwSignificantDisproportionality_Membership]'))
DROP VIEW [RDS].[vwSignificantDisproportionality_Membership]
