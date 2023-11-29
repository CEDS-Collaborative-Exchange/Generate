IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwDirectory_FactTable]'))
DROP VIEW [Debug].[vwDirectory_FactTable]
