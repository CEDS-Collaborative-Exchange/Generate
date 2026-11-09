CREATE PROCEDURE [App].[Wrapper_Migrate_EnglishLearnerAssessment_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from Staging data for English Learner Assessment
	
		--Populate DimStudents
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 1 of 9 - Staging-to-DimPeople_K12Students')

			exec Staging.[Staging-To-DimPeople_K12Students] NULL

		--Populate DimSeas
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 2 of 9 - Staging-to-DimSeas')

			exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

		--Populate DimLeas
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 3 of 9 - Staging-to-DimLeas')

			exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

		--Populate DimK12Schools
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 4 of 9 - Staging-to-DimK12Schools')

			exec [Staging].[Staging-to-DimK12Schools] NULL, 0

		--Populate DimAssessments
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 5 of 9 - Staging-to-DimAssessments')

			exec [Staging].[Staging-to-DimAssessments]

		-- --Populate DimAssessmentSubtests
		-- 	--write out message to DataMigrationHistories
		-- 	insert into app.DataMigrationHistories
		-- 	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessment - Start Migrate DimAssessmentSubtests')

		-- 	exec [Staging].[Staging-to-DimAssessmentSubtests]

		--Populate DimAssessmentAdministrations
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 6 of 9 - Staging-to-DimAssessmentAdministrations')

			exec [Staging].[Staging-to-DimAssessmentAdministrations]

		--Populate DimAssessmentPerformanceLevels
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 7 of 9 - Staging-to-DimAssessmentPerformanceLevels')

			exec [Staging].[Staging-to-DimAssessmentPerformanceLevels]

		--clear the data from the fact table
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 8 of 9 - Empty RDS')

			exec [rds].[Empty_RDS] 'assessment'

		--Populate the fact table
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment 9 of 9 - Staging-to-FactK12StudentAssessments')

			--remove the cursor if a previous migraton stopped/failed
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
				JOIN App.DataMigrationTypes b 
					ON b.DataMigrationTypeId=dd.DataMigrationTypeId 
			WHERE d.DimSchoolYearId <> -1 
			AND dd.IsSelected = 1 
			AND DataMigrationTypeCode = 'report'

			OPEN selectedYears_cursor
			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC [Staging].[Staging-to-FactK12StudentAssessment_EnglishLearnerAssessment] @submissionYear

				FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
			END
			
			CLOSE selectedYears_cursor
			DEALLOCATE selectedYears_cursor

		--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment Complete')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS English Learner Assessment failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END