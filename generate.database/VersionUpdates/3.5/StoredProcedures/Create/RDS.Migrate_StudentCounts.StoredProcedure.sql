CREATE PROCEDURE [RDS].[Migrate_StudentCounts]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN
	SET NOCOUNT ON;
	-- Lookup values
	declare @factTable as varchar(50)
	set @factTable = 'FactStudentCounts'
	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	
	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	set @migrationType='rds'

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	declare @useCutOffDate as bit
	set @useCutOffDate = 0

	if @factTypeCode in ('childcount','membership','titleIIIELOct')
	BEGIN
		set @useCutOffDate = 1
	END
	
	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end


	-- Get Dimension Data
	----------------------------

	-- Migrate_DimDates

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimStudentId int,
		StudentPersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,

		AgeCode varchar(50),
		RaceCode varchar(50),

		EcoDisStatusCode varchar(50),
		HomelessStatusCode varchar(50),
		LepStatusCode varchar(50),
		MigrantStatusCode varchar(50),
		SexCode varchar(50),
		MilitaryConnected varchar(50),
		HomelessUnaccompaniedYouthStatusCode varchar(50),
		HomelessNighttimeResidenceCode varchar(50),

		IDEAIndicatorCode varchar(50),
		BasisOfExitCode varchar(50),
		DisabilityCode varchar(50),
		EducEnvCode varchar(50),
		StudentCutOverStartDate Date,
		--TitleIStatusCode varchar(50),
		GradeLevelCode varchar(50),

		CteCode varchar(50),
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50),
		HomelessServicedIndicatorCode varchar(50),

		LanguageCode varchar(50),

		ContinuationOfServiceStatus varchar(50),
		MigrantPriorityForServiceCode varchar(50),
		MepServiceTypeCode varchar(50),
		MepFundStatus varchar(50),
		MepEnrollmentTypeCode varchar(50),

		MobilityStatus12moCode varchar(50),
		MobilityStatus36moCode varchar(50),
		MobilityStatusSYCode varchar(50),
		ReferralStatusCode varchar(50),
		DiplomaCredentialCode varchar(50),
		DisplacedHomemaker varchar(50),
		SingleParent varchar(50),
		CteNonTraditionalEnrollee varchar(50),
		PlacementType varchar(50),
		PlacementStatus varchar(50),
		RepresentationStatus varchar(50),
		InclutypCode varchar(50),
		LepPerkinsStatus varchar(50),

		TitleISchoolStatusCode varchar(50),
		TitleIinstructionalServiceCode varchar(50),		
		Title1SupportServiceCode varchar(50),
		Title1ProgramTypeCode varchar(50),

		TitleIIIAccountabilityCode varchar(50),
		TitleIIILanguageInstructionCode varchar(50),		
		ProficiencyStatusCode varchar(50),
		FormerEnglishLearnerYearStatus varchar(50),

		AbsenteeismCode varchar(50),
		PostSecondaryEnrollmentStatusCode varchar(50),
		AcademicOrVocationalOutcomeCode varchar(50),
		AcademicOrVocationalExitOutcomeCode varchar(50),
		CohortStatus varchar(10),

		LongTermStatusCode nvarchar(50),
		NeglectedProgramTypeCode nvarchar(50),

		ExitCode nvarchar(50),

		NSLPDirectCertificationIndicatorCode nvarchar(50)

	)
	
	declare @studentDateQuery as rds.StudentDateTableType
	
	declare @raceQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		RaceCode varchar(50),
		RaceRecordStartDate datetime,
		RaceRecordEndDate datetime
	)
	
	declare @ageQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		AgeCode varchar(50)
	)
	
	declare @demoQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		EcoDisStatusCode varchar(50),
		HomelessStatusCode varchar(50),
		HomelessUnaccompaniedYouthStatusCode varchar(50),
		LepStatusCode varchar(50),
		MigrantStatusCode varchar(50),
		SexCode varchar(50),
		MilitaryConnected varchar(50),
		HomelessNighttimeResidenceCode varchar(50),
		PersonStartDate DateTime,
		PersonEndDate DateTime
	)
	
	declare @schoolQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		Organizationid int
		unique clustered (DimStudentId, DimSchoolId, DimCountDateId, DimLeaId, OrganizationId)
	)
	
	declare @ideaQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		IDEAIndicatorCode varchar(50),
		DisabilityCode varchar(50),
		EducEnvCode varchar(50),
		BasisOfExitCode varchar(50),
		SpecialEducationServicesExitDate Date
	)
	
	declare @programStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50),
		HomelessServicedIndicatorCode varchar(50)
	)



	declare @gradelevelQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		GradeLevelCode Varchar(50)
	)

	declare @languageQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		LanguageCode varchar(50)
	)
	
	declare @migrantQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		ContinuationOfServiceStatus varchar(50),
		MigrantPriorityForServiceCode varchar(50),
		MepServiceTypeCode varchar(50),
		MepFundStatus varchar(50),
		MepEnrollmentTypeCode varchar(50)		
	)

	declare @studentenrollmentQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		PostSecondaryEnrollmentStatusCode varchar(50)
	)
	
	declare @studentStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		MobilityStatus12moCode varchar(50),
		MobilityStatus36moCode varchar(50),
		MobilityStatusSYCode varchar(50),
		ReferralStatusCode varchar(50),
		DiplomaCredentialCode varchar(50),
		PlacementType varchar(50),
		PlacementStatus varchar(50),
		NSLPDirectCertificationIndicatorCode varchar(50)
	)
	
	declare @title1StatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		TitleISchoolStatusCode varchar(50),
		TitleIinstructionalServiceCode varchar(50),		
		Title1SupportServiceCode varchar(50),
		Title1ProgramTypeCode varchar(50)
	)

	declare @titleIIIStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		TitleIIIAccountabilityCode varchar(50),
		TitleIIILanguageInstructionCode varchar(50),		
		ProficiencyStatusCode varchar(50),
		FormerEnglishLearnerYearStatus varchar(50)
	)
	
	declare @attendanceQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		AbsenteeismCode varchar(50)
	)

	declare @studentCohortStatus as table (
		DimStudentId int,
		PersonId integer, 
		CohortYear varchar(10), 
		CohortDescription varchar(30),
		DiplomaOrCredentialAwardDate datetime,
		CohortStatus varchar(10)
	)

	declare @NoDProgramStatus as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int, 
		DimCountDateId int,
		LongTermStatusCode varchar(10), 
		NeglectedProgramTypeCode varchar(30),
		AcademicOrVocationalOutcomeCode varchar(50),
		AcademicOrVocationalExitOutcomeCode varchar(50)
	)

	declare @cteStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		CteCode varchar(50),
		DisplacedHomemaker varchar(50),
		SingleParent varchar(50),
		CteNonTraditionalEnrollee varchar(50),
		RepresentationStatus varchar(50),
		InclutypCode varchar(50),
		LepPerkinsStatus varchar(50)
	)

	declare @enrollmentStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		ExitCode varchar(50)
	 )

	declare @factDimensions as table(
		DimensionTableName nvarchar(100)
	)

	insert into @factDimensions(DimensionTableName)
	select dt.DimensionTableName 
	from rds.DimFactType_DimensionTables ftd
	inner join rds.DimFactTypes ft on ftd.DimFactTypeId = ft.DimFactTypeId
	inner join app.DimensionTables dt on ftd.DimensionTableId = dt.DimensionTableId
	where ft.FactTypeCode = @factTypeCode
		

	BEGIN TRY
	
	declare @selectedDate as int, @submissionYear as varchar(50)
	DECLARE selectedYears_cursor CURSOR FOR 
	select d.DimDateId, d.SubmissionYear
		from rds.DimDates d
		inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimDateId <> -1 
		and dd.IsSelected=1 and DataMigrationTypeCode=@migrationType


	OPEN selectedYears_cursor
	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	WHILE @@FETCH_STATUS = 0
	BEGIN

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @submissionYear)
	END
	

	delete from #queryOutput
	delete from @studentDateQuery
	delete from @raceQuery
	delete from @ageQuery
	delete from @demoQuery
	delete from @schoolQuery
	delete from @ideaQuery
	delete from @programStatusQuery
	delete from @gradelevelQuery
	delete from @languageQuery
	delete from @studentenrollmentQuery
	delete from @studentStatusQuery
	delete from @title1StatusQuery
	delete from @titleIIIStatusQuery
	delete from @attendanceQuery
	delete from @studentCohortStatus
	delete from @NoDProgramStatus
	delete from @cteStatusQuery
	delete from @enrollmentStatusQuery

	insert into @studentDateQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		SubmissionYearDate,
		[Year],
		SubmissionYearStartDate,
		SubmissionYearEndDate
	)
	exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate

	if @runAsTest = 1
	BEGIN
		print 'studentDateQuery'
		select * from @studentDateQuery
	END

	if @factTypeCode = 'hsgradenroll'
	begin

		insert into @studentDateQuery
		(
			DimStudentId,
			PersonId,
			DimCountDateId,
			SubmissionYearDate,
			[Year],
			SubmissionYearStartDate,
			SubmissionYearEndDate
		)
		exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate, 1

		if @runAsTest = 1
		BEGIN
			print 'studentDateQuery'
			select * from @studentDateQuery
		END

	end

	-- Migrate_DimRaces

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimRaces')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Race Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
		END
	
		insert into @raceQuery
		(
			DimStudentId,
			PersonId,
			DimCountDateId,
			RaceCode,
			RaceRecordStartDate,
			RaceRecordEndDate
		)
		exec rds.Migrate_DimRaces  @factTypeCode, @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'raceQuery'
			select * from @raceQuery
		END

	END


	if exists(select 1 from @factDimensions where DimensionTableName = 'DimAges')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Age Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
		END


		-- Migrate_DimAges
		insert into @ageQuery
		(
			DimStudentId,
			PersonId,
			DimCountDateId,
			AgeCode
		)
		exec rds.Migrate_DimAges @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'ageQuery'
			select * from @ageQuery
		END

	END
	
	-- Migrate_DimDemographics

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimDemographics')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Demographics Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		insert into @demoQuery
		(
			DimStudentId,
			PersonId,
			DimCountDateId,
			EcoDisStatusCode,
			HomelessStatusCode,
			HomelessUnaccompaniedYouthStatusCode,
			LepStatusCode,
			MigrantStatusCode,
			SexCode,
			MilitaryConnected,
			HomelessNighttimeResidenceCode,
			PersonStartDate,
			PersonEndDate
		)
		exec rds.Migrate_DimDemographics @studentDateQuery, @useCutOffDate

		if @runAsTest = 1
		BEGIN
			print 'demoQuery'
			select * from @demoQuery
		END

	END

	-- Migrate_DimSchools

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END


	
	insert into @schoolQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		Organizationid
	)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, Organizationid
	from rds.Get_StudentOrganizations(@studentDateQuery, @useCutOffDate)

	if @runAsTest = 1
	BEGIN
		print 'schoolQuery'
		select * from @schoolQuery
	END

	
	-- Migrate_DimIdeaStatuses

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimIdeaStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating IDEA Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @ideaQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			IDEAIndicatorCode,
			DisabilityCode,
			EducEnvCode,
			BasisOfExitCode,
			SpecialEducationServicesExitDate
		)
		exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, @useCutOffDate

		if @runAsTest = 1
		BEGIN
			print 'ideaQuery'
			select * from @ideaQuery
		END

	END

	-- Migrate_DimProgramStatuses

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimProgramStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Program Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @programStatusQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			ImmigrantTitleIIICode,
			Section504Code,
			FoodServiceEligibilityCode,
			FosterCareCode,
			TitleIIIProgramParticipation,
			HomelessServicedIndicatorCode
		)
		exec rds.Migrate_DimProgramStatuses @studentDateQuery, @useCutOffDate

		if @runAsTest = 1
		BEGIN
			print 'programStatusQuery'
			select * from @programStatusQuery
		END

	END

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimGradeLevels')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Grade Level Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		insert into @gradelevelQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			GradeLevelCode
		)
		exec rds.Migrate_DimGradeLevels @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'gradelevelQuery'
			select * from @gradelevelQuery
		END

	END

	--Migrate Language

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimLanguages')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Language Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		insert into @languageQuery
		(
			DimStudentId,
			PersonId,
			DimCountDateId,
			LanguageCode
		)
		exec rds.[Migrate_DimLanguage] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'languageQuery'
			select * from @languageQuery
		END

	END

	-- Migrate_DimMigrant

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimMigrants')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Migrant Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @migrantQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			ContinuationOfServiceStatus ,
			MigrantPriorityForServiceCode ,
			MepServiceTypeCode ,
			MepFundStatus,
			MepEnrollmentTypeCode 		
		)
		exec rds.[Migrate_DimMigrant] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'migrantQuery'
			select * from @migrantQuery
		END

	END

	-- Migrate_DimEnrollments

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimEnrollment')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		insert into @studentenrollmentQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			PostSecondaryEnrollmentStatusCode
		)
		exec rds.[migrate_DimEnrollments] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'studentenrollmentQuery'
			select * from @studentenrollmentQuery
		END

	END
	
	
	-- Migrate_DimStudentStatuses

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimStudentStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Student Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @studentStatusQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			MobilityStatus12moCode,
			MobilityStatus36moCode,
			MobilityStatusSYCode,
			ReferralStatusCode,
			DiplomaCredentialCode,
			PlacementType,
			PlacementStatus,
			NSLPDirectCertificationIndicatorCode
		)
		exec rds.[migrate_DimStudentStatuses] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'studentStatusQuery'
			select * from @studentStatusQuery
		END

	END

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimTitle1Statuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title I Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @title1StatusQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			TitleISchoolStatusCode,
			TitleIinstructionalServiceCode,		
			Title1SupportServiceCode ,
			Title1ProgramTypeCode
		)
		exec rds.[Migrate_DimTitle1Statuses] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'title1StatusQuery'
			select * from @title1StatusQuery
		END

	END

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimTitleiiiStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title III Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

	
		insert into @titleIIIStatusQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			TitleIIIAccountabilityCode ,
			TitleIIILanguageInstructionCode ,		
			ProficiencyStatusCode ,
			FormerEnglishLearnerYearStatus
		)
		exec rds.[Migrate_DimTitleIIIStatuses] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'titleIIIStatusQuery'
			select * from @titleIIIStatusQuery
		END

	END

	--Migrate Attendance

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimAttendance')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Attendance Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		insert into @attendanceQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			AbsenteeismCode
		)
		exec rds.[Migrate_DimAttendance] @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'attendanceQuery'
			select * from @attendanceQuery
		END

	END

	-- migrate Cohort Statuses

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimCohortStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Student Cohort Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @studentCohortStatus
		(
			DimStudentId,
			PersonId,
			CohortYear,
			CohortDescription,
			DiplomaOrCredentialAwardDate,
			CohortStatus
		)
		exec RDS.Migrate_DimCohortStatuses @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'studentCohortStatus'
			select * from @studentCohortStatus
		END

	END

	-- migrate N or D Statuses

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimNorDProgramStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating N or D Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @NoDProgramStatus
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			LongTermStatusCode,
			NeglectedProgramTypeCode,
			AcademicOrVocationalOutcomeCode,
			AcademicOrVocationalExitOutcomeCode	
		)
		exec RDS.Migrate_DimNoDProgramStatuses @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'NoDProgramStatus'
			select * from @NoDProgramStatus
		END

	END

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimCteStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Cte Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @cteStatusQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			CteCode,
			DisplacedHomemaker,
			SingleParent,
			CteNonTraditionalEnrollee,
			RepresentationStatus,
			InclutypCode,
			LepPerkinsStatus
		)
		exec RDS.Migrate_DimCteStatuses @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'cteStatusQuery'
			select * from @cteStatusQuery
		END

	END

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimEnrollmentStatuses')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @enrollmentStatusQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			ExitCode
		)
		exec RDS.Migrate_DimEnrollmentStatuses @studentDateQuery

		if @runAsTest = 1
		BEGIN
			print 'enrollmentStatusQuery'
			select * from @enrollmentStatusQuery
		END

	END

	-- Combine Dimension Data
	----------------------------

	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combining Dimension Data for (' + @factTypeCode + ') -  ' + @submissionYear)
	end

	
	insert into #queryOutput
	(
		DimStudentId,
		StudentPersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		AgeCode,
		RaceCode,

		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,

		IDEAIndicatorCode,
		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
		StudentCutOverStartDate,
		--TitleIStatusCode,
		GradeLevelCode,

		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode,

		LanguageCode, 

		ContinuationOfServiceStatus ,
		MigrantPriorityForServiceCode ,
		MepServiceTypeCode ,
		MepFundStatus,
		MepEnrollmentTypeCode,

		MobilityStatus12moCode,
		MobilityStatus36moCode,
		MobilityStatusSYCode,
		ReferralStatusCode,
		DiplomaCredentialCode,
		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		PlacementType,
		PlacementStatus,
		RepresentationStatus,
		InclutypCode,
		LepPerkinsStatus,

		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,

		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus,

		AbsenteeismCode,
		PostSecondaryEnrollmentStatusCode,
		AcademicOrVocationalOutcomeCode,
		AcademicOrVocationalExitOutcomeCode,
		CohortStatus,

		LongTermStatusCode,
		NeglectedProgramTypeCode,
		
		ExitCode,

		NSLPDirectCertificationIndicatorCode
	)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(sch.DimSchoolId, -1),
		isnull(sch.DimLeaId, -1),
		a.AgeCode,
		isnull(race.RaceCode,'MISSING'),

		isnull(demo.EcoDisStatusCode, 'MISSING'),
		isnull(demo.HomelessStatusCode, 'MISSING'),
		isnull(demo.LepStatusCode, 'MISSING'),
		isnull(demo.MigrantStatusCode, 'MISSING'),
		isnull(demo.SexCode, 'MISSING'),
		isnull(demo.MilitaryConnected, 'MISSING'),
		isnull(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		isnull(demo.HomelessNighttimeResidenceCode, 'MISSING'),

		isnull(idea.IDEAIndicatorCode, 'MISSING'),
		isnull(idea.BasisOfExitCode, 'MISSING'),
		isnull(idea.DisabilityCode, 'MISSING'),
		isnull(idea.EducEnvCode, 'MISSING'),
		idea.SpecialEducationServicesExitDate,

		isnull(grade.GradeLevelCode,'MISSING'),
		isnull(cteStatus.CteCode,'MISSING'),
		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIProgramParticipation, 'MISSING'),
		isnull(programStatus.HomelessServicedIndicatorCode, 'MISSING'),

		ISNULL(lang.LanguageCode, 'MISSING'),

		ISNULL(migrant.ContinuationOfServiceStatus, 'MISSING'),
		ISNULL(migrant.MigrantPriorityForServiceCode ,'MISSING'),
		ISNULL(migrant.MepServiceTypeCode ,'MISSING'),
		ISNULL(migrant.MepFundStatus ,'MISSING'),
		ISNULL(migrant.MepEnrollmentTypeCode ,'MISSING'),

		ISNULL(studentStatus.MobilityStatus12moCode, 'MISSING'),
		ISNULL(studentStatus.MobilityStatus36moCode, 'MISSING'),
		ISNULL(studentStatus.MobilityStatusSYCode, 'MISSING'),
		ISNULL(studentStatus.ReferralStatusCode, 'MISSING'),
		ISNULL(studentStatus.DiplomaCredentialCode, 'MISSING'),
		ISNULL(cteStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(cteStatus.SingleParent, 'MISSING'),
		ISNULL(cteStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(studentStatus.PlacementType, 'MISSING'),
		ISNULL(studentStatus.PlacementStatus, 'MISSING'),
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatus, 'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),

		ISNULL(TitleIIIAccountabilityCode , 'MISSING'),
		ISNULL(TitleIIILanguageInstructionCode , 'MISSING'),	
		ISNULL(ProficiencyStatusCode , 'MISSING'),
		ISNULL(FormerEnglishLearnerYearStatus, 'MISSING'),

		ISNULL(att.AbsenteeismCode,'MISSING'),
		ISNULL(studentStatus2.PostSecondaryEnrollmentStatusCode,'MISSING'),
		ISNULL(noDProgramStatus.AcademicOrVocationalOutcomeCode,'MISSING'),
		ISNULL(noDProgramStatus.AcademicOrVocationalExitOutcomeCode,'MISSING'),
		isnull(cohortstatus.CohortStatus, 'MISSING'),
		
		isnull(noDProgramStatus.LongTermStatusCode , 'MISSING'),
		isnull(noDProgramStatus.NeglectedProgramTypeCode, 'MISSING'),
		isnull(enrollmentStatus.ExitCode, 'MISSING'),
		isnull(studentStatus.NSLPDirectCertificationIndicatorCode, 'MISSING')

	from @studentDateQuery s
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	left outer join @ageQuery a on s.DimStudentId = a.DimStudentId and s.DimCountDateId = a.DimCountDateId
	left outer join @raceQuery race on s.DimStudentId = race.DimStudentId and s.DimCountDateId = race.DimCountDateId
	left outer join @languageQuery lang on s.DimStudentId = lang.DimStudentId and s.DimCountDateId = lang.DimCountDateId
	left outer join @studentCohortStatus cohortstatus on cohortstatus.DimStudentId = s.DimStudentId
	left outer join @gradelevelQuery grade on s.DimStudentId = grade.DimStudentId and s.DimCountDateId = grade.DimCountDateId 
											and sch.DimSchoolId = grade.DimSchoolId and sch.DimLeaId = grade.DimLeaId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId 
									 and sch.DimSchoolId = idea.DimSchoolId and sch.DimLeaId = idea.DimLeaId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId 
									and sch.DimSchoolId = programStatus.DimSchoolId and sch.DimLeaId = programStatus.DimLeaId
	left outer join @migrantQuery migrant on s.DimStudentId = migrant.DimStudentId and s.DimCountDateId = migrant.DimCountDateId 
										  and sch.DimSchoolId = migrant.DimSchoolId and sch.DimLeaId = migrant.DimLeaId
	left outer join @studentStatusQuery studentStatus on s.DimStudentId = studentStatus.DimStudentId and s.DimCountDateId = studentStatus.DimCountDateId
										 and sch.DimSchoolId = studentStatus.DimSchoolId and sch.DimLeaId = studentStatus.DimLeaId
	left outer join @title1StatusQuery title1  on s.DimStudentId = title1.DimStudentId and s.DimCountDateId = title1.DimCountDateId 
											and sch.DimSchoolId = title1.DimSchoolId and sch.DimLeaId = title1.DimLeaId
	left outer join @titleIIIStatusQuery titleIII  on s.DimStudentId = titleIII.DimStudentId and s.DimCountDateId = titleIII.DimCountDateId 
											and sch.DimSchoolId = titleIII.DimSchoolId and sch.DimLeaId = titleIII.DimLeaId
	left outer join @attendanceQuery att on s.DimStudentId = att.DimStudentId and s.DimCountDateId = att.DimCountDateId and sch.DimSchoolId = att.DimSchoolId and sch.DimLeaId = att.DimLeaId
	left outer join @studentenrollmentQuery studentStatus2 on s.DimStudentId = studentStatus2.DimStudentId and s.DimCountDateId = studentStatus2.DimCountDateId 
										and sch.DimSchoolId = studentStatus2.DimSchoolId and sch.DimLeaId = studentStatus2.DimLeaId
	left outer join @NoDProgramStatus noDProgramStatus  on s.DimStudentId = noDProgramStatus.DimStudentId and s.DimCountDateId = noDProgramStatus.DimCountDateId 
										and sch.DimSchoolId = noDProgramStatus.DimSchoolId and sch.DimLeaId = noDProgramStatus.DimLeaId
	left outer join @cteStatusQuery cteStatus  on s.DimStudentId = cteStatus.DimStudentId and s.DimCountDateId = cteStatus.DimCountDateId 
										and sch.DimSchoolId = cteStatus.DimSchoolId and sch.DimLeaId = cteStatus.DimLeaId
	left outer join @enrollmentStatusQuery enrollmentStatus  on s.DimStudentId = enrollmentStatus.DimStudentId and s.DimCountDateId = enrollmentStatus.DimCountDateId 
										and sch.DimSchoolId = enrollmentStatus.DimSchoolId and sch.DimLeaId = enrollmentStatus.DimLeaId

	if @runAsTest = 1
	BEGIN
		print 'queryOutput'
		select * from #queryOutput
	END


	-- Insert New Facts
	----------------------------

	-- Log history

	if @runAsTest = 0
	begin

		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @submissionYear)


		
		insert into rds.FactStudentCounts
		(
			DimFactTypeId,
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			DimCountDateId,
			DimDemographicId,
			DimIdeaStatusId,
			DimAgeId,
			DimGradeLevelId,
			DimProgramStatusId,
			StudentCount,
			DimLanguageId,
			DimMigrantId,
			DimStudentStatusId,
			DimTitle1StatusId,
			DimTitleiiiStatusId,
			DimAttendanceId,
			DimEnrollmentId,
			DimCohortStatusId,
			DimNorDProgramStatusId,
			DimCteStatusId,
			DimEnrollmentStatusId,
			StudentCutOverStartDate,
			DimRaceId
		)
		select distinct
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(a.DimAgeId, -1) as DimAgeId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,

		isnull(lang.DimLanguageId, -1) as DimLanguageId,
		isnull(migrant.DimMigrantId, -1) as	DimMigrantId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId,
		isnull(studentStatusesII.DimEnrollmentId, -1) as DimEnrollmentId,
		isnull(cohortstatuses.DimCohortStatusId, -1) as DimCohortStatusId,
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1) as DimNorDProgramStatusId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId,
		isnull(enrStatus.DimEnrollmentStatusId, -1) as DimEnrollmentStatusId,
		q.StudentCutOverStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId
		from #queryOutput q
		left outer join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
		left outer join rds.DimAges a	on q.AgeCode = a.AgeCode
		left outer join rds.DimRaces race
			on q.RaceCode = race.RaceCode and race.DimFactTypeId = @factTypeId
		left outer join rds.DimDemographics d 
			on q.EcoDisStatusCode = d.EcoDisStatusCode
			and q.HomelessStatusCode = d.HomelessStatusCode
			and q.LepStatusCode = d.LepStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and q.SexCode = d.SexCode
			and  q.MilitaryConnected = d.MilitaryConnectedStatusCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessNighttimeResidenceCode
			 
		left outer join rds.DimIdeaStatuses idea
			on q.DisabilityCode = idea.DisabilityCode
			and q.EducEnvCode = idea.EducEnvCode
			and q.BasisOfExitCode = idea.BasisOfExitCode
			and q.IDEAIndicatorCode = idea.IDEAIndicatorCode

		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		
		left outer join rds.DimLanguages lang
		on lang.LanguageCode = q.LanguageCode
		left outer join rds.DimMigrants migrant 
		on migrant.ContinuationCode = q.ContinuationOfServiceStatus
		and migrant.MepFundsStatusCode =q.MepFundStatus
		and migrant.MepServicesCode = q.MepServiceTypeCode
		and migrant.MigrantPriorityForServicesCode = q.MigrantPriorityForServiceCode
		and migrant.MepEnrollmentTypeCode = q.MepEnrollmentTypeCode

		left outer join rds.DimStudentStatuses studentStatus
		on studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
		and studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
		and studentStatus.ReferralStatusCode = q.ReferralStatusCode
		and studentStatus.DiplomaCredentialTypeCode = q.DiplomaCredentialCode
		and studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
		and studentStatus.PlacementTypeCode = q.PlacementType
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.NSLPDirectCertificationIndicatorCode = q.NSLPDirectCertificationIndicatorCode
		
		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

		left outer join rds.DimTitleiiiStatuses title3
		on
		title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		left outer join rds.DimAttendance att
		on att.AbsenteeismCode = q.AbsenteeismCode

		left outer join rds.DimEnrollment studentStatusesII
		on studentStatusesII.PostSecondaryEnrollmentStatusCode = q.PostSecondaryEnrollmentStatusCode

		left join rds.DimCohortStatuses cohortstatuses on cohortstatuses.CohortStatusCode=q.CohortStatus

		left outer join rds.DimNorDProgramStatuses NorDProgramStatuses
		on NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
		and NorDProgramStatuses.NeglectedProgramTypeCode = q.NeglectedProgramTypeCode
		and NorDProgramStatuses.AcademicOrVocationalOutcomeEdFactsCode = q.AcademicOrVocationalOutcomeCode
		and NorDProgramStatuses.AcademicOrVocationalExitOutcomeEdFactsCode = q.AcademicOrVocationalExitOutcomeCode

		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
		and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
		and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
		and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
		and cte.RepresentationStatusCode = q.RepresentationStatus
		and cte.CteGraduationRateInclusionCode = q.InclutypCode
		and cte.LepPerkinsStatusCode = q.LepPerkinsStatus

		left outer join rds.DimEnrollmentStatuses enrStatus on q.exitCode = enrStatus.ExitOrWithdrawalCode

		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserted New Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

	end
	else
	begin

		-- Run As Test (return data instead of inserting it)

				select distinct
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(a.DimAgeId, -1) as DimAgeId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,

		isnull(lang.DimLanguageId, -1) as DimLanguageId,
		isnull(migrant.DimMigrantId, -1) as	DimMigrantId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId,
		isnull(studentStatusesII.DimEnrollmentId, -1) as DimEnrollmentId,
		isnull(cohortstatuses.DimCohortStatusId, -1) as DimCohortStatusId,
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1) as DimNorDProgramStatusId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId,
		isnull(enrStatus.DimEnrollmentStatusId, -1) as DimEnrollmentStatusId,
		q.StudentCutOverStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId
		from #queryOutput q
		left outer join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
		left outer join rds.DimAges a	on q.AgeCode = a.AgeCode
		left outer join rds.DimRaces race
			on q.RaceCode = race.RaceCode and race.DimFactTypeId = @factTypeId
		left outer join rds.DimDemographics d 
			on q.EcoDisStatusCode = d.EcoDisStatusCode
			and q.HomelessStatusCode = d.HomelessStatusCode
			and q.LepStatusCode = d.LepStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and q.SexCode = d.SexCode
			and  q.MilitaryConnected = d.MilitaryConnectedStatusCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessNighttimeResidenceCode
			 
		left outer join rds.DimIdeaStatuses idea
			on q.DisabilityCode = idea.DisabilityCode
			and q.EducEnvCode = idea.EducEnvCode
			and q.BasisOfExitCode = idea.BasisOfExitCode
			and q.IDEAIndicatorCode = idea.IDEAIndicatorCode

		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		
		left outer join rds.DimLanguages lang
		on lang.LanguageCode = q.LanguageCode
		left outer join rds.DimMigrants migrant 
		on migrant.ContinuationCode = q.ContinuationOfServiceStatus
		and migrant.MepFundsStatusCode =q.MepFundStatus
		and migrant.MepServicesCode = q.MepServiceTypeCode
		and migrant.MigrantPriorityForServicesCode = q.MigrantPriorityForServiceCode
		and migrant.MepEnrollmentTypeCode = q.MepEnrollmentTypeCode

		left outer join rds.DimStudentStatuses studentStatus
		on studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
		and studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
		and studentStatus.ReferralStatusCode = q.ReferralStatusCode
		and studentStatus.DiplomaCredentialTypeCode = q.DiplomaCredentialCode
		and studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
		and studentStatus.PlacementTypeCode = q.PlacementType
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.NSLPDirectCertificationIndicatorCode = q.NSLPDirectCertificationIndicatorCode
		
		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

		left outer join rds.DimTitleiiiStatuses title3
		on
		title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		left outer join rds.DimAttendance att
		on att.AbsenteeismCode = q.AbsenteeismCode

		left outer join rds.DimEnrollment studentStatusesII
		on studentStatusesII.PostSecondaryEnrollmentStatusCode = q.PostSecondaryEnrollmentStatusCode

		left join rds.DimCohortStatuses cohortstatuses on cohortstatuses.CohortStatusCode=q.CohortStatus

		left outer join rds.DimNorDProgramStatuses NorDProgramStatuses
		on NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
		and NorDProgramStatuses.NeglectedProgramTypeCode = q.NeglectedProgramTypeCode
		and NorDProgramStatuses.AcademicOrVocationalOutcomeEdFactsCode = q.AcademicOrVocationalOutcomeCode
		and NorDProgramStatuses.AcademicOrVocationalExitOutcomeEdFactsCode = q.AcademicOrVocationalExitOutcomeCode

		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
		and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
		and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
		and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
		and cte.RepresentationStatusCode = q.RepresentationStatus
		and cte.CteGraduationRateInclusionCode = q.InclutypCode
		and cte.LepPerkinsStatusCode = q.LepPerkinsStatus

		left outer join rds.DimEnrollmentStatuses enrStatus on q.exitCode = enrStatus.ExitOrWithdrawalCode

	end

	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	END


	END TRY
	BEGIN CATCH

		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
		
	END CATCH

	if CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	begin
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	end

	if exists (select  1 from tempdb.dbo.sysobjects o where o.xtype in ('U') and o.id = object_id(N'tempdb..#queryOutput'))
	drop table #queryOutput

	SET NOCOUNT OFF;
END