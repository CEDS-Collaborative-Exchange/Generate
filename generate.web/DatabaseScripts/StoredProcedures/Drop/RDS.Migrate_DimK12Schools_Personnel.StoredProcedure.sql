IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimSchools_Personnel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimSchools_Personnel]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12Schools_Personnel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12Schools_Personnel]