IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwChronic_FactTable]'))
    DROP VIEW [Debug].[vwChronic_FactTable]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwChronicAbsenteeism_FactTable]'))
    DROP VIEW [Debug].[vwChronicAbsenteeism_FactTable]
