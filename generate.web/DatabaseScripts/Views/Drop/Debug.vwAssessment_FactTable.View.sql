IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwAssessment_FactTable]'))
    DROP VIEW [Debug].[vwAssessment_FactTable]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwAssessments_FactTable]'))
    DROP VIEW [Debug].[vwAssessments_FactTable]
