-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		declare @ToggleSectionTypeId INT, @ToggleSection1 INT, @ToggleSection2 INT

	--CIID-3966 - FS194 Homeless - RDS Migration - Age calculation sproc requires a specific date to calculate age correctly
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'ToggleSectionTypes' AND Type = N'U')
		BEGIN
			insert into [App].[ToggleSectionTypes] (
				EmapsSurveyTypeAbbrv,SectionTypeName,SectionTypeSequence,SectionTypeShortName
			)
			values ('HOMELESS', 'Homeless',10, 'Homeless')
			SET @ToggleSectionTypeId = @@IDENTITY
		END


		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'ToggleSections' AND Type = N'U')
		BEGIN
			insert into [App].[ToggleSections] (
				EmapsParentSurveySectionAbbrv,EmapsSurveySectionAbbrv,SectionName,SectionSequence,SectionTitle,ToggleSectionTypeId
			)
			values(NULL,'HOMELESSPARENT','I',2000,'Homeless',@ToggleSectionTypeId)
			
			SET @ToggleSection1 = @@IDENTITY


			insert into [App].[ToggleSections] (
				EmapsParentSurveySectionAbbrv,EmapsSurveySectionAbbrv,SectionName,SectionSequence,SectionTitle,ToggleSectionTypeId
			)
			values('HOMELESSPARENT','HOMELESS', 'I1',2001,'Homeless',@ToggleSectionTypeId)

			SET @ToggleSection2 = @@IDENTITY


		END
		
		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'ToggleQuestions' AND Type = N'U')
		BEGIN
			insert into [App].[ToggleQuestions] (
				EmapsQuestionAbbrv,ParentToggleQuestionId,QuestionSequence,QuestionText,ToggleQuestionTypeId,ToggleSectionId
			)
			values('HOMELESSAGE',NULL,2001,'What comparison date does your state use to calculate Age for Homeless students?',9,@ToggleSection2)
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