IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Staging].[vwStagingValidationRules]'))
DROP VIEW [Staging].[vwStagingValidationRules]
