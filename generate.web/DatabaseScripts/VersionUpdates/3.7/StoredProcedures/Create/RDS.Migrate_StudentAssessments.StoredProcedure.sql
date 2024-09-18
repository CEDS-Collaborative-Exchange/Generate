CREATE PROCEDURE [RDS].[Migrate_StudentAssessments]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN
	SET NOCOUNT ON;

	-- Lookup values
	declare @factTable as varchar(50)
	set @factTable = 'FactStudentAssessments'
	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	
	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	set @migrationType='rds'

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	declare @studentDateQuery as rds.StudentDateTableType

	declare @raceQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		RaceCode varchar(50),
		RaceRecordStartDate datetime,
		RaceRecordEndDate datetime
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

	declare @ideaQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
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
		DimSeaId int,
		PersonId int,
		DimCountDateId int,
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50),
		HomelessServicedIndicatorCode varchar(50)
	)

	declare @assessmentQuery as table (
		DimStudentId int,
		PersonId int,
		DimLeaId int,
		DimSchoolId int,
		DimSeaId int,
		DimCountDateId int,
		AssessmentSubjectCode varchar(50),
		AssessmentTypeCode varchar(50),
		GradeLevelCode varchar(50),
		ParticipationStatusCode varchar(50),
		PerformanceLevelCode varchar(50),
		SeaFullYearStatusCode varchar(50),
		LeaFullYearStatusCode varchar(50),
		SchFullYearStatusCode varchar(50),
		AssessmentCount int
	)
		
	declare @schoolQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		Organizationid int
		unique clustered (DimStudentId, DimSchoolId, DimCountDateId, DimLeaId, OrganizationId)
	)

	declare @title1StatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
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
		DimSeaId int,
		PersonId int,
		DimCountDateId int,
		TitleIIIAccountabilityCode varchar(50),
		TitleIIILanguageInstructionCode varchar(50),		
		ProficiencyStatusCode varchar(50),
		FormerEnglishLearnerYearStatus varchar(50)
	)
	
	declare @AssessmentStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		PersonId int,
		DimCountDateId int,		
		AssessedFirstTime varchar(50),
		AcademicSubjectCode varchar(50),
		ProgressLevelCode varchar(50)
	)
	
	declare @studentStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
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

	declare @NoDProgramStatus as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
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
		DimSeaId int,
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
		DimSeaId int,
		PersonId int,
		DimCountDateId int,
		ExitCode varchar(50)
	 )

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimStudentId int,
		StudentPersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
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
		--TitleIStatusCode varchar(50),
		CteCode varchar(50),
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50),
		HomelessServicedIndicatorCode varchar(50),
		AssessmentSubjectCode varchar(50),
		AssessmentTypeCode varchar(50),
		GradeLevelCode varchar(50),
		ParticipationStatusCode varchar(50),
		PerformanceLevelCode varchar(50),
		SeaFullYearStatusCode varchar(50),
		LeaFullYearStatusCode varchar(50),
		SchFullYearStatusCode varchar(50),
		TitleIIIAccountabilityCode varchar(50),
		TitleIIILanguageInstructionCode varchar(50),		
		ProficiencyStatusCode varchar(50),
		FormerEnglishLearnerYearStatus varchar(50),
		AssessedFirstTime varchar(50),
		AcademicAssessmentSubjectCode varchar(50),
		ProgressLevel varchar(50),
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
		NSLPDirectCertificationIndicatorCode varchar(50),
		RepresentationStatus varchar(50),
		INCLUTYPCode varchar(50),
		LepPerkinsStatus varchar(50),
		LongTermStatusCode nvarchar(50),
		NeglectedProgramTypeCode nvarchar(50),
		AcademicOrVocationalOutcomeCode varchar(50),
		AcademicOrVocationalExitOutcomeCode varchar(50),
		TitleISchoolStatusCode varchar(50),
		TitleIinstructionalServiceCode varchar(50),		
		Title1SupportServiceCode varchar(50),
		Title1ProgramTypeCode varchar(50),
		ExitCode nvarchar(50),
		AssessmentCount int
	)
	
	-- Log history
	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end


	-- Get Dimension Data
	----------------------------

	-- Migrate_DimDates
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
	delete from @demoQuery
	delete from @schoolQuery
	delete from @assessmentQuery
	delete from @AssessmentStatusQuery
	delete from @ideaQuery
	delete from @programStatusQuery
	delete from @studentStatusQuery
	delete from @title1StatusQuery
	delete from @titleIIIStatusQuery
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

	Update @studentDateQuery set SubmissionYearDate = SubmissionYearEndDate

	if @runAsTest = 1
	BEGIN
		print 'studentDateQuery'
		select * from @studentDateQuery
	END

	-- Migrate_DimRaces

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


	-- Migrate_DimDemographics

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Demographics Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
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
	exec rds.Migrate_DimDemographics @studentDateQuery, 1

	if @runAsTest = 1
	BEGIN
		print 'demoQuery'
		select * from @demoQuery
	END


	-- Migrate_DimIdeaStatuses
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
		DimSeaId,
		PersonId,
		DimCountDateId,
		IDEAIndicatorCode,
		DisabilityCode,
		EducEnvCode,
		BasisOfExitCode,
		SpecialEducationServicesExitDate
	)
	exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, 0

	if @runAsTest = 1
	BEGIN
		print 'ideaQuery'
		select * from @ideaQuery
	END


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
		DimSeaId,
		PersonId,
		DimCountDateId,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode
	)
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, 0

	if @runAsTest = 1
	BEGIN
		print 'programStatusQuery'
		select * from @programStatusQuery
	END


	-- Migrate_DimAssessments

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Assessment Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	insert into @assessmentQuery
	(
		DimStudentId,
		PersonId,
		DimLeaId,
		DimSchoolId,
		DimSeaId,
		DimCountDateId,
		AssessmentSubjectCode,
		AssessmentTypeCode,
		GradeLevelCode,
		ParticipationStatusCode,
		PerformanceLevelCode,
		SeaFullYearStatusCode,
		LeaFullYearStatusCode,
		SchFullYearStatusCode,
		AssessmentCount
	)
	exec rds.Migrate_DimAssessments @studentDateQuery

	if @runAsTest = 1
	BEGIN
		print 'assessmentQuery'
		select * from @assessmentQuery
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
		DimSeaId,
		Organizationid
	)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, Organizationid
	from rds.Get_StudentOrganizations(@studentDateQuery, 0)

	if @runAsTest = 1
	BEGIN
		print 'schoolQuery'
		select * from @schoolQuery
	END

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
		DimSeaId,
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


	-- Migrate Title III Statuses

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
		DimSeaId,
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


	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Assessment Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	insert into @AssessmentStatusQuery
	(
		DimStudentId,
		DimSchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,		
		AssessedFirstTime,
		AcademicSubjectCode,
		ProgressLevelCode 
	)
	exec [RDS].[Migrate_DimAssessmentStatuses] @studentDateQuery

	if @runAsTest = 1
	BEGIN
		print 'AssessmentStatusQuery'
		select * from @AssessmentStatusQuery
	END


	-- Migrate_DimStudentStatuses

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
		DimSeaId,
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

	-- migrate N or D Statuses

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
		DimSeaId,
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
		DimSeaId,
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
		DimSeaId,
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
		DimSeaId,
		RaceCode,
		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected ,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,
		IDEAIndicatorCode,
		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode,
		AssessmentSubjectCode,
		AssessmentTypeCode,
		GradeLevelCode,
		ParticipationStatusCode,
		PerformanceLevelCode,
		SeaFullYearStatusCode,
		LeaFullYearStatusCode,
		SchFullYearStatusCode,
		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus,
		AssessedFirstTime,
		AcademicAssessmentSubjectCode,
		ProgressLevel,
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
		NSLPDirectCertificationIndicatorCode,
		RepresentationStatus,
		INCLUTYPCode,
		LepPerkinsStatus,
		LongTermStatusCode,
		NeglectedProgramTypeCode,
		AcademicOrVocationalOutcomeCode,
		AcademicOrVocationalExitOutcomeCode,
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,
		ExitCode,
		AssessmentCount
	)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(sch.DimSchoolId, -1),
		isnull(sch.DimLeaId, -1),
		isnull(sch.DimSeaId, -1),
		isnull(race.RaceCode,'MISSING'),
		isnull(demo.EcoDisStatusCode, 'MISSING'),
		isnull(demo.HomelessStatusCode, 'MISSING'),
		isnull(demo.LepStatusCode, 'MISSING'),
		isnull(demo.MigrantStatusCode, 'MISSING'),
		isnull(demo.SexCode, 'MISSING'),
		isnull(demo.MilitaryConnected ,'MISSING'),
		isnull(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		isnull(demo.HomelessNighttimeResidenceCode, 'MISSING'),
		isnull(idea.IDEAIndicatorCode, 'MISSING'),
		isnull(idea.BasisOfExitCode, 'MISSING'),
		isnull(idea.DisabilityCode, 'MISSING'),
		isnull(idea.EducEnvCode, 'MISSING'),
		--isnull(idea.TitleIStatusCode, 'MISSING'),
		isnull(cteStatus.CteCode,'MISSING'),
		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIProgramParticipation,'MISSING'),
		isnull(programStatus.HomelessServicedIndicatorCode,'MISSING'),

		isnull(assess.AssessmentSubjectCode, 'MISSING'),
		isnull(assess.AssessmentTypeCode, 'MISSING'),
		isnull(assess.GradeLevelCode, 'MISSING'),
		isnull(assess.ParticipationStatusCode, 'MISSING'),
		isnull(assess.PerformanceLevelCode, 'MISSING'),
		isnull(assess.SeaFullYearStatusCode, 'MISSING'),
		isnull(assess.LeaFullYearStatusCode, 'MISSING'),
		isnull(assess.SchFullYearStatusCode, 'MISSING'),
		ISNULL(titleIII.TitleIIIAccountabilityCode , 'MISSING'),
		ISNULL(titleIII.TitleIIILanguageInstructionCode , 'MISSING'),	
		ISNULL(titleIII.ProficiencyStatusCode , 'MISSING'),
		ISNULL(titleIII.FormerEnglishLearnerYearStatus, 'MISSING'),
		ISNULL(asq.AssessedFirstTime , 'MISSING'),
		ISNULL(asq.AcademicSubjectCode , 'MISSING'),
		ISNULL(asq.ProgresslevelCode , 'MISSING'),
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
		ISNULL(studentStatus.NSLPDirectCertificationIndicatorCode, 'MISSING'),			
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatus, 'MISSING'),

		isnull(noDProgramStatus.LongTermStatusCode , 'MISSING'),
		isnull(noDProgramStatus.NeglectedProgramTypeCode, 'MISSING'),
		ISNULL(noDProgramStatus.AcademicOrVocationalOutcomeCode,'MISSING'),
		ISNULL(noDProgramStatus.AcademicOrVocationalExitOutcomeCode,'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),
		isnull(enrollmentStatus.ExitCode, 'MISSING'),

		isnull(assess.AssessmentCount, 0)
	from @studentDateQuery s
	inner join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId 
	left outer join @raceQuery race on s.DimStudentId = race.DimStudentId and s.DimCountDateId = race.DimCountDateId
	left outer join @assessmentQuery assess on s.DimStudentId = assess.DimStudentId and s.DimCountDateId = assess.DimCountDateId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId 
									and sch.DimSchoolId = idea.DimSchoolId and sch.DimLeaId = idea.DimLeaId and sch.DimSeaId = idea.DimSeaId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId 
									and s.DimCountDateId = programStatus.DimCountDateId 
									and sch.DimSchoolId = programStatus.DimSchoolId and sch.DimLeaId = programStatus.DimLeaId
									and sch.DimSeaId = programStatus.DimSeaId
	left outer join @titleIIIStatusQuery titleIII  on s.DimStudentId = titleIII.DimStudentId and s.DimCountDateId = titleIII.DimCountDateId 
									and sch.DimSchoolId = titleIII.DimSchoolId and sch.DimLeaId = titleIII.DimLeaId
									and sch.DimSeaId = titleIII.DimSeaId
	left outer join @AssessmentStatusQuery asq on  s.DimStudentId = asq.DimStudentId and s.DimCountDateId = asq.DimCountDateId 
									and sch.DimSchoolId = asq.DimSchoolId and sch.DimLeaId = asq.DimLeaId
									and sch.DimSeaId = asq.DimSeaId
	left outer join @studentStatusQuery studentStatus on s.DimStudentId = studentStatus.DimStudentId 
									and s.DimCountDateId = studentStatus.DimCountDateId 
									and sch.DimSchoolId = studentStatus.DimSchoolId and sch.DimLeaId = studentStatus.DimLeaId
									and sch.DimSeaId = studentStatus.DimSeaId
	left join @NoDProgramStatus noDProgramStatus  on s.DimStudentId = noDProgramStatus.DimStudentId 
									and s.DimCountDateId = noDProgramStatus.DimCountDateId 
									and sch.DimSchoolId = noDProgramStatus.DimSchoolId and sch.DimLeaId = noDProgramStatus.DimLeaId
									and sch.DimSeaId = noDProgramStatus.DimSeaId
	left outer join @cteStatusQuery cteStatus  on s.DimStudentId = cteStatus.DimStudentId and s.DimCountDateId = cteStatus.DimCountDateId 
										and sch.DimSchoolId = cteStatus.DimSchoolId and sch.DimLeaId = cteStatus.DimLeaId
										and sch.DimSeaId = cteStatus.DimSeaId
	left outer join @title1StatusQuery title1  on s.DimStudentId = title1.DimStudentId and s.DimCountDateId = title1.DimCountDateId 
											and sch.DimSchoolId = title1.DimSchoolId and sch.DimLeaId = title1.DimLeaId
											and sch.DimSeaId = title1.DimSeaId
	left outer join @enrollmentStatusQuery enrollmentStatus  on s.DimStudentId = enrollmentStatus.DimStudentId 
										and s.DimCountDateId = enrollmentStatus.DimCountDateId 
										and sch.DimSchoolId = enrollmentStatus.DimSchoolId and sch.DimLeaId = enrollmentStatus.DimLeaId
										and sch.DimSeaId = enrollmentStatus.DimSeaId
	
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
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting Facts for (' + @factTypeCode + ') -  ' + @submissionYear)


		insert into rds.FactStudentAssessments
		(
			DimFactTypeId,
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			DimSeaId,
			DimCountDateId,
			DimDemographicId,
			DimIdeaStatusId,
			DimAssessmentId,
			DimGradeLevelId,
			DimProgramStatusId,
			DimTitle1StatusId,
			DimTitleiiiStatusId,
			DimAssessmentStatusId,
			DimStudentStatusId,
			DimNorDProgramStatusId,
			DimCteStatusId,
			DimRaceId,
			DimEnrollmentStatusId,
			AssessmentCount
			
		)
		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(assess.DimAssessmentId, -1) as DimAssessmentId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(assesSts.DimAssessmentStatusId, -1) as DimAssessmentStatusId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1) as DimNorDProgramStatusId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId,
		isnull(race.DimRaceId,-1) as DimRaceId,
		isnull(enrStatus.DimEnrollmentStatusId, -1) as DimEnrollmentStatusId,
		count(distinct q.DimStudentId) as AssessmentCount
		from #queryOutput q
		inner join rds.DimAssessments assess
			on q.AssessmentSubjectCode = assess.AssessmentSubjectCode
			and q.AssessmentTypeCode = assess.AssessmentTypeCode
			and q.ParticipationStatusCode = assess.ParticipationStatusCode
			and q.PerformanceLevelCode = assess.PerformanceLevelCode
			and q.SeaFullYearStatusCode = assess.SeaFullYearStatusCode
			and q.LeaFullYearStatusCode = assess.LeaFullYearStatusCode
			and q.SchFullYearStatusCode = assess.SchFullYearStatusCode
		inner join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
		inner join rds.DimRaces race
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
			on q.BasisOfExitCode = idea.BasisOfExitCode
			and q.DisabilityCode = idea.DisabilityCode
			and q.EducEnvCode = idea.EducEnvCode
			and q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode

		left outer join rds.DimTitleiiiStatuses title3	on title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		left outer join rds.DimAssessmentStatuses assesSts 
		on assesSts.AssessedFirstTimeCode = q.AssessedFirstTime
		and assesSts.AssessmentProgressLevelCode = q.ProgressLevel and q.AcademicAssessmentSubjectCode = q.AssessmentSubjectCode

		left outer join rds.DimNorDProgramStatuses NorDProgramStatuses
		on NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
		and NorDProgramStatuses.NeglectedProgramTypeCode = q.NeglectedProgramTypeCode
		and NorDProgramStatuses.AcademicOrVocationalOutcomeEdFactsCode = q.AcademicOrVocationalOutcomeCode
		and NorDProgramStatuses.AcademicOrVocationalExitOutcomeEdFactsCode = q.AcademicOrVocationalExitOutcomeCode

		left outer join rds.DimStudentStatuses studentStatus
		on studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
		and studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
		and studentStatus.ReferralStatusCode = q.ReferralStatusCode
		and studentStatus.DiplomaCredentialTypeCode = q.DiplomaCredentialCode
		and studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.PlacementTypeCode = q.PlacementStatus

		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
		and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
		and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
		and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
		and cte.RepresentationStatusCode = q.RepresentationStatus
		and cte.CteGraduationRateInclusionCode = q.InclutypCode
		and cte.LepPerkinsStatusCode = q.LepPerkinsStatus

		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

		left outer join rds.DimEnrollmentStatuses enrStatus on q.exitCode = enrStatus.ExitOrWithdrawalCode

		where assess.DimAssessmentId <> -1
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimCountDateId,
		isnull(assess.DimAssessmentId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(title1.DimTitle1StatusId, -1),
		isnull(title3.DimTitleiiiStatusId, -1),
		isnull(assesSts.DimAssessmentStatusId, -1),
		isnull(studentStatus.DimStudentStatusId, -1),
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1),
		isnull(race.DimRaceId,-1),
		isnull(enrStatus.DimEnrollmentStatusId, -1),
		isnull(cte.DimCteStatusId, -1)

		
	end
	else
	begin
		-- Run As Test (return data instead of inserting it)

		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(assess.DimAssessmentId, -1) as DimAssessmentId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(assesSts.DimAssessmentStatusId, -1) as DimAssessmentStatusId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1) as DimNorDProgramStatusId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId,
		isnull(race.DimRaceId,-1) as DimRaceId,
		isnull(enrStatus.DimEnrollmentStatusId, -1) as DimEnrollmentStatusId,
		count(distinct q.DimStudentId) as AssessmentCount
		from #queryOutput q
		inner join rds.DimAssessments assess
			on q.AssessmentSubjectCode = assess.AssessmentSubjectCode
			and q.AssessmentTypeCode = assess.AssessmentTypeCode
			and q.ParticipationStatusCode = assess.ParticipationStatusCode
			and q.PerformanceLevelCode = assess.PerformanceLevelCode
			and q.SeaFullYearStatusCode = assess.SeaFullYearStatusCode
			and q.LeaFullYearStatusCode = assess.LeaFullYearStatusCode
			and q.SchFullYearStatusCode = assess.SchFullYearStatusCode
		inner join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
		inner join rds.DimRaces race
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
			on q.BasisOfExitCode = idea.BasisOfExitCode
			and q.DisabilityCode = idea.DisabilityCode
			and q.EducEnvCode = idea.EducEnvCode
			and q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode

		left outer join rds.DimTitleiiiStatuses title3	on title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		left outer join rds.DimAssessmentStatuses assesSts 
		on assesSts.AssessedFirstTimeCode = q.AssessedFirstTime
		and assesSts.AssessmentProgressLevelCode = q.ProgressLevel and q.AcademicAssessmentSubjectCode = q.AssessmentSubjectCode

		left outer join rds.DimNorDProgramStatuses NorDProgramStatuses
		on NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
		and NorDProgramStatuses.NeglectedProgramTypeCode = q.NeglectedProgramTypeCode
		and NorDProgramStatuses.AcademicOrVocationalOutcomeEdFactsCode = q.AcademicOrVocationalOutcomeCode
		and NorDProgramStatuses.AcademicOrVocationalExitOutcomeEdFactsCode = q.AcademicOrVocationalExitOutcomeCode

		left outer join rds.DimStudentStatuses studentStatus
		on studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
		and studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
		and studentStatus.ReferralStatusCode = q.ReferralStatusCode
		and studentStatus.DiplomaCredentialTypeCode = q.DiplomaCredentialCode
		and studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.PlacementTypeCode = q.PlacementStatus

		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
		and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
		and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
		and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
		and cte.RepresentationStatusCode = q.RepresentationStatus
		and cte.CteGraduationRateInclusionCode = q.InclutypCode
		and cte.LepPerkinsStatusCode = q.LepPerkinsStatus

		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

		left outer join rds.DimEnrollmentStatuses enrStatus on q.exitCode = enrStatus.ExitOrWithdrawalCode

		where assess.DimAssessmentId <> -1
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimCountDateId,
		isnull(assess.DimAssessmentId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(title1.DimTitle1StatusId, -1),
		isnull(title3.DimTitleiiiStatusId, -1),
		isnull(assesSts.DimAssessmentStatusId, -1),
		isnull(studentStatus.DimStudentStatusId, -1),
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1),
		isnull(race.DimRaceId,-1),
		isnull(enrStatus.DimEnrollmentStatusId, -1),
		isnull(cte.DimCteStatusId, -1)

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