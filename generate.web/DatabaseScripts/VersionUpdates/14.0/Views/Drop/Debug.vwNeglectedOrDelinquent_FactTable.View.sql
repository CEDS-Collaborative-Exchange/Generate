IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwNeglectedOrDelinquent_FactTable]'))
    DROP VIEW [Debug].[vwNeglectedOrDelinquent_FactTable]
