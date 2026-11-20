--Drop the old name of the file if it exists
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_C218]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_C218]

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwNeglectedOrDelinquent_FactTable_218]'))
    DROP VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_218]
