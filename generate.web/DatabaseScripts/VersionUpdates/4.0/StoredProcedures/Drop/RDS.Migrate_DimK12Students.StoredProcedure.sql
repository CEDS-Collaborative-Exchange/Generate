IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimStudents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimStudents]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12Students]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12Students]
