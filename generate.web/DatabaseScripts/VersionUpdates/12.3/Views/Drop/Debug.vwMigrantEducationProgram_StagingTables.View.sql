IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwMigrantEducationProgram_StagingTables]'))
    DROP VIEW [Debug].[vwMigrantEducationProgram_StagingTables]
