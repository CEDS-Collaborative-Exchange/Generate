﻿CREATE Procedure [Staging].[Wrapper_Migrate_Exiting_to_IDS]
	@SchoolYear int 
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the IDS tables from Staging data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper Exiting - Start Clear IDS')

		--Clear the IDS tables
		exec [Staging].[Migrate_StagingToIDS_CompletelyClearDataFromODS] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper Exiting - Start Organization')

		--Populate Organization
		exec [Staging].[Migrate_StagingToIDS_Organization] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper Exiting - Start OrganizationProgramType')

		--Populate OrganizationProgramType
		exec [Staging].[Migrate_StagingToIDS_OrganizationProgramType] @SchoolYear


		--Populate FactK12StudentCounts
		exec Staging.[Staging.Staging-to-FactK12StudentCounts_SpecEdExit] @SchoolYear
	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper Exiting failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END