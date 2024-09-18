



CREATE PROCEDURE [RDS].[Migrate_PersonnelCounts]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

	SET NOCOUNT ON;

	-- Lookup values

	declare @factTable as varchar(50)
	set @factTable = 'FactPersonnelCounts'

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

	-- Log history

	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	end


	-- Get Dimension Data
	----------------------------

	-- Migrate_DimDates
	
	declare @personnelDateQuery as rds.PersonnelDateTableType

	insert into @personnelDateQuery
	(
		DimPersonnelId,
		PersonId,
		DimCountDateId,
		SubmissionYearDate,
		[Year],
		SubmissionYearStartDate,
		SubmissionYearEndDate
	)
	exec rds.Migrate_DimDates_Personnel


	
	-- Migrate_DimPersonnelStatuses

	declare @personnelStatusQuery as table (
		DimPersonnelId int,
		PersonId int,
		DimCountDateId int,
		AgeGroupCode varchar(50),
		CertificationStatusCode varchar(50),
		PersonnelTypeCode varchar(50),
		QualificationStatusCode varchar(50),
		StaffCategoryCode varchar(50),
		PersonnelFTE decimal(18,3)
	)

	insert into @personnelStatusQuery
	(
		DimPersonnelId,
		PersonId,
		DimCountDateId,
		AgeGroupCode,
		CertificationStatusCode,
		PersonnelTypeCode,
		QualificationStatusCode,
		StaffCategoryCode,
		PersonnelFTE
	)
	exec rds.Migrate_DimPersonnelStatuses @personnelDateQuery



		-- Migrate_DimPersonnelCategories

	declare @personnelCategoryQuery as table (
		DimPersonnelId int,
		PersonId int,
		DimCountDateId int,
		StaffCategorySpecialCode varchar(50),
		StaffCategoryCCD  varchar(50),
		StaffCategoryTitle1Code   varchar(50),
		PersonnelFTE decimal(18,3)
		
	)

	insert into @personnelCategoryQuery
	(
		DimPersonnelId,
		PersonId,
		DimCountDateId,
		StaffCategorySpecialCode,
		StaffCategoryCCD ,
		StaffCategoryTitle1Code,
		PersonnelFTE		
	)
	exec rds.migrate_DimPersonnelCategories @personnelDateQuery



	-- Migrate_DimSchools

	declare @schoolQuery as table (
		DimPersonnelId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int
	)

	insert into @schoolQuery
	(
		DimPersonnelId,
		PersonId,
		DimCountDateId,
		DimSchoolId
	)
	exec rds.Migrate_DimSchools_Personnel @personnelDateQuery, 1


	declare @titleIIIStatusQuery as table (
		DimPersonnelId int,
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
		DimPersonnelId,
		DimSchoolId,
		PersonId,
		DimCountDateId,
		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus
	)
	exec rds.[Migrate_DimTitleIIIStatuses_Personnel] @personnelDateQuery



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
		DimPersonnelId int,
		PersonnelPersonId int,
		DimCountDateId int,
		DimSchoolId int,
		
		AgeGroupCode varchar(50),
		CertificationStatusCode varchar(50),
		PersonnelTypeCode varchar(50),
		QualificationStatusCode varchar(50),
		--StaffCategoryCode varchar(50),

		StaffCategorySpecialCode varchar(50),
		StaffCategoryCCD  varchar(50),
		StaffCategoryTitle1Code   varchar(50),

		PersonnelCount int,
		PersonnelFTE decimal(18,3),

		TitleIIIAccountabilityCode varchar(50),
		TitleIIILanguageInstructionCode varchar(50),		
		ProficiencyStatusCode varchar(50),
		FormerEnglishLearnerYearStatus varchar(50)

	)

	insert into #queryOutput
	(
		DimPersonnelId,
		PersonnelPersonId,
		DimCountDateId,

		DimSchoolId,

		AgeGroupCode,
		CertificationStatusCode,
		PersonnelTypeCode,
		QualificationStatusCode,
		--StaffCategoryCode,

		StaffCategorySpecialCode ,
		StaffCategoryCCD ,
		StaffCategoryTitle1Code  ,

		PersonnelCount ,
		PersonnelFTE,

		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus
	)
	select 
		s.DimPersonnelId,
		s.PersonId,
		s.DimCountDateId,

		isnull(sch.DimSchoolId, -1),
		
		isnull(per.AgeGroupCode, 'MISSING'),
		isnull(per.CertificationStatusCode, 'MISSING'),
		isnull(per.PersonnelTypeCode, 'MISSING'),
		isnull(per.QualificationStatusCode, 'MISSING'),
		--isnull(per.StaffCategoryCode, 'MISSING'),
		isnull(cat.StaffCategorySpecialCode,'MISSING'),
		isnull(cat.StaffCategoryCCD, 'MISSING'),
		isnull(cat.StaffCategoryTitle1Code, 'MISSING'),

		1,
		cat.PersonnelFTE,

		isnull(title3.TitleIIIAccountabilityCode , 'MISSING'),
		isnull(TitleIIILanguageInstructionCode ,'MISSING'),	
		isnull(ProficiencyStatusCode , 'MISSING'),
		isnull(FormerEnglishLearnerYearStatus, 'MISSING')

	from @personnelDateQuery s
	left outer join @schoolQuery sch on s.DimPersonnelId = sch.DimPersonnelId and s.DimCountDateId = sch.DimCountDateId
	left outer join @personnelStatusQuery per on s.DimPersonnelId = per.DimPersonnelId and s.DimCountDateId = per.DimCountDateId
	left outer join @personnelCategoryQuery cat on s.DimPersonnelId = cat.DimPersonnelId and s.DimCountDateId = cat.DimCountDateId
	left outer join @titleIIIStatusQuery title3 on title3.DimPersonnelId = s.DimPersonnelId and s.DimCountDateId = title3.DimCountDateId



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
		delete from rds.FactPersonnelCounts where DimFactTypeId = @factTypeId
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
		insert into rds.FactPersonnelCounts
		(
			DimFactTypeId,
			DimPersonnelId,
			DimSchoolId,
			DimCountDateId,
			DimPersonnelStatusId,
			DimPersonnelCategoryId,
			PersonnelCount,
			PersonnelFTE,
			DimTitleiiiStatusId
		)
		select
		@factTypeId as DimFactTypeId,
		q.DimPersonnelId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(per.DimPersonnelStatusId, -1) as DimPersonnelStatusId,
		isnull(cat.DimPersonnelCategoryId, -1) as DimPersonnelCategoryId,
		---1,
		isnull(sum(
			case
				when per.DimPersonnelStatusId <> -1 then q.PersonnelCount
				else 0
			end
		),0) as PersonnelCount,
		isnull(sum(
			case
				when cat.DimPersonnelCategoryId <> -1 then q.PersonnelFTE
				else 0
			end
		),0) as PersonnelFTE
		,isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId
		from #queryOutput q
		left outer join rds.DimPersonnelStatuses per
			on q.AgeGroupCode = per.AgeGroupCode
			and q.CertificationStatusCode = per.CertificationStatusCode
			and q.PersonnelTypeCode = per.PersonnelTypeCode
			and q.QualificationStatusCode = per.QualificationStatusCode
			--and q.StaffCategoryCode = per.StaffCategoryCode
		left outer join rds.DimPersonnelCategories cat 
			on q.StaffCategorySpecialCode = cat.StaffCategorySpecialEdCode
			and q.StaffCategoryCCD = cat.StaffCategoryCCDCode
			and q.StaffCategoryTitle1Code = cat.StaffCategoryTitle1Code
				
		left outer join rds.DimTitleiiiStatuses title3
		on 
		 title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode
			
		group by
		q.DimPersonnelId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(per.DimPersonnelStatusId, -1),
		isnull(cat.DimPersonnelCategoryId, -1),
		isnull(title3.DimTitleiiiStatusId, -1) 


	end
	else
	begin

		-- Run As Test (return data instead of inserting it)
				
		select
		@factTypeId as DimFactTypeId,
		q.DimPersonnelId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(per.DimPersonnelStatusId, -1) as DimPersonnelStatusId,
		isnull(cat.DimPersonnelCategoryId, -1) as DimPersonnelCategoryId,
		isnull(sum(
			case
				when per.DimPersonnelStatusId <> -1 then q.PersonnelCount
				else 0
			end
		),0) as PersonnelCount,
		isnull(sum(
			case
				when cat.DimPersonnelCategoryId <> -1 then q.PersonnelFTE
				else 0
			end
		),0) as PersonnelFTE

		,isnull(title3.DimTitleiiiStatusId, -1) as DimTitleiiiStatusId
		from #queryOutput q
		left outer join rds.DimPersonnelStatuses per
			on q.AgeGroupCode = per.AgeGroupCode
			and q.CertificationStatusCode = per.CertificationStatusCode
			and q.PersonnelTypeCode = per.PersonnelTypeCode
			and q.QualificationStatusCode = per.QualificationStatusCode
			--and q.StaffCategoryCode = per.StaffCategoryCode
			left outer join rds.DimPersonnelCategories cat 
			on q.StaffCategorySpecialCode = cat.StaffCategorySpecialEdCode
			and q.StaffCategoryCCD = cat.StaffCategoryCCDCode
			and q.StaffCategoryTitle1Code = cat.StaffCategoryTitle1Code

		left outer join rds.DimTitleiiiStatuses title3
		on 
		title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
		and title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
		and title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
		and title3.ProficiencyStatusCode = q.ProficiencyStatusCode

		group by
		q.DimPersonnelId,
		q.DimSchoolId,
		q.DimCountDateId,
		isnull(per.DimPersonnelStatusId, -1),
		isnull(cat.DimPersonnelCategoryId, -1),
		isnull(title3.DimTitleiiiStatusId, -1)

		order by q.DimPersonnelId, q.DimCountDateId

	end


	drop table #queryOutput


	-- Create Report Data
	----------------------------

	if @runAsTest = 0
	begin
		
		if @factTypeCode = 'datapopulation' or @factTypeCode = 'submission'
		begin
			truncate table rds.FactPersonnelCountReports
		end
		
		if @factTypeCode = 'submission'
		begin

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c070')

			exec [RDS].[Create_ReportData]	@reportCode = 'c070', @runAsTest = @runAsTest


			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c099')

			exec [RDS].[Create_ReportData]	@reportCode = 'c099', @runAsTest = @runAsTest

			
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c112')

			exec [RDS].[Create_ReportData]	@reportCode = 'c112', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c059')

			exec [RDS].[Create_ReportData]	@reportCode = 'c059', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c059')

			exec [RDS].[Create_ReportData]	@reportCode = 'c067', @runAsTest = @runAsTest

		end
	end

	SET NOCOUNT OFF;

END


