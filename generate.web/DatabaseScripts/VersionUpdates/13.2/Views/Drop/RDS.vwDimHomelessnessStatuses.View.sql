IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimHomelessnessStatuses]'))
DROP VIEW [RDS].[vwDimHomelessnessStatuses]
