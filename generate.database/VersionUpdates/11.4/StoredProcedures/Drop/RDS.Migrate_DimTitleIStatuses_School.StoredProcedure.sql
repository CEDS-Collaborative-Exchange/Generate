IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimTitle1Statuses_School]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimTitle1Statuses_School]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimTitleIStatuses_School]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimTitleIStatuses_School]

