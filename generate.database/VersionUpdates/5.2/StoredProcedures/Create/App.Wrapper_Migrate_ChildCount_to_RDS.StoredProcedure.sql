CREATE PROCEDURE [App].[Wrapper_Migrate_ChildCount_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

		EXEC Staging.Rollover_SourceSystemReferenceData -- This only happens when it is needed

	--Populate the RDS tables from ODS data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Staging-to-DimK12Students')

		--Populate DimStudents
		--exec [rds].[Migrate_DimK12Students] NULL
		exec [Staging].[Staging-to-DimK12Students] NULL

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Staging-to-DimSeas')

		--Populate DimSeas
		exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Staging-to-DimLeas')

		--Populate DimLeas
		exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Staging-to-DimK12Schools')

		--Populate DimK12Schools
		exec [Staging].[Staging-to-DimK12Schools] NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Empty_RDS for the Submission reports')

/* Data Population not required for reporting code
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper gradrate - Start Empty for Data Population')

		----clear the data from the Data Population Summary report
		--exec [rds].[Empty_RDS]  'datapopulation', 'studentcounts'

		--	--write out message to DataMigrationHistories
		--	insert into app.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Migrate_StudentCounts for Data Population Summary')

		----create the Data Population Summary report
		--exec [rds].[Migrate_StudentCounts]  'datapopulation', 0

*/
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Empty_RDS for the Submission reports')

		----clear the data from the fact table
		exec [rds].[Empty_RDS] 'childcount'

		--	--write out message to DataMigrationHistories
		--	insert into app.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count - Start Migrate_StudentCounts for Submission reports')

		----populate the fact table for the submission report
		--exec [rds].[Migrate_StudentCounts] 'childcount', 0

		
		DECLARE @submissionYear AS VARCHAR(50)
		DECLARE selectedYears_cursor CURSOR FOR 
		SELECT d.SchoolYear
			FROM rds.DimSchoolYears d
			JOIN rds.DimSchoolYearDataMigrationTypes dd ON dd.DimSchoolYearId = d.DimSchoolYearId
			JOIN rds.DimDataMigrationTypes b ON b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
			WHERE d.DimSchoolYearId <> -1 
			AND dd.IsSelected=1 AND DataMigrationTypeCode='RDS'


		OPEN selectedYears_cursor
		FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC Staging.[Staging-to-FactK12StudentCounts_ChildCount] @submissionYear

			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		END
		
		CLOSE selectedYears_cursor
		DEALLOCATE selectedYears_cursor



	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - Child Count')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Child Count failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END