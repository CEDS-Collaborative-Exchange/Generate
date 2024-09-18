CREATE PROCEDURE [RDS].[Migrate_StudentAttendance]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN
	SET NOCOUNT ON;
	-- Lookup values
	declare @factTable as varchar(50)
	set @factTable = 'FactK12StudentAttendance'
	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	
	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	set @migrationType='rds'

	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	declare @k12StudentRoleId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'

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
		EcoDisStatusCode varchar(50),
		HomelessStatusCode varchar(50),
		LepStatusCode varchar(50),
		MigrantStatusCode varchar(50),
		SexCode varchar(50),
		MilitaryConnected varchar(50),
		HomelessUnaccompaniedYouthStatusCode varchar(50),
		HomelessNighttimeResidenceCode varchar(50),
		AbsenteeismCode varchar(50),
		StudentAttendanceRate decimal(18, 3)
	)
	
	declare @studentDateQuery as rds.StudentDateTableType
	
		
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
		Organizationid int,
		LeaOrganizationId int
		unique clustered (DimStudentId, DimSchoolId, DimCountDateId, DimLeaId, OrganizationId)
	)
	
		
	
	declare @attendanceQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		AbsenteeismCode varchar(50)
	)

	declare @attendanceRateQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		PersonId int,
		DimCountDateId int,
		StudentAttendanceRate decimal(18, 3)
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

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @submissionYear)
	END
	

	delete from #queryOutput
	delete from @studentDateQuery
	delete from @demoQuery
	delete from @schoolQuery
	delete from @attendanceQuery
	delete from @attendanceRateQuery
	

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

	
		
	-- Migrate_DimDemographics

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
		Organizationid, 
		LeaOrganizationId
	)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, Organizationid, LeaOrganizationId
	from rds.Get_StudentOrganizations(@studentDateQuery, @useCutOffDate)

	if @runAsTest = 1
	BEGIN
		print 'schoolQuery'
		select * from @schoolQuery
	END

	
	
	--Migrate Attendance

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

		--Migrate Attendance Rate

		if @runAsTest = 0
		BEGIN
			insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Attendance Rate for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		insert into @attendanceRateQuery
		(
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			PersonId,
			DimCountDateId,
			StudentAttendanceRate
		)
		select	
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,	
		s.DimCountDateId,		
		att.AttendanceRate
		from @studentDateQuery s
		inner join @schoolQuery org	on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
		inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
		and r.EntryDate <= s.SubmissionYearEndDate and (r.ExitDate >=  s.SubmissionYearStartDate or r.ExitDate is null)
		inner join ods.RoleAttendance att on r.OrganizationPersonRoleId = att.OrganizationPersonRoleId

		if @runAsTest = 1
		BEGIN
			print 'attendanceRateQuery'
			select * from @attendanceRateQuery
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
		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,
		AbsenteeismCode,
		StudentAttendanceRate
)
	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		isnull(sch.DimSchoolId, -1),
		isnull(sch.DimLeaId, -1),
		isnull(demo.EcoDisStatusCode, 'MISSING'),
		isnull(demo.HomelessStatusCode, 'MISSING'),
		isnull(demo.LepStatusCode, 'MISSING'),
		isnull(demo.MigrantStatusCode, 'MISSING'),
		isnull(demo.SexCode, 'MISSING'),
		isnull(demo.MilitaryConnected, 'MISSING'),
		isnull(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		isnull(demo.HomelessNighttimeResidenceCode, 'MISSING'),
		ISNULL(att.AbsenteeismCode,'MISSING'),
		attRate.StudentAttendanceRate
	from @studentDateQuery s
	left outer join @schoolQuery sch on s.DimStudentId = sch.DimStudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join @demoQuery demo on s.DimStudentId = demo.DimStudentId and s.DimCountDateId = demo.DimCountDateId
	left outer join @attendanceQuery att on s.DimStudentId = att.DimStudentId and s.DimCountDateId = att.DimCountDateId and sch.DimSchoolId = att.DimSchoolId and sch.DimLeaId = att.DimLeaId
	left outer join @attendanceRateQuery attRate on s.DimStudentId = attRate.DimStudentId and s.DimCountDateId = attRate.DimCountDateId and sch.DimSchoolId = attRate.DimSchoolId 
	and sch.DimLeaId = attRate.DimLeaId

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


		
		insert into rds.FactK12StudentAttendance
		(
			DimFactTypeId,
			DimStudentId,
			DimSchoolId,
			DimLeaId,
			DimCountDateId,
			DimDemographicId,
			DimAttendanceId,
			StudentAttendanceRate
		)
		select distinct
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimCountDateId,
		isnull(d.DimDemographicId, -1) as DimDemographicId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId,
		ISNULL(q.StudentAttendanceRate, 0.0)
		from #queryOutput q
		left outer join rds.DimDemographics d 
			on q.EcoDisStatusCode = d.EcoDisStatusCode
			and q.HomelessStatusCode = d.HomelessStatusCode
			and q.LepStatusCode = d.LepStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and q.SexCode = d.SexCode
			and  q.MilitaryConnected = d.MilitaryConnectedStatusCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessNighttimeResidenceCode
		left outer join rds.DimAttendance att
		on att.AbsenteeismCode = q.AbsenteeismCode

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
		isnull(att.DimAttendanceId, -1) as DimAttendanceId,
		ISNULL(q.StudentAttendanceRate, 0.0)
		from #queryOutput q
		left outer join rds.DimDemographics d 
			on q.EcoDisStatusCode = d.EcoDisStatusCode
			and q.HomelessStatusCode = d.HomelessStatusCode
			and q.LepStatusCode = d.LepStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and q.SexCode = d.SexCode
			and  q.MilitaryConnected = d.MilitaryConnectedStatusCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessNighttimeResidenceCode
		left outer join rds.DimAttendance att
		on att.AbsenteeismCode = q.AbsenteeismCode

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