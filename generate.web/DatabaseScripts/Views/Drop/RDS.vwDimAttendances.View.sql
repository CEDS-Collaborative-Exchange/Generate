IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimAttendances]'))
DROP VIEW [RDS].[vwDimAttendances]