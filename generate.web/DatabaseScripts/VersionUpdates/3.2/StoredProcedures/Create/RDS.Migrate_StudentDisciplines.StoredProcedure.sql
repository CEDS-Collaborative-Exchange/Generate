CREATE PROCEDURE [RDS].[Migrate_StudentDisciplines]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRANSACTION

	-- Lookup values

	declare @factTable as varchar(50)
	set @factTable = 'FactStudentDisciplines'
	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	
	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	set @migrationType='rds'

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimStudentId int,
		StudentPersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,

		AgeCode varchar(50),
		GradeLevelCode varchar(50),
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
		--TitleIStatusCode varchar(50),

		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIImmigrantParticipation varchar(50),

		DisciplineActionCode varchar(50),
		DisciplineMethodCode varchar(50),
		EducationalServicesCode varchar(50),
		RemovalReasonCode varchar(50),
		RemovalTypeCode varchar(50),
		DisciplineELStatusCode varchar(50),
		DisciplinaryActionStartDate date,


		FirearmsCode varchar(50),
		FirearmsDisciplineCode varchar(50),
		IDEAFirearmsDisciplineCode varchar(50),

		CteCode varchar(50),
		DisplacedHomemaker varchar(50),
		SingleParent varchar(50),
		CteNonTraditionalEnrollee varchar(50),
		RepresentationStatus varchar(50),
		INCLUTYPCode varchar(50),

		DisciplineCount int,
		DisciplineDuration decimal(18,2)

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
	declare @gradelevelQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		GradeLevelCode Varchar(50)
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
		InclutypCode varchar(50)
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
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIImmigrantParticipation varchar(50)
	)
	declare @firearmQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		FirearmsCode varchar(50))
	declare @disciplineQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DisciplineActionCode varchar(50),
		DisciplineMethodCode varchar(50),
		EducationalServicesCode varchar(50),
		RemovalReasonCode varchar(50),
		RemovalTypeCode varchar(50),
		DisciplineELStatusCode varchar(50),
		DisciplineDuration decimal(18,2),
		DisciplinaryActionStartDate Date
	)
	declare @disciplineFirearmsQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		FirearmsDisciplineCode varchar(50),
		IDEAFirearmsDisciplineCode varchar(50)		
		)
	declare @disciplineQuerySum as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolid int,
		DimLeaId int,
		DisciplineActionCode varchar(50),
		DisciplineMethodCode varchar(50),
		EducationalServicesCode varchar(50),
		RemovalReasonCode varchar(50),
		RemovalTypeCode varchar(50),
		DisciplineELStatusCode varchar(50),
		RemovalLengthSusExpCode varchar(50),
		RemovalLengthIdeaCode varchar(50),
		DisciplineCount int,
		DisciplineDuration decimal(18,2),
		DisciplinaryActionStartDate Date
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

	declare @factDimensions as table(
		DimensionTableName nvarchar(100)
	)

	insert into @factDimensions(DimensionTableName)
	select dt.DimensionTableName 
	from rds.DimFactType_DimensionTables ftd
	inner join rds.DimFactTypes ft on ftd.DimFactTypeId = ft.DimFactTypeId
	inner join app.DimensionTables dt on ftd.DimensionTableId = dt.DimensionTableId
	where ft.FactTypeCode = @factTypeCode
	

	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end


	-- Get Dimension Data
	----------------------------

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
	delete from @ageQuery
	delete from @gradelevelQuery
	delete from @ideaQuery
	delete from @programStatusQuery
	delete from @disciplineFirearmsQuery
	delete from @disciplineQuery
	delete from @disciplineQuerySum
	delete from @firearmQuery
	delete from @cteStatusQuery

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

	END

	
	-- Migrate_DimAges

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimAges')
	BEGIN

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

	END

	--- Migrate GradeLevels

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

	END
	
	-- Migrate_DimDemographics

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimDemographics')
	BEGIN

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
		exec rds.Migrate_DimDemographics @studentDateQuery, 0

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
			DisabilityCode,
			EducEnvCode,
			BasisOfExitCode,
			SpecialEducationServicesExitDate
		)
		exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, 0

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
			TitleIIIImmigrantParticipation

		)
		exec rds.Migrate_DimProgramStatuses @studentDateQuery, 0

	END

----Migrate_DimFirearms

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimFirearms')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Firearms Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @firearmQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			FirearmsCode
		)
		exec rds.Migrate_DimFirearms @studentDateQuery

	END

	--Migrate_DimDisciplineFirearms

	if exists(select 1 from @factDimensions where DimensionTableName = 'DimFirearmsDiscipline')
	BEGIN

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Discipline Firearms Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		insert into @disciplineFirearmsQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			FirearmsDisciplineCode,
			IDEAFirearmsDisciplineCode
		)
		exec rds.Migrate_DimFirearmsDiscipline @studentDateQuery

	END
		
	-- Migrate_DimDisciplines

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Discipline Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	insert into @disciplineQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplineDuration,
		DisciplinaryActionStartDate
	)
	exec rds.Migrate_DimDisciplines @studentDateQuery
		
	insert into @disciplineQuerySum
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplineCount,
		DisciplineDuration,
		DisciplinaryActionStartDate
	)
	select DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,		
		sum( case when isnull(DisciplineDuration,0) > 0 then 1 else 0 end ) as DisciplineCount,
		sum(isnull(DisciplineDuration, 0)) as DisciplineDuration,
		DisciplinaryActionStartDate
	from @disciplineQuery
	group by DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplinaryActionStartDate

	
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
	from rds.Get_StudentOrganizations(@studentDateQuery, 0)

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
			InclutypCode
		)
		exec RDS.Migrate_DimCteStatuses @studentDateQuery

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
		GradeLevelCode,
		RaceCode,

		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected ,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,

		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
	--	TitleIStatusCode,

		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIImmigrantParticipation,

		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplinaryActionStartDate,

		FirearmsCode,
		FirearmsDisciplineCode, 
		IDEAFirearmsDisciplineCode, 

		CteCode,
		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		RepresentationStatus,
		INCLUTYPCode,

		DisciplineCount,
		DisciplineDuration

	)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(sch.DimSchoolId, -1),
		isnull(sch.DimLeaId,-1),

		isnull(a.AgeCode, 'MISSING'),
		isnull(grade.GradeLevelCode,'MISSING'),
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
	--	isnull(idea.TitleIStatusCode, 'MISSING'),

		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIImmigrantParticipation,'MISSING'),

		isnull(dis.DiscIplineActionCode, 'MISSING'),
		isnull(dis.DisciplineMethodCode, 'MISSING'),
		isnull(dis.EducationalServicesCode, 'MISSING'),
		isnull(dis.RemovalReasonCode, 'MISSING'),
		isnull(dis.RemovalTypeCode, 'MISSING'),
		isnull(DisciplineELStatusCode, 'MISSING'),
		DisciplinaryActionStartDate,
		isnull(firearms.FirearmsCode, 'MISSING'),
		isnull(disciplineFirearms.FirearmsDisciplineCode, 'MISSING'),
		isnull(disciplineFirearms.IDEAFirearmsDisciplineCode, 'MISSING'),

		isnull(cteStatus.CteCode,'MISSING'),
		ISNULL(cteStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(cteStatus.SingleParent, 'MISSING'),
		ISNULL(cteStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),

		dis.DisciplineCount,
		dis.DisciplineDuration

	from @studentDateQuery s
	inner join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @disciplineQuerySum dis on s.DimStudentId = dis.DimStudentId and s.DimCountDateId = dis.DimCountDateId 
											and sch.DimSchoolId = dis.DimSchoolId and sch.DimLeaId = dis.DimLeaId
	left outer join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	and dis.DisciplinaryActionStartDate >= Convert(Date,demo.PersonStartDate)
	and dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(demo.PersonEndDate,dis.DisciplinaryActionStartDate))
	left outer join @ageQuery a on s.DimStudentId = a.DimStudentId and s.DimCountDateId = a.DimCountDateId
	left outer join @raceQuery race on s.DimStudentId = race.DimStudentId and s.DimCountDateId = race.DimCountDateId
	and dis.DisciplinaryActionStartDate >= Convert(Date,race.RaceRecordStartDate)
	and dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(race.RaceRecordEndDate,dis.DisciplinaryActionStartDate))
	left outer join @gradelevelQuery grade on s.DimStudentId = grade.DimStudentId and s.DimCountDateId = grade.DimCountDateId 
										and sch.DimSchoolId = grade.DimSchoolId and sch.DimLeaId = grade.DimLeaId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId 
										and idea.DimSchoolId = sch.DimSchoolId and sch.DimLeaId = idea.DimLeaId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId 
										and sch.DimSchoolId = programStatus.DimSchoolId and sch.DimLeaId = programStatus.DimLeaId
	left outer join @firearmQuery firearms on s.DimStudentId = firearms.DimStudentId and s.DimCountDateId = firearms.DimCountDateId 
										and sch.DimSchoolId = firearms.DimSchoolId and sch.DimLeaId = firearms.DimLeaId
	left outer join @disciplineFirearmsQuery disciplineFirearms on s.DimStudentId = disciplineFirearms.DimStudentId and s.DimCountDateId = disciplineFirearms.DimCountDateId 
										and sch.DimSchoolId = disciplineFirearms.DimSchoolId and sch.DimLeaId = disciplineFirearms.DimLeaId
	left outer join @cteStatusQuery cteStatus  on s.DimStudentId = cteStatus.DimStudentId and s.DimCountDateId = cteStatus.DimCountDateId 
										and sch.DimSchoolId = cteStatus.DimSchoolId and sch.DimLeaId = cteStatus.DimLeaId

	
	
	-- Delete Old Facts
	----------------------------

	-- Log history
	
	--if @runAsTest = 0
	--begin
	--	insert into app.DataMigrationHistories
	--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Delete Old Facts')
	--end

	--if @runAsTest = 0
	--begin
	--	delete from rds.FactStudentDisciplines where DimFactTypeId = @factTypeId
	--end

	-- Insert New Facts
	----------------------------

	-- Log history

	if @runAsTest = 0
	begin

		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

		insert into rds.FactStudentDisciplines
		(
			DimFactTypeId,
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			DimCountDateId,
			DimAgeId,
			DimGradeLevelId,
			DimDemographicId,
			DimIdeaStatusId,
			DimProgramStatusId,
			DimDisciplineId,
			DimFirearmsId,
			DimFirearmsDisciplineId,
			DisciplineCount,
			DisciplineDuration,
			DisciplinaryActionStartDate,
			DimRaceId,
			DimCteStatusId
		)
		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1) as DimAgeId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(dis.DimDisciplineId, -1) as DimDisciplineId,
		isnull(firearms.DimFirearmsId,-1) as DimFirearmsId,
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1) as DimFirearmsDisciplineId,
		sum(
			case
				when dis.DimDisciplineId <> -1 then q.DisciplineCount
				else 0
			end
		) as DisciplineCount,
		sum(
			case
				when dis.DimDisciplineId <> -1 then q.DisciplineDuration
				else 0
			end
		) as DisciplineDuration,
		isnull(q.DisciplinaryActionStartDate,getdate()) as DisciplinaryActionStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId
		from #queryOutput q
		left outer join rds.DimAges a on q.AgeCode = a.AgeCode
		left outer join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
		left outer join rds.DimRaces race
			on q.RaceCode = race.RaceCode and race.DimFactTypeId = @factTypeId
		left outer join rds.DimDemographics d 
			on q.EcoDisStatusCode = d.EcoDisStatusCode
			and q.HomelessStatusCode = d.HomelessStatusCode
			and q.LepStatusCode = d.LepStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and q.SexCode = d.SexCode
			and q.MilitaryConnected = d.MilitaryConnectedStatusCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessNighttimeResidenceCode
		left outer join rds.DimIdeaStatuses idea
			on q.BasisOfExitCode = idea.BasisOfExitCode
			and q.DisabilityCode = idea.DisabilityCode
			and q.EducEnvCode = idea.EducEnvCode
		--	and q.TitleIStatusCode = idea.TitleISchStatusCode
		left outer join rds.DimDisciplines dis
			on q.DisciplineActionCode = dis.DisciplineActionCode
			and q.DisciplineMethodCode = dis.DisciplineMethodCode
			and q.EducationalServicesCode = dis.EducationalServicesCode
			and q.RemovalReasonCode = dis.RemovalReasonCode
			and q.RemovalTypeCode = dis.RemovalTypeCode
			and q.DisciplineELStatusCode = dis.DisciplineELStatusCode
		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIImmigrantParticipation = programStatus.TitleiiiProgramParticipationCode
		left outer join rds.DimFirearms firearms on firearms.FirearmsCode=q.FirearmsCode
		left outer join rds.DimFirearmsDiscipline disciplineFirearms 
			on disciplineFirearms.FirearmsDisciplineCode=q.FirearmsDisciplineCode
			and disciplineFirearms.IDEAFirearmsDisciplineCode=q.IDEAFirearmsDisciplineCode
		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
			and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			and cte.RepresentationStatusCode = q.RepresentationStatus
			and cte.CteGraduationRateInclusionCode = q.InclutypCode
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(dis.DimDisciplineId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(firearms.DimFirearmsId, -1),
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1),
		isnull(race.DimRaceId,-1),
		isnull(cte.DimCteStatusId, -1),
		q.DisciplinaryActionStartDate

		
	end
	else
	begin

		-- Run As Test (return data instead of inserting it)
				
		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1) as DimAgeId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(dis.DimDisciplineId, -1) as DimDisciplineId,
		isnull(firearms.DimFirearmsId,-1) as DimFirearmsId,
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1) as DimFirearmsDisciplineId,
		sum(
			case
				when dis.DimDisciplineId <> -1 then q.DisciplineCount
				else 0
			end
		) as DisciplineCount,
		sum(
			case
				when dis.DimDisciplineId <> -1 then q.DisciplineDuration
				else 0
			end
		) as DisciplineDuration,
		isnull(q.DisciplinaryActionStartDate,getdate()) as DisciplinaryActionStartDate,
		isnull(race.DimRaceId,-1) as DimRaceId,
		isnull(cte.DimCteStatusId, -1) as DimCteStatusId
		from #queryOutput q
		left outer join rds.DimAges a on q.AgeCode = a.AgeCode
		left outer join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
		left outer join rds.DimRaces race
			on q.RaceCode = race.RaceCode and race.DimFactTypeId = @factTypeId
		left outer join rds.DimDemographics d 
			on q.EcoDisStatusCode = d.EcoDisStatusCode
			and q.HomelessStatusCode = d.HomelessStatusCode
			and q.LepStatusCode = d.LepStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and q.SexCode = d.SexCode
			and q.MilitaryConnected = d.MilitaryConnectedStatusCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessNighttimeResidenceCode
		left outer join rds.DimIdeaStatuses idea
			on q.BasisOfExitCode = idea.BasisOfExitCode
			and q.DisabilityCode = idea.DisabilityCode
			and q.EducEnvCode = idea.EducEnvCode
		left outer join rds.DimDisciplines dis
			on q.DisciplineActionCode = dis.DisciplineActionCode
			and q.DisciplineMethodCode = dis.DisciplineMethodCode
			and q.EducationalServicesCode = dis.EducationalServicesCode
			and q.RemovalReasonCode = dis.RemovalReasonCode
			and q.RemovalTypeCode = dis.RemovalTypeCode
			and q.DisciplineELStatusCode = dis.DisciplineELStatusCode
		left outer join rds.DimProgramStatuses programStatus
			on q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIImmigrantParticipation = programStatus.TitleiiiProgramParticipationCode
		left outer join rds.DimFirearms firearms on firearms.FirearmsCode=q.FirearmsCode
		left outer join rds.DimFirearmsDiscipline disciplineFirearms 
			on disciplineFirearms.FirearmsDisciplineCode=q.FirearmsDisciplineCode
			and disciplineFirearms.IDEAFirearmsDisciplineCode=q.IDEAFirearmsDisciplineCode
		left outer join rds.dimcteStatuses cte on q.CteCode = cte.CteProgramCode
			and cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			and cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			and cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			and cte.RepresentationStatusCode = q.RepresentationStatus
			and cte.CteGraduationRateInclusionCode = q.InclutypCode
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(dis.DimDisciplineId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(firearms.DimFirearmsId, -1),
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1),
		isnull(race.DimRaceId,-1),
		isnull(cte.DimCteStatusId, -1),
		q.DisciplinaryActionStartDate

	end
	
	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	END

	END TRY
	BEGIN CATCH
		ROLLBACK

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

	COMMIT
	
	SET NOCOUNT OFF;

END
