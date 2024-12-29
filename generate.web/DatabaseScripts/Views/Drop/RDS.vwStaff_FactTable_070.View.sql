--Drop the old name of the file if it exists
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwK12Staff_FactTable_C070]'))
    DROP VIEW [RDS].[vwK12Staff_FactTable_C070]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwStaff_FactTable_070]'))
    DROP VIEW [RDS].[vwStaff_FactTable_070]
