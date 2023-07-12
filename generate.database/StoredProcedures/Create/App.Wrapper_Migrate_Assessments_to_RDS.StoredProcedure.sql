CREATE PROCEDURE [App].[Wrapper_Migrate_Assessments_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from ODS data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start MigrateDimStudents')

		-- --Populate DimStudents
		-- exec [rds].[Migrate_DimK12Students]

		-- 	--write out message to DataMigrationHistories
		-- 	insert into app.DataMigrationHistories
		-- 	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Migrate_DimSeas')

		-- --Populate DimSeas
		-- exec [rds].[Migrate_DimSeas] 'directory', NULL, 0

		-- 	--write out message to DataMigrationHistories

		-- 	insert into app.DataMigrationHistories
		-- 	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Migrate_DimLeas')

		-- --Populate DimLeas
		-- exec [rds].[Migrate_DimLeas] 'directory', NULL, 0

		-- 	--write out message to DataMigrationHistories
		-- 	insert into app.DataMigrationHistories
		-- 	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Migrate_DimK12Schools')

		-- --Populate DimK12Schools
		-- exec [rds].[Migrate_DimK12Schools] NULL, 0

/* Data Population not required for reporting code
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Empty Assessments for Data Population Summary')

		----clear the data from the Data Population Summary report
		--exec [rds].[Empty_RDS]  'datapopulation', 'studentassessments'

		--	--write out message to DataMigrationHistories
		--	insert into app.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Migrate_StudentAssessments for Data Population Summary')

		----create the Data Population Summary report
		--exec [rds].[Migrate_StudentAssessments] 'datapopulation', 0

*/
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Empty_RDS for the Submission reports')

		--clear the data from the fact table
		exec [rds].[Empty_RDS] 'submission', 'studentassessments'

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Migrate_StudentAssessments for Submission reports')

		--populate the fact table for the submission report
		exec [rds].[Migrate_StudentAssessments] 'submission', 0

	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - Assessments')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END



