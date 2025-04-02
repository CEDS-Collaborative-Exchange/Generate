IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwChronic_StagingTables]'))
    DROP VIEW [Debug].[vwChronic_StagingTables]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwChronicAbsenteesim_StagingTables]'))
    DROP VIEW [Debug].[vwChronicAbsenteesim_StagingTables]
