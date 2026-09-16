IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimK12StaffCategories]'))
DROP VIEW [RDS].[vwDimK12StaffCategories]