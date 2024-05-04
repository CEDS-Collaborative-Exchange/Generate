IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_C220]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C220]
