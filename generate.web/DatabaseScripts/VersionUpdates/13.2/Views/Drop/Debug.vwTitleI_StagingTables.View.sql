IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwTitleI_StagingTables]'))
    DROP VIEW [Debug].[vwTitleI_StagingTables]
