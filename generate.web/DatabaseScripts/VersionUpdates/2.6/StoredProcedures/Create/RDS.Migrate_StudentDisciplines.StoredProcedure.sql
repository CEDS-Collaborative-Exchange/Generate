CREATE PROCEDURE [RDS].[Migrate_StudentDisciplines]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

	SET NOCOUNT ON;

	-- Lookup values

	declare @factTable as varchar(50)
	set @factTable = 'FactStudentDisciplines'
	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	if @factTypeCode = 'datapopulation'
	begin
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'ods'
		set @migrationType='ods'
	end
	else
	begin
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
		set @migrationType='rds'
	end

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end


	-- Get Dimension Data
	----------------------------

	-- Migrate_DimDates
	
	declare @studentDateQuery as rds.StudentDateTableType

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
	exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType


	-- Migrate_DimAges

	declare @ageQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		AgeCode varchar(50)
	)

	insert into @ageQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		AgeCode
	)
	exec rds.Migrate_DimAges @studentDateQuery

	--- Migrate GradeLevels
	
	declare @gradelevelQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		GradeLevelCode Varchar(50)
	)
	insert into @gradelevelQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		GradeLevelCode
	)
	exec rds.Migrate_DimGradeLevels @studentDateQuery


	
	-- Migrate_DimDemographics

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
		HomelessNighttimeResidenceCode varchar(50)
	)

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
		HomelessNighttimeResidenceCode
	)
	exec rds.Migrate_DimDemographics @studentDateQuery, 0


	-- Migrate_DimIdeaStatuses

	declare @ideaQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		DisabilityCode varchar(50),
		EducEnvCode varchar(50),
		BasisOfExitCode varchar(50)
	)

	insert into @ideaQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		DisabilityCode,
		EducEnvCode,
		BasisOfExitCode
	)
	exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode

	-- Migrate_DimProgramStatuses

	declare @programStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		CteCode varchar(50),
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIImmigrantParticipation varchar(50)
	)

	insert into @programStatusQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIImmigrantParticipation

	)
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, 0

----Migrate_DimFirearms
	declare @firearmQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		FirearmsCode varchar(50))

	insert into @firearmQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		FirearmsCode
	)
	exec rds.Migrate_DimFirearms @studentDateQuery

	--Migrate_DimDisciplineFirearms
	declare @disciplineFirearmsQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		FirearmsDisciplineCode varchar(50),
		IDEAFirearmsDisciplineCode varchar(50)		
		)

	insert into @disciplineFirearmsQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		FirearmsDisciplineCode,
		IDEAFirearmsDisciplineCode
	)
	exec rds.Migrate_DimFirearmsDiscipline @studentDateQuery



	
	-- Migrate_DimDisciplines

	declare @disciplineQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DisciplineActionCode varchar(50),
		DisciplineMethodCode varchar(50),
		EducationalServicesCode varchar(50),
		RemovalReasonCode varchar(50),
		RemovalTypeCode varchar(50),
		DisciplineELStatusCode varchar(50),
		DisciplineDuration decimal(18,2)
	)

	insert into @disciplineQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplineDuration
	)
	exec rds.Migrate_DimDisciplines @studentDateQuery

	declare @disciplineQuerySum as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolid int,
		DisciplineActionCode varchar(50),
		DisciplineMethodCode varchar(50),
		EducationalServicesCode varchar(50),
		RemovalReasonCode varchar(50),
		RemovalTypeCode varchar(50),
		DisciplineELStatusCode varchar(50),
		RemovalLengthSusExpCode varchar(50),
		RemovalLengthIdeaCode varchar(50),
		DisciplineCount int,
		DisciplineDuration decimal(18,2)
	)

	
	insert into @disciplineQuerySum
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplineCount,
		DisciplineDuration
	)
	select DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,		
		sum( case when isnull(DisciplineDuration,0) > 0 then 1 else 0 end ) as DisciplineCount,
		sum(isnull(DisciplineDuration, 0)) as DisciplineDuration
	from @disciplineQuery
	group by DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode

	-- Migrate_DimSchools

	declare @schoolQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int
	)

	insert into @schoolQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId
	)
	exec rds.Migrate_DimSchools_Students @studentDateQuery, 0


	-- Combine Dimension Data
	----------------------------

	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combine Dimension Data')
	end

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimStudentId int,
		StudentPersonId int,
		DimCountDateId int,
		DimSchoolId int,

		AgeCode varchar(50),
		GradeLevelCode varchar(50),

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

		CteCode varchar(50),
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


		FirearmsCode varchar(50),
		FirearmsDisciplineCode varchar(50),
		IDEAFirearmsDisciplineCode varchar(50),

		DisciplineCount int,
		DisciplineDuration decimal(18,2)

	)

	insert into #queryOutput
	(
		DimStudentId,
		StudentPersonId,
		DimCountDateId,
		DimSchoolId,
		AgeCode,
		GradeLevelCode,

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

		CteCode,
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


		FirearmsCode,
		FirearmsDisciplineCode, 
		IDEAFirearmsDisciplineCode, 

		DisciplineCount,
		DisciplineDuration

	)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(dis.DimSchoolId, -1),
		
		isnull(a.AgeCode, 'MISSING'),
		isnull(grade.GradeLevelCode,'MISSING'),

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

		isnull(programStatus.CteCode,'MISSING'),
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
		isnull(firearms.FirearmsCode, 'MISSING'),
		isnull(disciplineFirearms.FirearmsDisciplineCode, 'MISSING'),
		isnull(disciplineFirearms.IDEAFirearmsDisciplineCode, 'MISSING'),
		dis.DisciplineCount,
		dis.DisciplineDuration

	from @studentDateQuery s
	inner join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	left outer join @ageQuery a on s.DimStudentId = a.DimStudentId and s.DimCountDateId = a.DimCountDateId
	left outer join @gradelevelQuery grade on s.DimStudentId = grade.DimStudentId and s.DimCountDateId = grade.DimCountDateId and sch.DimSchoolId = grade.DimSchoolId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId and idea.DimSchoolId = sch.DimSchoolId
	left outer join @disciplineQuerySum dis on s.DimStudentId = dis.DimStudentId and s.DimCountDateId = dis.DimCountDateId and sch.DimSchoolId = dis.DimSchoolId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId and sch.DimSchoolId = programStatus.DimSchoolId
	left outer join @firearmQuery firearms on s.DimStudentId = firearms.DimStudentId and s.DimCountDateId = firearms.DimCountDateId and sch.DimSchoolId = firearms.DimSchoolId
	left outer join @disciplineFirearmsQuery disciplineFirearms on s.DimStudentId = disciplineFirearms.DimStudentId and s.DimCountDateId = disciplineFirearms.DimCountDateId and sch.DimSchoolId = disciplineFirearms.DimSchoolId
	





	-- Delete Old Facts
	----------------------------

	-- Log history
	
	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Delete Old Facts')
	end

	if @runAsTest = 0
	begin
		delete from rds.FactStudentDisciplines where DimFactTypeId = @factTypeId
	end

	-- Insert New Facts
	----------------------------

	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Insert New Facts')
	end

	if @runAsTest = 0
	begin
		insert into rds.FactStudentDisciplines
		(
			DimFactTypeId,
			DimStudentId,
			DimSchoolId,
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
			DisciplineDuration
		)
		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
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
		) as DisciplineDuration
		from #queryOutput q
		left outer join rds.DimAges a on q.AgeCode = a.AgeCode
		left outer join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
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
			on q.CteCode = programStatus.CteProgramCode
			and q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIImmigrantParticipation = programStatus.TitleiiiProgramParticipationCode
		left outer join rds.DimFirearms firearms on firearms.FirearmsCode=q.FirearmsCode
		left outer join rds.DimFirearmsDiscipline disciplineFirearms 
			on disciplineFirearms.FirearmsDisciplineCode=q.FirearmsDisciplineCode
			and disciplineFirearms.IDEAFirearmsDisciplineCode=q.IDEAFirearmsDisciplineCode
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(dis.DimDisciplineId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(firearms.DimFirearmsId, -1),
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1)
	end
	else
	begin

		-- Run As Test (return data instead of inserting it)
				
		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1) as DimAgeId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(dis.DimDisciplineId, -1) as DimDisciplineId,
		isnull(dis.DimDisciplineId, -1) as DimDisciplineId,
		isnull(firearms.DimFirearmsId,-1) as DimFirearmsId,
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1) as DimFirearmsDisciplineId,
		sum(
			case
				when dis.DimDisciplineId <> -1 then DisciplineCount
				else 0
			end
		) as DisciplineCount,
		sum(
			case
				when dis.DimDisciplineId <> -1 then DisciplineDuration
				else 0
			end
		) as DisciplineDuration
		from #queryOutput q
		left outer join rds.DimAges a on q.AgeCode = a.AgeCode
		left outer join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
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
			on q.CteCode = programStatus.CteProgramCode
			and q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
		left outer join rds.DimFirearms firearms 
			on firearms.FirearmsCode=q.FirearmsCode
		left outer join rds.DimFirearmsDiscipline disciplineFirearms 
			on disciplineFirearms.FirearmsDisciplineCode=q.FirearmsDisciplineCode
			and disciplineFirearms.IDEAFirearmsDisciplineCode=q.IDEAFirearmsDisciplineCode
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(a.DimAgeId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(dis.DimDisciplineId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(firearms.DimFirearmsId, -1),
		isnull(disciplineFirearms.DimFirearmsDisciplineId,-1)
		order by q.DimStudentId, q.DimCountDateId

	end

	drop table #queryOutput


	

	SET NOCOUNT OFF;

END
