﻿CREATE Procedure [Staging].[Wrapper_Migrate_ChildCount_to_IDS]
	@SchoolYear int 
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the IDS tables from Staging data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start Clear IDS')

		--Clear the IDS tables
		exec [Staging].[Migrate_StagingToIDS_CompletelyClearDataFromODS] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start Organization')

		--Populate Organization
		exec [Staging].[Migrate_StagingToIDS_Organization] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start OrganizationProgramType')

		--Populate OrganizationProgramType
		exec [Staging].[Migrate_StagingToIDS_OrganizationProgramType] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start K12Enrollment')

		--Populate K12Enrollment
		exec [Staging].[Migrate_StagingToIDS_K12Enrollment]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start PersonRace')

		--Populate PersonRace
		exec [Staging].[Migrate_StagingToIDS_PersonRace]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start PersonStatus')

		--Populate PersonStatus
		exec [Staging].[Migrate_StagingToIDS_PersonStatus] @SchoolYear

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount - Start ProgramParticipationSpecialEducation')

		--Populate ProgramParticipationSpecialEducation
		exec [Staging].[Migrate_StagingToIDS_ProgramParticipationSpecialEducation] @SchoolYear

	--IDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper Complete - ChildCount')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 1, 'IDS Migration Wrapper ChildCount failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END
