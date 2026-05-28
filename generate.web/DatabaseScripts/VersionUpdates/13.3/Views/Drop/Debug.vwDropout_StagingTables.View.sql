IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwDropout_StagingTables]'))
    DROP VIEW [Debug].[vwDropout_StagingTables]
