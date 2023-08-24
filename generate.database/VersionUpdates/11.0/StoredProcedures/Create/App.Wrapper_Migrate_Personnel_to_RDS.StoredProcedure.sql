﻿CREATE PROCEDURE [App].[Wrapper_Migrate_Personnel_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY
		EXEC Staging.Rollover_SourceSystemReferenceData -- This only happens when it is needed

	--Populate the RDS tables from ODS data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel - Start Staging-to-DimPeople_K112staff')

		--Populate DimPeople
		exec Staging.[Staging-To-DimPeople_K12Staff] NULL

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel - Start Staging-to-DimSeas')

		--Populate DimSeas
		exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel - Start Staging-to-DimLeas')

		--Populate DimLeas
		exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel - Start Staging-to-DimK12Schools')

		--Populate DimK12Schools
		exec [Staging].[Staging-to-DimK12Schools] NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel - Start Empty for Personnel')

		--clear the data from the fact table
		exec [rds].[Empty_RDS] 'submission', 'personnelcounts'

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel - Start Migrate_PersonnelCounts for Submission reports')

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
			JOIN rds.DimSchoolYearDataMigrationTypes dd 
				ON dd.DimSchoolYearId = d.DimSchoolYearId
			JOIN App.DataMigrationTypes b 
				ON b.DataMigrationTypeId=dd.DataMigrationTypeId 
		WHERE d.DimSchoolYearId <> -1 
		AND dd.IsSelected = 1 
		AND DataMigrationTypeCode = 'RDS'

		OPEN selectedYears_cursor
		FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC Staging.[Staging-to-FactK12StaffCounts] @submissionYear

			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		END
		
		CLOSE selectedYears_cursor
		DEALLOCATE selectedYears_cursor

	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - Personnel')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Personnel failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END



