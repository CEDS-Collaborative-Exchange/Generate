IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'StagingValidation_InsertRule') BEGIN
	DROP PROCEDURE [Staging].[StagingValidation_InsertRule]
END