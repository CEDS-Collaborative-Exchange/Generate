IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimAeProgramTypes]'))
DROP VIEW [RDS].[vwDimAeProgramTypes]