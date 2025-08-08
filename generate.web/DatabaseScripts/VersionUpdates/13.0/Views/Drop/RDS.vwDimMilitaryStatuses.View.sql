IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimMilitaryStatuses]'))
DROP VIEW [RDS].[vwDimMilitaryStatuses]
