declare @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT, @factTableId as INT
declare @questionTypeId as INT, @questionId as INT, @sectionId as INT

select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'toggle'
select @sectionId = ToggleSectionId from app.ToggleSections where EmapsParentSurveySectionAbbrv = 'ASSESS'

IF NOT EXISTS(SELECT 1 FROM app.ToggleQuestions where EmapsQuestionAbbrv = 'ASSESSRACEMAP')
BEGIN

	INSERT INTO [App].[ToggleQuestions]
           ([EmapsQuestionAbbrv]
           ,[QuestionSequence]
           ,[QuestionText]
           ,[ToggleQuestionTypeId]
           ,[ToggleSectionId])
     VALUES('ASSESSRACEMAP', 703, 'Does your state use MAP as a Major Racial Ethnic Category option?', @questionTypeId, @sectionId)

END

--Set the appropriate dimensionid for Assessment Participation Status
update app.filecolumns
set dimensionid = 23
where columnname = 'testingstatusid'
and displayname = 'Participation Status S'
