IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[Migrate_DimPersonnel_adhoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ODS].[Migrate_DimPersonnel_adhoc]

