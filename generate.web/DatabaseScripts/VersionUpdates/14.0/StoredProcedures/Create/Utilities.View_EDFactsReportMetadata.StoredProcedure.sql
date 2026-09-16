CREATE PROCEDURE [Utilities].[View_EDFactsReportMetadata] (
	@reportCode nvarchar(3),
	@reportYear nvarchar(4)
)
AS
BEGIN

	/*
		This utility displays the main pieces of the metadata that drives most of the file specification 
		logic in Generate.  
		The parameters required are the 3 digit EDFacts report code and the 4 digit School Year.  

		Sample Execution:
		exec [Utilities].[View_EDFactsReportMetadata] '002', '2025'

		This utility returns 3 separate results sets:
		1. The category sets, by Organization Level, that are part of that file specification and what 
			categories are part of that category set
		2. The permitted values (option set values) for each category that is part of that file specification
		3. The layout of the submission file for each Organization Level that is required
	*/

	--check that the @reportCode value is valid
	if len(@reportCode) <> 3 or @reportCode like '%[^0-9]%'
	begin
		print 'Invalid ReportCode value passed in, use only the 3 digit file specification number';

		insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), 4, 'Invalid ReportCode value passed in, only use the 3 digit file specification number')

		return
	end

	--check that the @reportCode value is valid
	if isnull(len(@reportYear), '') <> 4 or @reportYear like '%[^0-9]%'
	begin
		print 'Invalid ReportYear value passed in, use the 4 digit year';

		insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), 4, 'Invalid ReportYear value passed in')

		return
	end

	--declare the variables for the dynamic sql that will be used for the metadata queries
	declare @sql_categoryData nvarchar(max)
	declare @sql_permittedValuesByCategory nvarchar(max)
	declare @sql_fileSubmission nvarchar(max)

	declare @GenerateReportId INT
	set @GenerateReportId = (
		select generateReportId
		from App.GenerateReports
		where reportcode = @reportCode
	)

	--------------------------------------------------------
	--Category data by report code ordered by Org level
	--------------------------------------------------------
	SET @sql_categoryData = N'
		SELECT 
			' + @reportCode + ' AS ReportCode
			, cs.OrganizationLevelId
			, case cs.OrganizationLevelId
				when 1 then ''SEA''
				when 2 then ''LEA''
				when 3 then ''SCH''
				else NULL
			end as OrganizationLevel
			, cs.CategorySetCode
			, STRING_AGG(c.CategoryName, '', '') AS CategoryNames
		FROM app.CategorySets cs
		INNER JOIN app.CategorySet_Categories cc
			ON cs.CategorySetId = cc.CategorySetId
		INNER JOIN app.Categories c
			ON cc.CategoryId = c.CategoryId
		WHERE SubmissionYear = ' + @reportYear + '
			AND GenerateReportId = @GenerateReportId
		GROUP BY cs.CategorySetCode
				, cs.OrganizationLevelId
		ORDER BY cs.OrganizationLevelId
	';

	EXEC sp_executesql @sql_categoryData,
		N'@SubmissionYear INT, @GenerateReportId INT', 
		@SubmissionYear = @ReportYear, 
		@GenerateReportId = @GenerateReportId;


	--------------------------------------------------------
	--Category data by report code ordered by Org level
	--------------------------------------------------------
	SET @sql_permittedValuesByCategory = N'
		SELECT 
			' + @reportCode + ' AS ReportCode
			, cs.OrganizationLevelId
			, case cs.OrganizationLevelId
				when 1 then ''SEA''
				when 2 then ''LEA''
				when 3 then ''SCH''
				else NULL
			end as OrganizationLevel
			, c.CategoryName
			, co.CategoryOptionCode
			, co.CategoryOptionName
		FROM app.CategorySets cs
		JOIN app.CategorySet_Categories cc
			ON cs.CategorySetId = cc.CategorySetId
		JOIN app.Categories c
			ON cc.CategoryId = c.CategoryId
		JOIN app.CategoryOptions co
			ON co.CategorySetId = cs.CategorySetId
			AND co.CategoryId = c.CategoryId
		WHERE SubmissionYear = ' + @reportYear + '
			AND GenerateReportId = @GenerateReportId
		GROUP BY cs.OrganizationLevelId
				, c.CategoryName
				, co.CategoryOptionCode
				, co.CategoryOptionName
		ORDER BY cs.OrganizationLevelId
				, c.CategoryName
				, co.CategoryOptionName
	';

	EXEC sp_executesql @sql_permittedValuesByCategory,
		N'@SubmissionYear INT, @GenerateReportId INT', 
		@SubmissionYear = @ReportYear, 
		@GenerateReportId = @GenerateReportId;


	--------------------------------------------------------
	--File Submission data by report code
	--------------------------------------------------------
	SET @sql_fileSubmission = N'
		SELECT 
			' + @reportCode + ' AS ReportCode
			, fs.OrganizationLevelId
			, case fs.OrganizationLevelId
				when 1 then ''SEA''
				when 2 then ''LEA''
				when 3 then ''SCH''
				else NULL
			end as OrganizationLevel
			, fc.ColumnName
			, fsfc.SequenceNumber
			, fc.ColumnLength
		FROM app.filesubmissions fs
		JOIN app.filesubmission_filecolumns fsfc 
			ON fs.FileSubmissionId = fsfc.FileSubmissionId
		JOIN app.filecolumns fc 
			ON fsfc.filecolumnid = fc.FileColumnId
		WHERE SubmissionYear = ' + @reportYear + '
			AND GenerateReportId = @GenerateReportId
		GROUP BY fs.OrganizationLevelId
				, fc.ColumnName
				, fc.ColumnLength
				, fsfc.SequenceNumber
		ORDER BY fs.OrganizationLevelId
				, fsfc.SequenceNumber 
	';

	EXEC sp_executesql 
		@sql_fileSubmission, 
		N'@SubmissionYear INT, @GenerateReportId INT', 
		@SubmissionYear = @ReportYear, 
		@GenerateReportId = @GenerateReportId;

END



