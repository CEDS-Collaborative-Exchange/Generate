IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwChronic_FactTable_195]'))
    DROP VIEW [RDS].[vwChronic_FactTable_195]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwChronicAbsenteeism_FactTable_195]'))
    DROP VIEW [RDS].[vwChronicAbsenteeism_FactTable_195]
