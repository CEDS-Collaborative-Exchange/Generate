  IF NOT EXISTS (SELECT 1 FROM App.GenerateReports WHERE [ReportCode] = 'c210')
	  INSERT App.GenerateReports (
	  [CategorySetControlCaption]
		  ,[CategorySetControlLabel]
		  ,[CedsConnectionId]
		  ,[FactTableId]
		  ,[FilterControlLabel]
		  ,[GenerateReportControlTypeId]
		  ,[GenerateReportTypeId]
		  ,[IsActive]
		  ,[ReportCode]
		  ,[ReportName]
		  ,[ReportSequence]
		  ,[ReportShortName]
		  ,[ReportTypeAbbreviation]
		  ,[ShowCategorySetControl]
		  ,[ShowData]
		  ,[ShowFilterControl]
		  ,[ShowGraph]
		  ,[ShowSubFilterControl]
		  ,[SubFilterControlLabel]
		  ,[IsLocked]
		  ,[UseLegacyReportMigration]
	  )
	  SELECT
		[CategorySetControlCaption] = NULL
		,[CategorySetControlLabel] = NULL
		,[CedsConnectionId] = NULL
		,[FactTableId] = 1
		,[FilterControlLabel] = NULL
		,[GenerateReportControlTypeId] = 2
		,[GenerateReportTypeId] = 3
		,[IsActive] = 1
		,[ReportCode] = 'c210'
		,[ReportName] = 'C210: Title III English Learner Five Years'
		,[ReportSequence] = NULL
		,[ReportShortName] = 'C210'
		,[ReportTypeAbbreviation] = 'TTL3EL5YRS'
		,[ShowCategorySetControl] = 1
		,[ShowData] = 1
		,[ShowFilterControl] = 0
		,[ShowGraph] = 0
		,[ShowSubFilterControl] = 0
		,[SubFilterControlLabel] = NULL
		,[IsLocked] = 0
		,[UseLegacyReportMigration] = 0

GO

set nocount on
begin try
 
	begin transaction
 
		CREATE TABLE #recordIds 
		(
		Id int
		)
 
		declare @GenerateReportId as Int
		declare @CategorySetId as int
		declare @ToggleSectionTypeId as int
		declare @CategoryId as int
 
		declare @seaId as int, @leaId as int, @schId as int
		select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sea'
		select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'lea'
		select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'
 
		declare @edfactsSubmissionReportTypeId as int
		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
		----------------------
		-- c210
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c210' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into #recordIds (Id) values (21184)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21184)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 282, 21184, '2021', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21184
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2021', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 614
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSNO', 'Not proficient within five years', 9502 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSYES', 'Proficient within five years', 9503 )
 
 
		insert into #recordIds (Id) values (21209)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21209)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 282, 21209, '2021', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21209
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2021', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into #recordIds (Id) values (21210)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21210)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 282, 21210, '2021', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21210
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2021', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 614
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSNO', 'Not proficient within five years', 9502 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSYES', 'Proficient within five years', 9503 )
 
 
		insert into #recordIds (Id) values (21185)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21185)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 282, 21185, '2021', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21185
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2021', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into #recordIds (Id) values (21630)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21630)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 282, 21630, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21630
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 614
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSNO', 'Not proficient within five years', 9502 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSYES', 'Proficient within five years', 9503 )
 
 
		insert into #recordIds (Id) values (21632)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21632)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 282, 21632, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21632
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into #recordIds (Id) values (21633)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21633)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 282, 21633, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21633
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 614
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSNO', 'Not proficient within five years', 9502 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PROF5YRSYES', 'Proficient within five years', 9503 )
 
 
		insert into #recordIds (Id) values (21631)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21631)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 282, 21631, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21631
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 282, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
	-- Set App.CategorySets.TableTypeId
	update app.CategorySets set TableTypeId = (select TableTypeId from App.TableTypes where EdFactsTableTypeId = cs.EdFactsTableTypeId)
	from App.CategorySets cs
	where (cs.TableTypeId is null or cs.TableTypeId = 0) and cs.EdFactsTableTypeId is not null
 
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
DROP TABLE #recordIds
GO

set nocount on
begin try
 
	begin transaction
 
		declare @GenerateReportId as Int
		declare @fileSubmissionId as Int
		declare @fileColumnId as Int
		declare @headerId INT, @columnId INT
 
		declare @seaId as int, @leaId as int, @schId as int
		select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sea'
		select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'lea'
		select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'
 
		declare @edfactsSubmissionReportTypeId as int
		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
		----------------------
		-- c210
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c210' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA TITLE III ENGLISH LEARNER 5 YRS', @GenerateReportId, 1, '2021')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 10, 285)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', 'Carriage Return / Line Feed (CRLF)', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 295, 'false', 11, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ELProf5YrStatusID','String', 'English Learners Proficiency Within Five Years Status', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 284, 'true', 9, 85)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 84, 'false', 8, 84)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA TITLE III ENGLISH LEARNER 5 YRS', @GenerateReportId, 2, '2021')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 10, 285)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', 'Carriage Return / Line Feed (CRLF)', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 295, 'false', 11, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ELProf5YrStatusID','String', 'English Learners Proficiency Within Five Years Status', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 284, 'true', 9, 85)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 84, 'false', 8, 84)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA TITLE III ENGLISH LEARNER 5 YRS', @GenerateReportId, 1, '2022')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 10, 285)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', 'Carriage Return / Line Feed (CRLF)', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 295, 'false', 11, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ELProf5YrStatusID','String', 'English Learners Proficiency Within Five Years Status', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 284, 'true', 9, 85)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 84, 'false', 8, 84)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA TITLE III ENGLISH LEARNER 5 YRS', @GenerateReportId, 2, '2022')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA TITLE III ENGLISH LEARNER 5 YRS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 10, 285)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', 'Carriage Return / Line Feed (CRLF)', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 295, 'false', 11, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ELProf5YrStatusID','String', 'English Learners Proficiency Within Five Years Status', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 284, 'true', 9, 85)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 84, 'false', 8, 84)
 
 
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

GO

DECLARE @TableTypeId210 int

INSERT App.TableTypes (
	[EdFactsTableTypeId]
      ,[TableTypeAbbrv]
      ,[TableTypeName]
)
VALUES (
282
,'TTL3EL5YRS'
,'Title III English learners five years table'
)

SET @TableTypeId210 = SCOPE_IDENTITY()

UPDATE App.CategorySets
SET TableTypeId = @TableTypeId210
WHERE EdFactsTableTypeId = 282

GO

IF NOT EXISTS (SELECT 1 FROM App.Dimensions WHERE DimensionFieldName = 'EnglishLearnersProficiencyWithinFiveYearsStatus')
	INSERT App.Dimensions (
		[DimensionFieldName]
		  ,[DimensionTableId]
		  ,[IsCalculated]
		  ,[IsOrganizationLevelSpecific]
	)
	SELECT [DimensionFieldName] = 'EnglishLearnersProficiencyWithinFiveYearsStatus'
		  ,[DimensionTableId] = 21
		  ,[IsCalculated] = 0
		  ,[IsOrganizationLevelSpecific] = 0

MERGE INTO App.Category_Dimensions tgt
USING (
	SELECT c.CategoryId
		,d.DimensionId
	FROM App.Categories c
	CROSS JOIN App.Dimensions d
	WHERE c.CategoryCode = 'ELPROF5YRSTS'
		AND d.DimensionFieldName = 'EnglishLearnersProficiencyWithinFiveYearsStatus'
	) src
	ON (
			tgt.CategoryID = src.CategoryID
			AND tgt.DimensionID = src.DimensionID
			)
WHEN NOT MATCHED THEN
		INSERT (
			CategoryID
			,DimensionID
			)
		VALUES (
			src.CategoryID
			,src.DimensionID
			);
