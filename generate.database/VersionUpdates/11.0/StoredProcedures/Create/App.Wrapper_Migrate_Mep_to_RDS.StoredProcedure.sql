﻿CREATE PROCEDURE [App].[Wrapper_Migrate_Mep_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from Staging data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program - Start Staging-to-DimPeople_K12Students')

		--Populate DimPeople
		exec Staging.[Staging-To-DimPeople_K12Students] NULL

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program - Start Staging-to-DimSeas')

		--Populate DimSeas
		exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program - Start Staging-to-DimLeas')

		--Populate DimLeas
		exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program - Start Staging-to-DimK12Schools')

		--Populate DimK12Schools
		exec [Staging].[Staging-to-DimK12Schools] NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program - Start Empty_RDS for the Submission reports')

		--clear the data from the fact table
		exec [rds].[Empty_RDS] 'MEP'

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program - Start Staging-to-FactK12StudentCounts_Migrant Education Program for Submission reports')

		--remove the cursor if a previous migraton stopped/failed
		if cursor_status('global','selectedYears_cursor') >= -1
		begin
			deallocate selectedYears_cursor
		end
		
		--populate the Fact table
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
			EXEC Staging.[Staging-to-FactK12StudentCounts_MigrantEducationProgram] @submissionYear

			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		END
		
		CLOSE selectedYears_cursor
		DEALLOCATE selectedYears_cursor

	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - Migrant Education Program')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Migrant Education Program failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END



