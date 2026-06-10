IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwMembership_FactTable]'))
DROP VIEW [Debug].[vwMembership_FactTable]
