
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Utilities' AND ROUTINE_NAME = 'CompareRecordsAcrossMigrations') 
BEGIN
	DROP PROCEDURE [Utilities].[CompareRecordsAcrossMigrations]
END








