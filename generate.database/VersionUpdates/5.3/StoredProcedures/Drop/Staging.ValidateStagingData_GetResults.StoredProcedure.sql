IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'ValidateStagingData_GetResults') BEGIN
	DROP PROCEDURE [Staging].[ValidateStagingData_GetResults]
END