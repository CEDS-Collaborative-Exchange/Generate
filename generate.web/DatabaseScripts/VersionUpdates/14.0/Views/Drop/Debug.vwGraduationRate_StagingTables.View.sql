IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwGraduationRate_StagingTables]'))
    DROP VIEW [Debug].[vwGraduationRate_StagingTables]
