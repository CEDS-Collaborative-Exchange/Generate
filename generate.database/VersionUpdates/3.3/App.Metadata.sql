-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction

		Update app.Categories set CategoryCode = 'ACADVOCOUTCOMEX' where EdFactsCategoryId = 579

		declare @dimensionId as int, @dimensionTableId as int, @factTableId int, @categoryId int

		select  @factTableId = FactTableId from app.FactTables where FactTableName = 'FactStudentCounts'

		if not exists(select 1 from app.DimensionTables where DimensionTableName = 'DimCteStatuses')
		BEGIN
			INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimCteStatuses', 1)
		END

		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) values(@factTableId, @dimensionTableId)
		END


		if not exists(select 1 from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses')
		BEGIN
			INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimEnrollmentStatuses', 1)
		END

		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) values(@factTableId, @dimensionTableId)
		END

		select  @factTableId = FactTableId from app.FactTables where FactTableName = 'FactStudentAssessments'
		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) values(@factTableId, @dimensionTableId)
		END

		select  @factTableId = FactTableId from app.FactTables where FactTableName = 'FactStudentDisciplines'
		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) values(@factTableId, @dimensionTableId)
		END



		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'CteProgram'
		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId where DimensionId = @dimensionId
		END

		set @dimensionId = 0

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'RepresentationStatus'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId where DimensionId = @dimensionId
		END
		set @dimensionId = 0

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'DisplacedHomeMaker'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId, DimensionFieldName = 'CteAeDisplacedHomemakerIndicator' where DimensionId = @dimensionId
		END

		set @dimensionId = 0
		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'NonTraditionalEnrollee'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId, DimensionFieldName = 'CteNontraditionalGenderStatus' where DimensionId = @dimensionId
		END

		set @dimensionId = 0
		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'SingleParent'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId, DimensionFieldName = 'SingleParentOrSinglePregnantWoman' where DimensionId = @dimensionId

		END
		set @dimensionId = 0
		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'INCLUTYP'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId, DimensionFieldName = 'CteGraduationRateInclusion' where DimensionId = @dimensionId
		END

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalOutcome'
		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses'

		IF(@dimensionId > 0)
		BEGIN
			Update app.Dimensions set DimensionTableId = @dimensionTableId where DimensionId = @dimensionId
		END

		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses'

		IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'AcademicOrVocationalExitOutcome' and [DimensionTableId] = @dimensionTableId)
		BEGIN

			INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
				VALUES('AcademicOrVocationalExitOutcome',@dimensionTableId,0,0)

			select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalExitOutcome'

			select @categoryId = CategoryId from app.Categories Where CategoryCode = 'ACADVOCOUTCOMEX'
			IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
			BEGIN
				INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
			END

			Update app.FileColumns set DimensionId = @dimensionId where DisplayName = 'Academic / Vocational Outcomes (Exit)'
		END

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalOutcome'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'ACADVOCOUTCOMEX'

		delete from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId

		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'HomelessServicedIndicator')
		BEGIN

			INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
				VALUES('HomelessServicedIndicator',@dimensionTableId,0,0)

		END

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'TitleiiiAccountabilityProgressStatus'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'ENGLRNACCOUBL'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END

		select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'LepPerkinsStatus')
		BEGIN

			INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
				VALUES('LepPerkinsStatus',@dimensionTableId,0,0)

		END

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'LepStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'LEPPERKINS'

		delete from app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'LepPerkinsStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'LEPPERKINS'

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'LepPerkinsStatus'
		Update app.FileColumns set dimensionId = @dimensionId where DisplayName = 'LEP Status (Perkins)'

		
		select @dimensionTableId = DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimAssessments'
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'ProficiencyStatus' and DimensionTableId = @dimensionTableId
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'PROFSTATUS' and EdFactsCategoryId = 572

		delete from app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId
		delete from app.Dimensions where DimensionFieldName = 'ProficiencyStatus' and DimensionTableId = @dimensionTableId

		select @dimensionTableId = DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimTitleiiiStatuses'
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'ProficiencyStatus' and DimensionTableId = @dimensionTableId

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END


		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'PROFSTATUS' and EdFactsCategoryId = 202
		select @dimensionTableId = DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimTitleiiiStatuses'
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'ProficiencyStatus' and DimensionTableId = @dimensionTableId

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END

		delete cs from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		where r.ReportCode = 'c131' and SubmissionYear = '2018-19'

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
