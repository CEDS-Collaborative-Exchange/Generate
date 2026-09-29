IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwMigrantEducationProgram_FactTable]'))
    DROP VIEW [Debug].[vwMigrantEducationProgram_FactTable]
