CREATE PROCEDURE [RDS].[Migrate_StudentAttendance]
	@factTypeCode as varchar(50),
	@runAsTest as bit,
	@dataCollectionName as varchar(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dataCollectionId AS INT

	SELECT @dataCollectionId = DataCollectionId 
	FROM dbo.DataCollection
	WHERE DataCollectionName = @dataCollectionName

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
	select @k12StudentRoleId = RoleId from dbo.[Role] where Name = 'K12 Student'

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

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimStudentId int,
		StudentPersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
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
	
	declare @studentDateQuery as rds.K12StudentDateTableType
	
		
	CREATE TABLE #demoQuery (
		  DimK12StudentId							INT
		, DimIeuId									INT
		, DimLeaId									INT
		, DimK12SchoolId							INT
		, DimDateId									INT
		, EcoDisStatusCode							NVARCHAR(50)
		, HomelessStatusCode						NVARCHAR(50)
		, HomelessUnaccompaniedYouthStatusCode		NVARCHAR(50)
		, LepStatusCode								NVARCHAR(50)
		, MigrantStatusCode							NVARCHAR(50)
		, MilitaryConnected							NVARCHAR(50)
		, HomelessNighttimeResidenceCode			NVARCHAR(50)
		, PersonStartDate							DATETIME
		, PersonEndDate								DATETIME
		, DimK12DemographicId						INT
	)
	CREATE NONCLUSTERED INDEX IX_Demo ON #demoQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)
	
	DECLARE @schoolQuery AS RDS.K12StudentOrganizationTableType
	
		
	
	DECLARE @attendanceQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		DimCountDateId INT,
		AbsenteeismCode VARCHAR(50)
	)

	declare @attendanceRateQuery as table (
		DimStudentId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		PersonId int,
		DimCountDateId int,
		StudentAttendanceRate decimal(18, 3)
	)
	

	BEGIN TRY
	
	declare @selectedDate as int, @submissionYear as varchar(50)
	DECLARE selectedYears_cursor CURSOR FOR 
	select d.DimSchoolYearId, d.SchoolYear
		from rds.DimSchoolYears d
		inner join rds.DimSchoolYearDataMigrationTypes dd on dd.DimSchoolYearId = d.DimSchoolYearId
		inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimSchoolYearId <> -1 
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
	delete from #demoQuery
	delete from @schoolQuery
	delete from @attendanceQuery
	delete from @attendanceRateQuery
	
	INSERT INTO @studentDateQuery
	(
		DimK12StudentId,
		PersonId,
		DimSchoolYearId,
		DimCountDateId,
		CountDate,
		SchoolYear,
		SessionBeginDate,
		SessionEndDate,
		RecordStartDateTime,
		RecordEndDateTime
	)
	exec rds.Migrate_DimSchoolYears_K12Students @factTypeCode, @migrationType, @selectedDate

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
	
		INSERT INTO #demoQuery
		(
			  DimK12StudentId							
			, DimIeuId									
			, DimLeaId									
			, DimK12SchoolId							
			, DimDateId									
			, EcoDisStatusCode							
			, HomelessStatusCode						
			, HomelessUnaccompaniedYouthStatusCode		
			, LepStatusCode								
			, MigrantStatusCode							
			, MilitaryConnected							
			, HomelessNighttimeResidenceCode			
			, PersonStartDate							
			, PersonEndDate								
			, DimK12DemographicId						
		)
		exec rds.Migrate_DimK12Demographics @studentDateQuery, @schoolQuery, @useCutOffDate, @dataCollectionId

		if @runAsTest = 1
		BEGIN
			print 'demoQuery'
			select * from #demoQuery
		END


	-- Migrate_DimSchools

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END


	
	INSERT INTO @schoolQuery
	(
		  DimK12StudentId
		, PersonId
		, DimCountDateId
		, DimSeaId 
		, DimIeuId 
		, DimLeaID
		, DimK12SchoolId
		, IeuOrganizationId
		, LeaOrganizationId
		, K12SchoolOrganizationId
		, LeaOrganizationPersonRoleId 
		, K12SchoolOrganizationPersonRoleId 
		, LeaEntryDate
		, LeaExitDate 
		, K12SchoolEntryDate	
		, K12SchoolExitDate 
	)
	EXEC rds.Migrate_K12StudentOrganizations @studentDateQuery, @dataCollectionId, 0

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
			DimK12StudentId,
			DimK12SchoolId,
			DimLeaId,
			DimSeaId,
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
			DimSeaId,
			PersonId,
			DimCountDateId,
			StudentAttendanceRate
		)
		select	
		s.DimK12StudentId,
		org.DimK12SchoolId,
		org.DimLeaId,
		org.DimSeaId,
		s.PersonId,	
		s.DimCountDateId,		
		att.AttendanceRate
		from @studentDateQuery s
		inner join @schoolQuery org	on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
		inner join dbo.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId and r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
		and r.EntryDate <= s.SessionEndDate and (r.ExitDate >=  s.SessionBeginDate or r.ExitDate is null)
		inner join dbo.RoleAttendance att on r.OrganizationPersonRoleId = att.OrganizationPersonRoleId

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
		s.DimK12StudentId,
		s.PersonId,
		s.DimCountDateId,
		ISNULL(sch.DimK12SchoolId, -1),
		ISNULL(sch.DimLeaId, -1),
		ISNULL(demo.EcoDisStatusCode, 'MISSING'),
		ISNULL(demo.HomelessStatusCode, 'MISSING'),
--		ISNULL(demo.LepStatusCode, 'MISSING'),
		ISNULL(demo.LepStatusCode, 'NLEP'),
		ISNULL(demo.MigrantStatusCode, 'MISSING'),
		ISNULL(st.SexCode, 'MISSING'),
		ISNULL(demo.MilitaryConnected, 'MISSING'),
		ISNULL(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		ISNULL(demo.HomelessNighttimeResidenceCode, 'MISSING'),
		ISNULL(att.AbsenteeismCode,'MISSING'),
		attRate.StudentAttendanceRate
	from @studentDateQuery s
	LEFT JOIN rds.DimK12Students st on s.DimK12StudentId = st.DimK12StudentId
	left outer join @schoolQuery sch on s.DimK12StudentId = sch.DimK12StudentId and s.DimCountDateId = sch.DimCountDateId
	left outer join #demoQuery demo on s.DimK12StudentId = demo.DimK12StudentId and s.DimCountDateId = demo.DimDateId
	left outer join @attendanceQuery att on s.DimK12StudentId = att.DimK12StudentId and s.DimCountDateId = att.DimCountDateId and sch.DimK12SchoolId = att.DimK12SchoolId and sch.DimLeaId = att.DimLeaId and sch.DimSeaId = att.DimSeaId
	left outer join @attendanceRateQuery attRate on s.DimK12StudentId = attRate.DimStudentId and s.DimCountDateId = attRate.DimCountDateId and sch.DimK12SchoolId = attRate.DimSchoolId 
	and sch.DimLeaId = attRate.DimLeaId and sch.DimSeaId = attRate.DimSeaId

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
			FactTypeId,
			K12StudentId,
			K12SchoolId,
			LeaId,
			SeaId,
			SchoolYearId,
			K12DemographicId,
			AttendanceId,
			StudentAttendanceRate
		)
		select distinct
		@factTypeId as DimFactTypeId,
		q.DimStudentId,
		q.DimSchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimCountDateId,
		isnull(d.DimK12DemographicId, -1) as DimDemographicId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId,
		ISNULL(q.StudentAttendanceRate, 0.0)
		from #queryOutput q
		left outer join rds.DimK12Demographics d 
			on q.EcoDisStatusCode = d.EconomicDisadvantageStatusCode
			and q.HomelessStatusCode = d.HomelessnessStatusCode
			and q.LepStatusCode = d.EnglishLearnerStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and  q.MilitaryConnected = d.MilitaryConnectedStudentIndicatorCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessPrimaryNighttimeResidenceCode
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
		q.DimSeaId,
		q.DimCountDateId,
		isnull(d.DimK12DemographicId, -1) as DimDemographicId,
		isnull(att.DimAttendanceId, -1) as DimAttendanceId,
		ISNULL(q.StudentAttendanceRate, 0.0)
		from #queryOutput q
		left outer join rds.DimK12Demographics d 
			on q.EcoDisStatusCode = d.EconomicDisadvantageStatusCode
			and q.HomelessStatusCode = d.HomelessnessStatusCode
			and q.LepStatusCode = d.EnglishLearnerStatusCode
			and q.MigrantStatusCode = d.MigrantStatusCode
			and  q.MilitaryConnected = d.MilitaryConnectedStudentIndicatorCode
			and q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			and q.HomelessNighttimeResidenceCode = d.HomelessPrimaryNighttimeResidenceCode
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
	drop table #demoQuery

	SET NOCOUNT OFF;
END