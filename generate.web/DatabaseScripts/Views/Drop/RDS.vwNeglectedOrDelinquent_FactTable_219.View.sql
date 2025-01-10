--Drop the old name of the file if it exists
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_C219]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C219]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_219]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_219]
