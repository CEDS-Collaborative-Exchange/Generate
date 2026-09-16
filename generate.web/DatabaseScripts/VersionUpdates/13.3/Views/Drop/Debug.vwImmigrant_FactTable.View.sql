IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwImmigrant_FactTable]'))
DROP VIEW [Debug].[vwImmigrant_FactTable]
