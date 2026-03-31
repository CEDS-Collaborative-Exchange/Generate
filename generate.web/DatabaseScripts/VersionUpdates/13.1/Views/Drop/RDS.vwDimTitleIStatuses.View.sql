IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimTitleIStatuses]'))
DROP VIEW [RDS].[vwDimTitleIStatuses]