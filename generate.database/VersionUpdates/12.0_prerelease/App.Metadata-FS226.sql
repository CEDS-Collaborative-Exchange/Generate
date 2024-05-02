declare @reportCode as varchar(50)
declare @generateReportId as INT, @factTypeId as INT, @tableTypeId as INT, @categorySetId as INT, @categoryId as INT, @fileSubmissionId as INT, @fileColumnId as INT, @factTableId as INT

SET @reportCode = 'c226'

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
	VALUES(2,3,1,@reportCode,'Economically Disadvantaged Students',@reportCode,1,1,0,0,0,0,1)
END

UPDATE app.GenerateReports SET FactTableId = @factTableId, ReportTypeAbbreviation = 'ECODISSTU' where ReportCode = @reportCode

SELECT @generateReportId = GenerateReportId FROM app.GenerateReports where ReportCode = @reportCode
SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes where FactTypeCode = 'membership'

IF NOT EXISTS(SELECT 1 FROM app.GenerateReport_FactType where GenerateReportId = @generateReportId AND FactTypeId = @factTypeId)
BEGIN
	INSERT INTO [App].[GenerateReport_FactType]([GenerateReportId],[FactTypeId])
    VALUES(@generateReportId, @factTypeId)
END

IF NOT EXISTS(SELECT 1 FROM app.GenerateReport_OrganizationLevels where GenerateReportId = @generateReportId AND OrganizationLevelId = 3)
BEGIN
	INSERT INTO [App].[GenerateReport_OrganizationLevels]([GenerateReportId],[OrganizationLevelId])
    VALUES(@generateReportId, 3)
END


IF NOT EXISTS(SELECT 1 FROM app.TableTypes where TableTypeAbbrv = 'ECODISSTU')
BEGIN
	INSERT INTO [App].[TableTypes](TableTypeAbbrv, TableTypeName, EdFactsTableTypeId)
    VALUES('ECODISSTU', 'Economically Disadvantaged Students', -1)
END

SELECT @tableTypeId = TableTypeId FROM app.TableTypes where TableTypeAbbrv = 'ECODISSTU'


IF NOT EXISTS(SELECT 1 FROM app.GenerateReport_TableType where GenerateReportId = @generateReportId AND TableTypeId = @tableTypeId)
BEGIN
	INSERT INTO [App].[GenerateReport_TableType]([GenerateReportId],[TableTypeId])
    VALUES(@generateReportId, @tableTypeId)
END

If NOT EXISTS(SELECT 1 from app.Categorysets where GenerateReportId = @generateReportId AND OrganizationLevelId = 3 AND SubmissionYear = '2024' AND CategorySetCode = 'CSA')
BEGIN
	INSERT INTO app.CategorySets
	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	VALUES
	(@GenerateReportId, 3, 0, '2024', 'CSA', 'Category Set A')
 
	SET @categorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
END
ELSE
BEGIN
 	SELECT @categorySetId = CategorySetId from app.Categorysets where GenerateReportId = @generateReportId AND OrganizationLevelId = 3 AND SubmissionYear = '2024' AND CategorySetCode = 'CSA'
END


If NOT EXISTS(Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH ECONOMICALLY DISADVANTAGED STUDENTS' and GenerateReportId = @generateReportId
					and OrganizationLevelId = 3 and SubmissionYear = '2024')
BEGIN
	INSERT INTO App.FileSubmissions ([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
	values ('SCH ECONOMICALLY DISADVANTAGED STUDENTS', @GenerateReportId, 3, '2024')
 
END

SELECT @fileSubmissionId = FileSubmissionId FROM app.FileSubmissions where FileSubmissionDescription = 'SCH ECONOMICALLY DISADVANTAGED STUDENTS'

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

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'StateSchoolIDNumber' AND DisplayName = 'School Identifier (State)'
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

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'TotalIndicator'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 69, 0, 9, 69)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Explanation' AND DisplayName = 'Explanation'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 269, 1, 10, 70)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'Amount' AND DisplayName = 'Student Count' AND ColumnLength = 10 AND DataType = 'Number'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 279, 0, 11, 270)
END

SELECT @fileColumnId = FileColumnId from app.FileColumns where ColumnName = 'CarriageReturn/LineFeed' AND DisplayName = 'Carriage Return / Line Feed (CRLF)'
If NOT EXISTS(SELECT 1 FROM App.FileSubmission_FileColumns Where FileSubmissionId = @fileSubmissionId AND FileColumnId = @fileColumnId)
BEGIN
	INSERT INTO App.FileSubmission_FileColumns
	([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
	VALUES
	(@fileSubmissionId, @fileColumnId, 280, 0, 12, 280)
END