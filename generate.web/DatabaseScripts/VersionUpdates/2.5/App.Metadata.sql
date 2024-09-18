-- Release-Specific table changes for the App schema
-- e.g. FactTables, Dimensions, DimensionTables
----------------------------------

set nocount on
begin try
 
	begin transaction

	declare @generateReportControlTypeId as int, @factTableId as int
	declare @reportId as int , @displayTypeID as int
	declare @previousLepId as int

	   	  	
	select @generateReportControlTypeId=GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName='c197'
	select @factTableId=FactTableId from app.FactTables where FactFieldName='OrganizationCount' 
	update app.GenerateReports set GenerateReportControlTypeId=@generateReportControlTypeId, FactTableId=@factTableId where ReportCode='c103'


	--App Metadata for C132
	if not exists (select 1 from app.GenerateReportControlType where ControlTypeName = 'c132')
	begin
		insert into app.GenerateReportControlType (ControlTypeName) values ('c132')
	end 

	update app.GenerateReports
set GenerateReportControlTypeId = (select GenerateReportControlTypeId from  app.GenerateReportControlType where  ControlTypeName = 'c132'),
	FactTableId = (Select FactTableId from app.FactTables where FactTableName = 'FactOrganizationCounts'),
	ShowCategorySetControl = 0
where ReportCode='c132'


	----------------------c118 DIMENSIONS-----------------------------------------------------------------
	declare @dimensionTableId as int, @dimensionId int, @categoryId int,  @tableTypeID INT, @generateReportId as int
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
    Update app.GenerateReports set FactTableId = @factTableId Where ReportCode = 'C118'
	
	Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimGradeLevels'


	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'GradeLevel' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) VALUES('GradeLevel',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'GradeLevel'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'AGE3TOGRADE13'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END
	ELSE
	BEGIN
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'GradeLevel'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'AGE3TOGRADE13'

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
END


Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimDemographics'

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'HomelessNighttimeResidence' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) VALUES('HomelessNighttimeResidence',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'HomelessNighttimeResidence'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'HOMELSPRMRES'

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END 
	END
	ELSE
	BEGIN
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'HomelessNighttimeResidence'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'HOMELSPRMRES'

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END 
	END

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'HomelessUnaccompaniedYouthStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) VALUES('HomelessUnaccompaniedYouthStatus',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'HomelessUnaccompaniedYouthStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'HOMELESSUNAC'

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END 
	END
	ELSE
	BEGIN
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'HomelessUnaccompaniedYouthStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'HOMELESSUNAC'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END 
	END
	---------------------c118 end-------------------------------------------------------------------

	---------------------c195 metadata----------------------------------------------------------------

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'CHRONABSE' where ReportCode = 'c195'

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'Section504Program'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'DISABSTATUS504'

	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END 

	IF NOT EXISTS(select 1 from app.DimensionTables where DimensionTableName = 'DimAttendance')
	BEGIN

		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])  VALUES('DimAttendance',1)

		select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
		Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimAttendance'

			
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
		VALUES('Attendance',@dimensionTableId, 0, 0)


		
	END


	---------------------c103-----------------------------------------------------------------------
	---------------------seed organizational level
	declare @edfactsSubmissionReportTypeId as int, @schId as int, @CategorySetId as int
	select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'	
	select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
	select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c103'
	IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='C103') and OrganizationLevelId = 3 )
	BEGIN
	INSERT into App.GenerateReport_OrganizationLevels
	(GenerateReportId,OrganizationLevelId) 
	( SELECT generatereportid, 3 from app.GenerateReports where ReportCode ='c103' )
	END
    -------------------seed categorysets	
 
	If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c103' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @schId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
	BEGIN
			INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c103' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
					,@schId, 17338, '2017-18', 'CSA', 'Category Set A' )

 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
	END

	---------------------c170-----------------------------------------------------------------------

-- PlaceHolder CategorySets for C170


	Select @generateReportId = GenerateReportId from app.GenerateReports where ReportCode ='c170'


	declare @reportYear as varchar(50)

	DECLARE submissionYear_cursor CURSOR FOR 
	select distinct SubmissionYear from rds.DimDates where SubmissionYear is not null

	OPEN submissionYear_cursor
	FETCH NEXT FROM submissionYear_cursor INTO @reportYear

	WHILE @@FETCH_STATUS = 0
	BEGIN

	
	IF Not exists (Select 1 from [App].[CategorySets] where CategorySetCode = 'CSA' and GenerateReportId = @generateReportId and OrganizationLevelId = 2 and SubmissionYear =@reportYear)
	BEGIN
	INSERT INTO [App].[CategorySets]
           ([CategorySetCode] ,[CategorySetName]   ,[CategorySetSequence] ,[EdFactsTableTypeGroupId]  ,[ExcludeOnFilter]  ,[GenerateReportId]   ,[IncludeOnFilter]   ,[OrganizationLevelId]  ,[SubmissionYear]   ,[TableTypeId]  ,[ViewDefinition])
			VALUES   ('CSA'  ,'Category Set A'   ,NULL    ,0     ,'1'      ,@GenerateReportId    ,NULL      ,2        ,@reportYear      ,NULL    ,NULL)

	END	


	

FETCH NEXT FROM submissionYear_cursor INTO @reportYear
END

close submissionYear_cursor
DEALLOCATE  submissionYear_cursor




if not exists (select 1 from app.GenerateReportControlType where ControlTypeName = 'c170')
	begin
		insert into app.GenerateReportControlType (ControlTypeName) values ('c170')
	end 

update app.GenerateReports
set GenerateReportControlTypeId = (select GenerateReportControlTypeId from  app.GenerateReportControlType where  ControlTypeName = 'c170'),
	FactTableId = (Select FactTableId from app.FactTables where FactTableName = 'FactOrganizationCounts'),
	ShowCategorySetControl = 0
where ReportCode='c170'


---------------------c170 End-----------------------------------------------------------------------

	select @generateReportControlTypeId=GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName='c197'
	select @factTableId=FactTableId from app.FactTables where FactTableName='FactOrganizationCounts' 
	update app.GenerateReports set GenerateReportControlTypeId=@generateReportControlTypeId, FactTableId=@factTableId,  ReportTypeAbbreviation = 'STATPOV' where ReportCode='c103'

	---------------------c103 end ------------------------------------------------------------------
	---------------------c204-----------------------------------------------------------------------
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
    Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'TITLE3' Where ReportCode = 'c204'
	--------------------c204 end--------------------------------------------------------------------

	---------------------c205-----------------------------------------------------------------------
	If not exists (select 1 from app.GenerateReportControlType where ControlTypeName='c205')
	begin
	insert into app.GenerateReportControlType (ControlTypeName)values('c205')
	set @generateReportControlTypeId=SCOPE_IDENTITY()
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactOrganizationCounts'
    Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'ENGLANSTA', GenerateReportControlTypeId=@generateReportControlTypeId  Where ReportCode = 'c205'
	end
	--------------------c205 end--------------------------------------------------------------------

--------------------Insert Display Types--------------------------------------------------------

	IF NOT EXISTS(select 1 from app.GenerateReportDisplayTypes)
	BEGIN
		SET IDENTITY_INSERT app.GenerateReportDisplayTypes ON

			INSERT INTO app.GenerateReportDisplayTypes(GenerateReportDisplayTypeId,GenerateReportDisplayTypeName) values(1,'row')
			INSERT INTO app.GenerateReportDisplayTypes(GenerateReportDisplayTypeId,GenerateReportDisplayTypeName) values(2,'column')
		
		SET IDENTITY_INSERT app.GenerateReportDisplayTypes OFF
	END

	select @reportId = GenerateReportId from app.GenerateReports where ReportCode = 'c195'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'SEX'
	select @displayTypeID = GenerateReportDisplayTypeId from app.GenerateReportDisplayTypes where GenerateReportDisplayTypeName = 'row'

	Update app.CategorySet_Categories set GenerateReportDisplayTypeID = 1 
	where CategorySetId in (select CategorySetId from app.CategorySets where GenerateReportId = @reportId) and CategoryId = @categoryId

	select @displayTypeID = GenerateReportDisplayTypeId from app.GenerateReportDisplayTypes where GenerateReportDisplayTypeName = 'column'

	Update app.CategorySet_Categories set GenerateReportDisplayTypeID = 2
	where CategorySetId in (select CategorySetId from app.CategorySets where GenerateReportId = @reportId) and CategoryId <> @categoryId

	----------------------------------------------------c194-----------------------------------------------------------------------------------

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'Age'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'AGEPK'

	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END 

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'

	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'MVENTOPKS' where ReportCode = 'c194'

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'

	Update app.GenerateReports set FactTableId = @factTableId where ReportCode = 'c036'

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactPersonnelCounts'
	
	Update app.GenerateReports set FactTableId = @factTableId where ReportCode = 'c065'


	------------Add categoryset for 2017-18----
declare @caoId as int, @cmoId as int
select @caoId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'cao'
select @cmoId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'cmo'



If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c190' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @caoId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
BEGIN
 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c190' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
		,@caoId, 17339, '2017-18', 'CSA', 'Category Set A' )
 
SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
END
IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c190') and OrganizationLevelId = 1112 )
BEGIN
	INSERT into App.GenerateReport_OrganizationLevels
	(GenerateReportId,OrganizationLevelId) 
	( SELECT GenerateReportId, 1112 from app.GenerateReports where ReportCode ='c190' )
END

If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c196' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @cmoId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
BEGIN
 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c196' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
		,@cmoId, 17339, '2017-18', 'CSA', 'Category Set A' )
 
SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
END
IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c196') and OrganizationLevelId = 1182 )
BEGIN
	INSERT into App.GenerateReport_OrganizationLevels
	(GenerateReportId,OrganizationLevelId) 
	( SELECT GenerateReportId, 1182 from app.GenerateReports where ReportCode ='c196' )
END

If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c197' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @schId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
BEGIN
 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c197' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
		,@schId, 17339, '2017-18', 'CSA', 'Category Set A' )
 
SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
END
IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c197') and OrganizationLevelId = 3 )
BEGIN
	INSERT into App.GenerateReport_OrganizationLevels
	(GenerateReportId,OrganizationLevelId) 
	( SELECT GenerateReportId, 3 from app.GenerateReports where ReportCode ='c197' )
END

If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c198' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @schId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
BEGIN
 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c198' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
		,@schId, 17339, '2017-18', 'CSA', 'Category Set A' )
 
SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
END
IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c198') and OrganizationLevelId = 3 )
BEGIN
	INSERT into App.GenerateReport_OrganizationLevels
	(GenerateReportId,OrganizationLevelId) 
	( SELECT GenerateReportId, 3 from app.GenerateReports where ReportCode ='c198' )
END

--------------------------------------------------------------------
UPDATE app.categories SET CategoryName = 'English Learner Status' where CategoryCode = 'LEPBOTH'

	 Update app.CategoryOptions set CategoryOptionCode = 'FL'
	where CategoryId in (select CategoryId from app.Categories where CategoryCode = 'FREELUNCH') 
	and CategoryOptionCode = 'FREE' 

		Update app.CategorySets set IncludeOnFilter = 'SWD' Where GenerateReportId in (select GenerateReportId from app.GenerateReports where ReportCode = 'exitspecialeducation')
	and CategorySetCode = 'disabilitytype'

		delete o from app.CategoryOptions o
		inner join app.Categories c on o.CategoryId = c.CategoryId
		and c.CategoryCode = 'LEPBOTH'
		and CategoryOptionCode = 'LEP' and CategoryOptionName = 'Limited English Proficient (LEP) Student'
		and CategorySetId in (Select CategorySetId from app.CategorySets 
		where GenerateReportId in (Select GenerateReportId from app.GenerateReports where ReportCode = 'exitspecialeducation'))

		delete o from app.CategoryOptions o
		inner join app.Categories c on o.CategoryId = c.CategoryId
		and c.CategoryCode = 'LEPBOTH'
		and CategoryOptionCode = 'NLEP' and CategoryOptionName = 'Non-limited English proficient (non-LEP) Student'
		and CategorySetId in (Select CategorySetId from app.CategorySets 
		where GenerateReportId in (Select GenerateReportId from app.GenerateReports where ReportCode = 'exitspecialeducation'))

		Update app.CategorySets set CategorySetName = 'EL Status' 
		where GenerateReportId in (Select GenerateReportId from app.GenerateReports where ReportCode = 'exitspecialeducation')
		and categorysetcode = 'lepstatus'


	Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimDisciplines'
	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'DISCIPLINEELSTATUS' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Categories]([CategoryCode],[CategoryName],[EdFactsCategoryId]) values('LEPDISC','EL Status (Discipline)',0)

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) VALUES('DisciplineELStatus',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'DisciplineELStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'LEPDISC'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'LEPDISC'

	
		Update csc set categoryid = @categoryId
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
		inner join app.Categories c on c.CategoryId = csc.CategoryId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines' and c.CategoryCode = 'LEPBOTH'

		
		select @previousLepId = CategoryId from app.Categories Where CategoryCode = 'LEPBOTH'

		Update co set CategoryId = @categoryId
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines'  and co.CategoryOptionCode = 'MISSING' and cs.CategorySetCode = 'CSD'  and co.CategoryId = @previousLepId

		Update co set CategoryId = @categoryId, CategoryOptionName = 'English learner'
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines' and co.CategoryOptionCode = 'LEP'

		Update co set CategoryId = @categoryId, CategoryOptionName = 'Non–English learner'
		from app.GenerateReports r
		inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
		inner join app.CategoryOptions co on co.CategorySetId = cs.CategorySetId
		inner join app.FactTables ft on r.FactTableId = ft.FactTableId
		where ft.FactTableName = 'FactStudentDisciplines'  and co.CategoryOptionCode = 'NLEP'

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'DisciplineELStatus'

		Update fc set DisplayName = 'English Learner Status (Both)'
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
		inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('c005','c006','c007','c088','c143') and ColumnName = 'LEPStatusID' and SubmissionYear = '2017-18'

		Update fc set DimensionId = @dimensionId
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
		inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
		where r.ReportCode in ('c005','c006','c007','c088','c143') and ColumnName = 'LEPStatusID'



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
