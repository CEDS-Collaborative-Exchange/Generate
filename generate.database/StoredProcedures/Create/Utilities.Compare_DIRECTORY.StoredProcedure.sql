CREATE PROCEDURE [Utilities].[Compare_DIRECTORY]
	@DatabaseName varchar(100),
	@SchemaName varchar(100),
	@SubmissionYear int,
	@ReportLevel varchar(5),
	@ReportCode varchar(10),
	@LegacyTableName varchar(100),
	@ShowSQL bit = 0

AS
BEGIN
/***************************************************************
January 9, 2023

Run this with the appropriate parameters to create and load data
from Generate Reports table into a table that mimics the submission
file layout and compare to a preexisting table that contains
the exact columns with data from a legacy file.

This process assumes the following:
1. The @Database parameter is a valid database on the server
2. The @SchemaName is a valid schema on the database
3. Metadata exists in Generate for the SubmissionYear, ReportCode, ReportLevel
4. The @LegacyTableName exists, is populated, and has the exact column names from the Generate Metadata

10/17/2023 JW: Updated for V11
11/29/2023 JW: Fixed issues with SCH comparison
03/25/2024 JW: Added MailingAddressApartmentRoomOrSuiteNumber and PhysicalAddressApartmentRoomOrSuiteNumber
*****************************************************************/


declare
	@CreatedTableName varchar(100) = NULL, 
	@SQL varchar(max) = '',
	@Label varchar(100) = 'Generate',
	@ComparisonResultsTableName varchar(200) = ''


if @ReportCode not in ('C029', 'C039')
	begin
		print '@ReportCode must be C029 or C039'
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

if @ReportCode = 'C029'
	begin
		if @ReportLevel = 'SEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL					FileRecordNumber,
					StateANSICode			FIPSStateCode,
					''01''					StateAgencyNumber,
					NULL					Filler,
					NULL					Filler,
					NULL					Filler6,
					NULL					Filler7,
					OrganizationName		StateAgencyName,
					Website					StateAgencyWebAddress,
					Telephone				PhoneNumber,
					MailingAddressStreet	MailingAddress1,
					MailingAddressApartmentRoomOrSuiteNumber					MailingAddress2,
					NULL					MailingAddress3,
					MailingAddressCity		MailingCity,
					MailingAddressState		MailingPostalStateCode,
					left(MailingAddressPostalCode,5)	 MailingZipCode,
					case when len(MailingAddressPostalCode)=10 then right(MailingAddressPostalCode,4) else '''' end	 MailingZipcodePlus4,
					PhysicalAddressStreet	LocationAddress1,
					PhysicalAddressApartmentRoomOrSuiteNumber					LocationAddress2,
					NULL					LocationAddress3,
					PhysicalAddressCity		LocationCity,
					PhysicalAddressState	LocationPostalStateCode,
					left(PhysicalAddressPostalCode,5)	 LocationZipCode,
					case when len(PhysicalAddressPostalCode)=10 then right(PhysicalAddressPostalCode,4) else '''' end	 LocationZipcodePlus4,
					NULL					Filler,
					NULL					Filler,
					NULL					Filler,
					NULL					Filler,
					Null					Filler,
					NULL					Explanation'
			end

		if @ReportLevel = 'LEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL					FileRecordNumber,
					StateANSICode			FIPSStateCode,
					''01''					StateAgencyNumber,
					OrganizationStateId		StateLEAIdNumber,
					OrganizationNcesId		NCESLEAIDNumber,
					NULL					Filler6,
					NULL					Filler7,
					OrganizationName		LEAName,
					case when isnull(OutOfStateIndicator,0) = 0 then ''NO'' else ''YES'' end		OutOfStateInd,
					LEAType					LEAType,
					Website					LEAWebAddress,
					SupervisoryUnionIdentificationNumber	SupervisoryUnion,
					Telephone				LEAPhoneNumber,
					MailingAddressStreet	MailingAddress1,
					MailingAddressApartmentRoomOrSuiteNumber					MailingAddress2,
					NULL					MailingAddress3,
					MailingAddressCity		MailingCity,
					MailingAddressState		MailingPostalStateCode,
					left(MailingAddressPostalCode,5)	 MailingZipCode,
					case when len(MailingAddressPostalCode)=10 then right(MailingAddressPostalCode,4) else '''' end	 MailingZipcodePlus4,
					PhysicalAddressStreet	LocationAddress1,
					PhysicalAddressApartmentRoomOrSuiteNumber					LocationAddress2,
					NULL					LocationAddress3,
					PhysicalAddressCity		LocationCity,
					PhysicalAddressState	LocationPostalStateCode,
					left(PhysicalAddressPostalCode,5)	 LocationZipCode,
					case when len(PhysicalAddressPostalCode)=10 then right(PhysicalAddressPostalCode,4) else '''' end	 LocationZipcodePlus4,
					OperationalStatus		LEASysOpstatus,
					UpdatedOperationalStatus		LEAOpStatusNew,
					NULL					StatusEffectiveDate,
					case when isnull(CharterLeaStatus,''NO'') = ''NO'' then ''CHRTNOTLEA'' else isnull(CharterLEAStatus,'''') end		ChrtSchoolLEAStatusID,
					PriorLeaStateIdentifier	PriorStateLEAID,
					NULL					Explanation'

			end

		if @ReportLevel = 'SCH'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL					FileRecordNumber,
					StateANSICode			FIPSStateCode,
					''01''					StateAgencyNumber,
					ParentOrganizationStateId StateLEAIDNumber,
					ParentOrganizationNCESId	NCESLEAIDNumber,
					OrganizationStateId		StateLEAIdNumber,
					OrganizationNcesId		NCESLEAIDNumber,
					OrganizationName		SchoolName,
					SchoolType				SchoolType,
					case when isnull(OutOfStateIndicator,0) = 0 then ''NO'' else ''YES'' end		OutOfStateInd,
					Website					WebAddress,
					Telephone				PhoneNumber,
					MailingAddressStreet	MailingAddress1,
					MailingAddressApartmentRoomOrSuiteNumber					MailingAddress2,
					NULL					MailingAddress3,
					MailingAddressCity		MailingCity,
					MailingAddressState		MailingPostalStateCode,
					left(MailingAddressPostalCode,5)	 MailingZipCode,
					case when len(MailingAddressPostalCode)=10 then right(MailingAddressPostalCode,4) else '''' end	 MailingZipcodePlus4,
					PhysicalAddressStreet	LocationAddress1,
					PhysicalAddressApartmentRoomOrSuiteNumber					LocationAddress2,
					NULL					LocationAddress3,
					PhysicalAddressCity		LocationCity,
					PhysicalAddressState	LocationPostalStateCode,
					left(PhysicalAddressPostalCode,5)	 LocationZipCode,
					case when len(PhysicalAddressPostalCode)=10 then right(PhysicalAddressPostalCode,4) else '''' end	 LocationZipcodePlus4,
					OperationalStatus		SchoolSysOpstatus,
					UpdatedOperationalStatus					SchoolOpStatusNew,
					NULL					StatusEffectiveDate,
					case when isnull(CharterSchoolStatus,''NO'') = ''NO'' then ''NO'' else ''YES'' end		ChrtStatusID,
					PriorLEAStateIdentifier		PriorStateLEAId,
					PriorSchoolStateIdentifier	PriorStateSchoolID,
					ReconstitutedStatus	ReconstitutedStatus,
					NULL	Filler,
					CharterSchoolAuthorizerIdPrimary,
					CharterSchoolAuthorizerIdSecondary,
					NULL					Explanation'
			end
	end
if @ReportCode = 'C039'
	begin
		if @ReportLevel = 'LEA'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL					FileRecordNumber,
					StateANSICode			FIPSStateCode,
					''01''					StateAgencyNumber,
					OrganizationStateId		StateLEAIdNumber,
					NULL					Filler2,
					NULL					Filler3,
					NULL					Filler4,
					GradeLevel				GradeLevelId,
					NULL					Explanation'

			end

		if @ReportLevel = 'SCH'
			begin
				select @SQL = @SQL + '
				select distinct 
					NULL					FileRecordNumber,
					StateANSICode			FIPSStateCode,
					''01''					StateAgencyNumber,
					ParentOrganizationStateId		StateLEAIdNumber,
					NULL					Filler2,
					OrganizationStateId		StateSchoolIDNumber,
					NULL					Filler4,
					GradeLevel				GradeLevelId,
					NULL					Explanation'
			end

	end

	select @SQL = @SQL + char(10) +
			'FROM generate.rds.ReportEdFactsOrganizationCounts FACT
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
if @ReportCode = 'C029'
	begin
		exec Utilities.CompareSubmissionFiles_C029
			@DatabaseName = @DatabaseName,
			@SchemaName = @SchemaName,
			@SubmissionYear = @SubmissionYear,
			@ReportCode = @ReportCode,
			@ReportLevel = @ReportLevel,
			@LegacyTableName = @LegacyTableName, 
			@GenerateTableName = @CreatedTableName,
			@ShowSQL = @ShowSQL,
				@ComparisonResultsTableName = @ComparisonResultsTableName output
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
			@GenerateTableName = @CreatedTableName,
			@ShowSQL = @ShowSQL,
			@ComparisonResultsTableName = @ComparisonResultsTableName output

	end

	print 'RESULTS ARE LOCATED IN ' + @ComparisonResultsTableName

END

