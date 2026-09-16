IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwGraduatesCompleters_StagingTables]'))
    DROP VIEW [Debug].[vwGraduatesCompleters_StagingTables]
