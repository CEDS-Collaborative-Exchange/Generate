IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimK12StaffStatuses]'))
DROP VIEW [RDS].[vwDimK12StaffStatuses]