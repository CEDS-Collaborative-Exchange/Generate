IF NOT EXISTS(SELECT 1 FROM [App].[ToggleSections] WHERE [EmapsSurveySectionAbbrv]= 'ALTDLPMA')
INSERT INTO [App].[ToggleSections]
           ([EmapsParentSurveySectionAbbrv]
           ,[EmapsSurveySectionAbbrv]
           ,[SectionName]
           ,[SectionSequence]
           ,[SectionTitle]
           ,[ToggleSectionTypeId])
     VALUES
           (
            'DEFEX'
            ,'ALTDLPMA'
            ,'A16'
            ,106
            ,'Alternate Diploma'
            ,1
		)

DECLARE @ToggleSectionId INT
SELECT @ToggleSectionId = ToggleSectionId FROM [App].[ToggleSections]
WHERE [EmapsSurveySectionAbbrv]= 'ALTDLPMA'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestions] WHERE [EmapsQuestionAbbrv]= 'DEFEXDLPDIS')
INSERT INTO [App].[ToggleQuestions]
           ([EmapsQuestionAbbrv]
           ,[ParentToggleQuestionId]
           ,[QuestionSequence]
           ,[QuestionText]
           ,[ToggleQuestionTypeId]
           ,[ToggleSectionId])
     VALUES
           (
		'DEFEXDLPDIS'
           ,NULL
           ,110
           ,'Does your state offer a state-defined alternate diploma, defined in accordance with Section 8101(23) and (25) of ESEA(A)(ii)(I)(bb), as amended by the ESSA, that is for students with the most significant cognitive disabilities?'
           ,7
           ,@ToggleSectionId
		)

-----------------------------
IF NOT EXISTS(SELECT 1 FROM [App].[ToggleSections] WHERE [EmapsSurveySectionAbbrv]= 'CERT')
INSERT INTO [App].[ToggleSections]
           ([EmapsParentSurveySectionAbbrv]
           ,[EmapsSurveySectionAbbrv]
           ,[SectionName]
           ,[SectionSequence]
           ,[SectionTitle]
           ,[ToggleSectionTypeId])
     VALUES
           (
		'DEFEX'
           ,'CERT'
           ,'A17'
           ,107
           ,'Certificates'
           ,1
		)


SELECT @ToggleSectionId = ToggleSectionId FROM [App].[ToggleSections]
WHERE [EmapsSurveySectionAbbrv]= 'CERT'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleQuestions] WHERE [EmapsQuestionAbbrv]= 'DEFEXCERT')
INSERT INTO [App].[ToggleQuestions]
           ([EmapsQuestionAbbrv]
           ,[ParentToggleQuestionId]
           ,[QuestionSequence]
           ,[QuestionText]
           ,[ToggleQuestionTypeId]
           ,[ToggleSectionId])
     VALUES
           (
		'DEFEXCERT'
           ,NULL
           ,111
           ,'Can a student with disabilities (IDEA) exit an educational program by receiving a high school completion certificate, modified diploma, or similar document?'
           ,7
           ,@ToggleSectionId
		)

DECLARE @ToggleQuestionId INT
SELECT @ToggleQuestionId = ToggleQuestionId FROM [App].[ToggleQuestions]
WHERE [EmapsQuestionAbbrv]= 'DEFEXCERT'

IF NOT EXISTS(SELECT 1 FROM [App].[ToggleResponses] WHERE [ToggleQuestionId]= @ToggleQuestionId)
INSERT INTO [App].[ToggleResponses]
           ([ResponseValue]
           ,[ToggleQuestionId]
           )
     VALUES
           (
		'true'
           ,@ToggleQuestionId
		)