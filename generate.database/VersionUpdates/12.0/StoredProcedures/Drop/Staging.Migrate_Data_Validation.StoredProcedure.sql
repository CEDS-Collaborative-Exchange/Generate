IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'APP' AND ROUTINE_NAME = 'Migrate_Data_Validation') BEGIN
	DROP PROCEDURE [App].[Migrate_Data_Validation]
END

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Migrate_Data_Validation') BEGIN
	DROP PROCEDURE [Staging].[Migrate_Data_Validation]
END