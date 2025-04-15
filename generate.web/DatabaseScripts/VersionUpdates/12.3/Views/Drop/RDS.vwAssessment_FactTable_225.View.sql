--Drop the old name of the file if it exists
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessment_FactTable_C225]'))
DROP VIEW [RDS].[vwAssessment_FactTable_C225]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessment_FactTable_225]'))
DROP VIEW [RDS].[vwAssessment_FactTable_225]
