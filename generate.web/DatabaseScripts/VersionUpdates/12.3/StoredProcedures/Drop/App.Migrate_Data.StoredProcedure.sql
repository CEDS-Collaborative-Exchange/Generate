IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[App].[Migrate_Data]') AND type in (N'P', N'PC'))
DROP PROCEDURE [App].[Migrate_Data]

