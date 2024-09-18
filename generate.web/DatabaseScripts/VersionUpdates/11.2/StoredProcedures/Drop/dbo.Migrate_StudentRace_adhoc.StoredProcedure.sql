IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[Migrate_StudentRace_adhoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ODS].[Migrate_StudentRace_adhoc]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Migrate_StudentRace_adhoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Migrate_StudentRace_adhoc]