IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimSchoolStatuses_School]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimSchoolStatuses_School]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12SchoolStatuses_School]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12SchoolStatuses_School]