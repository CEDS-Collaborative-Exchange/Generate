IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimDates_Personnel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimDates_Personnel]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimSchoolYears_K12Staff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_K12Staff]
