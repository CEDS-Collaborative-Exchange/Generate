CREATE PROCEDURE [App].[ESS_MetadataAudit_Year_ReportCode]
	@SubmissionYear smallint = 2022
	,@ReportCode varchar(5) = 'c002'
AS

BEGIN TRAN
	BEGIN TRY

		exec [EDENDB_dbo_Generate_ExportMetadata_OneFile] @ReportCode,@SubmissionYear

		select [genReportCode] = gen.ReportCode
			,[genFileSubmissionDescription] = gen.FileSubmissionDescription
			,[genOrganizationLevelId] = gen.OrganizationLevelId
			,[genSubmissionYear] = gen.SubmissionYear
			,[genCategorySetCode] = gen.CategorySetCode
			,[genCategorySetName] = gen.CategorySetName
			,[genEdFactsTableTypeGroupId] = gen.EdFactsTableTypeGroupId
			,[genEdFactsTableTypeId] = gen.EdFactsTableTypeId
			,[genTableTypeAbbrv] = gen.TableTypeAbbrv
			,[genTableTypeName] = gen.TableTypeName
			,[genCategoryCode] = gen.CategoryCode
			,[genCategoryName] = gen.CategoryName
			,[genEdFactsCategoryId] = gen.EdFactsCategoryId
			,[genCategoryOptionCode] = gen.CategoryOptionCode
			,[genCategoryOptionName] = gen.CategoryOptionName
			,[genEdFactsCategoryCodeId] = gen.EdFactsCategoryCodeId
			,[essReportCode] = ess.ReportCode
			,[essFileSubmissionDescription] = ess.FileSubmissionDescription
			,[essOrganizationLevelId] = ess.OrganizationLevelId
			,[essSubmissionYear] = ess.SubmissionYear
			,[essCategorySetCode] = ess.CategorySetCode
			,[essCategorySetName] = ess.CategorySetName
			,[essEdFactsTableTypeGroupId] = ess.EdFactsTableTypeGroupId
			,[essEdFactsTableTypeId] = ess.EdFactsTableTypeId
			,[essTableTypeAbbrv] = ess.TableTypeAbbrv
			,[essTableTypeName] = ess.TableTypeName
			,[essCategoryCode] = ess.CategoryCode
			,[essCategoryName] = ess.CategoryName
			,[essEdFactsCategoryId] = ess.EdFactsCategoryId
			,[essCategoryOptionCode] = ess.CategoryOptionCode
			,[essCategoryOptionName] = ess.CategoryOptionName
			,[essEdFactsCategoryCodeId] = ess.EdFactsCategoryCodeId
		INTO #optionDiscrepancies
		from app.vwReportCode_CategoryOptions gen
		full join dbo.EDENDB_dbo_GenerateOptions ess 
			on gen.ReportCode = ess.ReportCode
			and gen.FileSubmissionDescription = ess.FileSubmissionDescription
			and gen.OrganizationLevelId = ess.OrganizationLevelId
			and gen.SubmissionYear = ess.SubmissionYear
			and gen.CategorySetCode = ess.CategorySetCode 
			and gen.CategorySetName = ess.CategorySetName
			and gen.EdFactsTableTypeGroupId = ess.EdFactsTableTypeGroupId
			and gen.EdFactsTableTypeId = ess.EdFactsTableTypeId
			and gen.TableTypeAbbrv = ess.TableTypeAbbrv
			and gen.TableTypeName = ess.TableTypeName
			and gen.CategoryCode = ess.CategoryCode
			and gen.CategoryName = ess.CategoryName
			and gen.EdFactsCategoryId = ess.EdFactsCategoryId
			and gen.CategoryOptionCode = ess.CategoryOptionCode
			and gen.CategoryOptionName = ess.CategoryOptionName
			and gen.EdFactsCategoryCodeId = ess.EdFactsCategoryCodeId
		where ISNULL(gen.SubmissionYear,@SubmissionYear) = @SubmissionYear
		and ISNULL(gen.ReportCode,@ReportCode) = @ReportCode
		and ISNULL(ess.SubmissionYear,@SubmissionYear) = @SubmissionYear
		and ISNULL(ess.ReportCode,@ReportCode) = @ReportCode
		and (
			gen.ReportCode IS NULL
			OR ess.ReportCode IS NULL
		)

		select [genColumnLength] = gen.ColumnLength
			,[genColumnName] = gen.ColumnName
			,[genDimensionFieldName] = gen.DimensionFieldName
			,[genDisplayName] = gen.DisplayName
			,[genXMLElementName] = gen.XMLElementName
			,[genDataType] = gen.DataType
			,[genEndPosition] = gen.EndPosition
			,[genIsOptional] = gen.IsOptional
			,[genSequenceNumber] = gen.SequenceNumber
			,[genStartPosition] = gen.StartPosition
			,[genSubmissionYear] = gen.SubmissionYear
			,[genOrganizationLevelId] = gen.OrganizationLevelId
			,[genReportCode] = gen.ReportCode
			,[essColumnLength] = ess.ColumnLength
			,[essColumnName] = ess.ColumnName
			,[essDimensionFieldName] = ess.DimensionFieldName
			,[essDisplayName] = ess.DisplayName
			,[essXMLElementName] = ess.XMLElementName
			,[essDataType] = ess.DataType
			,[essEndPosition] = ess.EndPosition
			,[essIsOptional] = ess.IsOptional
			,[essSequenceNumber] = ess.SequenceNumber
			,[essStartPosition] = ess.StartPosition
			,[essSubmissionYear] = ess.SubmissionYear
			,[essOrganizationLevelId] = ess.OrganizationLevelId
			,[essReportCode] = ess.ReportCode
		INTO #columnDiscrepancies
		from app.vwReportCode_FileColumns gen
		full join dbo.EDENDB_dbo_GenerateColumns ess
			on gen.ColumnLength = ess.ColumnLength
			and gen.ColumnName = ess.ColumnName
			and ISNULL(gen.DimensionFieldName,'') = ISNULL(ess.DimensionFieldName,'')
			and gen.DisplayName = ess.DisplayName
			and gen.XMLElementName = ess.XMLElementName
			and gen.DataType = ess.DataType
			and gen.EndPosition = ess.EndPosition
			and gen.IsOptional = ess.IsOptional
			and gen.SequenceNumber = ess.SequenceNumber
			and gen.StartPosition = ess.StartPosition
			and gen.SubmissionYear = ess.SubmissionYear
			and gen.OrganizationLevelId = ess.OrganizationLevelId
			and gen.ReportCode = ess.ReportCode
		where ISNULL(gen.SubmissionYear,@SubmissionYear) = @SubmissionYear
		and ISNULL(gen.ReportCode,@ReportCode) = @ReportCode
		and ISNULL(ess.SubmissionYear,@SubmissionYear) = @SubmissionYear
		and ISNULL(ess.ReportCode,@ReportCode) = @ReportCode
		and (
			gen.ReportCode IS NULL
			OR ess.ReportCode IS NULL
		)

		DECLARE @countColumnDiscrepancies int,@countOptionDiscrepancies int

		SELECT @countColumnDiscrepancies = count(*)
		FROM #columnDiscrepancies

		SELECT @countOptionDiscrepancies = count(*)
		FROM #optionDiscrepancies

		IF (@countColumnDiscrepancies + @countOptionDiscrepancies = 0)
		BEGIN
			PRINT 'No discrepancies found in ' + @ReportCode + ' ' + CAST(@SubmissionYear AS varchar(4)) + ' metadata.'
		END
		ELSE
			PRINT '!!!Discrepancies found in ' + @ReportCode + ' ' + CAST(@SubmissionYear AS varchar(4)) + ' metadata!!!'

		SELECT [ColumnLength]  = [genColumnLength] 
			,[ColumnName]  = [genColumnName] 
			,[DimensionFieldName]  = [genDimensionFieldName] 
			,[DisplayName]  = [genDisplayName] 
			,[XMLElementName]  = [genXMLElementName] 
			,[DataType]  = [genDataType] 
			,[EndPosition]  = [genEndPosition] 
			,[IsOptional]  = [genIsOptional] 
			,[SequenceNumber]  = [genSequenceNumber] 
			,[StartPosition]  = [genStartPosition] 
			,[SubmissionYear]  = [genSubmissionYear] 
			,[OrganizationLevelId] = [genOrganizationLevelId] 
			,[ReportCode]  = [genReportCode] 
		INTO #columnsNotInESS
		FROM #columnDiscrepancies
		WHERE essReportCode IS NULL

		SELECT [ColumnLength]  = [essColumnLength] 
			,[ColumnName]  = [essColumnName] 
			,[DimensionFieldName]  = [essDimensionFieldName] 
			,[DisplayName]  = [essDisplayName] 
			,[XMLElementName]  = [essXMLElementName] 
			,[DataType]  = [essDataType] 
			,[EndPosition]  = [essEndPosition] 
			,[IsOptional]  = [essIsOptional] 
			,[SequenceNumber]  = [essSequenceNumber] 
			,[StartPosition]  = [essStartPosition] 
			,[SubmissionYear]  = [essSubmissionYear] 
			,[OrganizationLevelId] = [essOrganizationLevelId] 
			,[ReportCode]  = [essReportCode]  
		INTO #columnsNotInGenerate
		FROM #columnDiscrepancies
		WHERE genReportCode IS NULL

		SELECT [ReportCode]  = [genReportCode] 
			,[FileSubmissionDescription] = [genFileSubmissionDescription] 
			,[OrganizationLevelId]  = [genOrganizationLevelId] 
			,[SubmissionYear]  = [genSubmissionYear] 
			,[CategorySetCode]  = [genCategorySetCode] 
			,[CategorySetName]  = [genCategorySetName] 
			,[EdFactsTableTypeGroupId]  = [genEdFactsTableTypeGroupId] 
			,[EdFactsTableTypeId]  = [genEdFactsTableTypeId] 
			,[TableTypeAbbrv]  = [genTableTypeAbbrv] 
			,[TableTypeName]  = [genTableTypeName] 
			,[CategoryCode]  = [genCategoryCode] 
			,[CategoryName]  = [genCategoryName] 
			,[EdFactsCategoryId]  = [genEdFactsCategoryId] 
			,[CategoryOptionCode]  = [genCategoryOptionCode] 
			,[CategoryOptionName]  = [genCategoryOptionName] 
			,[EdFactsCategoryCodeId]  = [genEdFactsCategoryCodeId] 
		INTO #optionsNotInESS
		FROM #optionDiscrepancies
		WHERE essReportCode IS NULL

		SELECT [ReportCode]  = [essReportCode] 
			,[FileSubmissionDescription] = [essFileSubmissionDescription] 
			,[OrganizationLevelId]  = [essOrganizationLevelId] 
			,[SubmissionYear]  = [essSubmissionYear] 
			,[CategorySetCode]  = [essCategorySetCode] 
			,[CategorySetName]  = [essCategorySetName] 
			,[EdFactsTableTypeGroupId]  = [essEdFactsTableTypeGroupId] 
			,[EdFactsTableTypeId]  = [essEdFactsTableTypeId] 
			,[TableTypeAbbrv]  = [essTableTypeAbbrv] 
			,[TableTypeName]  = [essTableTypeName] 
			,[CategoryCode]  = [essCategoryCode] 
			,[CategoryName]  = [essCategoryName] 
			,[EdFactsCategoryId]  = [essEdFactsCategoryId] 
			,[CategoryOptionCode]  = [essCategoryOptionCode] 
			,[CategoryOptionName]  = [essCategoryOptionName] 
			,[EdFactsCategoryCodeId]  = [essEdFactsCategoryCodeId] 
		INTO #optionsNotInGenerate
		FROM #optionDiscrepancies
		WHERE genReportCode IS NULL

		IF (SELECT COUNT(*) FROM #columnsNotInESS) > 0
		BEGIN
			SELECT 'The following column records are not in ESS'
			SELECT * FROM #columnsNotInESS
		END

		IF (SELECT COUNT(*) FROM #columnsNotInGenerate) > 0
		BEGIN
			SELECT 'The following column records are not in Generate'
			SELECT * FROM #columnsNotInGenerate
		END

		IF (SELECT COUNT(*) FROM #optionsNotInESS) > 0
		BEGIN
			SELECT 'The following option records are not in ESS'
			SELECT * FROM #optionsNotInESS
		END

		IF (SELECT COUNT(*) FROM #optionsNotInGenerate) > 0
		BEGIN
			SELECT 'The following option records are not in Generate'
			SELECT * FROM #optionsNotInGenerate
		END


		COMMIT
	END TRY
	BEGIN CATCH
		THROW
		ROLLBACK TRAN
	END CATCH


