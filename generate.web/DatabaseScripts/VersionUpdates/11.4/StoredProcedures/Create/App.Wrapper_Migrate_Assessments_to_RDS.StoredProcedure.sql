﻿CREATE PROCEDURE [App].[Wrapper_Migrate_Assessments_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from Staging data
	
		--Populate DimStudents
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 1 of 9 - Staging-to-DimPeople_K12Students')

			exec Staging.[Staging-To-DimPeople_K12Students] NULL

		--Populate DimSeas
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 2 of 9 - Staging-to-DimSeas')

			exec [Staging].[Staging-to-DimSeas] 'directory', NULL, 0

		--Populate DimLeas
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 3 of 9 - Staging-to-DimLeas')

			exec [Staging].[Staging-to-DimLeas] 'directory', NULL, 0

		--Populate DimK12Schools
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 4 of 9 - Staging-to-DimK12Schools')

			exec [Staging].[Staging-to-DimK12Schools] NULL, 0

		--Populate DimAssessments
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 5 of 9 - Staging-to-DimAssessments')

			exec [Staging].[Staging-to-DimAssessments]

		-- --Populate DimAssessmentSubtests
		-- 	--write out message to DataMigrationHistories
		-- 	insert into app.DataMigrationHistories
		-- 	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Assessments - Start Migrate DimAssessmentSubtests')

		-- 	exec [Staging].[Staging-to-DimAssessmentSubtests]

		--Populate DimAssessmentAdministrations
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 6 of 9 - Staging-to-DimAssessmentAdministrations')

			exec [Staging].[Staging-to-DimAssessmentAdministrations]

		--Populate DimAssessmentPerformanceLevels
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 7 of 9 - Staging-to-DimAssessmentPerformanceLevels')

			exec [Staging].[Staging-to-DimAssessmentPerformanceLevels]

		--clear the data from the fact table
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 8 of 9 - Empty RDS')

			exec [rds].[Empty_RDS] 'assessment'

		--Populate the fact table
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments 9 of 9 - Staging-to-FactK12StudentAssessments')

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
			AND DataMigrationTypeCode = 'RDS'

			OPEN selectedYears_cursor
			FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC [Staging].[Staging-to-FactK12StudentAssessments] @submissionYear

				FETCH NEXT FROM selectedYears_cursor INTO @submissionYear
			END
			
			CLOSE selectedYears_cursor
			DEALLOCATE selectedYears_cursor

		--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments Complete')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Assessments failed to run - ' + ERROR_MESSAGE())
	END CATCH

	SET NOCOUNT OFF;

END