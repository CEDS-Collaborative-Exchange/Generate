IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimK12ProgramTypes]'))
DROP VIEW [RDS].[vwDimK12ProgramTypes]