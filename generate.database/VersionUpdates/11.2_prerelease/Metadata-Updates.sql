declare @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT, @factTableId as INT
declare @questionTypeId as INT, @questionId as INT

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'EdFactsCertificationStatus'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'CERTSTATUSIDEA'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'FirearmType'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'FIREARMS'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END


update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'CertificationStatusID'


SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'HighSchoolDiplomaType'
update App.FileColumns set DimensionId = @dimensionId where ColumnName = 'DiplomaCredentialTypeID'

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'FirearmType'

Update fc set DimensionId = @dimensionId
from app.FileSubmission_FileColumns fsfc
inner join app.FileSubmissions fs on fs.FileSubmissionId = fsfc.FileSubmissionId
inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
where fs.SubmissionYear = 2023 and r.ReportCode in ('c086') and fc.ColumnName = 'WeaponTypeID'

Update app.DimensionTables set DimensionTableName = 'DimFirearmDisciplineStatuses' where DimensionTableName = 'DimFirearmDisciplines'


select @questionId = ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'GRADRPT'
select @questionTypeId = ToggleQuestionTypeId from app.ToggleQuestionTypes where ToggleQuestionTypeCode = 'toggle'

Update app.ToggleQuestions set QuestionText = 'Does your state allow Other high school completion credentials?', ToggleQuestionTypeId = @questionTypeId
Where ToggleQuestionId = @questionId

Update app.ToggleQuestionOptions set OptionText = 'Yes' Where ToggleQuestionId = @questionId and OptionSequence = 1
Update app.ToggleQuestionOptions set OptionText = 'No' Where ToggleQuestionId = @questionId and OptionSequence = 2