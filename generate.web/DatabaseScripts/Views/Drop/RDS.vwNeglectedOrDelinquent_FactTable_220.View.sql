IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_220]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_220]
