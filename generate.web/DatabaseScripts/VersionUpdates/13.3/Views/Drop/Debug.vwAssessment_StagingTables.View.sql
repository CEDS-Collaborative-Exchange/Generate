IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwAssessments_StagingTables]'))
    DROP VIEW [Debug].[vwAssessments_StagingTables]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwAssessment_StagingTables]'))
    DROP VIEW [Debug].[vwAssessment_StagingTables]

