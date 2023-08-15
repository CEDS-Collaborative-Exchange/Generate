-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	--CIID-4433 - Organization report table has columns defined as not null, affecting data migrations

		/*alter FactOrganizationCountReports*/
		IF EXISTS(select 1 from sys.columns where name = 'TitleiParentalInvolveRes' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
		ALTER TABLE RDS.FactOrganizationCountReports ALTER COLUMN TitleiParentalInvolveRes int NULL;

		IF EXISTS(select 1 from sys.columns where name = 'TitleiPartaAllocations' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
		ALTER TABLE RDS.FactOrganizationCountReports ALTER COLUMN TitleiPartaAllocations int NULL;

	--CIID-4431 - IDS migration - correct descriptions in App.DataMigrationTasks to match the new naming standard
		--remove all the tasks for the RDS migration type 1 - IDS
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DataMigrationTasks' AND Type = N'U')
		BEGIN
			delete from [App].[DataMigrationTasks]
			where DataMigrationTypeId = 1
		END 

		--add the rows back with the corrected Descriptions and add the wrapper migration SPs
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DataMigrationTasks' AND Type = N'U')
		BEGIN
			insert into [App].[DataMigrationTasks]
			values 
			(1,1,0,0,'Staging.Wrapper_Migrate_Directory_to_IDS @SchoolYear',	1,	0,'Complete IDS Migration - Directory/Grades Offered',	NULL),
			(1,1,0,0,'Staging.Wrapper_Migrate_ChildCount_to_IDS @SchoolYear',	2,	0,'Complete IDS Migration - Child Count',	NULL),
			(1,1,0,0,'Staging.Wrapper_Migrate_Exiting_to_IDS @SchoolYear',	3,	0,'Complete IDS Migration - Exiting',	NULL),
			(1,1,0,0,'Staging.Wrapper_Migrate_Discipline_to_IDS @SchoolYear',	4,	0,'Complete IDS Migration - Discipline',	NULL),
			(1,1,0,0,'Staging.Wrapper_Migrate_Personnel_to_IDS @SchoolYear',	5,	0,'Complete IDS Migration - Personnel',	NULL),
			(1,1,0,0,'Staging.Wrapper_Migrate_Assessment_to_IDS @SchoolYear',	6,	0,'Complete IDS Migration - Assessments',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_CompletelyClearDataFromODS @SchoolYear',	15,	0,'Staging to IDS Migration - Completely Clear Data From IDS',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_Organization @SchoolYear',	16,	0,'Staging to IDS Migration - Organization',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_CharterSchoolManagementOrganization @SchoolYear',	17,	0,'Staging to IDS Migration - Charter School Management Organization',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_OrganizationProgramType @SchoolYear',	18,	0,'Staging to IDS Migration - Organization Program Type',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_PsInstitution',	19,	0,'Staging to IDS Migration - PS Institution',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_OrganizationAddress',	20,	0,'Staging to IDS Migration - Organization Address',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_OrganizationCalendarSession @SchoolYear',	21,	0,'Staging to IDS Migration - Organization Calendar Session',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_K12Enrollment',	22,	0,'Staging to IDS Migration - K12 Enrollment',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_PersonRace',	23,	0,'Staging to IDS Migration - Person Race',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_PersonStatus @SchoolYear',	24,	0,'Staging to IDS Migration - Person Status',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_PsStudentEnrollment @SchoolYear',	25,	0,'Staging to IDS Migration - Post Secondary Student Enrollment',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_ProgramParticipationSpecialEducation @SchoolYear',	26,	0,'Staging to IDS Migration - Program Participation - Special Education',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_Migrant @SchoolYear',	27,	0,'Staging to IDS Migration - Migrant',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_ProgramParticipationTitleI @SchoolYear',	28, 0,'Staging to IDS Migration - Program Participation - Title I',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_ProgramParticipationCTE @SchoolYear',	29,	0,'Staging to IDS Migration - Program Participation - CTE',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_ProgramParticipationNorD @SchoolYear',	30,	0,'Staging to IDS Migration - Program Participation - N or D',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_ProgramParticipationTitleIII @SchoolYear',	31,	0,'Staging to IDS Migration - Program Participation - Title III',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_Discipline @SchoolYear',	32,	0,'Staging to IDS Migration - Discipline',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_K12ProgramParticipation',	33,	0,'Staging to IDS Migration - K12 Program Enrollment',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_StudentCourseSection @SchoolYear',	34,	0,'Staging to IDS Migration - Student Course Section',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_Assessment @SchoolYear',	35,	0,'Staging to IDS Migration - Assessment',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_K12StaffAssignment @SchoolYear',	36,	0,'Staging to IDS Migration - Staff Assignment',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_StateDefinedCustomIndicator @SchoolYear',	37,	0,'Staging to IDS Migration - State Defined Custom Indicator',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_PsStudentAcademicRecord',	38,	0,'Staging to IDS Migration - Student Academic Record',	NULL),
			(1,1,0,0,'Staging.Migrate_StagingToIDS_PsStudentAcademicAward @SchoolYear',	39,	0,'Staging to IDS Migration - Student Academic Award',	NULL)
		END

	--CIID-4344 - Update Generate 3.8 to include any missing charter authorizer code from 3.7 
		IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeCode' AND Object_ID = Object_ID(N'rds.DimCharterSchoolAuthorizers')) 
		BEGIN
			EXEC SP_RENAME 'rds.DimCharterSchoolAuthorizers.LeaTypeCode', 'CharterSchoolAuthorizerTypeCode', 'COLUMN' 
		END

		IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeEdFactsCode' AND Object_ID = Object_ID(N'rds.DimCharterSchoolAuthorizers')) 
		BEGIN
			EXEC SP_RENAME 'rds.DimCharterSchoolAuthorizers.LeaTypeEdFactsCode', 'CharterSchoolAuthorizerTypeEdfactsCode', 'COLUMN' 
		END

		IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeDescription' AND Object_ID = Object_ID(N'rds.DimCharterSchoolAuthorizers')) 
		BEGIN
			EXEC SP_RENAME 'rds.DimCharterSchoolAuthorizers.LeaTypeDescription', 'CharterSchoolAuthorizerTypeDescription', 'COLUMN' 
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaTypeID'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolAuthorizers')) 
		BEGIN
			ALTER TABLE rds.DimCharterSchoolAuthorizers 
			DROP COLUMN LeaTypeID 
		END


	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()         
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off