IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimPsRaces]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimPsRaces]