IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwTitleI_FactTable]'))
    DROP VIEW [Debug].[vwTitleI_FactTable]
