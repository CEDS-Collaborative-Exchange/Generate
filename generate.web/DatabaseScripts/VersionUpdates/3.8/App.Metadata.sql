set nocount on
begin try
	begin transaction

			  Update app.DataMigrationTypes set DataMigrationTypeName = 'Integrated Data Store' 
			  where DataMigrationTypeCode = 'ods'

			 declare @datamigrationtypeId as int,  @dimensionTableId as int
			 select @datamigrationtypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'ods'

			 delete from app.DataMigrationTasks where DataMigrationTypeId = @datamigrationtypeId


			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_CompletelyClearDataFromODS @SchoolYear', 1, 1, N'Staging Migration - Preliminary Step 01 - Completely Clear Data From ODS', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_Organization @SchoolYear', 2, 1, N'Staging Migration - Implementation Step 01 - Organization', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_CharterSchoolManagementOrganization @SchoolYear', 3, 1, N'Staging Migration - Implementation Step 02 - Charter School Management Organization', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_OrganizationProgramType @SchoolYear', 4, 1, N'Staging Migration - Implementation Step 02 - Organization Program Type', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_PsInstitution', 5, 1, N'Staging Migration - Implementation Step 02 - PS Institution', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_OrganizationAddress', 6, 1, N'Staging Migration - Implementation Step 03 - Organization Address', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_OrganizationCalendarSession @SchoolYear', 7, 1, N'Staging Migration - Implementation Step 03 - Organization Calendar Session', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_K12Enrollment', 8, 1, N'Staging Migration - Implementation Step 06 - K12 Enrollment', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_PersonRace', 9, 1, N'Staging Migration - Implementation Step 04 - Person Race', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_PersonStatus @SchoolYear', 10, 1, N'Staging Migration - Implementation Step 05 - Person Status', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_PsStudentEnrollment @SchoolYear', 11, 1, N'Staging Migration - Implementation Step 06 - Student Enrollment', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_ProgramParticipationSpecialEducation @SchoolYear', 13, 1, N'Staging Migration - Implementation Step 07 - Program Participation - Special Education', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_Migrant @SchoolYear', 14, 1, N'Staging Migration - Implementation Step 08 - Migrant', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_ProgramParticipationTitleI @SchoolYear', 15, 1, N'Staging Migration - Implementation Step 09 - Program Participation - Title I', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_ProgramParticipationCTE @SchoolYear', 16, 1, N'Staging Migration - Implementation Step 10 - Program Participation - CTE', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_ProgramParticipationNorD @SchoolYear', 17, 1, N'Staging Migration - Implementation Step 11 - Program Participation - N or D', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_ProgramParticipationTitleIII @SchoolYear', 18, 1, N'Staging Migration - Implementation Step 12 - Program Participation - Title III', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_Discipline @SchoolYear', 19, 1, N'Staging Migration - Implementation Step 13 - Disicipline', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_K12ProgramParticipation', 20, 1, N'Staging Migration - Implementation Step 13 - K12 Program Enrollment', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_StudentCourseSection @SchoolYear', 21, 1, N'Staging Migration - Implementation Step 14 - Student Course', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_Assessment @SchoolYear', 22, 1, N'Staging Migration - Implementation Step 15 - Assessment', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_K12StaffAssignment @SchoolYear', 23, 1, N'Staging Migration - Implementation Step 16 - Staff Assignment', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_StateDefinedCustomIndicator @SchoolYear', 24, 1, N'Staging Migration - Implementation Step 17 - State Defined Custom Indicator', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_PsStudentAcademicRecord', 25, 1, N'Staging Migration - Implementation Step 20 - Student Academic Record', NULL)
			INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], [Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Migrate_StagingToIDS_PsStudentAcademicAward @SchoolYear', 26, 1, N'Staging Migration - Implementation Step 21 - Student Academic Award', NULL)

			 
 
			--RDS Migration ---
			select @datamigrationtypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'
	
			Update app.DataMigrationTasks set StoredProcedureName = 'rds.Migrate_DimK12Students' where DataMigrationTypeId = @datamigrationtypeId and StoredProcedureName = 'rds.Migrate_DimStudents'
			Update app.DataMigrationTasks set StoredProcedureName = 'rds.Migrate_DimK12Staff' where DataMigrationTypeId = @datamigrationtypeId and StoredProcedureName = 'rds.Migrate_DimPersonnel'
			Update app.DataMigrationTasks set StoredProcedureName = 'rds.Migrate_K12StaffCounts ''submission'', 0' where DataMigrationTypeId = @datamigrationtypeId and StoredProcedureName like 'rds.Migrate_PersonnelCounts%'

			Update app.FactTables set FactTableName = 'FactK12StudentCounts', FactTableIdName = 'FactK12StudentCountId',
			FactReportTableName = 'ReportEDFactsK12StudentCounts', FactReportTableIdName = 'ReportEDFactsK12StudentCountId'
			where FactTableName = 'FactStudentCounts'

			Update app.FactTables set FactTableName = 'FactK12StudentDisciplines', FactTableIdName = 'FactK12StudentDisciplineId',
			FactReportTableName = 'ReportEDFactsK12StudentDisciplines', FactReportTableIdName = 'ReportEDFactsK12StudentDisciplineId'
			where FactTableName = 'FactStudentDisciplines'

			Update app.FactTables set FactTableName = 'FactK12StudentAssessments', FactTableIdName = 'Factk12StudentAssessmentId',
			FactReportTableName = 'FactK12StudentAssessmentReports', FactReportTableIdName = 'FactK12StudentAssessmentReportId'
			where FactTableName = 'FactStudentAssessments'

			Update app.FactTables set FactTableName = 'FactK12StaffCounts', FactTableIdName = 'Factk12StaffCountId',
			FactReportTableName = 'ReportEDFactsK12StaffCounts', FactReportTableIdName = 'ReportEDFactsK12StaffCountId', FactFieldName = 'StaffFTE'
			where FactTableName = 'FactPersonnelCounts'


		  Update app.DimensionTables set DimensionTableName = 'DimK12Demographics' where DimensionTableName = 'DimDemographics'
		  Update app.DimensionTables set DimensionTableName = 'DimK12Staff' where DimensionTableName = 'DimPersonnel'
		  Update app.DimensionTables set DimensionTableName = 'DimK12StaffStatuses' where DimensionTableName = 'DimPersonnelStatuses'
		  Update app.DimensionTables set DimensionTableName = 'DimK12Schools' where DimensionTableName = 'DimSchools'
		  Update app.DimensionTables set DimensionTableName = 'DimK12Students' where DimensionTableName = 'DimStudents'
		  Update app.DimensionTables set DimensionTableName = 'DimTitleIStatuses' where DimensionTableName = 'DimTitle1Statuses'
		  Update app.DimensionTables set DimensionTableName = 'DimK12StaffCategories' where DimensionTableName = 'DimPersonnelCategories'
		  Update app.DimensionTables set DimensionTableName = 'DimK12StudentStatuses' where DimensionTableName = 'DimStudentStatuses'
		  Update app.DimensionTables set DimensionTableName = 'DimK12SchoolStatuses' where DimensionTableName = 'DimSchoolStatuses'
		  Update app.DimensionTables set DimensionTableName = 'DimTitleIIIStatuses' where DimensionTableName = 'DimTitleiiiStatuses'
		  Update app.DimensionTables set DimensionTableName = 'DimFirearmDisciplines' where DimensionTableName = 'DimFirearmsDiscipline'
		  Update app.DimensionTables set DimensionTableName = 'DimNOrDProgramStatuses' where DimensionTableName = 'DimNorDProgramStatuses'
		  Update app.DimensionTables set DimensionTableName = 'DimK12EnrollmentStatuses' where DimensionTableName = 'DimEnrollmentStatuses'

		   
  
		  Update app.Dimensions set DimensionFieldName = 'DisciplinaryActionTaken' where DimensionFieldName = 'DisciplineAction'
		  Update app.Dimensions set DimensionFieldName = 'DisciplineMethodOfChildrenWithDisabilities' where DimensionFieldName = 'DisciplineMethod'
		  Update app.Dimensions set DimensionFieldName = 'EducationalServicesAfterRemoval' where DimensionFieldName = 'EducationalServices'
		  Update app.Dimensions set DimensionFieldName = 'IdeaInterimRemovalReason' where DimensionFieldName = 'RemovalReason'
		  Update app.Dimensions set DimensionFieldName = 'IdeaInterimRemoval' where DimensionFieldName = 'RemovalType'
		  Update app.Dimensions set DimensionFieldName = 'FirearmType' where DimensionFieldName = 'Firearms'
		  Update app.Dimensions set DimensionFieldName = 'DisciplineMethodForFirearmsIncidents' where DimensionFieldName = 'FirearmsDiscipline'
		  Update app.Dimensions set DimensionFieldName = 'IdeaDisciplineMethodForFirearmsIncidents' where DimensionFieldName = 'IDEAFirearmsDiscipline'
		  Update app.Dimensions set DimensionFieldName = 'SpecialEducationExitReason' where DimensionFieldName = 'BasisOfExit'
		  Update app.Dimensions set DimensionFieldName = 'PrimaryDisabilityType' where DimensionFieldName = 'Disability'
		  Update app.Dimensions set DimensionFieldName = 'IdeaEducationalEnvironment' where DimensionFieldName = 'EducEnv'
		  Update app.Dimensions set DimensionFieldName = 'IdeaIndicator' where DimensionFieldName = 'IDEAIndicator'
		  Update app.Dimensions set DimensionFieldName = 'K12StaffClassification' where DimensionFieldName = 'StaffCategoryCCD'
		  Update app.Dimensions set DimensionFieldName = 'SpecialEducationSupportServicesCategory' where DimensionFieldName = 'StaffCategorySpecialEd'
		  Update app.Dimensions set DimensionFieldName = 'TitleIProgramStaffCategory' where DimensionFieldName = 'StaffCategoryTitle1'
		  Update app.Dimensions set DimensionFieldName = 'SpecialEducationAgeGroupTaught' where DimensionFieldName = 'AgeGroup'
		  Update app.Dimensions set DimensionFieldName = 'K12StaffClassification' where DimensionFieldName = 'PersonnelType'
		  Update app.Dimensions set DimensionFieldName = 'Iso6392Language' where DimensionFieldName = 'Language'
		  Update app.Dimensions set DimensionFieldName = 'ContinuationOfServicesReason' where DimensionFieldName = 'Continuation'
		  Update app.Dimensions set DimensionFieldName = 'ConsolidatedMepFundsStatus' where DimensionFieldName = 'MepFundsStatus'
		  Update app.Dimensions set DimensionFieldName = 'MepServicesType' where DimensionFieldName = 'MepServices'
		  Update app.Dimensions set DimensionFieldName = 'MigrantPrioritizedForServices' where DimensionFieldName = 'MigrantPriorityForServices'
		  Update app.Dimensions set DimensionFieldName = 'EligibilityStatusForSchoolFoodServiceProgram' where DimensionFieldName = 'FoodServiceEligibility'
		  Update app.Dimensions set DimensionFieldName = 'TitleIIIImmigrantParticipationStatus' where DimensionFieldName = 'ImmigrantTitleIIIProgram'
		  Update app.Dimensions set DimensionFieldName = 'Section504Status' where DimensionFieldName = 'Section504Program'
		  Update app.Dimensions set DimensionFieldName = 'TitleIInstructionalServices' where DimensionFieldName = 'Title1InstructionalServices'
		  Update app.Dimensions set DimensionFieldName = 'TitleIProgramType' where DimensionFieldName = 'Title1ProgramType'
		  Update app.Dimensions set DimensionFieldName = 'TitleISchoolStatus' where DimensionFieldName = 'Title1SchoolStatus'
		  Update app.Dimensions set DimensionFieldName = 'TitleISupportServices' where DimensionFieldName = 'Title1SupportServices'
		  Update app.Dimensions set DimensionFieldName = 'EnglishLearnerStatus' where DimensionFieldName = 'LepStatus'
		  Update app.Dimensions set DimensionFieldName = 'HomelessnessStatus' where DimensionFieldName = 'HomelessStatus'
		  Update app.Dimensions set DimensionFieldName = 'EconomicDisadvantageStatus' where DimensionFieldName = 'EcoDisStatus'
		  Update app.Dimensions set DimensionFieldName = 'MilitaryConnectedStudentIndicator' where DimensionFieldName = 'MilitaryConnectedStatus'
		  Update app.Dimensions set DimensionFieldName = 'HomelessPrimaryNighttimeResidence' where DimensionFieldName = 'HomelessNighttimeResidence'
		  Update app.Dimensions set DimensionFieldName = 'NeglectedOrDelinquentProgramType' where DimensionFieldName = 'NeglectedProgramType'
		  Update app.Dimensions set DimensionFieldName = 'HighSchoolDiplomaType' where DimensionFieldName = 'DiplomaCredentialType'

		  select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimK12EnrollmentStatuses'
		  Update app.Dimensions set DimensionTableId = @dimensionTableId 
		  where DimensionFieldName in ('AcademicOrVocationalOutcome','AcademicOrVocationalExitOutcome', 'PostSecondaryEnrollmentStatus')

		  select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimK12Students'
		  Update app.Dimensions set DimensionTableId = @dimensionTableId where DimensionFieldName in ('Sex')

		  Update app.CategorySets
          set SubmissionYear = CASE CHARINDEX('-',SubmissionYear) WHEN 0 THEN SubmissionYear ELSE CAST(SUBSTRING(SubmissionYear, 1, 4) as int) + 1 END
          from app.CategorySets

		  
		  Update app.FileSubmissions
          set SubmissionYear = CASE CHARINDEX('-',SubmissionYear) WHEN 0 THEN SubmissionYear ELSE CAST(SUBSTRING(SubmissionYear, 1, 4) as int) + 1 END
          from app.FileSubmissions

		DECLARE @factTableId AS INT

		SELECT @factTableId = FactTableId  FROM app.FactTables WHERE FactTableName = 'FactK12StudentAssessments'
		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimK12EnrollmentStatuses'

		IF NOT EXISTS(SELECT 1 from app.FactTable_DimensionTables where FactTableId = @factTableId AND DimensionTableId = @dimensionTableId)
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
		  
		SELECT @factTableId = FactTableId  FROM app.FactTables WHERE FactTableName = 'FactOrganizationCounts'

		UPDATE app.generatereports 
		SET FactTableId = @factTableId 
		WHERE reportcode = 'c212' 
		
		DELETE csc
		FROM App.[CategorySet_Categories] csc
		INNER JOIN App.CategorySets cs ON csc.CategorySetId = cs.CategorySetId
		INNER JOIN [App].[GenerateReports]  gr ON cs.GenerateReportId = gr.GenerateReportId
		WHERE ReportCode IN ('c199','c200','c201','c202','c205')
		AND SubmissionYear = '2020'

		DELETE co
		FROM [App].[CategoryOptions] co
		INNER JOIN App.CategorySets cs ON co.CategorySetId = cs.CategorySetId
		INNER JOIN [App].[GenerateReports]  gr ON cs.GenerateReportId = gr.GenerateReportId
		WHERE ReportCode IN ('c199','c200','c201','c202','c205')
		AND SubmissionYear = '2020'

		DELETE  cs
		FROM App.CategorySets cs
		INNER JOIN [App].[GenerateReports]  gr ON cs.GenerateReportId = gr.GenerateReportId
		WHERE ReportCode IN ('c199','c200','c201','c202','c205')
		AND SubmissionYear = '2020'

		/* Exclude Metadata for FS206*/
		DELETE csc
		FROM App.[CategorySet_Categories] csc
		INNER JOIN App.CategorySets cs ON csc.CategorySetId = cs.CategorySetId
		INNER JOIN [App].[GenerateReports]  gr ON cs.GenerateReportId = gr.GenerateReportId
		WHERE ReportCode IN ('c206')
		AND SubmissionYear = '2021'

		DELETE co
		FROM [App].[CategoryOptions] co
		INNER JOIN App.CategorySets cs ON co.CategorySetId = cs.CategorySetId
		INNER JOIN [App].[GenerateReports]  gr ON cs.GenerateReportId = gr.GenerateReportId
		WHERE ReportCode IN ('c206')
		AND SubmissionYear = '2021'

		DELETE  cs
		FROM App.CategorySets cs
		INNER JOIN [App].[GenerateReports]  gr ON cs.GenerateReportId = gr.GenerateReportId
		WHERE ReportCode IN ('c206')
		AND SubmissionYear = '2021'

		/* End- Exclude Metadata for FS206*/

	
		/* Populate metadata for FS202 (Category Set A1,B1,C1,D1,Tot1) */
		DECLARE @GenerateReportId AS INT
		DECLARE @reportYear AS VARCHAR(50) = '2019'
		DECLARE @reportCode AS VARCHAR(50)
		DECLARE @level AS INT

		DECLARE @fileSpecs TABLE
		(
			fileSpec NVARCHAR(10)
		)

		INSERT INTO @fileSpecs (fileSpec) VALUES ('c202')

		DECLARE @CategorySetCode TABLE 
		(
			CategorySetCode NVARCHAR(50),
			CategorySetCode1 NVARCHAR(50)
		)

		INSERT INTO @CategorySetCode 
		VALUES ('CSA','CSA1'),('CSB','CSB1'),('CSC','CSC1'),('CSD','CSD1'),('TOT','TOT1')

		DECLARE  @CatOption TABLE 
		(
			CategoryId INT,
			CategoryOptionCode NVARCHAR(50),
			CategoryOptionName NVARCHAR(500),
			CategoryOptionSequence INT,
			CategorySetId INT,
			EdFactsCategoryCodeId INT
		)
		DECLARE @CatSetID INT
		DECLARE @CatSetCode NVARCHAR(50)
		DECLARE @CatSetCode1 NVARCHAR(50)

		DECLARE report_cursor CURSOR FOR 
		SELECT r.GenerateReportId, r.reportCode 
		FROM @fileSpecs f
		INNER JOIN app.GenerateReports r ON f.fileSpec = r.ReportCode
		ORDER BY fileSpec


		OPEN report_cursor
		FETCH NEXT FROM report_cursor INTO @GenerateReportId, @reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE level_cursor CURSOR FOR 
			SELECT OrganizationLevelId FROM app.GenerateReport_OrganizationLevels
			WHERE GenerateReportId = @GenerateReportId
	
			OPEN level_cursor
			FETCH NEXT FROM level_cursor INTO @level 

			WHILE @@FETCH_STATUS = 0
			BEGIN
	
			IF(@reportCode IN ('c202'))
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM [App].[CategorySets] WHERE CategorySetCode IN ('CSA1','CSB1','CSC1','CSD1','TOT1') 
								AND GenerateReportId = @GenerateReportId 
								AND OrganizationLevelId = @level
								AND SubmissionYear = @reportYear)
				BEGIN					
					INSERT INTO [App].[CategorySets]([CategorySetCode],[CategorySetName],[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
					VALUES	('CSA1','Category Set A 1',0,@GenerateReportId,@level,@reportYear),
							('CSB1','Category Set B 1',0,@GenerateReportId,@level,@reportYear),
							('CSC1','Category Set C 1',0,@GenerateReportId,@level,@reportYear),
							('CSD1','Category Set D 1',0,@GenerateReportId,@level,@reportYear),
							('TOT1','Total of the Education Unit 1',0,@GenerateReportId,@level,@reportYear)					 
				END	

				IF EXISTS (SELECT 1 FROM [App].[CategorySets] 
							WHERE CategorySetCode IN ('CSA1','CSB1','CSC1','CSD1','TOT1') 
							AND GenerateReportId = @GenerateReportId 
							AND OrganizationLevelId = @level
							AND SubmissionYear = @reportYear)
				BEGIN
					IF NOT EXISTS (SELECT 1 FROM app.CategoryOptions co
									INNER JOIN app.CategorySets  cs ON cs.CategorySetId = co.CategorySetId
									WHERE cs.GenerateReportId = @GenerateReportId
									AND cs.SubmissionYear = @reportYear
									AND cs.CategorySetCode IN ('CSA1','CSB1','CSC1','CSD1','TOT1'))
					BEGIN

						DECLARE categoryset_cursor CURSOR FOR 
						SELECT CategorySetCode,CategorySetCode1 FROM @CategorySetCode

						OPEN categoryset_cursor
						FETCH NEXT FROM categoryset_cursor INTO @CatSetCode, @CatSetCode1

						WHILE @@FETCH_STATUS = 0
						BEGIN

							DELETE FROM @CatOption

							SELECT @CatSetID = CategorySetId 
							FROM app.CategorySets 
							WHERE GenerateReportId = @GenerateReportId 
							AND SubmissionYear = @reportYear
							AND CategorySetCode = @CatSetCode1

							INSERT INTO @CatOption
							SELECT 
								co.CategoryId,
								co.CategoryOptionCode,
								co.CategoryOptionName,
								co.CategoryOptionSequence,	
								@CatSetID,	
								0
							FROM app.CategoryOptions co
							INNER JOIN app.CategorySets  cs ON cs.CategorySetId = co.CategorySetId
							WHERE cs.GenerateReportId = @GenerateReportId
							AND cs.SubmissionYear = @reportYear
							AND cs.CategorySetCode = @CatSetCode

							INSERT INTO app.CategoryOptions
							(
								CategoryId,
								CategoryOptionCode,
								CategoryOptionName,
								CategoryOptionSequence,
								CategorySetId,
								EdFactsCategoryCodeId
							)
							SELECT 		
								CategoryId,
								CategoryOptionCode,
								CategoryOptionName,
								CategoryOptionSequence,
								CategorySetId,
								EdFactsCategoryCodeId
							FROM  @CatOption

							INSERT INTO app.CategorySet_Categories 
							(
								CategorySetId,
								CategoryId,
								GenerateReportDisplayTypeID
							)
							SELECT DISTINCT
								CategorySetId,
								CategoryId,
								NULL
							FROM  @CatOption

						FETCH NEXT FROM categoryset_cursor INTO @CatSetCode, @CatSetCode1
						END

						CLOSE categoryset_cursor
						DEALLOCATE categoryset_cursor
					END
				END
			END
			FETCH NEXT FROM level_cursor INTO @level
			END

			CLOSE level_cursor
			DEALLOCATE level_cursor
	

		FETCH NEXT FROM report_cursor INTO @GenerateReportId, @reportCode
		END

		CLOSE report_cursor
		DEALLOCATE report_cursor
		/* end script - Populate metadata for FS202 (Category Set A1,B1,C1,D1,Tot1) */
 
		INSERT INTO [RDS].[DimSchoolYearDataMigrationTypes]
           ([DimSchoolYearId]
           ,[DataMigrationTypeId]
           ,[IsSelected])
		Select sy.DimSchoolYearId, t.DimDataMigrationTypeId, 0  
		from rds.DimSchoolYears sy
		cross join rds.DimDataMigrationTypes t
		left join rds.DimSchoolYearDataMigrationTypes sydt on sy.DimSchoolYearId = sydt.DimSchoolYearId 
														   and t.DimDataMigrationTypeId = sydt.DataMigrationTypeId
		where sy.DimSchoolYearId > 0 and sydt.DataMigrationTypeId IS NULL
	
	UPDATE App.Dimensions
	SET DimensionFieldName = 'HighSchoolDiplomaType'
	WHERE DimensionFieldName = 'DiplomaCredentialType'

	IF NOT EXISTS(select 1 from app.GenerateConfigurations where GenerateConfigurationKey = 'SchoolYear')
	INSERT INTO app.GenerateConfigurations([GenerateConfigurationCategory],[GenerateConfigurationKey],[GenerateConfigurationValue])
	VALUES('TestData','SchoolYear', 2021)

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