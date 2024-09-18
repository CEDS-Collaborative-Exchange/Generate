CREATE PROCEDURE [RDS].[Migrate_StudentCounts]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

	SET NOCOUNT ON;

	-- Lookup values

	declare @factTable as varchar(50)
	set @factTable = 'FactStudentCounts'

	declare @dataMigrationTypeId as int
	if @factTypeCode = 'datapopulation'
	begin
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'ods'
	end
	else
	begin
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	end

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	declare @useChildCountDate as bit
	set @useChildCountDate = 0

	IF @factTypeCode = 'childcount'
	BEGIN
		set @useChildCountDate = 1
	END
	
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
	exec rds.Migrate_DimDates_Students @factTypeCode

	 
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
		HomelessUnaccompaniedYouthStatusCode ,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected,
		HomelessNighttimeResidenceCode
	)
	exec rds.Migrate_DimDemographics @studentDateQuery, @useChildCountDate


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
		TitleIIIProgramParticipation varchar(50)
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
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, @useChildCountDate
	

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
	exec rds.Migrate_DimSchools_Students @studentDateQuery, @useChildCountDate

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

	--Migrate Language
	declare @languageQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		LanguageCode varchar(50)
	)

	insert into @languageQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		LanguageCode
	)
	exec rds.[Migrate_DimLanguage] @studentDateQuery


	-- Migrate_DimMigrant

	declare @migrantQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		ContinuationOfServiceStatus varchar(50),
		MigrantPriorityForServiceCode varchar(50),
		MepServiceTypeCode varchar(50),
		MepFundStatus varchar(50),
		MepEnrollmentTypeCode varchar(50)		
	)

	insert into @migrantQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		ContinuationOfServiceStatus ,
		MigrantPriorityForServiceCode ,
		MepServiceTypeCode ,
		MepFundStatus,
		MepEnrollmentTypeCode 		
	)
	exec rds.[Migrate_DimMigrant] @studentDateQuery
	

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


	-- Migrate_DimStudentStatuses

	declare @title1StatusQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		TitleISchoolStatusCode varchar(50),
		TitleIinstructionalServiceCode varchar(50),		
		Title1SupportServiceCode varchar(50),
		Title1ProgramTypeCode varchar(50)
	)

	insert into @title1StatusQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode
	)
	exec rds.[Migrate_DimTitle1Statuses] @studentDateQuery

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

	--Migrate Attendance
	declare @attendanceQuery as table (
		DimStudentId int,
		DimSchoolId int,
		PersonId int,
		DimCountDateId int,
		AbsenteeismCode varchar(50)
	)

	insert into @attendanceQuery
	(
		DimStudentId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		AbsenteeismCode
	)
	exec rds.[Migrate_DimAttendance] @studentDateQuery




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
		DimLeaId int,

		AgeCode varchar(50),

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

		AbsenteeismCode varchar(50)



	)

	insert into #queryOutput
	(
		DimStudentId,
		StudentPersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		AgeCode,

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
		--TitleIStatusCode,
		GradeLevelCode,
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,

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
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,

		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus,

		AbsenteeismCode

	)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(sch.DimSchoolId, -1),
		isnull(sch.DimLeaId, -1),
		a.AgeCode,

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
		isnull(grade.GradeLevelCode,'MISSING'),
		isnull(programStatus.CteCode,'MISSING'),
		isnull(programStatus.ImmigrantTitleIIICode,'MISSING'),
		isnull(programStatus.Section504Code,'MISSING'),
		isnull(programStatus.FoodServiceEligibilityCode,'MISSING'),
		isnull(programStatus.FosterCareCode,'MISSING'),
		isnull(programStatus.TitleIIIProgramParticipation, 'MISSING'),

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
		ISNULL(studentStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(studentStatus.SingleParent, 'MISSING'),
		ISNULL(studentStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(studentStatus.PlacementType, 'MISSING'),
		ISNULL(studentStatus.PlacementStatus, 'MISSING'),
		ISNULL(studentStatus.RepresentationStatus, 'MISSING'),
		ISNULL(studentStatus.InclutypCode, 'MISSING'),




		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),

		ISNULL(TitleIIIAccountabilityCode , 'MISSING'),
		ISNULL(TitleIIILanguageInstructionCode , 'MISSING'),	
		ISNULL(ProficiencyStatusCode , 'MISSING'),
		ISNULL(FormerEnglishLearnerYearStatus, 'MISSING'),

		ISNULL(att.AbsenteeismCode,'MISSING')



	from @studentDateQuery s
	inner join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	inner join @ageQuery a on s.DimStudentId = a.DimStudentId and s.DimCountDateId = a.DimCountDateId
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @ideaQuery idea on s.DimStudentId = idea.DimStudentId and s.DimCountDateId = idea.DimCountDateId and sch.DimSchoolId = idea.DimSchoolId
	left outer join @gradelevelQuery grade on s.DimStudentId = grade.DimStudentId and s.DimCountDateId = grade.DimCountDateId and sch.DimSchoolId = grade.DimSchoolId
	left outer join @programStatusQuery programStatus on s.DimStudentId = programStatus.DimStudentId and s.DimCountDateId = programStatus.DimCountDateId and sch.DimSchoolId = programStatus.DimSchoolId
	left outer join @languageQuery lang on s.DimStudentId = lang.DimStudentId and s.DimCountDateId = lang.DimCountDateId and sch.DimSchoolId = lang.DimSchoolId
	left outer join @migrantQuery migrant on s.DimStudentId = migrant.DimStudentId and s.DimCountDateId = migrant.DimCountDateId and sch.DimSchoolId = migrant.DimSchoolId
	left outer join @studentStatusQuery studentStatus on s.DimStudentId = studentStatus.DimStudentId and s.DimCountDateId = studentStatus.DimCountDateId and sch.DimSchoolId = studentStatus.DimSchoolId
	left outer join @title1StatusQuery title1  on s.DimStudentId = title1.DimStudentId and s.DimCountDateId = title1.DimCountDateId and sch.DimSchoolId = title1.DimSchoolId

	left outer join @titleIIIStatusQuery titleIII  on s.DimStudentId = titleIII.DimStudentId and s.DimCountDateId = titleIII.DimCountDateId and sch.DimSchoolId = titleIII.DimSchoolId
	left outer join @attendanceQuery att on s.DimStudentId = att.DimStudentId and s.DimCountDateId = att.DimCountDateId and sch.DimSchoolId = att.DimSchoolId



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
		delete from rds.FactStudentCounts where DimFactTypeId = @factTypeId
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
			DimAttendanceId
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
		grade.DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,

		isnull(lang.DimLanguageId, -1) as DimLanguageId,
		isnull(migrant.DimMigrantId, -1) as	DimMigrantId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId
		from #queryOutput q
		inner join rds.DimAges a	on q.AgeCode = a.AgeCode
		inner join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
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
		and studentStatus.DisplacedHomeMakerCode = q.DisplacedHomemaker
		and studentStatus.SingleParentCode = q.SingleParent
		and studentStatus.NonTraditionalEnrolleeCode = q.CteNonTraditionalEnrollee
		and studentStatus.PlacementTypeCode = q.PlacementType
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.RepresentationStatusCode = q.RepresentationStatus
		and studentStatus.IncluTypCode=q.InclutypCode

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
		isnull(grade.DimGradeLevelId, -1) as DimGradeLevelId,
		isnull(programStatus.DimProgramStatusId, -1) as DimProgramStatusId,
		1 as StudentCount,

		isnull(lang.DimLanguageId, -1) as DimLanguageId,
		isnull(migrant.DimMigrantId, -1) as	DimMigrantId,
		isnull(studentStatus.DimStudentStatusId, -1) as DimStudentStatusId,
		isnull(title1.DimTitle1StatusId, -1) as DimTitle1StatusId,
		isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId
		from #queryOutput q
		inner join rds.DimAges a	on q.AgeCode = a.AgeCode
		inner join rds.DimGradeLevels grade
			on q.GradeLevelCode = grade.GradeLevelCode
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
		and studentStatus.DisplacedHomeMakerCode = q.DisplacedHomemaker
		and studentStatus.SingleParentCode = q.SingleParent
		and studentStatus.NonTraditionalEnrolleeCode = q.CteNonTraditionalEnrollee
		and studentStatus.PlacementTypeCode = q.PlacementType
		and studentStatus.PlacementStatusCode = q.PlacementStatus
		and studentStatus.RepresentationStatusCode = q.RepresentationStatus
		and studentStatus.IncluTypCode=q.InclutypCode

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

		order by q.DimStudentId, q.DimCountDateId, idea.DimIdeaStatusId
	end

	drop table #queryOutput


	-- Create Report Data
	----------------------------

	if @runAsTest = 0
	begin
		if @factTypeCode = 'datapopulation' or @factTypeCode = 'submission'
		begin
			truncate table rds.FactStudentCountReports

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentcount')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentcount', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentsex')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentsex', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentdisability')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentdisability', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentrace')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentrace', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentswdtitle1')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentswdtitle1', @runAsTest = @runAsTest

		end

		if @factTypeCode = 'childcount'
		begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c002')

			exec [RDS].[Create_ReportData]	@reportCode = 'c002', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c089')

			exec [RDS].[Create_ReportData]	@reportCode = 'c089', @runAsTest = @runAsTest
		end

		if @factTypeCode = 'specedexit'
		begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c009')

			exec [RDS].[Create_ReportData]	@reportCode = 'c009', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - exitspecialeducation')

			exec [RDS].[Create_ReportData]	@reportCode = 'exitspecialeducation', @runAsTest = @runAsTest
		end

		if @factTypeCode = 'submission'
		begin
		
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c032')

			exec [RDS].[Create_ReportData]	@reportCode = 'c032', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c033')

			exec [RDS].[Create_ReportData]	@reportCode = 'c033', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c037')

			exec [RDS].[Create_ReportData]	@reportCode = 'c037', @runAsTest = @runAsTest


			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c040')

			exec [RDS].[Create_ReportData]	@reportCode = 'c040', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c045')

			exec [RDS].[Create_ReportData]	@reportCode = 'c045', @runAsTest = @runAsTest


			
			---- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c052')

			exec [RDS].[Create_ReportData]	@reportCode = 'c052', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c054')

			exec [RDS].[Create_ReportData]	@reportCode = 'c054', @runAsTest = @runAsTest

			
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c116')

			exec [RDS].[Create_ReportData]	@reportCode = 'c116', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c118')

			exec [RDS].[Create_ReportData]	@reportCode = 'c118', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c121')

			exec [RDS].[Create_ReportData]	@reportCode = 'c121', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c122')

			exec [RDS].[Create_ReportData]	@reportCode = 'c122', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c134')

			exec [RDS].[Create_ReportData]	@reportCode = 'c134', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c141')

			exec [RDS].[Create_ReportData]	@reportCode = 'c141', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c145')

			exec [RDS].[Create_ReportData]	@reportCode = 'c145', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c165')

			exec [RDS].[Create_ReportData]	@reportCode = 'c165', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c194')

			exec [RDS].[Create_ReportData]	@reportCode = 'c194', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c195')

			exec [RDS].[Create_ReportData]	@reportCode = 'c195', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator9')

			exec [RDS].[Create_ReportData]	@reportCode = 'indicator9', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator10')

			exec [RDS].[Create_ReportData]	@reportCode = 'indicator10', @runAsTest = @runAsTest

			
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - cohortgraduationrate')

			exec [RDS].[Create_CustomReportData]	@reportCode = 'cohortgraduationrate', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - studentfederalprogramsparticipation')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentfederalprogramsparticipation', @runAsTest = @runAsTest
			exec [RDS].[Create_StudentFederalProgramsReportData] @reportCode = 'studentfederalprogramsparticipation', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - studentmultifedprogsparticipation')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentmultifedprogsparticipation', @runAsTest = @runAsTest
			exec [RDS].[Create_StudentFederalProgramsReportData] @reportCode = 'studentmultifedprogsparticipation', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - edenvironmentdisabilitiesage3-5')

			exec [RDS].[Create_ReportData]	@reportCode = 'edenvironmentdisabilitiesage3-5', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - edenvironmentdisabilitiesage6-21')

			exec [RDS].[Create_ReportData]	@reportCode = 'edenvironmentdisabilitiesage6-21', @runAsTest = @runAsTest

				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c118')

			exec [RDS].[Create_ReportData]	@reportCode = 'c118', @runAsTest = @runAsTest

							-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c204')

			exec [RDS].[Create_ReportData]	@reportCode = 'c204', @runAsTest = @runAsTest

		end
		
		if @factTypeCode = 'cte'
		begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c082')

			exec [RDS].[Create_ReportData]	@reportCode = 'c082', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c083')

			exec [RDS].[Create_ReportData]	@reportCode = 'c083', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c154')

			exec [RDS].[Create_ReportData]	@reportCode = 'c154', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c155')

			exec [RDS].[Create_ReportData]	@reportCode = 'c155', @runAsTest = @runAsTest
	
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c156')

			exec [RDS].[Create_ReportData]	@reportCode = 'c156', @runAsTest = @runAsTest

		
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c158')

			exec [RDS].[Create_ReportData]	@reportCode = 'c158', @runAsTest = @runAsTest

				
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c169')

			exec [RDS].[Create_ReportData]	@reportCode = 'c169', @runAsTest = @runAsTest


				-- Log history -- This code is here because C132 uses FactStudentCounts and the table is not populated 
			--				  when Migrate_OrganizationCounts run
			
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c132 - Section 1003 Funds')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c132', @runAsTest = @runAsTest



		end

	end

	SET NOCOUNT OFF;

END