CREATE PROCEDURE [App].[Wrapper_Migrate_Directory_to_RDS]

AS
BEGIN

/*********************************************
9/13/2022 - Staging to RDS Version
*********************************************/
-- 9/27/2022 --

    SET NOCOUNT ON;

	BEGIN TRY

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory - Start Staging-to-DimSeas')

		--Populate DimSeas
		exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory - Start Staging-to-DimLeas')

		--Populate DimLeas
		exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory - Start Staging-to-DimK12Schools')

		--Populate DimK12Schools
		exec [Staging].[Staging-to-DimK12Schools] NULL, 0

	
	--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory - Start Staging-to-DimCharterSchoolAuthorizers')

		--Populate Charter Authorizer	
		exec Staging.[Staging-to-DimCharterSchoolAuthorizers] 



		--write out message to DataMigrationHistories
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory - Start Staging-to-FactOrganizationCounts')


		if cursor_status('global','selectedYears_cursor') >= -1
			begin
				deallocate selectedYears_cursor
			end

		DECLARE @submissionYear AS VARCHAR(50)
		DECLARE selectedYears_cursor CURSOR FOR 
		SELECT d.SchoolYear
			FROM rds.DimSchoolYears d
			JOIN rds.DimSchoolYearDataMigrationTypes dd 
				ON dd.DimSchoolYearId = d.DimSchoolYearId
			JOIN rds.DimDataMigrationTypes b 
				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			WHERE d.DimSchoolYearId <> -1 
			AND dd.IsSelected = 1 
			AND DataMigrationTypeCode = 'RDS'

		OPEN selectedYears_cursor
		FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		WHILE @@FETCH_STATUS = 0
		BEGIN

			begin try
				--Populate the organization tables	
				exec [Staging].[Staging-to-FactOrganizationCounts] @submissionyear
			end try
			begin catch
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory failed to run - ' + ERROR_MESSAGE())
			end catch


			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
		END
		close selectedYears_Cursor
		deallocate selectedYears_Cursor


	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - Directory')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Directory failed to run - ' + ERROR_MESSAGE())
	END CATCH

    SET NOCOUNT OFF;

END