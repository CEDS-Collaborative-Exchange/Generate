-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction

		declare @removalCategoryId as int, @disciplineActionCategoryId as int, @generateReportId as int, @categoryId as int, @cedsConnectionId as int, @tableTypeId as int
		declare @factTableId as int, @controlName as varchar(50), @controlTypeID as int, @generateReportTypeID as int, @dimensionId as int, @dimensionTableId as int
		declare @datamigrationtypeId as int

		select @removalCategoryId = CategoryId from app.Categories where EdFactsCategoryId = 153
		select @disciplineActionCategoryId = CategoryId from app.Categories where CategoryCode = 'DISCIPLINEACTION'

		delete co from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategorySet_Categories csc on csc.CategorySetId = cs.CategorySetId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId and co.CategoryId = csc.CategoryId
		where r.ReportCode = 'c143' and co.CategoryId in (@removalCategoryId, @disciplineActionCategoryId)

		delete csc from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategorySet_Categories csc on csc.CategorySetId = cs.CategorySetId
		where r.ReportCode = 'c143' and csc.CategoryId in (@removalCategoryId, @disciplineActionCategoryId)

		Update fc set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'StaffCategorySpecialEd')
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
		inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
		where r.ReportCode = 'c099' and fc.ColumnName = 'StaffCategoryID'

		select @factTableId = factTableId from app.FactTables where FactTableName = 'FactStudentAssessments'
		set @controlName = 'yeartoyearprogress'

		IF NOT EXISTS(select 1 from app.GenerateReportControlType where ControlTypeName = @controlName)
		BEGIN
			INSERT INTO [App].[GenerateReportControlType]([ControlTypeName]) VALUES(@controlName)
		END

		select @controlTypeID = GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName = @controlName
		select @generateReportTypeID = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'statereport'

		IF NOT EXISTS(select 1 from app.GenerateReports where ReportCode = 'yeartoyearprogress')
		BEGIN
			INSERT INTO [App].[GenerateReports]
					   ([CategorySetControlCaption]
					   ,[CategorySetControlLabel]
					   ,[FactTableId]
					   ,[FilterControlLabel]
					   ,[GenerateReportControlTypeId]
					   ,[GenerateReportTypeId]
					   ,[IsActive]
					   ,[ReportCode]
					   ,[ReportName]
					   ,[ShowCategorySetControl]
					   ,[ShowData]
					   ,[ShowFilterControl]
					   ,[ShowGraph]
					   ,[IsLocked]
					   ,[UseLegacyReportMigration])
			VALUES('Sub-population','Sub-population',@factTableId,'Assessment Academic Subject',@controlTypeID,@generateReportTypeID,1,'yeartoyearprogress','Year-to-Year Progress in Reading and Math',1,1,1,0,0,1)
		END

		set @controlName = 'yeartoyearattendance'

		IF NOT EXISTS(select 1 from app.GenerateReportControlType where ControlTypeName = @controlName)
		BEGIN
			INSERT INTO [App].[GenerateReportControlType]([ControlTypeName]) VALUES(@controlName)
		END

		select @controlTypeID = GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName = @controlName

		IF NOT EXISTS(select 1 from app.GenerateReports where ReportCode = 'yeartoyearattendance')
		BEGIN
			INSERT INTO [App].[GenerateReports]
					   ([CategorySetControlCaption]
					   ,[CategorySetControlLabel]
					   ,[FactTableId]
					   ,[GenerateReportControlTypeId]
					   ,[GenerateReportTypeId]
					   ,[IsActive]
					   ,[ReportCode]
					   ,[ReportName]
					   ,[ShowCategorySetControl]
					   ,[ShowData]
					   ,[ShowFilterControl]
					   ,[ShowGraph]
					   ,[IsLocked]
					   ,[UseLegacyReportMigration])
			VALUES('Sub-population','Sub-population',@factTableId,@controlTypeID,@generateReportTypeID,1,'yeartoyearattendance','Student Drop-out Attendance Patterns and Proficiency Levels in Math and Reading',1,1,0,0,0,1)
		END

		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimIdeaStatuses'

		IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'IDEAIndicator' and [DimensionTableId] = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('IDEAIndicator',@dimensionTableId,0,0)

			select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'IDEAIndicator'

			Update app.Category_Dimensions set DimensionId = @dimensionId where CategoryId in (select CategoryId from app.Categories where CategoryCode in ('DISABSTATIDEA','DISABSTATUS'))

			Update fc set DimensionId = @dimensionId
			from app.GenerateReports r
			inner join app.FileSubmissions fs on r.GenerateReportId = fs.GenerateReportId
			inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
			inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
			where ColumnName = 'DisabilityStatusID' and ReportCode in (select distinct ReportCode from app.GenerateReports r
			inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
			inner join app.CategorySet_Categories csc on csc.CategorySetId = cs.CategorySetId
			inner join app.Categories c on c.CategoryId = csc.CategoryId
			inner join app.Category_Dimensions cd on cd.CategoryId = c.CategoryId
			inner join app.Dimensions d on cd.DimensionId = d.DimensionId
			inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId and co.CategoryId = c.CategoryId
			where CategoryCode in ('DISABSTATIDEA','DISABSTATUS') and ReportCode not in ('c201', 'c202', 'c200', 'c199', 'c195'))
		END

		select @generateReportId = GenerateReportId from app.GenerateReports where reportcode = 'yeartoyearprogress' 

		if not exists(select 1 from app.GenerateReport_OrganizationLevels where GenerateReportId = @generateReportId)
		BEGIN
			INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId]) values (@generateReportId, 1)
			INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId]) values (@generateReportId, 2)
			INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId]) values (@generateReportId, 3)
		END

		select @generateReportId = GenerateReportId from app.GenerateReports where reportcode = 'yeartoyearattendance' 

		if not exists(select 1 from app.GenerateReport_OrganizationLevels where GenerateReportId = @generateReportId)
		BEGIN
			INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId]) values (@generateReportId, 1)
			INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId]) values (@generateReportId, 2)
			INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId]) values (@generateReportId, 3)
		END

		SELECT @categoryId = min(categoryId) from app.Categories Where CategoryCode = 'PROFSTATUS'

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'ProficiencyStatus'
		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimAssessments'

		if not exists(select 1 from app.Dimensions where DimensionFieldName = 'ProficiencyStatus' and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('ProficiencyStatus',@dimensionTableId,1,0)

			select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'ProficiencyStatus' and DimensionTableId = @dimensionTableId

			Update app.Category_Dimensions set dimensionId = @dimensionId where CategoryId = @categoryId
		END
		
		select @cedsConnectionId = CedsConnectionId from app.CedsConnections where CedsUseCaseId = 22

		Update app.GenerateReports set CategorySetControlCaption = 'Sub-population', CategorySetControlLabel = 'Sub-population', CedsConnectionId = @cedsConnectionId 
		where ReportCode = 'yeartoyearprogress'

		select @cedsConnectionId = CedsConnectionId from app.CedsConnections where CedsUseCaseId = 8

		Update app.GenerateReports set CedsConnectionId = @cedsConnectionId where ReportCode = 'yeartoyearattendance'

		select @tableTypeId = TableTypeId from app.TableTypes where TableTypeAbbrv = 'STUPARTSCI'

		Update cs set TableTypeId = @tableTypeId from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		where ReportCode in ('c189') and SubmissionYear = '2018-19'

		IF not exists(select 1 from app.FactTables where FactTableName = 'FactK12StudentAttendance')
		BEGIN
			INSERT INTO [App].[FactTables]([FactFieldName],[FactReportDtoIdName],[FactReportDtoName],[FactReportTableIdName],[FactReportTableName],[FactTableIdName],[FactTableName])
			VALUES('StudentAttendanceRate','FactK12StudentAttendanceDtoId','FactK12StudentAttendanceDto','FactK12StudentAttendanceId',
			'FactK12StudentAttendanceReports','FactK12StudentAttendanceId','FactK12StudentAttendance')
		END


		select @factTableId = factTableId from app.FactTables where FactTableName = 'FactK12StudentAttendance'
		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimAttendance'

		IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
		END

		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimDemographics'

		IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
		END

		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimAttendance'

		IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
		END

		select @datamigrationtypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'

		if not exists(select 1 from app.DataMigrationTasks where DataMigrationTypeId = @datamigrationtypeId and TaskSequence = 53)
		begin
			insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentattendance''',53,'Delete student attendance data from FactK12StudentAttendance (submission)',1)
			insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAttendance ''submission'', 0',54,'Load student attendance data into FactK12StudentAttendance',1)	
		end


		select @datamigrationtypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'

		if not exists(select 1 from app.DataMigrationTasks where TaskSequence = 53 and DataMigrationTypeId = @datamigrationtypeId)
		BEGIN
			insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_Reports ''other''',53,'',1)
			insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''other'',0,''studentcounts''',54,'',1)
		END

		select @factTableId = factTableId from app.FactTables where FactTableName = 'FactStudentAssessments'
		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimTitle1Statuses'

		IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
		END

		Update app.CategoryOptions set CategoryOptionName = 'Age 5 (Kindergarten)' where CategoryOptionCode = 'AGE05K'
		Update app.CategoryOptions set CategoryOptionName = 'Age 5 (not Kindergarten)' where CategoryOptionCode = 'AGE05NOTK'
		Update app.GenerateReports set IsActive = 0 where ReportCode = 'c207'

			   
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