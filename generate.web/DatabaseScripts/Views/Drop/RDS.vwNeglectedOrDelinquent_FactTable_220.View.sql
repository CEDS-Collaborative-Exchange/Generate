--Drop the old name of the file if it exists
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_C220]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C220]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_220]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_220]
