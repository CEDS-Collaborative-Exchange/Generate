IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimDates_Organizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimDates_Organizations]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimSchoolYears_Organizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_Organizations]

