IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimIndicatorStatuses]'))
DROP VIEW [RDS].[vwDimIndicatorStatuses]