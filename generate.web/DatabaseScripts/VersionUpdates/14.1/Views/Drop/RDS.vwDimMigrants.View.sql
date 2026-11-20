IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimMigrants]'))
DROP VIEW [RDS].[vwDimMigrants]