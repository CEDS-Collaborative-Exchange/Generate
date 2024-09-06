declare @reportCode as varchar(50)
declare @generateReportId as INT, @factTypeId as INT, @tableTypeId as INT, @categorySetId as INT, @categoryId as INT, @fileSubmissionId as INT, @fileColumnId as INT, @factTableId as INT

SET @reportCode = 'c219'

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
	VALUES(2,3,1,@reportCode,'N or D in Program Outcomes - LEA',@reportCode,1,1,0,0,0,0,1)
END

UPDATE app.GenerateReports SET FactTableId = @factTableId, ReportTypeAbbreviation = 'NDPROGOUTLEA' where ReportCode = @reportCode

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


IF NOT EXISTS(SELECT 1 FROM app.TableTypes where TableTypeAbbrv = 'NDPROGOUTLEA')
BEGIN
	INSERT INTO [App].[TableTypes](TableTypeAbbrv, TableTypeName, EdFactsTableTypeId)
    VALUES('NDPROGOUTLEA', 'N or D in Program Outcomes – LEA', -1)
END

SELECT @tableTypeId = TableTypeId FROM app.TableTypes where TableTypeAbbrv = 'NDPROGOUTLEA'


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

SELECT @categoryId = CategoryId FROM app.Categories where CategoryCode = 'ACADVOCOUTCOME'

IF NOT EXISTS(SELECT 1 FROM app.CategorySet_Categories where CategorySetId = @categorySetId AND CategoryId = @categoryId)
BEGIN
	INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
    VALUES(@categorySetId, @categoryId)
END


IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'EARNGED')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'EARNGED', 'Earned a GED', 8572)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'EARNDIPL')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'EARNDIPL', 'Obtained high school diploma', 8573)
END


IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'EARNCRE')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'EARNCRE', 'Earned high school course credits', 8570)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'ENROLLGED')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'ENROLLGED', 'Enrolled in a GED program', 8571)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'POSTSEC')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'POSTSEC', 'Were accepted and/or enrolled into post-secondary education', 8571)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'ENROLLTRAIN')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'ENROLLTRAIN', 'Enrolled in job training courses/programs', 8574)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'OBTAINEMP')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'OBTAINEMP', 'Obtained employment', 8575)
END

IF NOT EXISTS(SELECT 1 FROM app.CategoryOptions where CategorySetId = @categorySetId AND CategoryId = @categoryId AND CategoryOptionCode = 'MISSING')
BEGIN
	INSERT INTO App.CategoryOptions
	(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
	values
	(@categorySetId, @categoryId, 'MISSING', 'Missing', -1)
END

If NOT EXISTS(Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA ND PROGRAM OUTCOMES LEA' and GenerateReportId = @generateReportId
					and OrganizationLevelId = 2 and SubmissionYear = '2024')
BEGIN
	INSERT INTO App.FileSubmissions ([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
	values ('LEA ND PROGRAM OUTCOMES LEA', @GenerateReportId, 2, '2024')
 
END

SELECT @fileSubmissionId = FileSubmissionId FROM app.FileSubmissions where FileSubmissionDescription = 'LEA ND PROGRAM OUTCOMES LEA'

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

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'AcadVocOutcomeID' AND DisplayName = 'Academic / Vocational Outcomes'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 83, 0, 7, 69)
END


SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'TotalIndicator'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 84, 0, 8, 84)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Explanation' AND DisplayName = 'Explanation'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 284, 1, 9, 85)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Amount' AND DisplayName = 'Student Count' AND ColumnLength = 10 AND DataType = 'Number'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 294, 0, 10, 285)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'CarriageReturn/LineFeed' AND DisplayName = 'Carriage Return / Line Feed (CRLF)'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 295, 0, 11, 295)
END