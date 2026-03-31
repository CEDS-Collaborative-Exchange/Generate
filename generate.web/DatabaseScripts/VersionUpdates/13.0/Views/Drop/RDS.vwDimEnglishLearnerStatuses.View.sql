IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimEnglishLearnerStatuses]'))
DROP VIEW [RDS].[vwDimEnglishLearnerStatuses]
