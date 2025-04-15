CREATE PROCEDURE [App].[Wrapper_Migrate_CTE_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from ODS data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE - Start MigrateDimStudents')

		--Populate DimStudents
		exec [rds].[Migrate_DimK12Students]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE - Start Migrate_DimSeas')

		--Populate DimSeas
		exec [rds].[Migrate_DimSeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE - Start Migrate_DimLeas')

		--Populate DimLeas
		exec [rds].[Migrate_DimLeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE - Start Migrate_DimK12Schools')

		--Populate DimK12Schools
		exec [rds].[Migrate_DimK12Schools] NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE - Start Empty for CTE')

		--clear the data from the fact table
		exec [rds].[Empty_RDS] 'cte'

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE - Start Migrate_StudentCounts for Submission reports')

		--populate the fact table for the submission report
		exec [rds].[Migrate_StudentCounts] 'cte', 0

	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - CTE - ' + ERROR_MESSAGE())

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper CTE failed to run - ' + ERROR_MESSAGE())
	END CATCH

    SET NOCOUNT OFF;

END



