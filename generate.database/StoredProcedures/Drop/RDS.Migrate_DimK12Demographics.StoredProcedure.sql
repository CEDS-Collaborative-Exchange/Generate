IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimDemographics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimDemographics]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12Demographics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12Demographics]
