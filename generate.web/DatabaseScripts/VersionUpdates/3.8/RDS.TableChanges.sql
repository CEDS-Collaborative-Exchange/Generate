-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	--IF NOT EXISTS ( SELECT  1 FROM  sys.schemas  WHERE  name = N'cedsv8' )
	--BEGIN
	-- Drop all constraints on the RDS fact tables
	DECLARE @sql NVARCHAR(MAX);
	SET @sql = N'';

	SELECT @sql = @sql + N'
	  ALTER TABLE ' + QUOTENAME(s.name) + N'.'
	  + QUOTENAME(t.name) + N' DROP CONSTRAINT '
	  + QUOTENAME(c.name) + ';'
	FROM sys.objects AS c
	INNER JOIN sys.tables AS t
		ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s 
		ON t.[schema_id] = s.[schema_id]
	WHERE c.[type] IN ('D','C','F','PK','UQ')
	AND s.name = 'rds'
	and t.name like 'fact%'
	ORDER BY c.[type];
 
	EXEC sp_executesql @sql;

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimCountDateId' AND object_id = OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimCountDateId] ON [RDS].[FactPersonnelCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimFactTypeId' AND object_id = OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimFactTypeId] ON [RDS].[FactPersonnelCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimPersonnelId' AND object_id = OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimPersonnelId] ON [RDS].[FactPersonnelCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimPersonnelStatusId' AND object_id = OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimPersonnelStatusId] ON [RDS].[FactPersonnelCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimSchoolId' AND object_id = OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimSchoolId] ON [RDS].[FactPersonnelCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimPersonnelCategoryId' AND object_id= OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimPersonnelCategoryId] ON [RDS].[FactPersonnelCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactPersonnelCounts_DimTitleiiiStatusId' AND object_id = OBJECT_ID('[RDS].[FactPersonnelCounts]'))
	drop index [IX_FactPersonnelCounts_DimTitleiiiStatusId] ON [RDS].[FactPersonnelCounts];

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimAssessmentId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimAssessmentId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimCountDateId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimCountDateId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimDemographicId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimDemographicId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimFactTypeId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimFactTypeId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimGradeLevelId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimGradeLevelId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimIdeaStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimIdeaStatusId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimProgramStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimProgramStatusId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimSchoolId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimSchoolId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimStudentId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimStudentId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimAssessmentStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimAssessmentStatusId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimTitleiiiStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimTitleiiiStatusId] ON [RDS].[FactStudentAssessments];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentAssessments_DimStudentStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentAssessments]'))
	drop index [IX_FactStudentAssessments_DimStudentStatusId] ON [RDS].[FactStudentAssessments];


	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimAgeId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimAgeId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimCountDateId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimCountDateId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimDemographicId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimDemographicId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimFactTypeId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimFactTypeId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimGradeLevelId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimGradeLevelId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimIdeaStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimIdeaStatusId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimProgramStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimProgramStatusId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimSchoolId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimSchoolId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimStudentId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimStudentId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimLanguageId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimLanguageId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimMigrantId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimMigrantId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimStudentStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimStudentStatusId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimTitle1StatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimTitle1StatusId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_School' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_Date_Type_School] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimTitleiiiStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimTitleiiiStatusId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimLeaId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimLeaId] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_School_Count' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_Date_Type_School_Count] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_Grade_School_Student' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_Date_Type_Grade_School_Student] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_Grade_Statuses' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_Date_Type_Grade_Statuses] ON [RDS].[FactStudentCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_DimCountDateId_DimFactTypeId' AND object_id = OBJECT_ID('[RDS].[FactStudentCounts]'))
	drop index [IX_FactStudentCounts_DimCountDateId_DimFactTypeId] ON [RDS].[FactStudentCounts];

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimAgeId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimAgeId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimCountDateId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimCountDateId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimDemographicId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimDemographicId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimDisciplineId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimDisciplineId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimFactTypeId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimFactTypeId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimIdeaStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimIdeaStatusId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimProgramStatusId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimProgramStatusId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimSchoolId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimSchoolId] ON [RDS].[FactStudentDisciplines];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentDisciplines_DimStudentId' AND object_id = OBJECT_ID('[RDS].[FactStudentDisciplines]'))
	drop index [IX_FactStudentDisciplines_DimStudentId] ON [RDS].[FactStudentDisciplines];

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimCountDateId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimCountDateId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimFactTypeId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimFactTypeId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimLeaId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimLeaId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimPersonnelId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimPersonnelId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimSchoolId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimSchoolId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimSchoolStatusId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimSchoolStatusId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimSeaId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimSeaId] ON [RDS].[FactOrganizationCounts];
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimTitle1StatusId' AND object_id = OBJECT_ID('[RDS].[FactOrganizationCounts]'))
	drop index [IX_FactOrganizationCounts_DimTitle1StatusId] ON [RDS].[FactOrganizationCounts];

	IF EXISTS(select 1 from sys.columns where name = 'FactPersonnelCountId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.FactPersonnelCountId', 'FactK12StaffCountId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimCountDateId', 'SchoolYearId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimPersonnelId', 'K12StaffId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelStatusId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimPersonnelStatusId', 'K12StaffStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'PersonnelCount' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.PersonnelCount', 'StaffCount', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'PersonnelFTE' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.PersonnelFTE', 'StaffFTE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelCategoryId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimPersonnelCategoryId', 'K12StaffCategoryId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimTitleiiiStatusId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimTitleiiiStatusId', 'TitleIIIStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimLeaId', 'LeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSeaId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCounts'))
    EXEC sp_rename 'RDS.FactPersonnelCounts.DimSeaId', 'SeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FactStudentAssessmentId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.FactStudentAssessmentId', 'FactK12StudentAssessmentId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimAssessmentId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimAssessmentId', 'AssessmentId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimCountDateId', 'SchoolYearId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimDemographicId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimDemographicId', 'K12DemographicId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimGradeLevelId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimGradeLevelId', 'GradeLevelId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimIdeaStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimIdeaStatusId', 'IdeaStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimProgramStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimProgramStatusId', 'ProgramStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimLeaId', 'LeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSeaId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
    EXEC sp_rename 'RDS.FactStudentAssessments.DimSeaId', 'SeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStudentId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimStudentId', 'K12StudentId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimAssessmentStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimAssessmentStatusId', 'AssessmentStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimTitleiiiStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimTitleiiiStatusId', 'TitleIIIStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStudentStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimStudentStatusId', 'K12StudentStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimNorDProgramStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimNorDProgramStatusId', 'NOrDProgramStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimRaceId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimRaceId', 'RaceId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCteStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimCteStatusId', 'CteStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimEnrollmentStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimEnrollmentStatusId', 'EnrollmentStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimTitle1StatusId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
	EXEC sp_rename 'RDS.FactStudentAssessments.DimTitle1StatusId', 'TitleIStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FactStudentCountId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.FactStudentCountId', 'FactK12StudentCountId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSeaId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimSeaId', 'SeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimLeaId', 'LeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimAgeId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimAgeId', 'AgeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimCountDateId', 'SchoolYearId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimDemographicId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimDemographicId', 'K12DemographicId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimGradeLevelId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimGradeLevelId', 'GradeLevelId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimIdeaStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimIdeaStatusId', 'IdeaStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimProgramStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimProgramStatusId', 'ProgramStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStudentId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimStudentId', 'K12StudentId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLanguageId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimLanguageId', 'LanguageId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimMigrantId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimMigrantId', 'MigrantId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStudentStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimStudentStatusId', 'K12StudentStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimTitle1StatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimTitle1StatusId', 'TitleIStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimTitleiiiStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimTitleiiiStatusId', 'TitleIIIStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimAttendanceId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimAttendanceId', 'AttendanceId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimEnrollmentId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	ALTER TABLE RDS.FactStudentCounts DROP COLUMN DimEnrollmentId;

	IF EXISTS(select 1 from sys.columns where name = 'DimCohortStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimCohortStatusId', 'CohortStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimNorDProgramStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimNorDProgramStatusId', 'NOrDProgramStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimRaceId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimRaceId', 'RaceId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCteStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
    EXEC sp_rename 'RDS.FactStudentCounts.DimCteStatusId', 'CteStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimEnrollmentStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
	EXEC sp_rename 'RDS.FactStudentCounts.DimEnrollmentStatusId', 'K12EnrollmentStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FactStudentDisciplineId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.FactStudentDisciplineId', 'FactK12StudentDisciplineId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSeaId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimSeaId', 'SeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimLeaId', 'LeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimAgeId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimAgeId', 'AgeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimDisciplineId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimDisciplineId', 'DisciplineId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimCountDateId', 'SchoolYearId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimDemographicId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimDemographicId', 'K12DemographicId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimGradeLevelId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimGradeLevelId', 'GradeLevelId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimIdeaStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimIdeaStatusId', 'IdeaStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimProgramStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimProgramStatusId', 'ProgramStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStudentId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimStudentId', 'K12StudentId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimRaceId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimRaceId', 'RaceId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCteStatusId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimCteStatusId', 'CteStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFirearmsId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimFirearmsId', 'FirearmsId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFirearmsDisciplineId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
	EXEC sp_rename 'RDS.FactStudentDisciplines.DimFirearmsDisciplineId', 'FirearmDisciplineId', 'COLUMN';


	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimCountDateId', 'SchoolYearId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimDemographicId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimDemographicId', 'K12DemographicId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimLeaId', 'LeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimAttendanceId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimAttendanceId', 'AttendanceId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStudentId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimStudentId', 'K12StudentId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSeaId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendance'))
	EXEC sp_rename 'RDS.FactK12StudentAttendance.DimSeaId', 'SeaId', 'COLUMN';


	IF EXISTS(select 1 from sys.columns where name = 'DimSeaId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimSeaId', 'SeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimLeaId', 'LeaId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimCountDateId', 'SchoolYearId', 'COLUMN'; 

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimPersonnelId', 'K12StaffId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimSchoolStatusId', 'SchoolStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimTitle1StatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimTitle1StatusId', 'TitleIStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'TitleiParentalInvolveRes' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.TitleiParentalInvolveRes', 'TitleIParentalInvolveRes', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'TitleiPartaAllocations' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.TitleiPartaAllocations', 'TitleIPartAAllocations', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCharterSchoolAuthorizerId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimCharterSchoolAuthorizerId', 'CharterSchoolApproverAgencyId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCharterSchoolManagementOrganizationId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimCharterSchoolManagementOrganizationId', 'CharterSchoolManagerOrganizationId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCharterSchoolSecondaryAuthorizerId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimCharterSchoolSecondaryAuthorizerId', 'CharterSchoolSecondaryApproverAgencyId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCharterSchoolUpdatedManagementOrganizationId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimCharterSchoolUpdatedManagementOrganizationId', 'CharterSchoolUpdatedManagerOrganizationId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimOrganizationStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimOrganizationStatusId', 'OrganizationStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolStateStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimSchoolStateStatusId', 'SchoolStateStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'SCHOOLIMPROVEMENTFUNDS' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.SCHOOLIMPROVEMENTFUNDS', 'SchoolImprovementFunds', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimComprehensiveAndTargetedSupportId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimComprehensiveAndTargetedSupportId', 'ComprehensiveAndTargetedSupportId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCharterSchoolStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
	EXEC sp_rename 'RDS.FactOrganizationCounts.DimCharterSchoolStatusId', 'CharterSchoolStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimSchoolId', 'K12SchoolId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimCountDateId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimCountDateId', 'SchoolYearId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimFactTypeId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimFactTypeId', 'FactTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimRaceId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimRaceId', 'RaceId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimIdeaStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimIdeaStatusId', 'IdeaStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimDemographicId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimDemographicId', 'K12DemographicId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimIndicatorStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimIndicatorStatusId', 'IndicatorStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStateDefinedStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimStateDefinedStatusId', 'StateDefinedStatusId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimStateDefinedCustomIndicatorId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimStateDefinedCustomIndicatorId', 'StateDefinedCustomIndicatorId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DimIndicatorStatusTypeId' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCounts'))
	EXEC sp_rename 'RDS.FactOrganizationStatusCounts.DimIndicatorStatusTypeId', 'IndicatorStatusTypeId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FactPersonnelCountReportId' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.FactPersonnelCountReportId', 'ReportEDFactsK12StaffCountId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'AGEGROUP' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.AGEGROUP', 'SPECIALEDUCATIONAGEGROUPTAUGHT', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'PERSONNELTYPE' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.PERSONNELTYPE', 'K12STAFFCLASSIFICATION', 'COLUMN';

	--IF EXISTS(select 1 from sys.columns where name = 'STAFFCATEGORYCCD' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	--EXEC sp_rename 'RDS.FactPersonnelCountReports.STAFFCATEGORYCCD', '', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'STAFFCATEGORYSPECIALED' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.STAFFCATEGORYSPECIALED', 'SPECIALEDUCATIONSUPPORTSERVICESCATEGORY', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'STAFFCATEGORYTITLE1' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.STAFFCATEGORYTITLE1', 'TITLEIPROGRAMSTAFFCATEGORY', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'PersonnelCount' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.PersonnelCount', 'StaffCount', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'PersonnelFTE' AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports'))
	EXEC sp_rename 'RDS.FactPersonnelCountReports.PersonnelFTE', 'StaffFTE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FactStudentCountReportId' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.FactStudentCountReportId', 'ReportEDFactsK12StudentCountId', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'BASISOFEXIT' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.BASISOFEXIT', 'SPECIALEDUCATIONEXITREASON', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'DISABILITY' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.DISABILITY', 'PRIMARYDISABILITYTYPE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'EDUCENV' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.EDUCENV', 'IDEAEDUCATIONALENVIRONMENT', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'LANGUAGE' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.LANGUAGE', 'ISO6392LANGUAGE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'CONTINUATION' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.CONTINUATION', 'CONTINUATIONOFSERVICESREASON', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'MEPFUNDSSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.MEPFUNDSSTATUS', 'CONSOLIDATEDMEPFUNDSSTATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'MEPSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.MEPSERVICES', 'MEPSERVICESTYPE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'MIGRANTPRIORITYFORSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.MIGRANTPRIORITYFORSERVICES', 'MIGRANTPRIORITIZEDFORSERVICES', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'NEGLECTEDPROGRAMTYPE' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.NEGLECTEDPROGRAMTYPE', 'NEGLECTEDORDELINQUENTPROGRAMTYPE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FOODSERVICEELIGIBILITY' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.FOODSERVICEELIGIBILITY', 'ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'IMMIGRANTTITLEIIIPROGRAM' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.IMMIGRANTTITLEIIIPROGRAM', 'TITLEIIIIMMIGRANTPARTICIPATIONSTATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'SECTION504PROGRAM' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.SECTION504PROGRAM', 'SECTION504STATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'TITLE1INSTRUCTIONALSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.TITLE1INSTRUCTIONALSERVICES', 'TITLEIINSTRUCTIONALSERVICES', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'TITLE1PROGRAMTYPE' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.TITLE1PROGRAMTYPE', 'TITLEIPROGRAMTYPE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'TITLE1SCHOOLSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.TITLE1SCHOOLSTATUS', 'TITLEISCHOOLSTATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'TITLE1SUPPORTSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.TITLE1SUPPORTSERVICES', 'TITLEISUPPORTSERVICES', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'LEPSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.LEPSTATUS', 'ENGLISHLEARNERSTATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'ECODISSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.ECODISSTATUS', 'ECONOMICDISADVANTAGESTATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'HOMELESSSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.HOMELESSSTATUS', 'HOMELESSNESSSTATUS', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'MILITARYCONNECTEDSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.MILITARYCONNECTEDSTATUS', 'MILITARYCONNECTEDSTUDENTINDICATOR', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'HOMELESSNIGHTTIMERESIDENCE' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
	EXEC sp_rename 'RDS.FactStudentCountReports.HOMELESSNIGHTTIMERESIDENCE', 'HOMELESSPRIMARYNIGHTTIMERESIDENCE', 'COLUMN';

	IF EXISTS(select 1 from sys.columns where name = 'FactStudentDisciplineReportId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.FactStudentDisciplineReportId', 'ReportEDFactsK12StudentDisciplineId', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'BASISOFEXIT' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.BASISOFEXIT', 'SPECIALEDUCATIONEXITREASON', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'DISABILITY' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.DISABILITY', 'PRIMARYDISABILITYTYPE', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'EDUCENV' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.EDUCENV', 'IDEAEDUCATIONALENVIRONMENT', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'FOODSERVICEELIGIBILITY' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.FOODSERVICEELIGIBILITY', 'ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'IMMIGRANTTITLEIIIPROGRAM' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.IMMIGRANTTITLEIIIPROGRAM', 'TITLEIIIIMMIGRANTPARTICIPATIONSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'SECTION504PROGRAM' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.SECTION504PROGRAM', 'SECTION504STATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'DISCIPLINEACTION' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.DISCIPLINEACTION', 'DISCIPLINARYACTIONTAKEN', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'DISCIPLINEMETHOD' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.DISCIPLINEMETHOD', 'DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'EDUCATIONALSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.EDUCATIONALSERVICES', 'EDUCATIONALSERVICESAFTERREMOVAL', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'REMOVALREASON' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.REMOVALREASON', 'IDEAINTERIMREMOVALREASON', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'REMOVALTYPE' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.REMOVALTYPE', 'IDEAINTERIMREMOVAL', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'FIREARMS' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.FIREARMS', 'FIREARMTYPE', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'FIREARMSDISCIPLINE' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.FIREARMSDISCIPLINE', 'DISCIPLINEMETHODFORFIREARMSINCIDENTS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'IDEAFIREARMSDISCIPLINE' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.IDEAFIREARMSDISCIPLINE', 'IDEADISCIPLINEMETHODFORFIREARMSINCIDENTS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'LEPSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.LEPSTATUS', 'ENGLISHLEARNERSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'ECODISSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.ECODISSTATUS', 'ECONOMICDISADVANTAGESTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'HOMELESSSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.HOMELESSSTATUS', 'HOMELESSNESSSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'MILITARYCONNECTEDSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.MILITARYCONNECTEDSTATUS', 'MILITARYCONNECTEDSTUDENTINDICATOR', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'HOMELESSNIGHTTIMERESIDENCE' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
	EXEC sp_rename 'RDS.FactStudentDisciplineReports.HOMELESSNIGHTTIMERESIDENCE', 'HOMELESSPRIMARYNIGHTTIMERESIDENCE', 'COLUMN';


	IF EXISTS(select 1 from sys.columns where name = 'FactStudentAssessmentReportId' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.FactStudentAssessmentReportId', 'FactK12StudentAssessmentReportId', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'BASISOFEXIT' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.BASISOFEXIT', 'SPECIALEDUCATIONEXITREASON', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'DISABILITY' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.DISABILITY', 'PRIMARYDISABILITYTYPE', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'EDUCENV' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.EDUCENV', 'IDEAEDUCATIONALENVIRONMENT', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'FOODSERVICEELIGIBILITY' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.FOODSERVICEELIGIBILITY', 'ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'IMMIGRANTTITLEIIIPROGRAM' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.IMMIGRANTTITLEIIIPROGRAM', 'TITLEIIIIMMIGRANTPARTICIPATIONSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'SECTION504PROGRAM' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.SECTION504PROGRAM', 'SECTION504STATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'NEGLECTEDPROGRAMTYPE' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.NEGLECTEDPROGRAMTYPE', 'NEGLECTEDORDELINQUENTPROGRAMTYPE', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'TITLE1INSTRUCTIONALSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.TITLE1INSTRUCTIONALSERVICES', 'TITLEIINSTRUCTIONALSERVICES', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'TITLE1PROGRAMTYPE' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.TITLE1PROGRAMTYPE', 'TITLEIPROGRAMTYPE', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'TITLE1SCHOOLSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.TITLE1SCHOOLSTATUS', 'TITLEISCHOOLSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'TITLE1SUPPORTSERVICES' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.TITLE1SUPPORTSERVICES', 'TITLEISUPPORTSERVICES', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'LEPSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.LEPSTATUS', 'ENGLISHLEARNERSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'ECODISSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.ECODISSTATUS', 'ECONOMICDISADVANTAGESTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'HOMELESSSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.HOMELESSSTATUS', 'HOMElESSNESSSTATUS', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'MILITARYCONNECTEDSTATUS' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.MILITARYCONNECTEDSTATUS', 'MILITARYCONNECTEDSTUDENTINDICATOR', 'COLUMN';
	IF EXISTS(select 1 from sys.columns where name = 'HOMELESSNIGHTTIMERESIDENCE' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactStudentAssessmentReports.HOMELESSNIGHTTIMERESIDENCE', 'HOMELESSPRIMARYNIGHTTIMERESIDENCE', 'COLUMN';
	
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactStudentCounts')
    EXEC sp_rename 'RDS.FactStudentCounts', 'FactK12StudentCounts';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactPersonnelCounts')
    EXEC sp_rename 'RDS.FactPersonnelCounts', 'FactK12StaffCounts';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactStudentAssessments')
    EXEC sp_rename 'RDS.FactStudentAssessments', 'FactK12StudentAssessments';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactStudentDisciplines')
	EXEC sp_rename 'RDS.FactStudentDisciplines', 'FactK12StudentDisciplines';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactPersonnelCountReports')
	EXEC sp_rename 'RDS.FactPersonnelCountReports', 'ReportEDFactsK12StaffCounts';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactStudentCountReports')
	EXEC sp_rename 'RDS.FactStudentCountReports', 'ReportEDFactsK12StudentCounts';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactStudentDisciplineReports')
	EXEC sp_rename 'RDS.FactStudentDisciplineReports', 'ReportEDFactsK12StudentDisciplines';
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactStudentAssessmentReports')
	EXEC sp_rename 'RDS.FactStudentAssessmentReports', 'FactK12StudentAssessmentReports';

	IF NOT EXISTS(select 1 from sys.columns where name = 'IeuId' AND Object_ID = Object_ID(N'RDS.FactK12StudentAssessments'))
    ALTER TABLE RDS.FactK12StudentAssessments ADD IeuId int NOT NULL DEFAULT (-1);
	--IF NOT EXISTS(select 1 from sys.columns where name = 'ScoreValue' AND Object_ID = Object_ID(N'RDS.FactK12StudentAssessments'))
	--ALTER TABLE RDS.FactK12StudentAssessments ADD ScoreValue NVARCHAR (50) NOT NULL;
	IF NOT EXISTS(select 1 from sys.columns where name = 'IeuId' AND Object_ID = Object_ID(N'RDS.FactK12StudentCounts'))
	ALTER TABLE RDS.FactK12StudentCounts ADD IeuId int NOT NULL DEFAULT (-1);
	IF NOT EXISTS(select 1 from sys.columns where name = 'SpecialEducationServicesExitDateId' AND Object_ID = Object_ID(N'RDS.FactK12StudentCounts'))
	ALTER TABLE RDS.FactK12StudentCounts ADD SpecialEducationServicesExitDateId int NOT NULL DEFAULT (-1);
	IF NOT EXISTS(select 1 from sys.columns where name = 'IeuId' AND Object_ID = Object_ID(N'RDS.FactK12StudentDisciplines'))
	ALTER TABLE RDS.FactK12StudentDisciplines ADD IeuId int NOT NULL DEFAULT (-1);
	IF NOT EXISTS(select 1 from sys.columns where name = 'PostSecondaryEnrollmentStatus' AND Object_ID = Object_ID(N'RDS.FactK12StudentAssessmentReports'))
	ALTER TABLE RDS.FactK12StudentAssessmentReports ADD PostSecondaryEnrollmentStatus varchar(50)
	IF EXISTS(select 1 from sys.columns where name = 'DiplomaCredentialType' AND Object_ID = Object_ID(N'RDS.FactK12StudentAssessmentReports'))
	EXEC sp_rename 'RDS.FactK12StudentAssessmentReports.DIPLOMACREDENTIALTYPE', 'HIGHSCHOOLDIPLOMATYPE', 'COLUMN';
    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimDates_SpecialEducationServicesExitDate' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	    ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimDates_SpecialEducationServicesExitDate] FOREIGN KEY ([SpecialEducationServicesExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId])


    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StaffCounts_LeaId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [DF_FactK12StaffCounts_LeaId]  DEFAULT ((-1)) FOR [LeaId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StaffCounts_K12StaffCategoryId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [DF_FactK12StaffCounts_K12StaffCategoryId]  DEFAULT ((-1)) FOR [K12StaffCategoryId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StaffCounts_SeaId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [DF_FactK12StaffCounts_SeaId]  DEFAULT ((-1)) FOR [SeaId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StaffCounts_TitleIIIStatusId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [DF_FactK12StaffCounts_TitleIIIStatusId]  DEFAULT ((-1)) FOR [TitleIIIStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactK12StaffCounts' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD  CONSTRAINT [PK_FactK12StaffCounts] PRIMARY KEY CLUSTERED 
    (
	    [FactK12StaffCountId] ASC
    )WITH (DATA_COMPRESSION = PAGE)
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimSchoolYear_DimSchoolYearId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimSchoolYear_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimFactTypes_DimFactTypeId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimFactTypes_DimFactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimK12Staff_DimK12StaffId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimK12Staff_DimK12StaffId] FOREIGN KEY ([K12StaffId]) REFERENCES [RDS].[DimK12Staff] ([DimK12StaffId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimK12StaffCategories_DimK12StaffCategoryId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimK12StaffCategories_DimK12StaffCategoryId] FOREIGN KEY ([K12StaffCategoryId]) REFERENCES [RDS].[DimK12StaffCategories] ([DimK12StaffCategoryId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId] FOREIGN KEY ([K12StaffStatusId]) REFERENCES [RDS].[DimK12StaffStatuses] ([DimK12StaffStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimSchools_DimK12SchoolId' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimSchools_DimK12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StaffCounts_DimTitleIiiStatuses' 
	    AND OBJECT_NAME(id) = 'FactK12StaffCounts' )
    ALTER TABLE [RDS].[FactK12StaffCounts] ADD CONSTRAINT [FK_FactK12StaffCounts_DimTitleIiiStatuses] FOREIGN KEY ([TitleiiiStatusId]) REFERENCES [RDS].[DimTitleIiiStatuses] ([DimTitleiiiStatusId])
	
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_AssessmentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_AssessmentStatusId] DEFAULT ((-1)) FOR [AssessmentStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_CteStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId] DEFAULT ((-1)) FOR [CteStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_EnrollmentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_EnrollmentStatusId] DEFAULT ((-1)) FOR [EnrollmentStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_LeaId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_LeaId] DEFAULT ((-1)) FOR [LeaId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_NorDProgramStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_NorDProgramStatusId] DEFAULT ((-1)) FOR [NorDProgramStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_RaceId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_RaceId] DEFAULT ((-1)) FOR [RaceId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_SeaId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_SeaId] DEFAULT ((-1)) FOR [SeaId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_StudentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
 --   ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_StudentStatusId] DEFAULT ((-1)) FOR [StudentStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_TitleIStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_TitleIStatusId] DEFAULT ((-1)) FOR [TitleIStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentAssessments_TitleIIIStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId] DEFAULT ((-1)) FOR [TitleIIIStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactK12StudentAssessments' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
     ALTER TABLE [RDS].[FactK12StudentAssessments] ADD  CONSTRAINT [PK_FactK12StudentAssessments] PRIMARY KEY CLUSTERED 
    (
	    [FactK12StudentAssessmentId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimSchoolYear_DimSchoolYearId' 
	    AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimSchoolYear_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimIeus' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
 --   ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimIeus] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimK12Students' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimK12Students] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimK12Students] ([DimK12StudentId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimLeas' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimLeas] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimTitleIIIStatuses' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimTitleIIIStatuses] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimAssessments_DimAssessmentId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimAssessments_DimAssessmentId] FOREIGN KEY ([AssessmentId]) REFERENCES [RDS].[DimAssessments] ([DimAssessmentId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimAssessmentStatuses_DimAssessmentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimAssessmentStatuses_DimAssessmentStatusId] FOREIGN KEY ([AssessmentStatusId]) REFERENCES [RDS].[DimAssessmentStatuses] ([DimAssessmentStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimDemographics_DimDemographicId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimDemographics_DimDemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimFactTypes_DimFactTypeId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimFactTypes_DimFactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimGradeLevels_DimGradeLevelId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimGradeLevels_DimGradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimIdeaStatuses_DimIdeaStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimIdeaStatuses_DimIdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimNOrDProgramStatuses' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimNOrDProgramStatuses] FOREIGN KEY ([NOrDProgramStatusId]) REFERENCES [RDS].[DimNOrDProgramStatuses] ([DimNOrDProgramStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimProgramStatuses_DimProgramStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimProgramStatuses_DimProgramStatusId] FOREIGN KEY ([ProgramStatusId]) REFERENCES [RDS].[DimProgramStatuses] ([DimProgramStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimCteStatuses_DimCteStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimCteStatuses_DimCteStatusId] FOREIGN KEY ([CteStatusId]) REFERENCES [RDS].[DimCteStatuses] ([DimCteStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimSchools_DimK12SchoolId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimSchools_DimK12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimStudentStatuses_DimStudentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentAssessments' )
    ALTER TABLE [RDS].[FactK12StudentAssessments] ADD CONSTRAINT [FK_FactK12StudentAssessments_DimStudentStatuses_DimStudentStatusId] FOREIGN KEY ([K12StudentStatusId]) REFERENCES [RDS].[DimK12StudentStatuses] ([DimK12StudentStatusId])

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_AttendanceId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_AttendanceId] DEFAULT ((-1)) FOR [AttendanceId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_CohortStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_CohortStatusId] DEFAULT ((-1)) FOR [CohortStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_CteStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_CteStatusId] DEFAULT ((-1)) FOR [CteStatusId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_EnrollmentId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_EnrollmentId] DEFAULT ((-1)) FOR [EnrollmentId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_EnrollmentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_EnrollmentStatusId] DEFAULT ((-1)) FOR [K12EnrollmentStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_LanguageId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_LanguageId] DEFAULT ((-1)) FOR [LanguageId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_LeaId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_LeaId] DEFAULT ((-1)) FOR [LeaId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_MigrantId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_MigrantId] DEFAULT ((-1)) FOR [MigrantId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_NorDProgramStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_NorDProgramStatusId] DEFAULT ((-1)) FOR [NorDProgramStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_RaceId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_RaceId] DEFAULT ((-1)) FOR [RaceId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_SeaId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_SeaId] DEFAULT ((-1)) FOR [SeaId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_StudentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_StudentStatusId] DEFAULT ((-1)) FOR [StudentStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_TitleIStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_TitleIStatusId] DEFAULT ((-1)) FOR [TitleIStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentCounts_TitleIIIStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_TitleIIIStatusId] DEFAULT ((-1)) FOR [TitleIIIStatusId]

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactStudentCounts' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [PK_FactStudentCounts] PRIMARY KEY CLUSTERED ([FactK12StudentCountId] ASC) WITH (DATA_COMPRESSION = PAGE)
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimAttendance' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimAttendance] FOREIGN KEY ([AttendanceId]) REFERENCES [RDS].[DimAttendance] ([DimAttendanceId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimCohortStatuses' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimCohortStatuses] FOREIGN KEY ([CohortStatusId]) REFERENCES [RDS].[DimCohortStatuses] ([DimCohortStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimSeas' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimSeas] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimIeus' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimIeus] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimEnrollment' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimEnrollment] FOREIGN KEY ([EnrollmentId]) REFERENCES [RDS].[DimEnrollments] ([DimEnrollmentId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimK12EnrollmentStatuses' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimK12EnrollmentStatuses] FOREIGN KEY ([EnrollmentStatusId]) REFERENCES [RDS].[DimK12EnrollmentStatuses] ([DimK12EnrollmentStatusId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimNOrDProgramStatuses' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimNOrDProgramStatuses] FOREIGN KEY ([NOrDProgramStatusId]) REFERENCES [RDS].[DimNOrDProgramStatuses] ([DimNOrDProgramStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_FactK12StudentCounts' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_FactK12StudentCounts] FOREIGN KEY ([FactK12StudentCountId]) REFERENCES [RDS].[FactK12StudentCounts] ([FactK12StudentCountId])

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimAges_DimAgeId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimAges_DimAgeId] FOREIGN KEY ([AgeId]) REFERENCES [RDS].[DimAges] ([DimAgeId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimSchoolYear_DimSchoolYearId' 
	--    AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
 --   ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimSchoolYear_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimDemographics_DimDemographicId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimDemographics_DimDemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimFactTypes_DimFactTypeId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimFactTypes_DimFactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimGradeLevels_DimGradeLevelId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimGradeLevels_DimGradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimIdeaStatuses_DimIdeaStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimIdeaStatuses_DimIdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimLanguages_DimLanguageId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimLanguages_DimLanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [RDS].[DimLanguages] ([DimLanguageId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimLeas_DimLeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimMigrants_DimMigrantId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimMigrants_DimMigrantId] FOREIGN KEY ([MigrantId]) REFERENCES [RDS].[DimMigrants] ([DimMigrantId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimProgramStatuses_DimProgramStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimProgramStatuses_DimProgramStatusId] FOREIGN KEY ([ProgramStatusId]) REFERENCES [RDS].[DimProgramStatuses] ([DimProgramStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimRaces_DimRaceId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimRaces_DimRaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimSchools_DimK12SchoolId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimSchools_DimK12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimStudentStatuses_DimStudentStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	--ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimStudentStatuses_DimStudentStatusId] FOREIGN KEY ([K12StudentStatusId]) REFERENCES [RDS].[DimK12StudentStatuses] ([DimK12StudentStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimTitleIStatuses_DimTitleIStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimTitleIStatuses_DimTitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimTitleIIIStatuses_DimTitleiiiStatusId' AND OBJECT_NAME(id) = 'FactK12StudentCounts' )
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [FK_FactK12StudentCounts_DimTitleIIIStatuses_DimTitleiiiStatusId] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId])

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_CteStatusId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_CteStatusId] DEFAULT ((-1)) FOR [CteStatusId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_FirearmsId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_FirearmsId] DEFAULT ((-1)) FOR [DimFirearmsId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_FirearmsDisciplineId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_FirearmsDisciplineId] DEFAULT ((-1)) FOR [DimFirearmsDisciplineId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_GradeLevelId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_GradeLevelId] DEFAULT ((-1)) FOR [DimGradeLevelId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_RaceId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_RaceId] DEFAULT ((-1)) FOR [RaceId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_SeaId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_SeaId] DEFAULT ((-1)) FOR [SeaId]
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_IeuId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_IeuId] DEFAULT ((-1)) FOR [IeuId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactK12StudentDisciplines_DisciplineId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD CONSTRAINT [DF_FactK12StudentDisciplines_DisciplineId] DEFAULT ((-1)) FOR [DisciplineId]

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactK12StudentDisciplines' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD	CONSTRAINT [PK_FactK12StudentDisciplines] PRIMARY KEY CLUSTERED ([FactK12StudentDisciplineId] ASC) WITH (DATA_COMPRESSION = PAGE)
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimSea' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimSea] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimIeus' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimIeus] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimLeas' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimLeas] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimAges_DimAgeId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimAges_DimAgeId] FOREIGN KEY ([AgeId]) REFERENCES [RDS].[DimAges] ([DimAgeId])
	
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimSchoolYears_DimSchoolYearId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimSchoolYears_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimDemographics_DimDemographicId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	--ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimDemographics_DimDemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimDisciplines_DimDisciplineId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimDisciplines_DimDisciplineId] FOREIGN KEY ([DisciplineId]) REFERENCES [RDS].[DimDisciplines] ([DimDisciplineId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimFactTypes_DimFactTypeId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimFactTypes_DimFactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimIdeaStatuses_DimIdeaStatusId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimIdeaStatuses_DimIdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimProgramStatuses_DimProgramStatusId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimProgramStatuses_DimProgramStatusId] FOREIGN KEY ([ProgramStatusId]) REFERENCES [RDS].[DimProgramStatuses] ([DimProgramStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimRaces_DimRaceId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimRaces_DimRaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimK12Schools_DimK12SchoolId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimK12Schools_DimK12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimK12Students_DimK12StudentId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimK12Students_DimK12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimK12Students] ([DimK12StudentId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimFirearms_DimFirearmsId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimFirearms_DimFirearmsId] FOREIGN KEY ([FirearmsId]) REFERENCES [RDS].[DimFirearms] ([DimFirearmsId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimFirearmDisciplines_DimFirearmsId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimFirearmDisciplines_DimFirearmsId] FOREIGN KEY ([FirearmDisciplineId]) REFERENCES [RDS].[DimFirearmDisciplines] ([DimFirearmDisciplineId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentDisciplines_DimGradeLevels_DimGradeLevelId' AND OBJECT_NAME(id) = 'FactK12StudentDisciplines' )
	ALTER TABLE [RDS].[FactK12StudentDisciplines] ADD    CONSTRAINT [FK_FactK12StudentDisciplines_DimGradeLevels_DimGradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_CharterSchoolStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolStatusId] DEFAULT ((-1)) FOR [CharterSchoolStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT [DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId] DEFAULT ((-1)) FOR [ComprehensiveAndTargetedSupportId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_OrganizationStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT [DF_FactOrganizationCounts_OrganizationStatusId] DEFAULT ((-1)) FOR [OrganizationStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_SchoolStateStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT [DF_FactOrganizationCounts_SchoolStateStatusId] DEFAULT ((-1)) FOR [SchoolStateStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_TitleIParentalInvolveRes' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT [DF_FactOrganizationCounts_TitleIParentalInvolveRes] DEFAULT ((-1)) FOR [TitleIParentalInvolveRes]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_TitleIPartAAllocations' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT [DF_FactOrganizationCounts_TitleIPartAAllocations] DEFAULT ((-1)) FOR [TitleIPartAAllocations]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_CharterSchoolApproverAgencyId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolApproverAgencyId]  DEFAULT ((-1)) FOR [CharterSchoolApproverAgencyId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_CharterSchoolManagerOrganizationId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolManagerOrganizationId]  DEFAULT ((-1)) FOR [CharterSchoolManagerOrganizationId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_CharterSchoolSecondaryApproverAgencyId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolSecondaryApproverAgencyId]  DEFAULT ((0)) FOR [CharterSchoolSecondaryApproverAgencyId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationCounts_CharterSchoolUpdatedManagerOrganizationId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolUpdatedManagerOrganizationId]  DEFAULT ((0)) FOR [CharterSchoolUpdatedManagerOrganizationId]

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactOrganizationCounts' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD	CONSTRAINT [PK_FactOrganizationCounts] PRIMARY KEY CLUSTERED ([FactOrganizationCountId] ASC) WITH (DATA_COMPRESSION = PAGE)
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimSchoolYears_DimSchoolYearId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	--ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimSchoolYears_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimFactTypes_DimFactTypeId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimFactTypes_DimFactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimK12Staff_DimK12StaffId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimK12Staff_DimK12StaffId] FOREIGN KEY ([K12StaffId]) REFERENCES [RDS].[DimK12Staff] ([DimK12StaffId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimLeas_DimLeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimSchools_DimK12SchoolId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimSchools_DimK12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimSchoolStatuses_DimSchoolStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimSchoolStatuses_DimSchoolStatusId] FOREIGN KEY ([SchoolStatusId]) REFERENCES [RDS].[DimK12SchoolStatuses] ([DimK12SchoolStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimSeas_DimSeaId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimSeas_DimSeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimTitleIStatuses_DimTitleIStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts' )
	ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [FK_FactOrganizationCounts_DimTitleIStatuses_DimTitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId])

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_DemographicId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_DemographicId] DEFAULT ((-1)) FOR [K12DemographicId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_IdeaStatusId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_IdeaStatusId] DEFAULT ((-1)) FOR [IdeaStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_IndicatorStatusTypeId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_IndicatorStatusTypeId] DEFAULT ((-1)) FOR [IndicatorStatusTypeId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_IndicatorStatusId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_IndicatorStatusId] DEFAULT ((-1)) FOR [IndicatorStatusId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_RaceId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_RaceId] DEFAULT ((-1)) FOR [RaceId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_StateDefinedCustomIndicatorId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_StateDefinedCustomIndicatorId] DEFAULT ((-1)) FOR [StateDefinedCustomIndicatorId]
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF_FactOrganizationStatusCounts_StateDefinedStatusId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD CONSTRAINT [DF_FactOrganizationStatusCounts_StateDefinedStatusId] DEFAULT ((-1)) FOR [StateDefinedStatusId]

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactOrganizationStatusCount' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD 	CONSTRAINT [PK_FactOrganizationStatusCount] PRIMARY KEY CLUSTERED ([FactOrganizationStatusCountId] ASC) WITH (DATA_COMPRESSION = PAGE)
	--IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimSchoolYears_DimSchoolYearId' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	--ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolYears_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([SchoolYearId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimK12Demographics' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimK12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimFactTypes' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimFactTypes] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimIdeaStatuses' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimIdeaStatuses] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimIndicatorStatuses' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimIndicatorStatuses] FOREIGN KEY ([IndicatorStatusId]) REFERENCES [RDS].[DimIndicatorStatuses] ([DimIndicatorStatusId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimIndicatorStatusTypes' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimIndicatorStatusTypes] FOREIGN KEY ([IndicatorStatusTypeId]) REFERENCES [RDS].[DimIndicatorStatusTypes] ([DimIndicatorStatusTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimRaces' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimSchools' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchools] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators] FOREIGN KEY ([StateDefinedCustomIndicatorId]) REFERENCES [RDS].[DimStateDefinedCustomIndicators] ([DimStateDefinedCustomIndicatorId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimStateDefinedStatuses' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts' )
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD     CONSTRAINT [FK_FactOrganizationStatusCounts_DimStateDefinedStatuses] FOREIGN KEY ([StateDefinedStatusId]) REFERENCES [RDS].[DimStateDefinedStatuses] ([DimStateDefinedStatusId])


	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimSchoolYears_DimSchoolYearId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance' )
	ALTER TABLE [RDS].[FactK12StudentAttendance] ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimSchoolYears_DimSchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimDemographics_DimDemographicId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance' )
	ALTER TABLE [RDS].[FactK12StudentAttendance] ADD     CONSTRAINT [FK_FactK12StudentAttendance_DimDemographics_DimDemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimFactTypes_DimFactTypeId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance' )
	ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimFactTypes_DimFactTypeId] FOREIGN KEY([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimDemographics_DimDemographicId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance' )
	ALTER TABLE [RDS].[FactK12StudentAttendance] ADD     CONSTRAINT [FK_FactK12StudentAttendance_DimDemographics_DimDemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId])
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimSeas_DimSeaId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance' )
	ALTER TABLE [RDS].[FactK12StudentAttendance] ADD     CONSTRAINT [FK_FactK12StudentAttendance_DimSeas_DimSeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId])

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactK12ProgramParticipations')
	CREATE TABLE [RDS].[FactK12ProgramParticipations] (
        [FactK12ProgramParticipationId]        BIGINT IDENTITY (1, 1) NOT NULL,
        [SchoolYearId]                   INT    NOT NULL,
        [DateId]                         INT    NOT NULL,
        [DataCollectionId]               INT    NOT NULL,
        [SeaId]                          INT    NOT NULL,
        [IeuId]                          INT    NOT NULL,
        [LeaID]                          INT    NOT NULL,
        [K12SchoolId]                    INT    NOT NULL,
        [K12ProgramTypeId]               INT    NOT NULL,
        [K12StudentId]                   INT    NOT NULL,
        [K12DemographicId]               INT    NOT NULL,
        [IdeaStatusId]                   INT    NOT NULL,
        [EntryDateId]                    INT    NOT NULL,
        [ExitDateId]                     INT    NOT NULL,
        [StudentCount] INT NOT NULL DEFAULT 1, 
        CONSTRAINT [PK_FactK12ProgramParticipation] PRIMARY KEY CLUSTERED ([FactK12ProgramParticipationId] ASC) WITH (DATA_COMPRESSION = PAGE),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimCollections] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimIdeaStatuses] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimIeus] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimLeas] FOREIGN KEY ([LeaID]) REFERENCES [RDS].[DimLeas] ([DimLeaId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimK12Schools] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimK12Students] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimK12Students] ([DimK12StudentId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimK12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimK12ProgramTypes] FOREIGN KEY ([K12ProgramTypeId]) REFERENCES [RDS].[DimK12ProgramTypes] ([DimK12ProgramTypeId]),
        CONSTRAINT [FK_FactK12ProgramParticipations_DimSchoolYears] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
        );

		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactK12StudentCourseSections')
		CREATE TABLE [RDS].[FactK12StudentCourseSections] (
			[FactK12StudentCourseSectionId] BIGINT IDENTITY (1, 1) NOT NULL,
			[SchoolYearId]        INT    NOT NULL,
			[DataCollectionId]    INT    NOT NULL,
			[IeuId]               INT    NOT NULL,
			[LeaID]               INT    NOT NULL,
			[K12SchoolId]         INT    NOT NULL,
			[K12StudentId]        INT    NOT NULL,
			[K12DemographicId]    INT    NOT NULL,
			[K12CourseId]         INT    NOT NULL,
			[K12CourseStatusId]   INT    NOT NULL,
			[ScedCodeId]          INT    NOT NULL,
			[CipCodeId]           INT    NOT NULL,
			[LanguageId]          INT    NOT NULL,
			[DateId]              INT    NOT NULL,
			[GradeLevelId]        INT    NOT NULL,
			[StudentCourseSectionCount] INT NOT NULL DEFAULT 1, 
			CONSTRAINT [PK_FactK12StudentCourseSection] PRIMARY KEY CLUSTERED ([FactK12StudentCourseSectionId] ASC) WITH (DATA_COMPRESSION = PAGE),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimCollection] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimK12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimGradeLevels] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimIeus] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimK12Courses] FOREIGN KEY ([K12CourseId]) REFERENCES [RDS].[DimK12Courses] ([DimK12CourseId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimK12CourseStatuses] FOREIGN KEY ([K12CourseStatusId]) REFERENCES [RDS].[DimK12CourseStatuses] ([DimK12CourseStatusId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimK12Schools] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimLanguages] FOREIGN KEY ([LanguageId]) REFERENCES [RDS].[DimLanguages] ([DimLanguageId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimLeas] FOREIGN KEY ([LeaID]) REFERENCES [RDS].[DimLeas] ([DimLeaID]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimScedCodes] FOREIGN KEY ([ScedCodeId]) REFERENCES [RDS].[DimScedCodes] ([DimScedCodeId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimCipCodes] FOREIGN KEY ([CipCodeId]) REFERENCES [RDS].[DimCipCodes] ([DimCipCodeId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimSchoolYears] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
			CONSTRAINT [FK_FactK12StudentCourseSection_DimStudents] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimK12Students] ([DimK12StudentId])
		);

		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactK12StudentEnrollments')
		CREATE TABLE [RDS].[FactK12StudentEnrollments] (
			[FactK12StudentEnrollmentId]       BIGINT IDENTITY (1, 1) NOT NULL,
			[SchoolYearId]                     INT    NOT NULL,
			[DataCollectionId]                 INT    NOT NULL,
			[SeaId]                            INT    NOT NULL,
			[IeuId]                            INT    NOT NULL,
			[LeaID]                            INT    NOT NULL,
			[K12SchoolId]                      INT    NOT NULL,
			[K12StudentId]                     INT    NOT NULL,
			[K12EnrollmentStatusId]            INT    NOT NULL,
			[EntryGradeLevelId]                INT    NOT NULL,
			[ExitGradeLevelId]                 INT    NOT NULL,
			[EntryDateId]                      INT    NOT NULL,
			[ExitDateId]                       INT    NOT NULL,
			[ProjectedGraduationDateId]        INT    NOT NULL,
			[K12DemographicId]                 INT    NOT NULL,
			[IdeaStatusId]                     INT    NOT NULL,
			[StudentCount]					   INT    NOT NULL DEFAULT 1, 
			CONSTRAINT [PK_FactK12StudentEnrollments] PRIMARY KEY CLUSTERED ([FactK12StudentEnrollmentId] ASC) WITH (DATA_COMPRESSION = PAGE),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimCollection] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimEntryDates] FOREIGN KEY ([EntryDateId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimEntryGradeLevels] FOREIGN KEY ([EntryGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimExitDates] FOREIGN KEY ([ExitDateId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimExitGradeLevels] FOREIGN KEY ([ExitGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimProjectedGraduationDates] FOREIGN KEY ([ProjectedGraduationDateId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimIdeaStatuses] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimIeus] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimK12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimK12EnrollmentStatuses] FOREIGN KEY ([K12EnrollmentStatusId]) REFERENCES [RDS].[DimK12EnrollmentStatuses] ([DimK12EnrollmentStatusId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimK12Schools] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimK12Students] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimK12Students] ([DimK12StudentId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimLeas] FOREIGN KEY ([LeaID]) REFERENCES [RDS].[DimLeas] ([DimLeaID]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimSchoolYears] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
			CONSTRAINT [FK_FactK12StudentEnrollments_DimSeas] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId])
		);

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactPsStudentAcademicAwards')
	CREATE TABLE [RDS].[FactPsStudentAcademicAwards] (
		[FactPsStudentAcademicAwardId] INT IDENTITY (1, 1) NOT NULL,
		[PsInstitutionID]              INT NOT NULL,
		[PsStudentId]                  INT NOT NULL,
		[AcademicAwardDateId]          INT NOT NULL,
		[PsAcademicAwardStatusId]      INT NOT NULL,
		[StudentCount] INT NOT NULL, 
		CONSTRAINT [PK_FactPsStudentAcademicAwards] PRIMARY KEY CLUSTERED ([FactPsStudentAcademicAwardId] ASC) WITH (DATA_COMPRESSION = PAGE),
		CONSTRAINT [FK_FactPsStudentAcademicAwards_DimAcademicAwardDates] FOREIGN KEY ([AcademicAwardDateId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
		CONSTRAINT [FK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus] FOREIGN KEY ([PsAcademicAwardStatusId]) REFERENCES [RDS].[DimPsAcademicAwardStatuses] ([DimPsAcademicAwardStatusId]),
		CONSTRAINT [FK_FactPsStudentAcademicAwards_DimPsInstitutions] FOREIGN KEY ([PsInstitutionID]) REFERENCES [RDS].[DimPsInstitutions] ([DimPsInstitutionID]),
		CONSTRAINT [FK_FactPsStudentAcademicAwards_DimPsStudents] FOREIGN KEY ([PsStudentId]) REFERENCES [RDS].[DimPsStudents] ([DimPsStudentId])
	);

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactPsStudentAcademicRecords')
	CREATE TABLE [RDS].[FactPsStudentAcademicRecords] (
		[FactPsStudentAcademicRecordId]          BIGINT         IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                           INT            NOT NULL,
		[AcademicTermDesignatorId]				 INT            NOT NULL,
		[SeaId]                                  INT            NOT NULL,
		[PsInstitutionID]                        INT            NOT NULL,
		[PsStudentId]                            INT            NOT NULL,
		[PsInstitutionStatuseId]                 INT            NOT NULL,
		[PsEnrollmentStatusId]                   BIGINT         NOT NULL,
		[DataCollectionId]                       INT            NOT NULL,
		[GradePointAverage]                      DECIMAL (5, 4) NOT NULL,
		[GradePointAverageCumulative]            DECIMAL (5, 4) NOT NULL,
		[DualCreditDualEnrollmentCreditsAwarded] DECIMAL (4, 2) NOT NULL,
		[AdvancePlacementsCreditsAwarded]        INT            NOT NULL,
		[CourseTotal]                            INT            NOT NULL,
		[StudentCourseCount] INT NOT NULL DEFAULT 1, 
		CONSTRAINT [PK_FactPsStudentAcademicRecords] PRIMARY KEY CLUSTERED ([FactPsStudentAcademicRecordId] ASC) WITH (DATA_COMPRESSION = PAGE),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimCollections] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimSchoolYears] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimAcademicTermDesignatorId] FOREIGN KEY ([AcademicTermDesignatorId]) REFERENCES [RDS].[DimAcademicTermDesignators] ([DimAcademicTermDesignatorId]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses] FOREIGN KEY ([PsEnrollmentStatusId]) REFERENCES [RDS].[DimPsEnrollmentStatuses] ([DimPsEnrollmentStatusId]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsInstitutions] FOREIGN KEY ([PsInstitutionID]) REFERENCES [RDS].[DimPsInstitutions] ([DimPsInstitutionID]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses] FOREIGN KEY ([PsInstitutionStatuseId]) REFERENCES [RDS].[DimPsInstitutionStatuses] ([DimPsInstitutionStatusId]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsStudents] FOREIGN KEY ([PsStudentId]) REFERENCES [RDS].[DimPsStudents] ([DimPsStudentId]),
		CONSTRAINT [FK_FactPsStudentAcademicRecords_DimSeas] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId])
	);

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'FactPsStudentEnrollments')
	CREATE TABLE [RDS].[FactPsStudentEnrollments] (
		[FactPsStudentEnrollmentId]     BIGINT IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                  INT    NOT NULL,
		[DataCollectionId]              INT    NOT NULL,
		[EntryDateId]                   INT    NOT NULL,
		[ExitDateId]                    INT    NOT NULL,
		[PsEnrollmentStatusId]          BIGINT NOT NULL,
		[PsInstitutionStatusId]         INT    NOT NULL,
		[PsInstitutionID]               INT    NOT NULL,
		[PsStudentId]                   INT    NOT NULL,
		[AgeId]                         INT    NOT NULL,
		[StudentCount] INT NOT NULL DEFAULT 1, 
		CONSTRAINT [PK_FactPsStudentEnrollments] PRIMARY KEY CLUSTERED ([FactPsStudentEnrollmentId] ASC) WITH (DATA_COMPRESSION = PAGE),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimAges] FOREIGN KEY ([AgeId]) REFERENCES [RDS].[DimAges] ([DimAgeId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimDataCollections] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimEntryDates] FOREIGN KEY ([EntryDateId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimExitDates] FOREIGN KEY ([ExitDateId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimPsEnrollmentStatuses] FOREIGN KEY ([PsEnrollmentStatusId]) REFERENCES [RDS].[DimPsEnrollmentStatuses] ([DimPsEnrollmentStatusId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimPsInstitutions] FOREIGN KEY ([PsInstitutionID]) REFERENCES [RDS].[DimPsInstitutions] ([DimPsInstitutionID]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimPsInstitutionStatuses] FOREIGN KEY ([PsInstitutionStatusId]) REFERENCES [RDS].[DimPsInstitutionStatuses] ([DimPsInstitutionStatusId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimPsStudents] FOREIGN KEY ([PsStudentId]) REFERENCES [RDS].[DimPsStudents] ([DimPsStudentId]),
		CONSTRAINT [FK_FactPsStudentEnrollments_DimSchoolYears] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId])
	)

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'ReportK12PsProgramEffectiveness')
	CREATE TABLE [RDS].[ReportK12PsProgramEffectiveness]
	(
		  [ReportLevel]							NVARCHAR(20)	NOT NULL
		, [ReportCode]							NVARCHAR(20)	NOT NULL
		, [SchoolYear]							SMALLINT		NOT NULL
		, [CategorySetCode]						NVARCHAR(20)	NOT NULL
		, [PsInstitutionIdentifier]				NVARCHAR(40)	NULL
		, [PsInstitutionName]					NVARCHAR(100)	NULL
		, [K12OrganizationIdentifier]			NVARCHAR(40)	NULL
		, [K12OrganizationName]					NVARCHAR(100)	NULL
		, [ReportMeasureLabel]					NVARCHAR(100)	NULL
		, [ReportMeasure]						NVARCHAR(MAX)	NOT NULL
		, [Sex]									NVARCHAR(10)	NULL
		, [RaceEthnicity]						NVARCHAR(60)	NULL
		, [EconomicDisadvantagedStatus]			NVARCHAR(10)	NULL
		, [IdeaIndicator]						NVARCHAR(10)	NULL
		, [HomelessPrimaryNighttimeResidence]	NVARCHAR(20)	NULL
		, [MigrantStatus]						NVARCHAR(10)	NULL
		, [EnglishLearnerStatus]				NVARCHAR(10)	NULL
	)

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'ReportPsAttainment')
	CREATE TABLE [RDS].[ReportPsAttainment]
	(
		[ReportLevel] [nvarchar](20) NOT NULL,
		[ReportCode] [nvarchar](20) NOT NULL,
		[SchoolYear] [smallint] NULL,
		[CategorySetCode] [nvarchar](20) NOT NULL,
		[PsInstitutionIdentifier] [nvarchar](40) NULL,
		[PsInstitutionName] [nvarchar](100) NULL,
		[ReportMeasureLabel] [nvarchar](100) NULL,
		[ReportMeasure] [nvarchar](max) NOT NULL,
		[AcademicAwardYear] [smallint] NULL,
		[AgeRange] [nvarchar](20) NULL,
		[CumulativeCreditsEarnedRange] [nvarchar](20) NULL,
		[Earned24CreditsFirst12Months] [nvarchar](20) NULL,
		[EconomicDisadvantageStatus] [nvarchar](20) NULL,
		[EnglishLearnerStatus] [nvarchar](20) NULL,
		[EnrolledFirstToSecondFall] [nvarchar](20) NULL,
		[HomelessnessStatus] [nvarchar](20) NULL,
		[IdeaIndicator] [nvarchar](20) NULL,
		[MigrantStatus] [nvarchar](20) NULL,
		[	] [nvarchar](20) NULL,
		[PescAwardLevelTypeDescription] [nvarchar](100) NULL,
		[RaceEthnicity] [nvarchar](60) NULL,
		[RemedialSession] [nvarchar](20) NULL,
		[Sex] [nvarchar](20) NULL,
		[SchoolYearExitedFromHS] [smallint] NULL
	)

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeK12AssessmentRaces')
    CREATE TABLE [RDS].[BridgeK12AssessmentRaces] (
    [BridgeK12AssessmentRaceId] INT IDENTITY (1, 1) NOT NULL,
    [FactStudentAssessmentId]   INT NULL,
    [RaceId]                 INT NULL,
    CONSTRAINT [PK_BridgeK12AssessmentRaces] PRIMARY KEY CLUSTERED ([BridgeK12AssessmentRaceId] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BridgeK12AssessmentRaces_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]),
    CONSTRAINT [FK_BridgeK12AssessmentRaces_FactK12StudentAssessments] FOREIGN KEY ([FactStudentAssessmentId]) 
    REFERENCES [RDS].[FactK12StudentAssessments] ([FactK12StudentAssessmentId])
);

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeK12StudentCourseSectionRace')
    CREATE TABLE [RDS].[BridgeK12StudentCourseSectionRace] (
    [BridgeK12StudentCourseSectionRaceId] INT    NOT NULL,
    [RaceId]					   INT    NULL,
    [FactK12StudentCourseSectionId]           BIGINT NULL,
    CONSTRAINT [PK_BridgeK12StudentCourseSectionRace] PRIMARY KEY CLUSTERED ([BridgeK12StudentCourseSectionRaceId] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_DimRace] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]),
    CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSection] FOREIGN KEY ([FactK12StudentCourseSectionId]) REFERENCES [RDS].[FactK12StudentCourseSections] ([FactK12StudentCourseSectionId])
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeK12ProgramParticipationRaces')
    CREATE TABLE [RDS].[BridgeK12ProgramParticipationRaces] (
    [BridgeK12ProgramParticipationId] BIGINT IDENTITY (1, 1),
    [FactK12ProgramParticipationId]   BIGINT NOT NULL,
    [RaceId]                       INT    NOT NULL,
    CONSTRAINT [PK_BridgeK12ProgramParticipations] PRIMARY KEY CLUSTERED ([BridgeK12ProgramParticipationId] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]),
    CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations] FOREIGN KEY ([FactK12ProgramParticipationId]) REFERENCES [RDS].[FactK12ProgramParticipations] ([FactK12ProgramParticipationId])
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeK12StudentEnrollmentRaces')
    CREATE TABLE [RDS].[BridgeK12StudentEnrollmentRaces] (
    [BridgeK12StudentEnrollmentRaceId] BIGINT IDENTITY(1, 1),
    [FactK12StudentEnrollmentId]       BIGINT NULL,
    [RaceId]                           INT    NULL,
    CONSTRAINT [PK_BridgeK12StudentEnrollmentRaces] PRIMARY KEY CLUSTERED ([BridgeK12StudentEnrollmentRaceId] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]),
    CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments] FOREIGN KEY ([FactK12StudentEnrollmentId]) REFERENCES [RDS].[FactK12StudentEnrollments] ([FactK12StudentEnrollmentId])
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgePsStudentEnrollmentRaces')
    CREATE TABLE [RDS].[BridgePsStudentEnrollmentRaces] (
    [BridgePsStudentEnrollmentRaceId] BIGINT IDENTITY (1, 1) NOT NULL,
    [FactPsStudentEnrollmentId]       BIGINT NULL,
    [RaceId]                          INT    NULL,
    CONSTRAINT [PK_BridgePsStudentEnrollmentRaces] PRIMARY KEY CLUSTERED ([BridgePsStudentEnrollmentRaceId] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]),
    CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments] FOREIGN KEY ([FactPsStudentEnrollmentId]) REFERENCES [RDS].[FactPsStudentEnrollments] ([FactPsStudentEnrollmentId])
    );

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeK12StudentCourseSectionK12Staff')
    CREATE TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] (
    [BridgeK12StudentCourseSectionK12StaffId] INT    NOT NULL,
    [K12StaffId]					   INT    NULL,
    [FactK12StudentCourseSectionId]           BIGINT NULL,
    [TeacherOfRecord]                  BIT    NULL,
    CONSTRAINT [PK_BridgeK12StudentCourseSectionK12Staff] PRIMARY KEY CLUSTERED ([BridgeK12StudentCourseSectionK12StaffId] ASC) WITH (DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff] FOREIGN KEY ([K12StaffId]) REFERENCES [RDS].[DimK12Staff] ([DimK12StaffId]),
    CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection] FOREIGN KEY ([FactK12StudentCourseSectionId]) REFERENCES [RDS].[FactK12StudentCourseSections] ([FactK12StudentCourseSectionId])
);


    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId' 
	    AND OBJECT_NAME(id) = 'BridgeLeaGradeLevels' )
    ALTER TABLE [RDS].[BridgeLeaGradeLevels] ADD CONSTRAINT [FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId] 
    FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeLeaGradeLevels_DimLeas_DimLeaId' 
	    AND OBJECT_NAME(id) = 'BridgeLeaGradeLevels' )
    ALTER TABLE [RDS].[BridgeLeaGradeLevels] ADD CONSTRAINT [FK_BridgeLeaGradeLevels_DimLeas_DimLeaId] 
    FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID])

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeK12SchoolGradeLevels_DimGradeLevels_DimGradeLevelId' 
	    AND OBJECT_NAME(id) = 'BridgeK12SchoolGradeLevels' )
    ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] ADD CONSTRAINT [FK_BridgeK12SchoolGradeLevels_DimGradeLevels_DimGradeLevelId] 
    FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeK12SchoolGradeLevels_DimK12Schools_DimK12SchoolId' 
	    AND OBJECT_NAME(id) = 'BridgeK12SchoolGradeLevels' )
    ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] ADD CONSTRAINT [FK_BridgeK12SchoolGradeLevels_DimK12Schools_DimK12SchoolId] 
    FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId])

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_ReportEDFactsK12StaffCounts' AND OBJECT_NAME(id) = 'ReportEDFactsK12StaffCounts' )
	ALTER TABLE [RDS].[ReportEDFactsK12StaffCounts] ADD  CONSTRAINT [PK_ReportEDFactsK12StaffCounts] PRIMARY KEY CLUSTERED ([ReportEDFactsK12StaffCountId] ASC) WITH (DATA_COMPRESSION = PAGE)
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_ReportEDFactsK12StudentCounts' AND OBJECT_NAME(id) = 'ReportEDFactsK12StudentCounts' )
	ALTER TABLE [RDS].[ReportEDFactsK12StudentCounts] ADD CONSTRAINT [PK_ReportEDFactsK12StudentCounts] PRIMARY KEY CLUSTERED ([ReportEDFactsK12StudentCountId] ASC) WITH (DATA_COMPRESSION = PAGE)
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_FactStudentAssessmentReports' AND OBJECT_NAME(id) = 'FactK12StudentAssessmentReports' )
	ALTER TABLE [RDS].[FactK12StudentAssessmentReports] ADD CONSTRAINT [PK_FactStudentAssessmentReports] PRIMARY KEY CLUSTERED ([FactK12StudentAssessmentReportId] ASC) WITH (DATA_COMPRESSION = PAGE)
	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_ReportEDFactsK12StudentCounts' AND OBJECT_NAME(id) = 'ReportEDFactsK12StudentCounts' )
	ALTER TABLE [RDS].[ReportEDFactsK12StudentCounts] ADD CONSTRAINT [PK_ReportEDFactsK12StudentCounts] PRIMARY KEY CLUSTERED ([ReportEDFactsK12StudentCountId] ASC) WITH (DATA_COMPRESSION = PAGE)

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimSchoolYears')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimSchoolYears]
    ON [RDS].[FactPsStudentEnrollments]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimPsStudents')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimPsStudents]
		ON [RDS].[FactPsStudentEnrollments]([PsStudentId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimPsInstitutionStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimPsInstitutionStatuses]
		ON [RDS].[FactPsStudentEnrollments]([PsInstitutionStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimPsInstitutions')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimPsInstitutions]
		ON [RDS].[FactPsStudentEnrollments]([PsInstitutionID] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimPsEnrollmentStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimPsEnrollmentStatuses]
		ON [RDS].[FactPsStudentEnrollments]([PsEnrollmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimDates_ExitDate')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimDates_ExitDate]
		ON [RDS].[FactPsStudentEnrollments]([ExitDateId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimDates_EntryDate')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimDates_EntryDate]
		ON [RDS].[FactPsStudentEnrollments]([EntryDateId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimDataCollections')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimDataCollections]
		ON [RDS].[FactPsStudentEnrollments]([DataCollectionId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentEnrollments_DimAges')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DimAges]
    ON [RDS].[FactPsStudentEnrollments]([AgeId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimAcademicTermDesignators')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimAcademicTermDesignators]
    ON [RDS].[FactPsStudentAcademicRecords]([AcademicTermDesignatorId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimSchoolYears')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimSchoolYears]
		ON [RDS].[FactPsStudentAcademicRecords]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses]
		ON [RDS].[FactPsStudentAcademicRecords]([PsInstitutionStatuseId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimPsInstitutions')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimPsInstitutions]
		ON [RDS].[FactPsStudentAcademicRecords]([PsInstitutionID] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses]
		ON [RDS].[FactPsStudentAcademicRecords]([PsEnrollmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	--IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimDates')
	--CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimDates]
	--	ON [RDS].[FactPsStudentAcademicRecords]([DateId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimCollections')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimCollections]
		ON [RDS].[FactPsStudentAcademicRecords]([DataCollectionId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimSeas')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimSeas]
		ON [RDS].[FactPsStudentAcademicRecords]([SeaId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicRecords_DimPsStudents')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DimPsStudents]
		ON [RDS].[FactPsStudentAcademicRecords]([PsStudentId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicAwards_DimPsStudents')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_DimPsStudents]
    ON [RDS].[FactPsStudentAcademicAwards]([PsStudentId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicAwards_DimPsInstitutions')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_DimPsInstitutions]
		ON [RDS].[FactPsStudentAcademicAwards]([PsInstitutionID] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus]
		ON [RDS].[FactPsStudentAcademicAwards]([PsAcademicAwardStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactPsStudentAcademicAwards_DimAcademicAwardDates')
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_DimAcademicAwardDates]
		ON [RDS].[FactPsStudentAcademicAwards]([AcademicAwardDateId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StaffCounts_DimTitleIIIStatuses')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_DimTitleIIIStatuses]
    ON [RDS].[FactK12StaffCounts]([TitleIIIStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StaffCounts_DimK12StaffCateries_DimK12StaffCategoryId')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_DimK12StaffCateries_DimK12StaffCategoryId]
    ON [RDS].[FactK12StaffCounts]([K12StaffCategoryId] ASC) WITH (DATA_COMPRESSION = PAGE);


	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StaffCounts_DimSchoolYears_DimSchoolYearId')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_DimSchoolYears_DimSchoolYearId]
    ON [RDS].[FactK12StaffCounts]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StaffCounts_DimK12Staff_DimK12Staffid')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_DimK12Staff_DimK12Staffid]
    ON [RDS].[FactK12StaffCounts]([K12StaffId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId]
    ON [RDS].[FactK12StaffCounts]([K12StaffStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StaffCounts_DimK12School_DimK12SchoolId')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_DimK12School_DimK12SchoolId]
    ON [RDS].[FactK12StaffCounts]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimStudents')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimStudents]
        ON [RDS].[FactK12ProgramParticipations]([K12StudentId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimSchoolYears')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimSchoolYears]
        ON [RDS].[FactK12ProgramParticipations]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimK12Schools')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimK12Schools]
        ON [RDS].[FactK12ProgramParticipations]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimK12ProgramTypes')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimK12ProgramTypes]
        ON [RDS].[FactK12ProgramParticipations]([K12ProgramTypeId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimLeas')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimLeas]
        ON [RDS].[FactK12ProgramParticipations]([LeaID] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimK12Demographics')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimK12Demographics]
        ON [RDS].[FactK12ProgramParticipations]([K12DemographicId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimIeus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimIeus]
        ON [RDS].[FactK12ProgramParticipations]([IeuId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimIdeaStatuses')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimIdeaStatuses]
        ON [RDS].[FactK12ProgramParticipations]([IdeaStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimDates')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimDates]
        ON [RDS].[FactK12ProgramParticipations]([DateId] ASC) WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12ProgramParticipations_DimCollections')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DimCollections]
        ON [RDS].[FactK12ProgramParticipations]([DataCollectionId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimTitleIIIStatuses')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimTitleIIIStatuses]
    ON [RDS].[FactK12StudentAssessments]([TitleIIIStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimLeas')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimLeas]
        ON [RDS].[FactK12StudentAssessments]([LeaId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimK12Students')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimK12Students]
        ON [RDS].[FactK12StudentAssessments]([K12StudentId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimK12Schools')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimK12Schools]
        ON [RDS].[FactK12StudentAssessments]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimIeus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimIeus]
        ON [RDS].[FactK12StudentAssessments]([IeuId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimK12Demographics')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimK12Demographics]
        ON [RDS].[FactK12StudentAssessments]([K12DemographicId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimGradeLevel')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimGradeLevel]
        ON [RDS].[FactK12StudentAssessments]([GradeLevelId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimIeaStatus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimIeaStatus]
        ON [RDS].[FactK12StudentAssessments]([IdeaStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimProgramStatus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimProgramStatus]
        ON [RDS].[FactK12StudentAssessments]([ProgramStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimAssessmentStatuses')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimAssessmentStatuses]
        ON [RDS].[FactK12StudentAssessments]([AssessmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimK12StudentStatus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimK12StudentStatus]
        ON [RDS].[FactK12StudentAssessments]([K12StudentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimNOrDProgramStatus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimNOrDProgramStatus]
        ON [RDS].[FactK12StudentAssessments]([NOrDProgramStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimCteStatus')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimCteStatus]
        ON [RDS].[FactK12StudentAssessments]([CteStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimRace')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimRace]
        ON [RDS].[FactK12StudentAssessments]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentAssessments_DimAssessment')
    CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_DimAssessment]
        ON [RDS].[FactK12StudentAssessments]([AssessmentId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactK12StudentCounts_DimSchoolYearId_DimFactTypeId')
	CREATE NONCLUSTERED INDEX [IX_FactK12StudentCounts_DimSchoolYearId_DimFactTypeId]
    ON [RDS].[FactK12StudentCounts]([SchoolYearId] ASC, [FactTypeId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimK12EnrollmentStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimK12EnrollmentStatuses]
		ON [RDS].[FactK12StudentCounts]([K12EnrollmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimAges')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimAges]
		ON [RDS].[FactK12StudentCounts]([AgeId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimSchoolYearId')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimSchoolYearId]
		ON [RDS].[FactK12StudentCounts]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimGradeLevels')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimGradeLevels]
		ON [RDS].[FactK12StudentCounts]([GradeLevelId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimIdeaStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimIdeaStatuses]
		ON [RDS].[FactK12StudentCounts]([IdeaStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimProgramStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimProgramStatuses]
		ON [RDS].[FactK12StudentCounts]([ProgramStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimK12School')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimK12School]
		ON [RDS].[FactK12StudentCounts]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimK12Students')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimK12Students]
		ON [RDS].[FactK12StudentCounts]([K12StudentId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimLanguages')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimLanguages]
		ON [RDS].[FactK12StudentCounts]([LanguageId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimMigrants')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimMigrants]
		ON [RDS].[FactK12StudentCounts]([MigrantId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimK12StudentStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimK12StudentStatuses]
		ON [RDS].[FactK12StudentCounts]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimTitleIStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimTitleIStatuses]
		ON [RDS].[FactK12StudentCounts]([TitleIStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimTitleIIIStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimTitleIIIStatuses]
		ON [RDS].[FactK12StudentCounts]([TitleIIIStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimLeas')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimLeas]
		ON [RDS].[FactK12StudentCounts]([LeaId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimAttendances')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimAttendances]
		ON [RDS].[FactK12StudentCounts]([AttendanceId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimCohortStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimCohortStatuses]
		ON [RDS].[FactK12StudentCounts]([CohortStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimNOrDProgramStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimNOrDProgramStatuses]
		ON [RDS].[FactK12StudentCounts]([NOrDProgramStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimRace')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimRace]
		ON [RDS].[FactK12StudentCounts]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCounts_DimIeus')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_DimIeus]
		ON [RDS].[FactK12StudentCounts]([IeuId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimStudents')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimStudents]
    ON [RDS].[FactK12StudentCourseSections]([K12StudentId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimSchoolYears')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimSchoolYears]
		ON [RDS].[FactK12StudentCourseSections]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimScedCodes')
	CREATE NONCLUSTERED INDEX[IXFK_FactK12StudentCourseSection_DimScedCodes]
		ON [RDS].[FactK12StudentCourseSections]([ScedCodeId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimCipCodes')
	CREATE NONCLUSTERED INDEX[IXFK_FactK12StudentCourseSection_DimCipCodes]
		ON [RDS].[FactK12StudentCourseSections]([CipCodeId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimLeas')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimLeas]
		ON [RDS].[FactK12StudentCourseSections]([LeaID] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimLanguages')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimLanguages]
		ON [RDS].[FactK12StudentCourseSections]([LanguageId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimK12Schools')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimK12Schools]
		ON [RDS].[FactK12StudentCourseSections]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimK12CourseStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimK12CourseStatuses]
		ON [RDS].[FactK12StudentCourseSections]([K12CourseStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimK12Courses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimK12Courses]
		ON [RDS].[FactK12StudentCourseSections]([K12CourseId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimIeus')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimIeus]
		ON [RDS].[FactK12StudentCourseSections]([IeuId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimGradeLevels')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimGradeLevels]
		ON [RDS].[FactK12StudentCourseSections]([GradeLevelId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	  
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimDates')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimDates]
		ON [RDS].[FactK12StudentCourseSections]([DateId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_DimCollections')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_DimCollections]
		ON [RDS].[FactK12StudentCourseSections]([DataCollectionId] ASC) WITH (DATA_COMPRESSION = PAGE);
	   	 
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentCourseSection_K12DemographicId')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSection_K12DemographicId]
		ON [RDS].[FactK12StudentCourseSections]([K12DemographicId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimK12Students')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimK12Students]
		ON [RDS].[FactK12StudentEnrollments]([K12StudentId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimSeas')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimSeas]
		ON [RDS].[FactK12StudentEnrollments]([SeaId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimSchoolYears')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimSchoolYears]
		ON [RDS].[FactK12StudentEnrollments]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimK12Schools')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimK12Schools]
		ON [RDS].[FactK12StudentEnrollments]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimLeas')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimLeas]
		ON [RDS].[FactK12StudentEnrollments]([LeaID] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimK12EnrollmentStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimK12EnrollmentStatuses]
		ON [RDS].[FactK12StudentEnrollments]([K12EnrollmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimK12Demographics')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimK12Demographics]
		ON [RDS].[FactK12StudentEnrollments]([K12DemographicId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimIeus')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimIeus]
		ON [RDS].[FactK12StudentEnrollments]([IeuId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimIdeaStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimIdeaStatuses]
		ON [RDS].[FactK12StudentEnrollments]([IdeaStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimGradeLevels')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimGradeLevels]
		ON [RDS].[FactK12StudentEnrollments]([EntryGradeLevelId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimDates_ProjectedGraduationDateId')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimDates_ProjectedGraduationDateId]
		ON [RDS].[FactK12StudentEnrollments]([ProjectedGraduationDateId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimDates_ExitDateId')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimDates_ExitDateId]
		ON [RDS].[FactK12StudentEnrollments]([ExitDateId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimDates_EntryDateId')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimDates_EntryDateId]
		ON [RDS].[FactK12StudentEnrollments]([EntryDateId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactK12StudentEnrollments_DimCollection')
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DimCollection]
		ON [RDS].[FactK12StudentEnrollments]([DataCollectionId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimK12Schools')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimK12Schools]
    ON [RDS].[FactOrganizationStatusCounts]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimSchoolYearId')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimSchoolYearId]
		ON [RDS].[FactOrganizationStatusCounts]([SchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimRace')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimRace]
		ON [RDS].[FactOrganizationStatusCounts]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimIdeaStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimIdeaStatuses]
		ON [RDS].[FactOrganizationStatusCounts]([IdeaStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimK12Demographics')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimK12Demographics]
		ON [RDS].[FactOrganizationStatusCounts]([K12DemographicId] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_IndicatorStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_IndicatorStatuses]
		ON [RDS].[FactOrganizationStatusCounts]([IndicatorStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimStateDefinedStatuses')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimStateDefinedStatuses]
		ON [RDS].[FactOrganizationStatusCounts]([StateDefinedStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators]
		ON [RDS].[FactOrganizationStatusCounts]([StateDefinedCustomIndicatorId] ASC) WITH (DATA_COMPRESSION = PAGE);
		
	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_FactOrganizationStatusCounts_DimIndicatorStatusType')
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimIndicatorStatusType]
		ON [RDS].[FactOrganizationStatusCounts]([IndicatorStatusTypeId] ASC) WITH (DATA_COMPRESSION = PAGE);

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeLeaGradeLevels_DimGradeLevels')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeLeaGradeLevels_DimGradeLevels]
        ON [RDS].[BridgeLeaGradeLevels]([GradeLevelId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeLeaGradeLevels_DimLeas')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeLeaGradeLevels_DimLeas]
        ON [RDS].[BridgeLeaGradeLevels]([LeaId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments')
        CREATE NONCLUSTERED INDEX [IXFK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]
        ON [RDS].[BridgePsStudentEnrollmentRaces]([FactPsStudentEnrollmentId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgePsStudentEnrollmentRaces_DimRaces')
        CREATE NONCLUSTERED INDEX [IXFK_BridgePsStudentEnrollmentRaces_DimRaces]
        ON [RDS].[BridgePsStudentEnrollmentRaces]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12AssessmentRaces_FactK12StudentAssessments')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12AssessmentRaces_FactK12StudentAssessments]
        ON [RDS].[BridgeK12AssessmentRaces]([FactStudentAssessmentId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12AssessmentRaces_DimRace')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12AssessmentRaces_DimRace]
        ON [RDS].[BridgeK12AssessmentRaces]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection]
        ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([FactK12StudentCourseSectionId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff]
        ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([K12StaffId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSection')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSection]
        ON [RDS].[BridgeK12StudentCourseSectionRace]([FactK12StudentCourseSectionId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12StudentCourseSectionRace_DimRace')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionRace_DimRace]
        ON [RDS].[BridgeK12StudentCourseSectionRace]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations]
        ON [RDS].[BridgeK12ProgramParticipationRaces]([FactK12ProgramParticipationId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12ProgramParticipationRaces_DimRaces')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12ProgramParticipationRaces_DimRaces]
        ON [RDS].[BridgeK12ProgramParticipationRaces]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]
        ON [RDS].[BridgeK12StudentEnrollmentRaces]([FactK12StudentEnrollmentId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12StudentEnrollmentRaces_DimRaces')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentRaces_DimRaces]
        ON [RDS].[BridgeK12StudentEnrollmentRaces]([RaceId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12SchoolGradeLevels_DimGradeLevels')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12SchoolGradeLevels_DimGradeLevels]
        ON [RDS].[BridgeK12SchoolGradeLevels]([GradeLevelId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IXFK_BridgeK12SchoolGradeLevels_DimK12Schools')
        CREATE NONCLUSTERED INDEX [IXFK_BridgeK12SchoolGradeLevels_DimK12Schools]
        ON [RDS].[BridgeK12SchoolGradeLevels]([K12SchoolId] ASC) WITH (DATA_COMPRESSION = PAGE);

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimComprehensiveSupportReasonApplicabilities' AND Type = N'U')
		BEGIN

			CREATE TABLE [RDS].[DimComprehensiveSupportReasonApplicabilities](
				[DimComprehensiveSupportReasonApplicabilityId] [int] IDENTITY(1,1) NOT NULL,
				[ComprehensiveSupportReasonApplicabilityId] [int] NULL,
				[ComprehensiveSupportReasonApplicabilityCode] [varchar](50) NULL,
				[ComprehensiveSupportReasonApplicabilityDescription] [varchar](200) NULL,
				[ComprehensiveSupportReasonApplicabilityEdFactsCode] [varchar](50) NULL,
			 CONSTRAINT [PK_DimComprehensiveSupportReasonApplicability] PRIMARY KEY CLUSTERED 
			(
				[DimComprehensiveSupportReasonApplicabilityId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimSubgroups' AND Type = N'U')
		BEGIN

		CREATE TABLE [RDS].[DimSubgroups](
			[DimSubgroupId] [int] IDENTITY(1,1) NOT NULL,
			[SubgroupId] [int] NULL,
			[SubgroupCode] [varchar](50) NULL,
			[SubgroupDescription] [varchar](200) NULL,
			[SubgroupEdFactsCode] [varchar](50) NULL,
		 CONSTRAINT [PK_DimSubgroups] PRIMARY KEY CLUSTERED 
		(
			[DimSubgroupId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		END

		/*alter FactOrganizationCounts*/
		IF NOT EXISTS(select 1 from sys.columns where name = 'DimSubGroupId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
		ALTER TABLE RDS.FactOrganizationCounts ADD DimSubgroupId int NOT NULL DEFAULT (-1);

		IF NOT EXISTS(select 1 from sys.columns where name = 'DimComprehensiveSupportReasonApplicabilityId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD [DimComprehensiveSupportReasonApplicabilityId] int NOT NULL default(-1)


		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[RDS].[FK_FactOrganizationCounts_DimComprehensiveSupportReasonApplicabilities_DimComprehensiveSupportReasonApplicabilityId]') AND parent_object_id = OBJECT_ID(N'[RDS].[FactOrganizationCounts]'))
		ALTER TABLE [RDS].[FactOrganizationCounts]  WITH NOCHECK ADD  CONSTRAINT [FK_FactOrganizationCounts_DimComprehensiveSupportReasonApplicabilities_DimComprehensiveSupportReasonApplicabilityId] FOREIGN KEY(DimComprehensiveSupportReasonApplicabilityId)
		REFERENCES [RDS].[DimComprehensiveSupportReasonApplicabilities] ([DimComprehensiveSupportReasonApplicabilityId])

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[RDS].[FK_FactOrganizationCounts_DimComprehensiveSupportReasonApplicabilities_DimComprehensiveSupportReasonApplicabilityId]') AND parent_object_id = OBJECT_ID(N'[RDS].[FactOrganizationCounts]'))
		ALTER TABLE [RDS].[FactOrganizationCounts] CHECK CONSTRAINT [FK_FactOrganizationCounts_DimComprehensiveSupportReasonApplicabilities_DimComprehensiveSupportReasonApplicabilityId]

		IF NOT EXISTS(select 1 from sys.columns where name = 'ReasonApplicabilityCode' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
		ALTER TABLE [RDS].[FactOrganizationCountReports] ADD ReasonApplicabilityCode varchar(50) NULL

		IF NOT EXISTS(select 1 from sys.columns where name = 'SubgroupCode' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
		ALTER TABLE [RDS].[FactOrganizationCountReports] ADD SubgroupCode varchar(50) NULL

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactOrganizationIndicatorStatuses' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.FactOrganizationIndicatorStatuses
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactOrganizationIndicatorStatusReports' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.FactOrganizationIndicatorStatusReports
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactOrganizationIndicatorStatusReportDtos' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.FactOrganizationIndicatorStatusReportDtos
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'ParentOrganizationName' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCountReports'))
		BEGIN
			ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD ParentOrganizationName nvarchar(1000) NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'ParentOrganizationName' AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCountReportDtos'))
		BEGIN
			ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD ParentOrganizationName nvarchar(1000) NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'AssessmentTypeAdministeredToEnglishLearnersCode' AND Object_ID = Object_ID(N'RDS.DimAssessments'))
		BEGIN
			ALTER TABLE [RDS].[DimAssessments] ADD AssessmentTypeAdministeredToEnglishLearnersCode VARCHAR(50) NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'AssessmentTypeAdministeredToEnglishLearnersDescription' AND Object_ID = Object_ID(N'RDS.DimAssessments'))
		BEGIN
			ALTER TABLE [RDS].[DimAssessments] ADD AssessmentTypeAdministeredToEnglishLearnersDescription VARCHAR(200) NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'AssessmentTypeAdministeredToEnglishLearnersEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimAssessments'))
		BEGIN
			ALTER TABLE [RDS].[DimAssessments] ADD AssessmentTypeAdministeredToEnglishLearnersEdFactsCode VARCHAR(50) NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'AssessmentTypeAdministeredToEnglishLearnersId' AND Object_ID = Object_ID(N'RDS.DimAssessments'))
		BEGIN
			ALTER TABLE [RDS].[DimAssessments] ADD AssessmentTypeAdministeredToEnglishLearnersId INT NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'AssessmentTypeAdministeredToEnglishLearners' AND Object_ID = Object_ID(N'RDS.FactK12StudentAssessmentReports'))
		BEGIN
			ALTER TABLE [RDS].[FactK12StudentAssessmentReports] ADD AssessmentTypeAdministeredToEnglishLearners VARCHAR(50) NULL
		END

		IF NOT EXISTS(select 1 from sys.columns where name = 'AssessmentTypeAdministeredToEnglishLearners' AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentAssessmentReportDtos] ADD AssessmentTypeAdministeredToEnglishLearners VARCHAR(50) NULL
		END

		        
    -- Update DimRaces to make it a conformed dimension similar to other DIM tables
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DimRaces' AND COLUMN_NAME = 'RaceEdFactsCode') BEGIN
        ALTER TABLE RDS.DimRaces ADD RaceEdFactsCode VARCHAR(100) NULL
    END
    
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DimRaces' AND COLUMN_NAME = 'DimFactTypeId') 
	BEGIN
		SET @SQL = 
		N'
		IF EXISTS (SELECT 1 FROM RDS.DimRaces WHERE RaceEdFactsCode IS NULL)
		BEGIN
        UPDATE RDS.DimRaces 
        SET RaceEdFactsCode = CASE RaceCode
                                WHEN ''AmericanIndianorAlaskaNative'' THEN ''AM7''
                                WHEN ''Asian'' THEN ''AS7''
                                WHEN ''BlackorAfricanAmerican'' THEN ''BL7''
                                WHEN ''NativeHawaiianorOtherPacificIslander'' THEN ''PI7''
                                WHEN ''White'' THEN ''WH7''
                                WHEN ''TwoorMoreRaces'' THEN ''MU7''
                                WHEN ''HI'' THEN ''HI7''
                                END

        UPDATE RDS.FactK12StudentCounts
        SET RaceId = dr2.DimRaceId
        FROM RDS.FactK12StudentCounts fsc
        JOIN RDS.DimRaces dr1
            ON fsc.RaceId = dr1.DimRaceId
        JOIN RDS.DimRaces dr2
            ON (dr1.RaceCode = dr2.RaceCode
                OR dr1.RaceCode = dr2.RaceEdFactsCode)
            AND dr2.DimFactTypeID = 1

        UPDATE RDS.BridgeK12AssessmentRaces
        SET RaceId = dr2.DimRaceId
        FROM RDS.BridgeK12AssessmentRaces basr
        JOIN RDS.DimRaces dr1
            ON basr.RaceId = dr1.DimRaceId
        JOIN RDS.DimRaces dr2
            ON (dr1.RaceCode = dr2.RaceCode
                OR dr1.RaceCode = dr2.RaceEdFactsCode)
            AND dr2.DimFactTypeID = 1

        UPDATE RDS.FactK12StudentAssessments
        SET RaceId = dr2.DimRaceId
        FROM RDS.FactK12StudentAssessments fsa
        JOIN RDS.DimRaces dr1
            ON fsa.RaceId = dr1.DimRaceId
        JOIN RDS.DimRaces dr2
            ON (dr1.RaceCode = dr2.RaceCode
                OR dr1.RaceCode = dr2.RaceEdFactsCode)
            AND dr2.DimFactTypeID = 1

        UPDATE RDS.FactK12StudentDisciplines
        SET RaceId = dr2.DimRaceId
        FROM RDS.FactK12StudentDisciplines fsd
        JOIN RDS.DimRaces dr1
            ON fsd.RaceId = dr1.DimRaceId
        JOIN RDS.DimRaces dr2
            ON (dr1.RaceCode = dr2.RaceCode
                OR dr1.RaceCode = dr2.RaceEdFactsCode)
            AND dr2.DimFactTypeID = 1

        UPDATE RDS.FactOrganizationStatusCounts
        SET RaceId = dr2.DimRaceId
        FROM RDS.FactOrganizationStatusCounts fosc
        JOIN RDS.DimRaces dr1
            ON fosc.RaceId = dr1.DimRaceId
        JOIN RDS.DimRaces dr2
            ON (dr1.RaceCode = dr2.RaceCode
                OR dr1.RaceCode = dr2.RaceEdFactsCode)
            AND dr2.DimFactTypeID = 1

        UPDATE RDS.DimRaces SET RaceCode = ''HispanicorLatinoEthnicity'' WHERE RaceCode = ''HI''

        DELETE FROM RDS.DimRaces WHERE DimFactTypeId > 1

        DROP INDEX IX_DimRaces_DimFactTypeId ON RDS.DimRaces;

        ALTER TABLE RDS.DimRaces DROP CONSTRAINT FK_DimRaces_DimFactTypes_DimFactTypeId;

        ALTER TABLE RDS.DimRaces DROP COLUMN DimFactTypeId
		END'
        
    END
        
    EXEC sp_executesql @SQL

	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReportEDFactsK12StudentCounts' AND COLUMN_NAME = 'DIPLOMACREDENTIALTYPE')
		EXEC sp_rename 'RDS.ReportEDFactsK12StudentCounts.DIPLOMACREDENTIALTYPE','HIGHSCHOOLDIPLOMATYPE','COLUMN';


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