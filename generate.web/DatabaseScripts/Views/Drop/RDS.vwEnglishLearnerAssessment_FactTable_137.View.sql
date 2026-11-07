--drop the view with the deprecated name
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessment_FactTable_137]'))
DROP VIEW [RDS].[vwAssessment_FactTable_137]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwEnglishLearnerAssessment_FactTable_137]'))
DROP VIEW [RDS].[vwEnglishLearnerAssessment_FactTable_137]
