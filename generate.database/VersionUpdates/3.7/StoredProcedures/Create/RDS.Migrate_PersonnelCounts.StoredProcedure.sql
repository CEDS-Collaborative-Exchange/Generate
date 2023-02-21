CREATE PROCEDURE [RDS].[Migrate_PersonnelCounts]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN
	SET NOCOUNT ON;
	-- Lookup values
	declare @factTable as varchar(50)
	set @factTable = 'FactPersonnelCounts'
	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	
	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	set @migrationType='rds'
	

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	declare @personnelDateQuery as rds.PersonnelDateTableType
	declare @personnelStatusQuery as table (
		DimPersonnelId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		PersonId int,
		DimCountDateId int,
		AgeGroupCode varchar(50),
		CertificationStatusCode varchar(50),
		PersonnelTypeCode varchar(50),
		QualificationStatusCode varchar(50),
		StaffCategoryCode varchar(50),
		PersonnelFTE decimal(18,3),
		UnexperiencedStatusCode varchar(50),
		EmergencyOrProvisionalCredentialStatusCode varchar(50),
		OutOfFieldStatusCode varchar(50)
	)

	declare @personnelCategoryQuery as table (
		DimPersonnelId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		PersonId int,
		DimCountDateId int,
		StaffCategorySpecialCode varchar(50),
		StaffCategoryCCD  varchar(50),
		StaffCategoryTitle1Code   varchar(50),
		PersonnelFTE decimal(18,3)
	)

	declare @schoolQuery as table (
		DimPersonnelId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int
	)

	declare @titleIIIStatusQuery as table (
		DimPersonnelId int,
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

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimPersonnelId int,
		PersonnelPersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		
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
		FormerEnglishLearnerYearStatus varchar(50),

		UnexperiencedStatusCode varchar(50),
		EmergencyOrProvisionalCredentialStatusCode varchar(50),
		OutOfFieldStatusCode varchar(50)
	)


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

	-- Log history
	if @runAsTest = 0
	begin
		insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @submissionYear)
	end

	delete from #queryOutput
	delete from @personnelDateQuery
	delete from @personnelStatusQuery
	delete from @personnelCategoryQuery
	delete from @schoolQuery
	delete from @titleIIIStatusQuery

	-- Get Dimension Data
	----------------------------
	-- Migrate_DimDates

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
	exec rds.Migrate_DimDates_Personnel @migrationType, @selectedDate
	
	-- Migrate_DimPersonnelStatuses

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Personnel Status Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	insert into @personnelStatusQuery
	(
		DimPersonnelId,
		DimSchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		AgeGroupCode,
		CertificationStatusCode,
		PersonnelTypeCode,
		QualificationStatusCode,
		StaffCategoryCode,
		PersonnelFTE,
		UnexperiencedStatusCode,
		EmergencyOrProvisionalCredentialStatusCode,
		OutOfFieldStatusCode
	)
	exec rds.Migrate_DimPersonnelStatuses @personnelDateQuery

	-- Migrate_DimPersonnelCategories

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Personnel Categories Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	insert into @personnelCategoryQuery
	(
		DimPersonnelId,
		DimSchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		StaffCategorySpecialCode,
		StaffCategoryCCD ,
		StaffCategoryTitle1Code,
		PersonnelFTE		
	)
	exec rds.migrate_DimPersonnelCategories @personnelDateQuery

	-- Migrate_DimSchools

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	insert into @schoolQuery
	(
		DimPersonnelId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		DimSeaId
	)
	exec rds.Migrate_DimSchools_Personnel @personnelDateQuery, 1

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title III Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END
	
	insert into @titleIIIStatusQuery
	(
		DimPersonnelId,
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
	exec rds.[Migrate_DimTitleIIIStatuses_Personnel] @personnelDateQuery

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
		DimPersonnelId,
		PersonnelPersonId,
		DimCountDateId,

		DimSchoolId,
		DimLeaId,
		DimSeaId,

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
		FormerEnglishLearnerYearStatus,

		UnexperiencedStatusCode,
		EmergencyOrProvisionalCredentialStatusCode,
		OutOfFieldStatusCode
	)
	select 
		s.DimPersonnelId,
		s.PersonId,
		s.DimCountDateId,

		isnull(sch.DimSchoolId, -1),
		isnull(sch.DimLeaId, -1),
		isnull(sch.DimSeaId, -1),
		
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
		isnull(FormerEnglishLearnerYearStatus, 'MISSING'),

		isnull(per.UnexperiencedStatusCode, 'MISSING'),
		isnull(per.EmergencyOrProvisionalCredentialStatusCode, 'MISSING'),
		isnull(per.OutOfFieldStatusCode, 'MISSING')
	from @personnelDateQuery s
	left outer join @schoolQuery sch on s.DimPersonnelId = sch.DimPersonnelId and s.DimCountDateId = sch.DimCountDateId
	left outer join @personnelStatusQuery per on s.DimPersonnelId = per.DimPersonnelId and s.DimCountDateId = per.DimCountDateId 
	and sch.DimSchoolId = per.DimSchoolId and sch.DimLeaId = per.DimLeaId and sch.DimSeaId = per.DimSeaId
	left outer join @personnelCategoryQuery cat on s.DimPersonnelId = cat.DimPersonnelId and s.DimCountDateId = cat.DimCountDateId 
	and sch.DimSchoolId = cat.DimSchoolId and sch.DimLeaId = cat.DimLeaId and sch.DimSeaId = cat.DimSeaId
	left outer join @titleIIIStatusQuery title3 on title3.DimPersonnelId = s.DimPersonnelId and s.DimCountDateId = title3.DimCountDateId 
	and sch.DimSchoolId = title3.DimSchoolId and sch.DimLeaId = title3.DimLeaId and sch.DimSeaId = title3.DimSeaId

	
	-- Insert New Facts
	----------------------------
	-- Log history
	

	if @runAsTest = 0
	begin
		
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting Facts for (' + @factTypeCode + ') -  ' + @submissionYear)


		insert into rds.FactPersonnelCounts
		(
			DimFactTypeId,
			DimPersonnelId,
			DimSchoolId,
			DimLeaId,
			DimSeaId,
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
			q.DimLeaId,
			q.DimSeaId,
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
			and q.UnexperiencedStatusCode = per.UnexperiencedStatusCode
			and q.EmergencyOrProvisionalCredentialStatusCode = per.EmergencyOrProvisionalCredentialStatusCode
			and q.OutOfFieldStatusCode = per.OutOfFieldStatusCode
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
			q.DimLeaId,
			q.DimSeaId,
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
			and q.UnexperiencedStatusCode = per.UnexperiencedStatusCode
			and q.EmergencyOrProvisionalCredentialStatusCode = per.EmergencyOrProvisionalCredentialStatusCode
			and q.OutOfFieldStatusCode = per.OutOfFieldStatusCode
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
	SET NOCOUNT OFF;
END
