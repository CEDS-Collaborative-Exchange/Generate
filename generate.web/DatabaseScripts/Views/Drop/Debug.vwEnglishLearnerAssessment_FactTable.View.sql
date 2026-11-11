IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwEnglishLearnerAssessment_FactTable]'))
    DROP VIEW [Debug].[vwEnglishLearnerAssessment_FactTable]
