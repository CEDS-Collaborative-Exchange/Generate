IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[App].[FS175_TestCase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [App].[Migrate_Data]