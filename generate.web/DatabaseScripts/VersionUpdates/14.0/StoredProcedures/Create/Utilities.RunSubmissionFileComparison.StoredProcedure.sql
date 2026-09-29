CREATE PROCEDURE [Utilities].[RunSubmissionFileComparison]
		@DatabaseName varchar(100),-- = 'TESTING', -- If NULL then DatabaseName = 'Generate'
		@SchemaName varchar(25), -- = 'NH',
		@SubmissionYear int, -- = 2022,
		@ReportCode varchar(5), -- = 'C175',
		@ReportLevel varchar(5), -- = 'SEA',
		@LegacySourceFilePathAndName varchar(200), -- = 'D:\AEM\0 New Hampshire\Assessment\2022 Files\LegacyProcess\NH_SEA_STUPERFMA.TAB',
		@GenerateSourceFilePathAndName varchar(200), -- = 'D:\AEM\0 New Hampshire\Assessment\2022 Files\GenerateProcess\NHSEASTUPERFMAv182744.TAB',
		@FileType varchar(5) = NULL, --'CSV', -- If NULL or 'TAB' then TAB
		@ShowSQL bit -- = 0


AS
BEGIN

/***************************************************************
November 22, 2022

Run this with the appropriate parameters to create and load data
from a Generate (or legacy-produced) submission file into a database
table.

This process assumes the following:
1. The @Database parameter is a valid database on the server
2. The @SchemaName is a valid schema on the database
3. Metadata exists in Generate for the SubmissionYear, ReportCode, ReportLevel
4. The @SourceFilePathAndName is the fully qualified path to an existing file
5. The @SourceFilePathAndName is in the same format as the ReportCode and ReportLevel
6. The @SourceFilePathAndName file has the header row REMOVED
7. SQL Bulk Insert is available and the user has authorization to execute it
*****************************************************************/

	SET NOCOUNT ON

	declare @CreatedTableName varchar(100) = NULL


-- LEGACY -------------------------------------------------------------------
	exec Utilities.CreateSubmissionFileTable
		@DatabaseName = @DatabaseName,
		@SchemaName = @SchemaName,
		@SubmissionYear = @SubmissionYear,
		@ReportCode = @ReportCode,
		@ReportLevel = @ReportLevel,
		@Label = 'Legacy', 
		@ShowSQL = @ShowSQL,
		@CreatedTableName = @CreatedTableName OUTPUT
		
	exec Utilities.LoadSubmissionFileTable
		@TargetTableName = @CreatedTableName,
		@SourceFilePathAndName = @LegacySourceFilePathAndName,
		@FileType = @FileType,
		@ShowSQL = @ShowSQL

-- GENERATE -------------------------------------------------------------------
	exec Utilities.CreateSubmissionFileTable
		@DatabaseName = @DatabaseName,
		@SchemaName = @SchemaName,
		@SubmissionYear = @SubmissionYear,
		@ReportCode = @ReportCode,
		@ReportLevel = @ReportLevel,
		@Label = 'Generate', 
		@ShowSQL = @ShowSQL,
		@CreatedTableName = @CreatedTableName OUTPUT

	exec Utilities.LoadSubmissionFileTable
		@TargetTableName = @CreatedTableName,
		@SourceFilePathAndName = @GenerateSourceFilePathAndName,
		@FileType = @FileType,
		@ShowSQL = @ShowSQL

-- BUILD COMPARISON ----------------------------------------------------------

	declare @LegacyTableName varchar(200), @GenerateTableName varchar(200), @ComparisonTableName varchar(200)

	select @LegacyTableName = @DatabaseName + '.' + @SchemaName + '.' + @ReportCode + '_' + @ReportLevel + '_' + convert(varchar, @SubmissionYear) + '_Legacy'
	select @GenerateTableName = @DatabaseName + '.' + @SchemaName + '.' + @ReportCode + '_' + @ReportLevel + '_' + convert(varchar, @SubmissionYear) + '_Generate'
	select @ComparisonTableName = @DatabaseName + '.' + @SchemaName + '.' + @ReportCode + '_' + @ReportLevel + '_' + convert(varchar, @SubmissionYear) + '_Comparison'


	if @ReportCode = 'C029'
		begin
			exec Utilities.CompareSubmissionFiles_C029
				@DatabaseName = @DatabaseName,
				@SchemaName = @SchemaName,
				@SubmissionYear = @SubmissionYear,
				@ReportCode = @ReportCode,
				@ReportLevel = @ReportLevel,
				@LegacyTableName = @LegacyTableName, 
				@GenerateTableName = @GenerateTableName,
				@ShowSQL = @ShowSQL,
				@ComparisonResultsTableName = @ComparisonTableName

		end
	if @ReportCode = 'C039'
		begin
			exec Utilities.CompareSubmissionFiles_C039
				@DatabaseName = @DatabaseName,
				@SchemaName = @SchemaName,
				@SubmissionYear = @SubmissionYear,
				@ReportCode = @ReportCode,
				@ReportLevel = @ReportLevel,
				@LegacyTableName = @LegacyTableName, 
				@GenerateTableName = @GenerateTableName,
				@ShowSQL = @ShowSQL,
				@ComparisonResultsTableName = @ComparisonTableName

		end		
	else
		begin
			exec Utilities.CompareSubmissionFiles
				@DatabaseName = @DatabaseName,
				@SchemaName = @SchemaName,
				@SubmissionYear = @SubmissionYear,
				@ReportCode = @ReportCode,
				@ReportLevel = @ReportLevel,
				@LegacyTableName = @LegacyTableName, 
				@GenerateTableName = @GenerateTableName,
				@ShowSQL = @ShowSQL
		end

print 'RESULTS ARE LOCATED IN TABLE ' + @ComparisonTableName


END

