﻿CREATE PROCEDURE [App].[Wrapper_Migrate_TitleIIIELSY_to_RDS]
AS
BEGIN

    SET NOCOUNT ON;

	BEGIN TRY

	--Populate the RDS tables from ODS data
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper titleIIIELSY - Start MigrateDimStudents')

		--Populate DimStudents
		exec [rds].[Migrate_DimStudents]

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper titleIIIELSY - Start Migrate_OrganizationCounts')

		--Populate the organization tables	
		exec [rds].[Migrate_OrganizationCounts] 'directory', 0

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper titleIIIELSY - Start Empty_RDS for the Submission reports')

		--clear the data from the fact table
		exec [rds].[Empty_RDS] 'titleIIIELSY'

			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper titleIIIELSY - Start Migrate_StudentCounts for Submission reports')

		--populate the fact table for the submission report
		exec [rds].[Migrate_StudentCounts] 'titleIIIELSY', 0

	--RDS migration complete
			--write out message to DataMigrationHistories
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper Complete - titleIIIELSY')

	END TRY
	BEGIN CATCH
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'RDS Migration Wrapper titleIIIELSY failed to run')
	END CATCH

	SET NOCOUNT OFF;

END



