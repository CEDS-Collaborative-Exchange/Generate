IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[migrate_DimPersonnelCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[migrate_DimPersonnelCategories]

