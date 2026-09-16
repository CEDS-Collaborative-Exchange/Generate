IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwChildCount_FactTable_002]'))
    DROP VIEW [RDS].[vwChildCount_FactTable_002]
