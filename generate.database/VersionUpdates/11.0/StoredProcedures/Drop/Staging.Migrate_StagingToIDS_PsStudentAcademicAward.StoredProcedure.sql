﻿IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Migrate_Data_ETL_IMPLEMENTATION_STEP21_PsStudentAcademicAward_EncapsulatedCode') BEGIN
	DROP PROCEDURE Staging.Migrate_Data_ETL_IMPLEMENTATION_STEP21_PsStudentAcademicAward_EncapsulatedCode
END

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Migrate_StagingToIDS_PsStudentAcademicAward') BEGIN
	DROP PROCEDURE Staging.Migrate_StagingToIDS_PsStudentAcademicAward
END