declare @reportCode as varchar(50)
declare @generateReportId as INT, @factTypeId as INT, @tableTypeId as INT, @categorySetId as INT, @categoryId as INT, @fileSubmissionId as INT, @fileColumnId as INT, @factTableId as INT

SET @reportCode = 'c225'

SELECT @factTableId = FactTableId FROM app.FactTables where FactTableName = 'FactK12StudentCounts'

IF NOT EXISTS(SELECT 1 FROM app.GenerateReports where ReportCode = @reportCode)
BEGIN
	INSERT INTO [App].[GenerateReports]
			   ([GenerateReportControlTypeId]
			   ,[GenerateReportTypeId]
			   ,[IsActive]
			   ,[ReportCode]
			   ,[ReportName]
			   ,[ReportShortName]
			   ,[ShowCategorySetControl]
			   ,[ShowData]
			   ,[ShowFilterControl]
			   ,[ShowGraph]
			   ,[ShowSubFilterControl]
			   ,[IsLocked]
			   ,[UseLegacyReportMigration])
	VALUES(2,3,1,@reportCode,'N or D Assessment Proficiency - LEA',@reportCode,1,1,0,0,0,0,1)
END

UPDATE app.GenerateReports SET FactTableId = @factTableId, ReportTypeAbbreviation = 'NDACACLEA' where ReportCode = @reportCode

SELECT @generateReportId = GenerateReportId FROM app.GenerateReports where ReportCode = @reportCode
SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes where FactTypeCode = 'neglectedordelinquent'

IF NOT EXISTS(SELECT 1 FROM app.GenerateReport_FactType where GenerateReportId = @generateReportId AND FactTypeId = @factTypeId)
BEGIN
	INSERT INTO [App].[GenerateReport_FactType]([GenerateReportId],[FactTypeId])
    VALUES(@generateReportId, @factTypeId)
END

IF NOT EXISTS(SELECT 1 FROM app.GenerateReport_OrganizationLevels where GenerateReportId = @generateReportId AND OrganizationLevelId = 2)
BEGIN
	INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId])
    VALUES(@generateReportId, 2)
END


IF NOT EXISTS(SELECT 1 FROM app.TableTypes where TableTypeAbbrv = 'NDACACLEA')
BEGIN
	INSERT INTO [App].[TableTypes](TableTypeAbbrv, TableTypeName, EdFactsTableTypeId)
    VALUES('NDACACLEA', 'N or D assessment proficiency table - LEA', -1)
END

SELECT @tableTypeId = TableTypeId FROM app.TableTypes where TableTypeAbbrv = 'NDACACLEA'


IF NOT EXISTS(SELECT 1 FROM app.GenerateReport_TableType where GenerateReportId = @generateReportId AND TableTypeId = @tableTypeId)
BEGIN
	INSERT INTO [App].[GenerateReport_TableType]([GenerateReportId],[TableTypeId])
    VALUES(@generateReportId, @tableTypeId)
END

If NOT EXISTS(SELECT 1 from app.Categorysets where GenerateReportId = @generateReportId AND OrganizationLevelId = 2 AND SubmissionYear = '2024' AND CategorySetCode = 'CSA')
BEGIN
	INSERT INTO app.CategorySets
	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	VALUES
	(@GenerateReportId, 2, 0, '2024', 'CSA', 'Category Set A')
 
	SET @categorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
END
ELSE
BEGIN
 	SELECT @categorySetId = CategorySetId from app.Categorysets where GenerateReportId = @generateReportId AND OrganizationLevelId = 2 AND SubmissionYear = '2024' AND CategorySetCode = 'CSA'
END

SELECT @categoryId = CategoryId FROM app.Categories where CategoryCode = 'ACADSUBASSESNOSCI'

IF NOT EXISTS(SELECT 1 FROM app.CategorySet_Categories where CategorySetId = @categorySetId AND CategoryId = @categoryId)
BEGIN
	INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
    VALUES(@categorySetId, @categoryId)
END


IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'M')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'M', 'Mathematics', 9344)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'RLA')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'RLA', 'Reading/Language Arts', 9345)
END


SELECT @categoryId = CategoryId FROM app.Categories where CategoryId = 418

IF NOT EXISTS(SELECT 1 FROM app.CategorySet_Categories where CategorySetId = @categorySetId AND CategoryId = @categoryId)
BEGIN
	INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
    VALUES(@categorySetId, @categoryId)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'PROFICIENT')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'PROFICIENT', 'Attained Proficiency', 8374)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'NOTPROFICIENT')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'NOTPROFICIENT', 'Not proficient', 8375)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'MISSING')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'MISSING', 'Missing', -1)
END

If NOT EXISTS(Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA ND ASSESSMENT PROFICIENCY LEA' and GenerateReportId = @generateReportId
					and OrganizationLevelId = 2 and SubmissionYear = '2024')
BEGIN
	INSERT INTO App.FileSubmissions ([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
	values ('LEA ND ASSESSMENT PROFICIENCY LEA', @GenerateReportId, 2, '2024')
 
END

SELECT @fileSubmissionId = FileSubmissionId FROM app.FileSubmissions where FileSubmissionDescription = 'LEA ND ASSESSMENT PROFICIENCY LEA'

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'FileRecordNumber' AND LEN(DisplayName) > 0
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 10, 0, 1, 1)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'FIPSStateCode' AND DisplayName = 'State Code'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 12, 0, 2, 11)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'StateAgencyNumber' AND DisplayName = 'State Agency Number' AND XMLElementName = 'STATEAGENCYIDNUMBER'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 14, 0, 3, 13)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'StateLEAIDNumber' AND DisplayName = 'LEA Identifier (State)'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 28, 0, 4, 15)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Filler1' AND DisplayName = 'Filler' AND ColumnLength = 20
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 48, 0, 5, 29)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'TableTypeAbbrv' AND DisplayName = 'Table Name'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 68, 0, 6, 49)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'SubjectID' AND DisplayName = 'Academic Subject (Assessment - no science)'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 83, 0, 7, 69)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'ProficiencyStatusID' AND DisplayName = 'Proficiency Status'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 98, 0, 8, 84)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'TotalIndicator'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 99, 0, 9, 99)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Explanation' AND DisplayName = 'Explanation'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 299, 1, 10, 100)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Amount' AND DisplayName = 'Student Count' AND ColumnLength = 10 AND DataType = 'Number'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 309, 0, 11, 300)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'CarriageReturn/LineFeed' AND DisplayName = 'Carriage Return / Line Feed (CRLF)'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 310, 0, 12, 310)
END