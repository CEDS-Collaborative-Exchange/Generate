CREATE PROCEDURE [Utilities].[Compare_ASSESSMENTS]
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
December 5, 2023

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


if @ReportCode not in ('175', '178', '179', '185', '188', '189', '224', '225')
	begin
		print '@ReportCode must be 175, 178, 179, 185, 188, 189, 224, 225'
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
if @ReportCode in ('175', '178', '179')
	begin
		if @ReportLevel = 'SEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL								FileRecordNumber,
					StateANSICode						FIPSStateCode,
					''01''								StateAgencyNumber,
					NULL								Filler1,
					NULL								Filler2,
					TableTypeAbbrv						TableTypeAbbrv,
					GradeLevel							GradeLevelId,
					RACE								RaceEthnicityId,
					SEX									GenderId,
					IDEAINDICATOR						DisabilityStatusId,
					ENGLISHLEARNERSTATUS				LEPStatusID,
					MIGRANTSTATUS						MigrantStatusId,
					ECONOMICDISADVANTAGESTATUS			EconDisadvantagedStatusId,
					HOMElESSNESSSTATUS					HomelessServedID,
					ASSESSMENTTYPEADMINISTERED			AssessAdministeredID,
					NULL								Filler3,
					ProficiencyStatus					ProficiencyStatusID,
					PROGRAMPARTICIPATIONFOSTERCARE		FosterCareStatusID,
					MILITARYCONNECTEDSTUDENTINDICATOR	MilitaryConnectedStudentStatusID,
					TotalIndicator						TotalIndicator,
					NULL								Explanation,
					AssessmentCount						Amount'
			end

		if @ReportLevel = 'LEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL								FileRecordNumber,
					StateANSICode						FIPSStateCode,
					''01''								StateAgencyNumber,
					OrganizationIdentifierSea			StateLEAIDNumber,
					NULL								Filler1,
					TableTypeAbbrv						TableTypeAbbrv,
					GradeLevel							GradeLevelId,
					RACE								RaceEthnicityId,
					SEX									GenderId,
					IDEAINDICATOR						DisabilityStatusId,
					ENGLISHLEARNERSTATUS				LEPStatusID,
					MIGRANTSTATUS						MigrantStatusId,
					ECONOMICDISADVANTAGESTATUS			EconDisadvantagedStatusId,
					HOMElESSNESSSTATUS					HomelessServedID,
					ASSESSMENTTYPEADMINISTERED			AssessAdministeredID,
					NULL								Filler2,
					ProficiencyStatus					ProficiencyStatusID,
					PROGRAMPARTICIPATIONFOSTERCARE		FosterCareStatusID,
					MILITARYCONNECTEDSTUDENTINDICATOR	MilitaryConnectedStudentStatusID,
					TotalIndicator						TotalIndicator,
					NULL								Explanation,
					AssessmentCount						Amount'
			end

		if @ReportLevel = 'SCH'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL								FileRecordNumber,
					StateANSICode						FIPSStateCode,
					''01''								StateAgencyNumber,
					ParentOrganizationIdentifierSea		StateLEAIDNumber,
					OrganizationIdentifierSea			StateSchoolIDNumber,
					TableTypeAbbrv						TableTypeAbbrv,
					GradeLevel							GradeLevelId,
					RACE								RaceEthnicityId,
					SEX									GenderId,
					IDEAINDICATOR						DisabilityStatusId,
					ENGLISHLEARNERSTATUS				LEPStatusID,
					MIGRANTSTATUS						MigrantStatusId,
					ECONOMICDISADVANTAGESTATUS			EconDisadvantagedStatusId,
					HOMElESSNESSSTATUS					HomelessServedID,
					ASSESSMENTTYPEADMINISTERED			AssessAdministeredID,
					NULL								Filler1,
					ProficiencyStatus					ProficiencyStatusID,
					PROGRAMPARTICIPATIONFOSTERCARE		FosterCareStatusID,
					MILITARYCONNECTEDSTUDENTINDICATOR	MilitaryConnectedStudentStatusID,
					TotalIndicator						TotalIndicator,
					NULL								Explanation,
					AssessmentCount						Amount'
			end
		end
if @ReportCode in ('C185', 'C188', 'C189')
	begin
		if @ReportLevel = 'SEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL													FileRecordNumber,
					StateANSICode											FIPSStateCode,
					''01''													StateAgencyNumber,
					NULL													Filler1,
					NULL													Filler2,
					TableTypeAbbrv											TableTypeAbbrv,
					GradeLevel												GradeLevelId,
					RACE													RaceEthnicityId,
					SEX														GenderId,
					IDEAINDICATOR											DisabilityStatusId,
					ENGLISHLEARNERSTATUS									LEPStatusID,
					MIGRANTSTATUS											MigrantStatusId,
					ECONOMICDISADVANTAGESTATUS								EconDisadvantagedStatusId,
					HOMElESSNESSSTATUS										HomelessServedID,
					PROGRAMPARTICIPATIONFOSTERCARE							FosterCareStatusID,
					MILITARYCONNECTEDSTUDENTINDICATOR						MilitaryConnectedStudentStatusID,
					NULL													Filler5,
					NULL													Filler7,
					NULL													Filler6,
					ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR			TestingStatusId,
					TotalIndicator											TotalIndicator,
					NULL													Explanation,
					AssessmentCount											Amount'
			end

		if @ReportLevel = 'LEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL													FileRecordNumber,
					StateANSICode											FIPSStateCode,
					''01''													StateAgencyNumber,
					OrganizationIdentifierSea								StateLEAIDNumber,
					TableTypeAbbrv											TableTypeAbbrv,
					GradeLevel												GradeLevelId,
					RACE													RaceEthnicityId,
					SEX														GenderId,
					IDEAINDICATOR											DisabilityStatusId,
					ENGLISHLEARNERSTATUS									LEPStatusID,
					MIGRANTSTATUS											MigrantStatusId,
					ECONOMICDISADVANTAGESTATUS								EconDisadvantagedStatusId,
					HOMElESSNESSSTATUS										HomelessServedID,
					PROGRAMPARTICIPATIONFOSTERCARE							FosterCareStatusID,
					MILITARYCONNECTEDSTUDENTINDICATOR						MilitaryConnectedStudentStatusID,
					NULL													Filler5,
					NULL													Filler7,
					NULL													Filler6,
					ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR			TestingStatusId,
					TotalIndicator											TotalIndicator,
					NULL													Explanation,
					AssessmentCount											Amount'
			end

		if @ReportLevel = 'SCH'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL													FileRecordNumber,
					StateANSICode											FIPSStateCode,
					''01''													StateAgencyNumber,
					ParentOrganizationIdentifierSea							StateLEAIDNumber,
					OrganizationIdentifierSea								StateSchoolIDNumber,
					TableTypeAbbrv											TableTypeAbbrv,
					GradeLevel												GradeLevelId,
					RACE													RaceEthnicityId,
					SEX														GenderId,
					IDEAINDICATOR											DisabilityStatusId,
					ENGLISHLEARNERSTATUS									LEPStatusID,
					MIGRANTSTATUS											MigrantStatusId,
					ECONOMICDISADVANTAGESTATUS								EconDisadvantagedStatusId,
					HOMElESSNESSSTATUS										HomelessServedID,
					PROGRAMPARTICIPATIONFOSTERCARE							FosterCareStatusID,
					MILITARYCONNECTEDSTUDENTINDICATOR						MilitaryConnectedStudentStatusID,
					NULL													Filler5,
					NULL													Filler7,
					NULL													Filler6,
					ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR			TestingStatusId,
					TotalIndicator											TotalIndicator,
					NULL													Explanation,
					AssessmentCount											Amount'
			end
end
if @ReportCode in ('224')
	begin
		select @SQL = @SQL + '
		select distinct 
			NULL								FileRecordNumber,
			StateANSICode						FIPSStateCode,
			''01''								StateAgencyNumber,
			NULL								Filler1,
			NULL								Filler2,
			TableTypeAbbrv						TableTypeAbbrv,
			AssessmentAcademicSubject			SubjectId,
			ProficiencyStatus					ProficiencyStatusID,
			TotalIndicator						TotalIndicator,
			NULL								Explanation,
			AssessmentCount						Amount'
		end

if @ReportCode in ('225')
	begin
		select @SQL = @SQL + '
		select distinct 
			NULL								FileRecordNumber,
			StateANSICode						FIPSStateCode,
			''01''								StateAgencyNumber,
			OrganizationIdentifierSea			StateLEAIDNumber,
			NULL								Filler1,
			TableTypeAbbrv						TableTypeAbbrv,
			AssessmentAcademicSubject			SubjectId,
			ProficiencyStatus					ProficiencyStatusID,
			TotalIndicator						TotalIndicator,
			NULL								Explanation,
			AssessmentCount						Amount'
		end

select @SQL = @SQL + char(10) +
		'FROM [' + @DatabaseName + '].rds.ReportEdFactsK12StudentAssessments FACT
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
