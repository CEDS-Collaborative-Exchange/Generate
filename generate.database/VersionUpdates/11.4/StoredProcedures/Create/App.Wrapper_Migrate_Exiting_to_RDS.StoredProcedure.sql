CREATE PROCEDURE [App].[Wrapper_Migrate_Exiting_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY
		EXEC Staging.Rollover_SourceSystemReferenceData -- This only happens when it is needed

	--Populate the RDS tables from ODS data
		--Populate DimPeople
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting 1 of 6 - Staging-to-DimPeople_K12Students')

			exec [Staging].[Staging-to-DimPeople_K12Students] NULL

		--Populate DimSeas
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting 2 of 6 - Staging-to-DimSeas')

			exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

		--Populate DimLeas
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting 3 of 6 - Staging-to-DimLeas')

			exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

		--Populate DimK12Schools
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting 4 of 6 - Staging-to-DimK12Schools')

			exec [Staging].[Staging-to-DimK12Schools] NULL, 0

		--clear the data from the fact table
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting 5 of 6 - Empty RDS')

			exec [rds].[Empty_RDS]  'exiting'

		--Populate the fact table
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting 6 of 6 - Staging-to-FactK12StudentCounts_SpecEdExit')

			--remove the cursor if a previous migraton stopped/failed
			if cursor_status('global','selectedYears_cursor') >= -1
			begin
				deallocate selectedYears_cursor
			end
			
			--populate the fact table for the submission report
			DECLARE @submissionYear AS VARCHAR(50)
			DECLARE selectedYears_cursor CURSOR FOR 
			SELECT d.SchoolYear
				FROM rds.DimSchoolYears d
				JOIN rds.DimSchoolYearDataMigrationTypes dd ON dd.DimSchoolYearId = d.DimSchoolYearId
				JOIN App.DataMigrationTypes b ON b.DataMigrationTypeId=dd.DataMigrationTypeId 
				WHERE d.DimSchoolYearId <> -1 
				AND dd.IsSelected=1 AND DataMigrationTypeCode='RDS'

			OPEN selectedYears_cursor
			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec Staging.[Staging-to-FactK12StudentCounts_Exiting] @submissionYear

				FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
			END
			
			CLOSE selectedYears_cursor
			DEALLOCATE selectedYears_cursor

		--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting Complete')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Exiting failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END



