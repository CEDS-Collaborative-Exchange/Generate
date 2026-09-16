IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimTeachingCredentialStatuses]'))
DROP VIEW [RDS].[vwDimTeachingCredentialStatuses]