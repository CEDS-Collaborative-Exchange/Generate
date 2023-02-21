-- Release-Specific table changes for the App schema
-- e.g. FactTables, Dimensions, DimensionTables
----------------------------------

set nocount on
begin try
 
	begin transaction
		 
		 declare @sectionTypeId as int, @questionTypeId as int, @sectionId as int, @datamigrationtypeId as int

    	  declare @reportId as int

		  Update app.DataMigrationTasks set StoredProcedureName = 'ods.Migrate_DimStudents_adhoc @SchoolYear' where DataMigrationTypeId = 1 and TaskSequence = 1
		  Update app.DataMigrationTasks set StoredProcedureName = 'ods.Migrate_DimPersonnel_adhoc @SchoolYear' where DataMigrationTypeId = 1 and TaskSequence = 2
		  Update app.DataMigrationTasks set StoredProcedureName = 'ods.Migrate_StudentRace_adhoc @SchoolYear' where DataMigrationTypeId = 1 and TaskSequence = 3
		  Update app.DataMigrationTasks set StoredProcedureName = 'ods.Migrate_Organization_adhoc @SchoolYear' where DataMigrationTypeId = 1 and TaskSequence = 4

          if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'AppUpdate' and GenerateConfigurationKey = 'DevUrl')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('AppUpdate', 'DevUrl', 'http://localhost:9001')
          end
          if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'AppUpdate' and GenerateConfigurationKey = 'TestUrl')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('AppUpdate', 'TestUrl', 'https://generate-update-test.aem-tx.com')
          end
          if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'AppUpdate' and GenerateConfigurationKey = 'StageUrl')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('AppUpdate', 'StageUrl', 'https://generate-update-stage.aem-tx.com')
          end
          if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'AppUpdate' and GenerateConfigurationKey = 'ProdUrl')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('AppUpdate', 'ProdUrl', 'https://generate-update.aem-tx.com')
          end

          if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'AppUpdate' and GenerateConfigurationKey = 'Status')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('AppUpdate', 'Status', 'OK')
          end

		    if not exists(select 1 from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'MEMBER')
			BEGIN
				INSERT INTO [App].[ToggleSectionTypes]([EmapsSurveyTypeAbbrv],[SectionTypeName],[SectionTypeSequence],[SectionTypeShortName])
				VALUES('MEMBER','Membership',4,'Membership')
			END

			select @sectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'MEMBER'

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'MEMBER')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('MEMBERPARENT','C',1400,'Membership',@sectionTypeId)
			END

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'MEMBER')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsParentSurveySectionAbbrv],[EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('MEMBERPARENT','MEMBER','C1',1401,'Membership',@sectionTypeId)
			END

			select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
			select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'MEMBER'

			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'MEMBERDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('MEMBERDTE',1401,'What is the membership count date of the state?',@questionTypeId,@sectionId)
			END

			Update app.ToggleSections set SectionTitle = 'English Learner' where EmapsSurveySectionAbbrv in ('ELASSESS','ASSESSENGLEARN')

			select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
			select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'ASSESSENGLEARN'

			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'ELDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('ELDTE',1104,'What is the english learner count date of the state?',@questionTypeId,@sectionId)
			END

			if not exists(select 1 from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'INSTPRD')
			BEGIN
				INSERT INTO [App].[ToggleSectionTypes]([EmapsSurveyTypeAbbrv],[SectionTypeName],[SectionTypeSequence],[SectionTypeShortName])
				VALUES('INSTPRD','School Year',5,'School Year')
			END

			select @sectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'INSTPRD'

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'INSTPARENT')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('INSTPARENT','D',1500,'Instructional Period',@sectionTypeId)
			END

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'INST')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsParentSurveySectionAbbrv],[EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('INSTPARENT','INST','D1',1501,'Instructional Period',@sectionTypeId)
			END

			select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
			select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'INST'

			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'INSTSTARTDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('INSTSTARTDTE',1501,'What is the instructional period start date of the state?',@questionTypeId,@sectionId)
			END
			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'INSTENDDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('INSTENDDTE',1502,'What is the instructional period end date of the state?',@questionTypeId,@sectionId)
			END

			-------------------------------------------------------------------------------------------------------------------------------

			if not exists(select 1 from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'STATESY')
			BEGIN
				INSERT INTO [App].[ToggleSectionTypes]([EmapsSurveyTypeAbbrv],[SectionTypeName],[SectionTypeSequence],[SectionTypeShortName])
				VALUES('STATESY','State School Year',6,'School Year')
			END

			select @sectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'STATESY'

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'STATESYPARENT')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('STATESYPARENT','E',1600,'State School Year',@sectionTypeId)
			END

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'STATESY')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsParentSurveySectionAbbrv],[EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('STATESYPARENT','STATESY','E1',1601,'State School Year',@sectionTypeId)
			END

			select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
			select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'STATESY'

			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'STATESYSTARTDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('STATESYSTARTDTE',1601,'What is the School Year start date defined by the state?',@questionTypeId,@sectionId)
			END
			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'STATESYENDDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('STATESYENDDTE',1602,'What is the School Year end date defined by the state?',@questionTypeId,@sectionId)
			END

			-------------------------------------------------------------------------------------------------------------------

			if not exists(select 1 from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'PYINCTIMEPRD')
			BEGIN
				INSERT INTO [App].[ToggleSectionTypes]([EmapsSurveyTypeAbbrv],[SectionTypeName],[SectionTypeSequence],[SectionTypeShortName])
				VALUES('PYINCTIMEPRD','Inclusion time period',7,'Inclusion time period')
			END

			select @sectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'PYINCTIMEPRD'

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'PYINCTIMEPRDPARENT')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('PYINCTIMEPRDPARENT','F',1700,'Inclusion time period',@sectionTypeId)
			END

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'PYINCTIMEPRD')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsParentSurveySectionAbbrv],[EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('PYINCTIMEPRDPARENT','PYINCTIMEPRD','F1',1701,'Inclusion time period',@sectionTypeId)
			END

			select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
			select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'PYINCTIMEPRD'

			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'PYINCTIMEPRDSTARTDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('PYINCTIMEPRDSTARTDTE',1701,'What is the start date of time period for inclusion in the cohort of students from the previous academic year?',@questionTypeId,@sectionId)
			END
			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'PYINCTIMEPRDENDDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('PYINCTIMEPRDENDDTE',1702,'What is the end date of time period for inclusion in the cohort of students from the previous academic year?',@questionTypeId,@sectionId)
			END

			-------------------------------------------------------------------------------------------------------------------

			if not exists(select 1 from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'IHETIMEPRD')
			BEGIN
				INSERT INTO [App].[ToggleSectionTypes]([EmapsSurveyTypeAbbrv],[SectionTypeName],[SectionTypeSequence],[SectionTypeShortName])
				VALUES('IHETIMEPRD','IHE Enrollment',8,'IHE Enrollment')
			END

			select @sectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'IHETIMEPRD'

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'IHETIMEPRDPARENT')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('IHETIMEPRDPARENT','G',1800,'IHE Enrollment',@sectionTypeId)
			END

			if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'IHETIMEPRD')
			BEGIN
				INSERT INTO [App].[ToggleSections]([EmapsParentSurveySectionAbbrv],[EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
				VALUES('IHETIMEPRDPARENT','IHETIMEPRD','G1',1801,'IHE Enrollment',@sectionTypeId)
			END

			select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
			select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'IHETIMEPRD'

			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'IHETIMEPRDSTARTDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('IHETIMEPRDSTARTDTE',1801,'What is the start date of enrollment in the IHE in the current academic	year?',@questionTypeId,@sectionId)
			END
			if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'IHETIMEPRDENDDTE')
			BEGIN
				INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
				VALUES('IHETIMEPRDENDDTE',1802,'What is the end date of enrollment in the IHE in the current academic	year?',@questionTypeId,@sectionId)
			END

			select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'

			-- populate app.DataMigrationTasks
	truncate table app.DataMigrationTasks

	--RDS Migration ---
	select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'
	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimStudents',1,'Load the base student population to DimStudents.',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimPersonnel',2,'Load the base personnel population into DimPersonnel',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationCounts ''directory'', 0',3,'Load organization data into FactOrganizationCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationStatusCounts ''organizationstatus'', 0',4,'Load organization rate data into FactOrganizationIndicatorStatusReports',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation'', ''studentcounts''',5,'Delete student count data from FactStudentCounts (datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''datapopulation'', 0',6,'Load student count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation'', ''disciplinecounts''',7,'Delete student discipline count data from FactStudentDiscipline (datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''datapopulation'', 0',8,'Load student discipline data into FactStudentDiscipline',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation'', ''studentassessments''',9,'Delete student assessment data from FactStudentAssessment (datapopulation)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''datapopulation'', 0',10,'Load student discipline data into FactStudentAssessment',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation'', ''personnelcounts''',11,'Delete personnel data from FactPersonnelCounts (datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''datapopulation'', 0',12,'Load personnel data into FactPersonnelCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentcounts''',13,'Delete student count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''submission'', 0',14,'Load student count data into FactStudentCounts',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''disciplinecounts''',15,'Delete student discipline count data from FactStudentDiscipline (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''submission'', 0',16,'Load student discipline data into FactStudentDiscipline',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentassessments''',17,'Delete student assessment data from FactStudentAssessment (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''submission'', 0',18,'Load student discipline data into FactStudentAssessment',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''personnelcounts''',19,'Delete personnel data from FactPersonnelCounts (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''submission'', 0',20,'Load personnel data into FactPersonnelCounts',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''childcount''',21,'Delete child count data from FactStudentCounts (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''childcount'', 0',22,'Load child count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''specedexit''',23,'Delete students specedexit  count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_SpecialEdStudentCounts ''specedexit'', 0',24,'Load Students specedexit count data into FactStudentCounts',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''cte''',25,'Delete CTE students count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''cte'', 0',26,'Load CTE Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''membership''',27,'Delete Membership students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''membership'', 0',28,'Load Membership Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''dropout''',29,'Delete dropout students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''dropout'', 0',30,'Load dropout Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''grad''',31,'Delete Graduaters or Completers students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''grad'', 0',32,'Load  Graduaters or Completers Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''titleIIIELOct''',33,'Delete Title III EL October students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''titleIIIELOct'', 0',34,'Load  Title III EL October Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''titleIIIELSY''',35,'Delete Title III EL SY students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''titleIIIELSY'', 0',36,'Load  Title III EL SY Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''titleI''',37,'Delete TitleI students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''titleI'', 0',38,'Load  TitleI Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''mep''',39,'Delete MEP students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''mep'', 0',40,'Load  MEP Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''immigrant''',41,'Delete Immigrant students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''immigrant'', 0',42,'Load  Immigrant Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''nord''',43,'Delete N or D students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''nord'', 0',44,'Load N or D Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''homeless''',45,'Delete Homeless students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''homeless'', 0',46,'Load Homeless Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''chronic''',47,'Delete Chronic Absenteeism students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''chronic'', 0',48,'Load Chronic Absenteeism Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''gradrate''',49,'Delete Grad Rate students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''gradrate'', 0',50,'Load Grad Rate Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''hsgradenroll''',51,'Delete HS Grad PS Enrollment students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''hsgradenroll'', 0',52,'Load HS Grad PS Enrollment Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''other''',53,'Delete Other students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''other'', 0',54,'Load Other Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''sppapr''',55,'Delete SPP/APR students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''sppapr'', 0',56,'Load SPP/APR Students count data into FactStudentCounts',1)


	
---Report Migration ------	
	select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='report'
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''directory''',1,'Delete Organization Reports (unlocked) from FactOrganizationCountReports table(datapopulation) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''directory'',0, ''organizationcounts''',2,'Create Organization Reports and Load FactorganizationReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''organizationstatus''',3,'Delete Organization Status Reports (unlocked) from FactOrganizationStatusCountReports table(datapopulation) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''organizationstatus'',0, ''organizationstatuscounts''',4,'Create Organization Status Reports and Load FactOrganizationStatusCountReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''datapopulation'', ''studentcounts''',5,'Delete Student Count Reports (unlocked) from FactStudentCountReports table(datapopulation) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''studentcounts''',6,'Create Student Count Reports and Load FactStudentCountReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''datapopulation'', ''disciplinecounts''',7,'Delete Student Discipline Reports (unlocked) from FactStudentDisciplineReports table(datapopulation) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''disciplinecounts''',8,'Create Student Discipline Reports and Load FactStudentDisciplineReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''datapopulation'', ''studentassessments''',9,'Delete Student Assessment Reports (unlocked) from FactStudentAssessmentReports table(datapopulation) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''studentassessments''',10,'Create Student Assessment Reports and Load FactStudentAssessmentReports table(datapopulation)',1)
	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''submission'', ''studentcounts''',11,'Delete Student Count Reports (unlocked) from FactStudentCountReports table(submission) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''studentcounts''',12,'Create Student Count Reports (unlocked) and Load FactStudentCountReports table(submission)',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''submission'', ''disciplinecounts''',13,'Delete Student Discipline Reports (unlocked) from FactStudentDisciplineReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''disciplinecounts''',14,'Create Student Discipline Reports (unlocked) and Load FactStudentDisciplineReports table(submission)',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''submission'', ''studentassessments''',15,'Delete Student Assessment Reports (unlocked) from FactStudentAssessmentReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''studentassessments''',16,'Create Student Assessment Reports (unlocked) and Load FactStudentAssessmentReports table(submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''submission'', ''personnelcounts''',17,'Delete Personnel Count Reports (unlocked) from FactPersonnelCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''personnelcounts''',18,'Create Personnel Count Reports (unlocked) and Load FactPersonnelCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''specedexit''',19,'Delete Students specedexit Reports (unlocked) from FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''specedexit'',0,''studentcounts''',20,'Create Students specedexit Reports (unlocked) and Load FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''cte''',21,'Delete CTE Students Reports (unlocked) from FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''cte'',0,''studentcounts''',22,'Create CTE Students Reports (unlocked) and Load FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''childcount''',23,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''childcount'',0,''studentcounts''',24,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''membership''',25,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''membership'',0,''studentcounts''',26,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''dropout''',27,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''dropout'',0,''studentcounts''',28,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''grad''',29,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''grad'',0,''studentcounts''',30,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''titleIIIELOct''',31,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''titleIIIELOct'',0,''studentcounts''',32,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''titleIIIELSY''',33,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''titleIIIELSY'',0,''studentcounts''',34,'',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''titleI''',35,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''titleI'',0,''studentcounts''',36,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''sppapr''',37,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''sppapr'',0,''studentcounts''',38,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''mep''',39,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''mep'',0,''studentcounts''',40,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''immigrant''',41,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''immigrant'',0,''studentcounts''',42,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''nord''',43,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''nord'',0,''studentcounts''',44,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''homeless''',45,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''homeless'',0,''studentcounts''',46,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''chronic''',47,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''chronic'',0,''studentcounts''',48,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''gradrate''',49,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''gradrate'',0,''studentcounts''',50,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''hsgradenroll''',51,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''hsgradenroll'',0,''studentcounts''',52,'',1)


	select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='ods'

	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,1,0,0,'ods.Migrate_DimStudents_adhoc @SchoolYear',1,1,'ODS migration 1 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,2,0,0,'ods.Migrate_DimPersonnel_adhoc @SchoolYear',2,1,'ODS migration 2 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,3,0,0,'ods.Migrate_StudentRace_adhoc @SchoolYear',3,1,'ODS migration 3 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,4,0,0,'ods.Migrate_Organization_adhoc @SchoolYear',4,1,'ODS migration 4 test stored procedure')
  
		  
			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c029'
			Update app.CategorySets set IncludeOnFilter = NULL where GenerateReportId = @reportId

			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c039'
			Update app.CategorySets set IncludeOnFilter = NULL where GenerateReportId = @reportId

			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c130'
			Update app.CategorySets set IncludeOnFilter = NULL where GenerateReportId = @reportId

			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c190'
			Update app.CategorySets set ExcludeOnFilter = NULL, IncludeOnFilter = NULL where GenerateReportId = @reportId

			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c196'
			Update app.CategorySets set ExcludeOnFilter = NULL, IncludeOnFilter = NULL where GenerateReportId = @reportId

			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c197'
			Update app.CategorySets set ExcludeOnFilter = NULL, IncludeOnFilter = NULL where GenerateReportId = @reportId

			select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c198'
			Update app.CategorySets set ExcludeOnFilter = NULL, IncludeOnFilter = NULL where GenerateReportId = @reportId


		  -- Change TestData config values

		  delete from app.GenerateConfigurations where GenerateConfigurationCategory = 'TestData'

		  if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'TestData' and GenerateConfigurationKey = 'Seed')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('TestData', 'Seed', '1000')
          end

		  if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'TestData' and GenerateConfigurationKey = 'StudentCount')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('TestData', 'StudentCount', '10000')
          end

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