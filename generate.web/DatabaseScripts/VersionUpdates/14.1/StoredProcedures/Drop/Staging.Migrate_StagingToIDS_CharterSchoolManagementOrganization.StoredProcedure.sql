IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'APP' AND ROUTINE_NAME = 'Migrate_Data_ETL_IMPLEMENTATION_STEP02_CharterSchoolManagementOrganization_EncapsulatedCode') BEGIN
	DROP PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP02_CharterSchoolManagementOrganization_EncapsulatedCode]
END

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Migrate_StagingToIDS_CharterSchoolManagementOrganization') BEGIN
	DROP PROCEDURE [Staging].[Migrate_StagingToIDS_CharterSchoolManagementOrganization]
END