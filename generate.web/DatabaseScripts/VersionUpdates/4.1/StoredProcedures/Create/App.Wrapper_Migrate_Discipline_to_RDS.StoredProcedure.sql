CREATE PROCEDURE [App].[Wrapper_Migrate_Discipline_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from ODS data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start MigrateDimK12Students')

		--Populate DimStudents
		exec [rds].[Migrate_DimK12Students]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Migrate_DimSeas')

		--Populate DimSeas
		exec [rds].[Migrate_DimSeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Migrate_DimLeas')

		--Populate DimLeas
		exec [rds].[Migrate_DimLeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Migrate_DimK12Schools')

		--Populate DimK12Schools
		exec [rds].[Migrate_DimK12Schools] NULL, 0

/* Data Population not required for reporting code
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Empty for Discipline')

		----clear the data from the Data Population Summary report
		--exec [rds].[Empty_RDS]  'datapopulation', 'disciplinecounts'

		--	--write out message to DataMigrationHistories
		--	insert into app.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Migrate_StudentDisciplines for Data Population Summary')

		----create the Data Population Summary report
		--exec [rds].[Migrate_StudentDisciplines] 'datapopulation', 0

*/
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Empty_RDS for the Submission reports')

		--clear the data from the fact table
		exec [rds].[Empty_RDS] 'submission', 'disciplinecounts'

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline - Start Migrate_StudentDisciplines for Submission reports')

		--populate the fact table for the submission report
		exec [rds].[Migrate_StudentDisciplines] 'submission', 0

	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - Discipline')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Discipline failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END



