IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimK12ProgramStatuses]'))
DROP VIEW [RDS].vwDimK12ProgramStatuses