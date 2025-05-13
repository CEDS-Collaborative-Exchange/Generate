CREATE PROCEDURE [Utilities].[Compare_EXITING]
	@DatabaseName varchar(100),
	@SchemaName varchar(100),
	@SubmissionYear int,
	@ReportCode varchar(10),
	@ReportLevel varchar(5),
	@LegacyTableName varchar(100),
	@ShowSQL bit = 0

AS
BEGIN
/***************************************************************
December 20, 2023

Run this with the appropriate parameters to create and load data
from Generate Reports table into a table that mimics the submission
file layout and compare to a preexisting table that contains
the exact columns with data from a legacy file.

This process assumes the following:
1. The @Database parameter is a valid database on the server
2. The @SchemaName is a valid schema on the database
3. Metadata exists in Generate for the SubmissionYear, ReportCode, ReportLevel
4. The @LegacyTableName exists, is populated, and has the exact column names from the Generate Metadata
*****************************************************************/

declare
	@CreatedTableName varchar(100) = NULL, 
	@SQL varchar(max) = '',
	@Label varchar(100) = 'Generate',
	@ComparisonResultsTableName varchar(200) = ''


if @ReportCode not in ('C009')
	begin
		print '@ReportCode must be C009'
		return
	end

exec Utilities.CreateSubmissionFileTable
	@DatabaseName = @DatabaseName,
	@SchemaName = @SchemaName,
	@SubmissionYear = @SubmissionYear,
	@ReportCode = @ReportCode,
	@ReportLevel = @ReportLevel,
	@Label = @Label,
	@ShowSQL = 0, 
	@CreatedTableName = @CreatedTableName OUTPUT



select @SQL = 'INSERT INTO ' + @CreatedTableName

	if @ReportLevel = 'SEA'
		begin
			select @SQL = @SQL + '
			select distinct 
				NULL							FileRecordNumber,
				StateANSICode					FIPSStateCode,
				''01''							StateAgencyNumber,
				OrganizationIdentifierSea		Filler1,
				NULL							Filler2,
				TableTypeAbbrv					TableTypeAbbrv,
				NULL							Filler3,
				Race							RaceEthnicityId,
				Sex								GenderId,
				NULL							Filler4,
				NULL							Filler5,
				NULL							Filler6,
				NULL							Filler7,
				NULL							Filler8,
				NULL							Filler9,
				IDEADISABILITYTYPE				DisabilityCategoryId,
				Age								AgeID,
				EnglishLearnerStatus			LEPStatusID,
				NULL							Filler11,
				NULL							Filler12,
				NULL							Filler13,
				SPECIALEDUCATIONEXITREASON		BasisOfExitId,
				TotalIndicator					TotalIndicator,
				NULL							Explanation,
				StudentCount					Amount'
		end

	if @ReportLevel = 'LEA'
		begin
			select @SQL = @SQL + '
			select distinct 
				NULL							FileRecordNumber,
				StateANSICode					FIPSStateCode,
				''01''							StateAgencyNumber,
				OrganizationIdentifierSea		StateLEAIDNumber,
				NULL							Filler2,
				TableTypeAbbrv					TableTypeAbbrv,
				NULL							Filler3,
				Race							RaceEthnicityId,
				Sex								GenderId,
				NULL							Filler4,
				NULL							Filler5,
				NULL							Filler6,
				NULL							Filler7,
				NULL							Filler8,
				NULL							Filler9,
				IDEADISABILITYTYPE				DisabilityCategoryId,
				Age								AgeID,
				EnglishLearnerStatus			LEPStatusID,
				NULL							Filler11,
				NULL							Filler12,
				NULL							Filler13,
				SPECIALEDUCATIONEXITREASON		BasisOfExitId,
				TotalIndicator					TotalIndicator,
				NULL							Explanation,
				StudentCount					Amount'

		end



select @SQL = @SQL + char(10) +
		'FROM [' + @DatabaseName + '].rds.ReportEDFactsK12StudentCounts FACT
			where 
			ReportCode = ''' + @ReportCode + '''
			and ReportLevel = ''' + @ReportLevel + '''
			and ReportYear = ' + convert(varchar, @SubmissionYear) + char(10)

if @ShowSQL = 1
	begin
		select @SQL
	end
else
	begin
		exec (@SQL)
	end

-- NOW DO THE COMPARISON ----------------------
			exec Utilities.CompareSubmissionFiles
				@DatabaseName = @DatabaseName,
				@SchemaName = @SchemaName,
				@SubmissionYear = @SubmissionYear,
				@ReportCode = @ReportCode,
				@ReportLevel = @ReportLevel,
				@LegacyTableName = @LegacyTableName, 
				@GenerateTableName = @CreatedTableName,
				@ShowSQL = @ShowSQL,
				@ComparisonResultsTableName = @ComparisonResultsTableName output

	print 'RESULTS ARE LOCATED IN ' + @ComparisonResultsTableName

END



