CREATE Procedure [Staging].[Wrapper_Migrate_StudentCounts_to_IDS]
	@SchoolYear int 
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the IDS tables from Staging data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts - Start Clear IDS')

		--Clear the IDS tables
		exec [Staging].[Migrate_StagingToIDS_CompletelyClearDataFromODS] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts - Start Organization')

		--Populate Organization
		exec [Staging].[Migrate_StagingToIDS_Organization] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts - Start OrganizationProgramType')

		--Populate OrganizationProgramType
		exec [Staging].[Migrate_StagingToIDS_OrganizationProgramType] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts - Start K12Enrollment')

		--Populate K12Enrollment
		exec [Staging].[Migrate_StagingToIDS_K12Enrollment]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts - Start PersonRace')

		--Populate PersonRace
		exec [Staging].[Migrate_StagingToIDS_PersonRace]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts - Start PersonStatus')

		--Populate PersonStatus
		exec [Staging].[Migrate_StagingToIDS_PersonStatus] @SchoolYear

	--IDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper Complete - StudentCounts')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper StudentCounts failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END
