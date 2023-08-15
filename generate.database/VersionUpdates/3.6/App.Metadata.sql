-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction	

		Update app.ToggleSections set SectionTitle = 'Environments for School-Age Children with Disabilities (IDEA)' 
		where EmapsSurveySectionAbbrv = 'ENVSCHAGE'
		
		Update app.ToggleSections set SectionTitle = 'Early Childhood Environments for Children with Disabilities (IDEA)' 
		where EmapsSurveySectionAbbrv = 'ENVERLYCH'
		
		Update app.ToggleQuestions set QuestionText = 'Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, in a residential facility.'
		where EmapsQuestionAbbrv = 'ENVECRESFAC'
		
		Update app.ToggleQuestions set QuestionText = 'What is the start date of the Perkins program year?'
		where EmapsQuestionAbbrv = 'CTEPERKPROGYRSTART'
		
		Update app.ToggleQuestions set QuestionText = 'What is the end date of the Perkins program year?'
		where EmapsQuestionAbbrv = 'CTEPERKPROGYREND'

		declare @sectionTypeId as int, @questionTypeId as int, @sectionId as int, @datamigrationtypeId as int

		if not exists(select 1 from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'DIRECTORY')
		BEGIN
			INSERT INTO [App].[ToggleSectionTypes]([EmapsSurveyTypeAbbrv],[SectionTypeName],[SectionTypeSequence],[SectionTypeShortName])
			VALUES('DIRECTORY','Directory',9,'Directory')
		END

		select @sectionTypeId = ToggleSectionTypeId from app.ToggleSectionTypes where EmapsSurveyTypeAbbrv = 'DIRECTORY'

		if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'DIRECTORY')
		BEGIN
			INSERT INTO [App].[ToggleSections]([EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
			VALUES('DIRECTORYPARENT','H',1900,'Directory',@sectionTypeId)
		END

		if not exists(select 1 from app.ToggleSections where EmapsSurveySectionAbbrv = 'DIRECTORY')
		BEGIN
			INSERT INTO [App].[ToggleSections]([EmapsParentSurveySectionAbbrv],[EmapsSurveySectionAbbrv],[SectionName],[SectionSequence],[SectionTitle],[ToggleSectionTypeId])
			VALUES('DIRECTORYPARENT','DIRECTORY','H1',1901,'Directory',@sectionTypeId)
		END

		select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'date'
		select @sectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'DIRECTORY'

		if not exists(select 1 from app.ToggleQuestions where EmapsQuestionAbbrv = 'EFFECTIVEDTE')
		BEGIN
			INSERT INTO [App].[ToggleQuestions]([EmapsQuestionAbbrv],[QuestionSequence],[QuestionText],[ToggleQuestionTypeId],[ToggleSectionId])
			VALUES('EFFECTIVEDTE',1401,'What date should be used to fill the EFFECTIVE DATE field in FS029 - Directory?',@questionTypeId,@sectionId)
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