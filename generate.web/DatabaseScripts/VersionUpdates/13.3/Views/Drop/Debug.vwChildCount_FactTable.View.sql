IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwChildCount_FactTable]'))
DROP VIEW [Debug].[vwChildCount_FactTable]
