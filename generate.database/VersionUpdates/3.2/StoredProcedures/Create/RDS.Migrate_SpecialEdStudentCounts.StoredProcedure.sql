﻿CREATE PROCEDURE [RDS].[Migrate_SpecialEdStudentCounts]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN
	SET NOCOUNT ON;
	--BEGIN TRANSACTION
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
		CohortStatus varchar(10),

		LongTermStatusCode nvarchar(50),
		NeglectedProgramTypeCode nvarchar(50)

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
		CteCode varchar(50),
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50)
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

			
	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end


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
	delete from @title1StatusQuery
	

	-- Get Dimension Data
	----------------------------

	-- Migrate_DimDates
	
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
	exec rds.Migrate_DimRaces  @factTypeCode,  @studentDateQuery

	

	 
	-- Migrate_DimAges

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Age Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END

	insert into @ageQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		AgeCode
	)
	exec rds.Migrate_DimAges @studentDateQuery

	

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
	exec rds.Migrate_DimDemographics @studentDateQuery, @useCutOffDate

	

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
		PersonId,
		DimCountDateId,
		DisabilityCode,
		EducEnvCode,
		BasisOfExitCode,
		SpecialEducationServicesExitDate
	)
	exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, @useCutOffDate

	


	-- Migrate_DimProgramStatuses
	
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
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation
	)
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, @useCutOffDate
	
	

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

		
	-- Migrate_DimTitle1Statuses

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

	

	-- Combine Dimension Data
	----------------------------
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

		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
		StudentCutOverStartDate,
	
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
				
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode
				
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

		isnull(idea.BasisOfExitCode, 'MISSING'),
		isnull(idea.DisabilityCode, 'MISSING'),
		isnull(idea.EducEnvCode, 'MISSING'),
		idea.SpecialEducationServicesExitDate,
		isnull(programStatus.CteCode,'MISSING'),
		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIProgramParticipation, 'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING')

	from @studentDateQuery s
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId 
									and sch.DimSchoolId = idea.DimSchoolId and sch.DimLeaId = idea.DimLeaId
	left outer join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	and ISNULL(idea.SpecialEducationServicesExitDate, Convert(Date,demo.PersonStartDate)) >= Convert(Date,demo.PersonStartDate)
	and ISNULL(idea.SpecialEducationServicesExitDate, Convert(Date,demo.PersonEndDate)) <= Convert(Date,ISNULL(demo.PersonEndDate,idea.SpecialEducationServicesExitDate))
	left outer join @ageQuery a on s.DimStudentId = a.DimStudentId and s.DimCountDateId = a.DimCountDateId
	left outer join @raceQuery race on s.DimStudentId = race.DimStudentId and s.DimCountDateId = race.DimCountDateId
	and ISNULL(idea.SpecialEducationServicesExitDate, Convert(Date,race.RaceRecordStartDate)) >= Convert(Date,race.RaceRecordStartDate)
	and ISNULL(idea.SpecialEducationServicesExitDate,Convert(Date,race.RaceRecordEndDate)) <= Convert(Date,ISNULL(race.RaceRecordEndDate, idea.SpecialEducationServicesExitDate))
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId 
											and sch.DimSchoolId = programStatus.DimSchoolId and sch.DimLeaId = programStatus.DimLeaId
	left outer join @title1StatusQuery title1  on s.DimStudentId = title1.DimStudentId and s.DimCountDateId = title1.DimCountDateId 
												and sch.DimSchoolId = title1.DimSchoolId and sch.DimLeaId = title1.DimLeaId
		
	
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
		a.DimAgeId,
		-1,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,
		-1,	-1,	-1,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		-1, -1, -1, -1,-1,
		q.StudentCutOverStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId
		from #queryOutput q
		inner join rds.DimAges a	on q.AgeCode = a.AgeCode
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

		left outer join rds.DimProgramStatuses programStatus
			on q.CteCode = programStatus.CteProgramCode
			and q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
		
		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode
		
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
		a.DimAgeId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		q.StudentCutOverStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId
		from #queryOutput q
		inner join rds.DimAges a	on q.AgeCode = a.AgeCode
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

		left outer join rds.DimProgramStatuses programStatus
			on q.CteCode = programStatus.CteProgramCode
			and q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
		
		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

	end
	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	END

	END TRY
	BEGIN CATCH
		--ROLLBACK

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

	--COMMIT
	SET NOCOUNT OFF;
END
