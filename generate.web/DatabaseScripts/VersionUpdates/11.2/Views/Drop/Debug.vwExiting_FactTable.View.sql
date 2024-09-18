IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwExiting_FactTable]'))
DROP VIEW [Debug].[vwExiting_FactTable]
