-- App metadata updates for release 14.0
-- Add release-specific metadata changes in this file.

print 'App.Metadata.sql executed for 14.0.'

declare @toggleQuestionId as int, @toggleSectionId as int


IF NOT EXISTS(SELECT 1 FROM [App].[ToggleSections] WHERE [EmapsSurveySectionAbbrv]= 'EDUENVSCHAGE')
INSERT INTO [App].[ToggleSections]
           ([EmapsParentSurveySectionAbbrv]
           ,[EmapsSurveySectionAbbrv]
           ,[SectionName]
           ,[SectionSequence]
           ,[SectionTitle]
           ,[ToggleSectionTypeId])
     VALUES
           ('ENVSA','EDUENVSCHAGE','A32',301,'Environments for School-Age',1)

select @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'EDUENVSCHAGE'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestions] WHERE [EmapsQuestionAbbrv]= 'EDUENVSA')
INSERT INTO [App].[ToggleQuestions]
           ([EmapsQuestionAbbrv]
           ,[QuestionSequence]
           ,[QuestionText]
           ,[ToggleQuestionTypeId]
           ,[ToggleSectionId])
     VALUES
           ('EDUENVSA',304,'Which permitted values are included in your state’s definition for Educational Environments (IDEA) SA?',10,@toggleSectionId)




select @toggleQuestionId = ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'EDUENVSA'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'RC80 - Inside regular class 80% or more of the day')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (1, 'RC80 - Inside regular class 80% or more of the day', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'RC79TO40 - Inside regular class 40% through 79% of the day')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (2, 'RC79TO40 - Inside regular class 40% through 79% of the day', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'RC39 - Inside regular class less than 40% of the day')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (3, 'RC39 - Inside regular class less than 40% of the day', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'SS - Separate School')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (4, 'SS - Separate School', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'RF - Residential Facility')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (5, 'RF - Residential Facility', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'HH - Homebound/Hospital')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (6, 'HH - Homebound/Hospital', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'CF - Correctional Facilities')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (7, 'CF - Correctional Facilities', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'PPPS - Parentally placed in private schools')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (8, 'PPPS - Parentally placed in private schools', @toggleQuestionId)


IF NOT EXISTS(SELECT 1 FROM [App].[ToggleSections] WHERE [EmapsSurveySectionAbbrv]= 'ENVEL')
INSERT INTO [App].[ToggleSections]
           ([EmapsSurveySectionAbbrv]
           ,[SectionName]
           ,[SectionSequence]
           ,[SectionTitle]
           ,[ToggleSectionTypeId])
     VALUES
           ('ENVEL','A4',400,'Environment',1)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleSections] WHERE [EmapsSurveySectionAbbrv]= 'ENVIDEAEL')
INSERT INTO [App].[ToggleSections]
           ([EmapsParentSurveySectionAbbrv]
           ,[EmapsSurveySectionAbbrv]
           ,[SectionName]
           ,[SectionSequence]
           ,[SectionTitle]
           ,[ToggleSectionTypeId])
     VALUES
           ('ENVEL','ENVIDEAEL','A41',401,'Early Childhood',1)


select @toggleSectionId = ToggleSectionId from app.ToggleSections where EmapsSurveySectionAbbrv = 'ENVIDEAEL'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestions] WHERE [EmapsQuestionAbbrv]= 'EDUENVEC')
INSERT INTO [App].[ToggleQuestions]
           ([EmapsQuestionAbbrv]
           ,[QuestionSequence]
           ,[QuestionText]
           ,[ToggleQuestionTypeId]
           ,[ToggleSectionId])
     VALUES
           ('EDUENVEC',401,'Which permitted values are included in your state’s definition for Educational Environments (IDEA) EC?',10,@toggleSectionId)


select @toggleQuestionId = ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'EDUENVEC'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'REC10YSVCS - Services in Regular Early Childhood Program (at least 10 hours)')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (1, 'REC10YSVCS - Services in Regular Early Childhood Program (at least 10 hours)', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'REC10YOTHLOC - Other Location Regular Early Childhood Program (at least 10 hours)')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (2, 'REC10YOTHLOC - Other Location Regular Early Childhood Program (at least 10 hours)', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'REC09YSVCS - Services in Regular Early Childhood Program (less than 10 hours)')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (3, 'REC09YSVCS - Services in Regular Early Childhood Program (less than 10 hours)', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'REC09YOTHLOC - Other Location Regular Early Childhood Program (less than 10 hours)')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (4, 'REC09YOTHLOC - Other Location Regular Early Childhood Program (less than 10 hours)', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'SC - Separate Class')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (5, 'SC - Separate Class', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'SS - Separate School')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (6, 'SS - Separate School', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'RF - Residential Facility')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (7, 'RF - Residential Facility', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'H - Home')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (8, 'H - Home', @toggleQuestionId)

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestionOptions] WHERE [ToggleQuestionId]= @toggleQuestionId AND [OptionText]= 'SPL - Service Provider Location')
INSERT INTO [App].[ToggleQuestionOptions]([OptionSequence],[OptionText],[ToggleQuestionId])
VALUES (9, 'SPL - Service Provider Location', @toggleQuestionId)


Update app.Category_Dimensions set DimensionId = 56 where CategoryId = 402