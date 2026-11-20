--drop the view with the deprecated name
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessment_FactTable_139]'))
DROP VIEW [RDS].[vwAssessment_FactTable_139]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwEnglishLearnerAssessment_FactTable_139]'))
DROP VIEW [RDS].[vwEnglishLearnerAssessment_FactTable_139]
