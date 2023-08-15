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

	-- Migrate_DimRaces

	declare @raceQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		RaceCode varchar(50),
		RaceRecordStartDate datetime,
		RaceRecordEndDate datetime
	)

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
		HomelessNighttimeResidenceCode varchar(50),
		PersonStartDate DateTime,
		PersonEndDate DateTime
		unique clustered (DimStudentId, DimCountDateId)
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
		HomelessNighttimeResidenceCode,
		PersonStartDate,
		PersonEndDate
	)
	exec rds.Migrate_DimDemographics @studentDateQuery, 1

	-- Migrate_DimIdeaStatuses

	declare @ideaQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		DisabilityCode varchar(50),
		EducEnvCode varchar(50),
		BasisOfExitCode varchar(50),
		SpecialEducationServicesExitDate Date
		unique clustered (DimStudentId, DimSchoolId, DimCountDateId)
	)

	insert into @ideaQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		DisabilityCode,
		EducEnvCode,
		BasisOfExitCode,
		SpecialEducationServicesExitDate
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
		TitleIIIProgramParticipation varchar(50)
		unique clustered (DimStudentId, DimSchoolId, DimCountDateId)
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
		TitleIIIProgramParticipation
	)
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, 0

	-- Migrate_DimAssessments

	declare @assessmentQuery as table (
		DimStudentId int,
		PersonId int,
		DimSchoolId int,
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

	insert into @assessmentQuery
	(
		DimStudentId,
		PersonId,
		DimSchoolId,
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
	
	-- Migrate_DimSchools

	declare @schoolQuery as table (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int
		unique clustered (DimStudentId, DimSchoolId, DimCountDateId, DimLeaId)
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

	-- Migrate Title III Statuses

	declare @titleIIIStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		TitleIIIAccountabilityCode varchar(50),
		TitleIIILanguageInstructionCode varchar(50),		
		ProficiencyStatusCode varchar(50),
		FormerEnglishLearnerYearStatus varchar(50)
	)

	insert into @titleIIIStatusQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus
	)
	exec rds.[Migrate_DimTitleIIIStatuses] @studentDateQuery

	declare @AssessmentStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,		
		AssessedFirstTime varchar(50),
		AcademicSubjectCode varchar(50),
		ProgressLevelCode varchar(50)
	)

	insert into @AssessmentStatusQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,		
		AssessedFirstTime,
		AcademicSubjectCode,
		ProgressLevelCode 
	)
	exec [RDS].[Migrate_DimAssessmentStatuses] @studentDateQuery

	
	-- Migrate_DimStudentStatuses

	declare @studentStatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
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
		InclutypCode varchar(50)
	)

	insert into @studentStatusQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
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
		InclutypCode
					
	)
	exec rds.[migrate_DimStudentStatuses] @studentDateQuery
	
	-- migrate N or D Statuses
	declare @NoDProgramStatus as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int, 
		DimCountDateId int,
		LongTermStatusCode varchar(10), 
		NeglectedProgramTypeCode varchar(30)
	)
	insert into @NoDProgramStatus
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		LongTermStatusCode,
		NeglectedProgramTypeCode
	)
	exec RDS.Migrate_DimNoDProgramStatuses @studentDateQuery
	
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
		CteCode varchar(50),
		ImmigrantTitleIIICode varchar(50),
		Section504Code varchar(50),
		FoodServiceEligibilityCode varchar(50),
		FosterCareCode varchar(50),
		TitleIIIProgramParticipation varchar(50),
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
		RepresentationStatus varchar(50),
		INCLUTYPCode varchar(50),
		LongTermStatusCode nvarchar(50),
		NeglectedProgramTypeCode nvarchar(50),
		AssessmentCount int
	)

	insert into #queryOutput
	(
		DimStudentId,
		StudentPersonId,
		DimCountDateId,
		DimSchoolId,
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
		--TitleIStatusCode,
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
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
		RepresentationStatus,
		INCLUTYPCode,
		LongTermStatusCode,
		NeglectedProgramTypeCode,
		AssessmentCount
	)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(sch.DimSchoolId, -1),
		isnull(race.RaceCode,'MISSING'),
		isnull(demo.EcoDisStatusCode, 'MISSING'),
		isnull(demo.HomelessStatusCode, 'MISSING'),
		isnull(demo.LepStatusCode, 'MISSING'),
		isnull(demo.MigrantStatusCode, 'MISSING'),
		isnull(demo.SexCode, 'MISSING'),
		isnull(demo.MilitaryConnected ,'MISSING'),
		isnull(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		isnull(demo.HomelessNighttimeResidenceCode, 'MISSING'),
		isnull(idea.BasisOfExitCode, 'MISSING'),
		isnull(idea.DisabilityCode, 'MISSING'),
		isnull(idea.EducEnvCode, 'MISSING'),
		--isnull(idea.TitleIStatusCode, 'MISSING'),
		isnull(programStatus.CteCode,'MISSING'),
		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIProgramParticipation,'MISSING'),
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
		ISNULL(studentStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(studentStatus.SingleParent, 'MISSING'),
		ISNULL(studentStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(studentStatus.PlacementType, 'MISSING'),
		ISNULL(studentStatus.PlacementStatus, 'MISSING'),
		ISNULL(studentStatus.RepresentationStatus, 'MISSING'),
		ISNULL(studentStatus.InclutypCode, 'MISSING'),
		isnull(noDProgramStatus.LongTermStatusCode , 'MISSING'),
		isnull(noDProgramStatus.NeglectedProgramTypeCode, 'MISSING'),
		isnull(assess.AssessmentCount, 0)
	from @studentDateQuery s
	inner join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId 
	left outer join @raceQuery race on s.DimStudentId = race.DimStudentId and s.DimCountDateId = race.DimCountDateId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId and idea.DimSchoolId = sch.DimSchoolId
	left outer join @assessmentQuery assess on s.DimStudentId = assess.DimStudentId and s.DimCountDateId = assess.DimCountDateId and sch.DimSchoolId = assess.DimSchoolId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId and programStatus.DimSchoolId = sch.DimSchoolId
	left outer join @titleIIIStatusQuery titleIII  on s.DimStudentId = titleIII.DimStudentId and s.DimCountDateId = titleIII.DimCountDateId and sch.DimSchoolId = titleIII.DimSchoolId
	left outer join @AssessmentStatusQuery asq on  s.DimStudentId = asq.DimStudentId and s.DimCountDateId = asq.DimCountDateId and sch.DimSchoolId = asq.DimSchoolId 
	left outer join @studentStatusQuery studentStatus on s.DimStudentId = studentStatus.DimStudentId and s.DimCountDateId = studentStatus.DimCountDateId and sch.DimSchoolId = studentStatus.DimSchoolId
	left join @NoDProgramStatus noDProgramStatus  on s.DimStudentId = noDProgramStatus.DimStudentId and s.DimCountDateId = noDProgramStatus.DimCountDateId and sch.DimSchoolId = noDProgramStatus.DimSchoolId

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
		delete from rds.FactStudentAssessments where DimFactTypeId = @factTypeId
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
		insert into rds.FactStudentAssessments
		(
			DimFactTypeId,
			DimStudentId,
			DimSchoolId,
			DimCountDateId,
			DimDemographicId,
			DimIdeaStatusId,
			DimAssessmentId,
			DimGradeLevelId,
			DimProgramStatusId,
			DimTitleiiiStatusId,
			DimAssessmentStatusId,
			DimStudentStatusId,
			DimNorDProgramStatusId,
			DimRaceId,
			AssessmentCount
			
		)
		select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(assess.DimAssessmentId, -1) as DimAssessmentId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(assesSts.DimAssessmentStatusId, -1) as DimAssessmentStatusId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1) as DimNorDProgramStatusId,
		isnull(race.DimRaceId,-1) as DimRaceId,
		sum(
			case
				when assess.DimAssessmentId <> -1 then q.AssessmentCount
				else 0
			end
		) as AssessmentCount
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
		left outer join rds.DimRaces race
			on q.RaceCode = race.RaceCode
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
		--	and q.TitleIStatusCode = idea.TitleISchStatusCode
		left outer join rds.DimProgramStatuses programStatus
			on q.CteCode = programStatus.CteProgramCode
			and q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
		left outer join rds.DimTitleiiiStatuses title3
		on 
		title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		left outer join rds.DimAssessmentStatuses assesSts 
		on assesSts.AssessedFirstTimeCode = q.AssessedFirstTime
		and assesSts.AssessmentProgressLevelCode = q.ProgressLevel and q.AcademicAssessmentSubjectCode = q.AssessmentSubjectCode

		left join rds.DimNorDProgramStatuses NorDProgramStatuses
		on NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
		and NorDProgramStatuses.NeglectedProgramTypeCode = q.NeglectedProgramTypeCode

		left outer join rds.DimStudentStatuses studentStatus
		on studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
		and studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
		and studentStatus.ReferralStatusCode = q.ReferralStatusCode
		and studentStatus.DiplomaCredentialTypeCode = q.DiplomaCredentialCode
		and studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
		and studentStatus.DisplacedHomeMakerCode = q.DisplacedHomemaker
		and studentStatus.SingleParentCode = q.SingleParent
		and studentStatus.NonTraditionalEnrolleeCode = q.CteNonTraditionalEnrollee
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.PlacementTypeCode = q.PlacementStatus
		and studentStatus.RepresentationStatusCode = q.RepresentationStatus
		and studentStatus.IncluTypCode=q.IncluTypCode
		where assess.DimAssessmentId <> -1
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(assess.DimAssessmentId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(title3.DimTitleiiiStatusId, -1),
		isnull(assesSts.DimAssessmentStatusId, -1),
		isnull(studentStatus.DimStudentStatusId, -1),
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1),
		isnull(race.DimRaceId,-1)
	end
	else
	begin
		-- Run As Test (return data instead of inserting it)
		/*
			[RDS].[Migrate_StudentAssessments] @factTypeCode='datapopulation', @runAsTest=0
		*/
				select
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,
		isnull(assess.DimAssessmentId, -1) as DimAssessmentId,
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(assesSts.DimAssessmentStatusId, -1) as DimAssessmentStatusId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1) as DimNorDProgramStatusId,
		isnull(race.DimRaceId,-1) as DimRaceId,
		sum(
			case
				when assess.DimAssessmentId <> -1 then q.AssessmentCount
				else 0
			end
		) as AssessmentCount
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
		left outer join rds.DimRaces race
			on q.RaceCode = race.RaceCode
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
		--	and q.TitleIStatusCode = idea.TitleISchStatusCode
		left outer join rds.DimProgramStatuses programStatus
			on q.CteCode = programStatus.CteProgramCode
			and q.ImmigrantTitleIIICode = programStatus.ImmigrantTitleIIIProgramCode
			and q.Section504Code = programStatus.Section504ProgramCode
			and q.FoodServiceEligibilityCode = programStatus.FoodServiceEligibilityCode
			and q.FosterCareCode = programStatus.FosterCareProgramCode
			and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
		left outer join rds.DimTitleiiiStatuses title3
		on 
		title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		left outer join rds.DimAssessmentStatuses assesSts 
		on assesSts.AssessedFirstTimeCode = q.AssessedFirstTime
		and assesSts.AssessmentProgressLevelCode = q.ProgressLevel and q.AcademicAssessmentSubjectCode = q.AssessmentSubjectCode

		left join rds.DimNorDProgramStatuses NorDProgramStatuses
		on NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
		and NorDProgramStatuses.NeglectedProgramTypeCode = q.NeglectedProgramTypeCode

		left outer join rds.DimStudentStatuses studentStatus
		on studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
		and studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
		and studentStatus.ReferralStatusCode = q.ReferralStatusCode
		and studentStatus.DiplomaCredentialTypeCode = q.DiplomaCredentialCode
		and studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
		and studentStatus.DisplacedHomeMakerCode = q.DisplacedHomemaker
		and studentStatus.SingleParentCode = q.SingleParent
		and studentStatus.NonTraditionalEnrolleeCode = q.CteNonTraditionalEnrollee
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.PlacementTypeCode = q.PlacementStatus
		and studentStatus.RepresentationStatusCode = q.RepresentationStatus
		and studentStatus.IncluTypCode=q.IncluTypCode
		where assess.DimAssessmentId <> -1
		group by
		q.DimStudentId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(assess.DimAssessmentId, -1),
		isnull(grade.DimGradeLevelId, -1),
		isnull(d.DimDemographicId, -1),
		isnull(idea.DimIdeaStatusId, -1),
		isnull(programStatus.DimProgramStatusId, -1),
		isnull(title3.DimTitleiiiStatusId, -1),
		isnull(assesSts.DimAssessmentStatusId, -1),
		isnull(studentStatus.DimStudentStatusId, -1),
		isnull(NorDProgramStatuses.DimNorDProgramStatusId, -1),
		isnull(race.DimRaceId,-1)
		order by q.DimStudentId, q.DimCountDateId

	end
	drop table #queryOutput
	SET NOCOUNT OFF;
END

