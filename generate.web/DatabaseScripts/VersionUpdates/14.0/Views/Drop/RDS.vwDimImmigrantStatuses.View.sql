IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimImmigrantStatuses]'))
DROP VIEW [RDS].[vwDimImmigrantStatuses]
