declare @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT, @factTableId as INT
declare @questionTypeId as INT, @questionId as INT

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'EdFactsCertificationStatus'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'CERTSTATUSIDEA'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END


update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'CertificationStatusID'


SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'HighSchoolDiplomaType'
update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'DiplomaCredentialTypeID'


select @questionId = ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'GRADRPT'
select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'toggle'

Update app.ToggleQuestions set QuestionText = 'Does your state allow Other high school completion credentials?', ToggleQuestionTypeId = @questionTypeId
Where ToggleQuestionId = @questionId

Update app.ToggleQuestionOptions set OptionText = 'Yes' Where ToggleQuestionId = @questionId and OptionSequence = 1
Update app.ToggleQuestionOptions set OptionText = 'No' Where ToggleQuestionId = @questionId and OptionSequence = 2