IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwStaff_FactTable]'))
DROP VIEW [Debug].[vwStaff_FactTable]
