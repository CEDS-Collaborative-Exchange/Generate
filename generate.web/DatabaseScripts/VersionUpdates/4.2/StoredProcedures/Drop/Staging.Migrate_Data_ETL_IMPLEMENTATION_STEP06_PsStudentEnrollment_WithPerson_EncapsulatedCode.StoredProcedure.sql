IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Migrate_Data_ETL_IMPLEMENTATION_STEP06_PsStudentEnrollment_WithPerson_EncapsulatedCode.StoredProcedure') BEGIN
	DROP PROCEDURE Staging.Migrate_Data_ETL_IMPLEMENTATION_STEP06_PsStudentEnrollment_WithPerson_EncapsulatedCode
END