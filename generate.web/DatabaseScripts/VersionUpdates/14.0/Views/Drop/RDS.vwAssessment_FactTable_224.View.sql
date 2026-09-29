--Drop the old name of the file if it exists
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessment_FactTable_C224]'))
DROP VIEW [RDS].[vwAssessment_FactTable_C224]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessment_FactTable_224]'))
DROP VIEW [RDS].[vwAssessment_FactTable_224]
