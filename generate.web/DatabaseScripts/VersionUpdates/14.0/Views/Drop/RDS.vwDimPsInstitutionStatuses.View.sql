IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimPsInstitutionStatuses]'))
DROP VIEW [RDS].[vwDimPsInstitutionStatuses]
