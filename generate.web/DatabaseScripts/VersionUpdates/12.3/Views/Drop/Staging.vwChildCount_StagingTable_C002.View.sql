IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Staging].[vwChildCount_StagingTable_C002]'))
    DROP VIEW [Staging].[vwChildCount_StagingTable_C002]
