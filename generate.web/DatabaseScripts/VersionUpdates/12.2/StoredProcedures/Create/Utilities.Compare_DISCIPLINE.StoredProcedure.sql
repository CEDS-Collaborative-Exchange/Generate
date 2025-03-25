CREATE PROCEDURE [Utilities].[Compare_DISCIPLINE]
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
February 1, 2024

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


if @ReportCode not in ('C005', 'C006', 'C007', 'C088', 'C143', 'C144')
	begin
		print '@ReportCode must be C005, C006, C007, C088, C143 or C144'
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
if @ReportCode = 'C088'
	begin
		if @ReportLevel = 'SEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL							FileRecordNumber,
					StateANSICode					FIPSStateCode,
					''01''							StateAgencyNumber,
					NULL							Filler4,
					NULL							Filler5,'
			end

		if @ReportLevel = 'LEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL							FileRecordNumber,
					StateANSICode					FIPSStateCode,
					''01''							StateAgencyNumber,
					OrganizationIdentifierSea   	StateLEAIDNumber,
					NULL							Filler5,'
			end

	end
else -- All other file specs use Filler1 and Filler2
	begin
		if @ReportLevel = 'SEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL							FileRecordNumber,
					StateANSICode					FIPSStateCode,
					''01''							StateAgencyNumber,
					NULL							Filler1,
					NULL							Filler2,'
			end

		if @ReportLevel = 'LEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL							FileRecordNumber,
					StateANSICode					FIPSStateCode,
					''01''							StateAgencyNumber,
					OrganizationIdentifierSea   	StateLEAIDNumber,
					NULL							Filler2,'
			end

	end

if @ReportCode = 'C005'
	begin
		select @SQL = @SQL + '
					TableTypeAbbrv					TableTypeAbbrv,
					Sex								GenderId,
					Race							RaceEthnicityId,
					ENGLISHLEARNERSTATUS			LEPStatusID,
					NULL							Filler4,
					NULL							Filler5,
					NULL							Filler6,
					NULL							Filler7,
					NULL							Filler8,
					NULL							Filler9,
					IDEADISABILITYTYPE				DisabilityCategoryId,
					NULL							Filler10,
					IDEAINTERIMREMOVAL				RemovalTypeId,
					TotalIndicator					TotalIndicator,
					NULL							Explanation,
					DisciplineCount					Amount'
	end

if @ReportCode = 'C006'
	begin
		select @SQL = @SQL + '
					TableTypeAbbrv					TableTypeAbbrv,
					REMOVALLENGTH					RemovalLengthId,
					Race							RaceEthnicityId,
					Sex								GenderId,
					NULL							Filler5,
					NULL							Filler6,
					NULL							Filler7,
					NULL							Filler8,
					NULL							Filler9,
					NULL							Filler10,
					IDEADISABILITYTYPE				DisabilityCategoryId,
					ENGLISHLEARNERSTATUS			LEPStatusID,
					DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES	DisciplineMethodId,
					TotalIndicator					TotalIndicator,
					NULL							Explanation,
					DisciplineCount					Amount'

	end

if @ReportCode = 'C007'
	begin
		select @SQL = @SQL + '
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
					ENGLISHLEARNERSTATUS			LEPStatusID,
					IDEAINTERIMREMOVALREASON		RemovalReasonID,
					TotalIndicator					TotalIndicator,
					NULL							Explanation,
					DisciplineCount					Amount'

	end


if @ReportCode = 'C088'
	begin
		select @SQL = @SQL + '
					TableTypeAbbrv					TableTypeAbbrv,
					Sex								GenderId,
					Race							RaceEthnicityId,
					REMOVALLENGTH					RemovalLengthId,
					IDEADISABILITYTYPE				DisabilityCategoryId,
					ENGLISHLEARNERSTATUS			LEPStatusID,
					TotalIndicator					TotalIndicator,
					NULL							Explanation,
					DisciplineCount					Amount'

	end

if @ReportCode = 'C143'
	begin
		select @SQL = @SQL + '
					TableTypeAbbrv					TableTypeAbbrv,
					Sex								GenderId,
					Race							RaceEthnicityId,
					ENGLISHLEARNERSTATUS			LEPStatusID,
					IDEADISABILITYTYPE				DisabilityCategoryId,
					NULL							Filler3,
					TotalIndicator					TotalIndicator,
					NULL							Explanation,
					DisciplineCount					Amount'

	end

if @ReportCode = 'C144'
	begin
		select @SQL = @SQL + '
					TableTypeAbbrv					TableTypeAbbrv,
					IDEAINDICATOR					DisabilityStatusId,
					EDUCATIONALSERVICESAFTERREMOVAL	EducationServicesId,
					NULL							Filler3,
					TotalIndicator					TotalIndicator,
					NULL							Explanation,
					DisciplineCount					Amount'


	end

select @SQL = @SQL + char(10) +
		'FROM [' + @DatabaseName + '].rds.ReportEDFactsK12StudentDisciplines FACT
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



