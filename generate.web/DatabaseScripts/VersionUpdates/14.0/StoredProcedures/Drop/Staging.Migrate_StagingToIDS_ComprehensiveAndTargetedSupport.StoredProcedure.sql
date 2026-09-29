
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Migrate_StagingToIDS_ComprehensiveAndTargetedSupport') 
BEGIN
	DROP PROCEDURE [Staging].[Migrate_StagingToIDS_ComprehensiveAndTargetedSupport]
END


