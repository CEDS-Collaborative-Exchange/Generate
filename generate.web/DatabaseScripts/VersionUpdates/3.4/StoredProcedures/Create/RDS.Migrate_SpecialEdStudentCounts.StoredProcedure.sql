CREATE PROCEDURE [RDS].[Migrate_SpecialEdStudentCounts]
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

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end

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

		GradeLevelCode varchar(50),

		CteCode varchar(50),
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50),
		HomelessServicedIndicatorCode varchar(50),

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
		Title1ProgramTypeCode varchar(50)
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
		DimLeaId int,
		DimSchoolId int,
		DimCountDateId int,
		AgeCode varchar(50),
		Exitdate datetime
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
	delete from @cteStatusQuery
	

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
	exec rds.Migrate_DimRaces  @factTypeCode,  @studentDateQuery

	if @runAsTest = 1
	BEGIN
		print 'raceQuery'
		select * from @raceQuery
	END

	 
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
		DimLeaId,
		DimSchoolId,
		DimCountDateId,
		AgeCode,
		Exitdate
	)
	exec rds.Migrate_DimAges @studentDateQuery, @factTypeCode

	if @runAsTest = 1
	BEGIN
		print 'ageQuery'
		select * from @ageQuery
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
	exec rds.Migrate_DimDemographics @studentDateQuery, @useCutOffDate

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
		PersonId,
		DimCountDateId,
		IDEAIndicatorCode,
		DisabilityCode,
		EducEnvCode,
		BasisOfExitCode,
		SpecialEducationServicesExitDate
	)
	exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, @useCutOffDate

	delete from @ideaQuery where SpecialEducationServicesExitDate is NULL

	if @runAsTest = 1
	BEGIN
		print '@ideaQuery'
		select * from @ideaQuery
	END

	
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
		print '@programStatusQuery'
		select * from @programStatusQuery
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
		print '@schoolQuery'
		select * from @schoolQuery
	END

		
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

	if @runAsTest = 1
	BEGIN
		print 'title1StatusQuery'
		select * from @title1StatusQuery
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


	-- Combine Dimension Data
	----------------------------
	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combining Dimension Data for (' + @factTypeCode + ') -  ' + @submissionYear)
	end

	insert into #queryOutput
	(
		DimStudentId,StudentPersonId,DimCountDateId,DimSchoolId,DimLeaId,
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
	
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode,
				
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,

		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		RepresentationStatus,
		InclutypCode,
		LepPerkinsStatus
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
		isnull(cteStatus.CteCode,'MISSING'),
		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIProgramParticipation, 'MISSING'),
		isnull(programStatus.HomelessServicedIndicatorCode, 'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),

		ISNULL(cteStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(cteStatus.SingleParent, 'MISSING'),
		ISNULL(cteStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatus, 'MISSING')

	from @studentDateQuery s
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId 
									and sch.DimSchoolId = idea.DimSchoolId and sch.DimLeaId = idea.DimLeaId
	left outer join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	and idea.SpecialEducationServicesExitDate >= Convert(Date,demo.PersonStartDate)
	and idea.SpecialEducationServicesExitDate <= Convert(Date,ISNULL(demo.PersonEndDate, idea.SpecialEducationServicesExitDate))
	left outer join @raceQuery race on s.DimStudentId = race.DimStudentId and s.DimCountDateId = race.DimCountDateId
	and idea.SpecialEducationServicesExitDate >= Convert(Date,race.RaceRecordStartDate)
	and idea.SpecialEducationServicesExitDate <= Convert(Date,ISNULL(race.RaceRecordEndDate, idea.SpecialEducationServicesExitDate))
	left outer join @ageQuery a on s.DimStudentId = a.DimStudentId and s.DimCountDateId = a.DimCountDateId 
									and a.Exitdate = idea.SpecialEducationServicesExitDate
									and sch.DimSchoolId = a.DimSchoolId and sch.DimLeaId = a.DimLeaId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId 
											and sch.DimSchoolId = programStatus.DimSchoolId and sch.DimLeaId = programStatus.DimLeaId
	left outer join @title1StatusQuery title1  on s.DimStudentId = title1.DimStudentId and s.DimCountDateId = title1.DimCountDateId 
												and sch.DimSchoolId = title1.DimSchoolId and sch.DimLeaId = title1.DimLeaId
	left outer join @cteStatusQuery cteStatus on s.DimStudentId = cteStatus.DimStudentId and s.DimCountDateId = cteStatus.DimCountDateId 
										and sch.DimSchoolId = cteStatus.DimSchoolId and sch.DimLeaId = cteStatus.DimLeaId
	
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
			StudentCutOverStartDate,
			DimRaceId,
			DimCteStatusId
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
		isnull(race.DimRaceId,-1) as DimRaceId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId
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
			and q.IDEAIndicatorCode = idea.IDEAIndicatorCode

		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		
		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
		and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
		and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
		and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
		and cte.RepresentationStatusCode = q.RepresentationStatus
		and cte.CteGraduationRateInclusionCode = q.InclutypCode
		and cte.LepPerkinsStatusCode = q.LepPerkinsStatus
		
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
		-1,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,
		-1,	-1,	-1,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		-1, -1, -1, -1,-1,
		q.StudentCutOverStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId
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
			and q.IDEAIndicatorCode = idea.IDEAIndicatorCode

		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		
		left outer join rds.DimTitle1Statuses title1
		on title1.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
		and title1.Title1ProgramTypeCode = q.Title1ProgramTypeCode
		and title1.Title1SchoolStatusCode = q.TitleISchoolStatusCode
		and title1.Title1SupportServicesCode = q.Title1SupportServiceCode

		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
		and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
		and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
		and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
		and cte.RepresentationStatusCode = q.RepresentationStatus
		and cte.CteGraduationRateInclusionCode = q.InclutypCode
		and cte.LepPerkinsStatusCode = q.LepPerkinsStatus

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
