IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimTitle1Statuses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimTitle1Statuses]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimTitleIStatuses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimTitleIStatuses]

