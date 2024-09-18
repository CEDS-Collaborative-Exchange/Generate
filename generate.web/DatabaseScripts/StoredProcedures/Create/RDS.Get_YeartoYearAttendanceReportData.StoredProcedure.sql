CREATE PROCEDURE [RDS].[Get_YeartoYearAttendanceReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@reportGrade as varchar(50),
	@reportLea as varchar(50) = null,
	@reportSchool as varchar(50) = null
AS
BEGIN


	SET NOCOUNT ON;

	create table #organizations
	(
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
	)
	
	
	create table #zeroCounts
	(
		ReportCode [nvarchar](1000) NOT NULL,
		ReportYear [nvarchar](1000) NOT NULL,
		ReportLevel [nvarchar](1000) NOT NULL,
		ReportGrade [nvarchar](1000) NOT NULL,
		CategorySetCode [nvarchar](1000) NOT NULL,
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		ProficiencyStatus varchar(100) NOT NULL,
		ProficiencyName varchar(100) NOT NULL,
		AssessmentSubject varchar(100) NOT NULL,
		SubjectName varchar(100) NOT NULL,
		GradeLevel varchar(100) NOT NULL,
		GradeName varchar(100) NOT NULL,
		CategoryOptionCode varchar(100) NULL,
		CategoryOptionName varchar(100) NULL,
		rowSequence int NOT NULL
		)

	create table #categoryOptions
	(
		CategoryOptionCode varchar(100) NOT NULL,
		CategoryOptionName varchar(100) NOT NULL,
		DimensionFieldName varchar(100) NOT NULL
	)
	
	if @reportLevel = 'sea'
	begin
		insert into #organizations(OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, StateName)
		select SeaName, SeaStateIdentifier, SeaStateIdentifier, StateANSICode, StateCode, StateName from rds.DimSeas 
		where RecordEndDateTime IS NULL and DimSeaId <> -1
	end
	else if @reportLevel = 'lea'
	begin
		insert into #organizations(OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, StateName, ParentOrganizationStateId)
		select LeaName, ISNULL(LeaNcesIdentifier, ''), LeaStateIdentifier, StateANSICode, StateCode, StateName, SeaStateIdentifier from rds.DimLeas
		where RecordEndDateTime IS NULL and DimLeaId <> -1
	end
	else if @reportLevel = 'sch'
	begin
		insert into #organizations(OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, 
		StateName, ParentOrganizationStateId)
		select SchoolName, SchoolNcesIdentifier, SchoolStateIdentifier, StateANSICode, StateCode, StateName, LeaStateIdentifier from rds.DimSchools 
		where RecordEndDateTime IS NULL and DimSchoolId <> -1
	end

	insert into #categoryOptions(CategoryOptionCode, CategoryOptionName, DimensionFieldName)
	SELECT CategoryOptionCode, CategoryOptionName, upper(d.DimensionFieldName)
	FROM app.GenerateReports r 
	inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
	inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
	inner join app.Categories c on csc.CategoryId = c.CategoryId
	inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
	inner join app.Dimensions d on d.DimensionId = cd.DimensionId
	inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
	inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
	Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear and cs.CategorySetCode = @categorySetCode
	and upper(d.DimensionFieldName) not in ('TITLE1SCHOOLSTATUS','MIGRANTSTATUS') 
	and CategoryOptionCode <> 'MISSING'

	IF @categorySetCode = 'migrant'
	begin
		insert into #categoryOptions(CategoryOptionCode, CategoryOptionName, DimensionFieldName)
		SELECT 'Migrant', 'Migrant Students', 'MIGRANTSTATUS' 
		UNION
		SELECT 'NonMigrant', 'Non Migrant Students', 'MIGRANTSTATUS'
	end

	IF @categorySetCode = 'title1'
	begin
		insert into #categoryOptions(CategoryOptionCode, CategoryOptionName, DimensionFieldName)
		SELECT 'Title1', 'Title I', 'TITLE1SCHOOLSTATUS'
		UNION
		SELECT 'NotTitle1', 'Not Title I', 'TITLE1SCHOOLSTATUS'
	end

		

	IF @categorySetCode = 'All'
	BEGIN

		
		insert into #zeroCounts(
			ReportCode,
			ReportYear,
			ReportLevel,
			ReportGrade,
			CategorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName, rowSequence)
		select 
			@reportCode,
			@reportYear,
			@reportLevel,
			@reportGrade,
			@categorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, Grade, GradeName,
			ROW_NUMBER() OVER(ORDER BY Grade, AssessmentSubject, ProficiencyStatus ASC)
		from
		(SELECT CategoryOptionCode as ProficiencyStatus, CategoryOptionName as ProficiencyName
		FROM #categoryOptions
		where upper(DimensionFieldName) in ('PROFICIENCYSTATUS')) proficiencyValues
		CROSS JOIN
		(SELECT CategoryOptionCode as AssessmentSubject, CategoryOptionName as SubjectName
		FROM #categoryOptions
		Where upper(DimensionFieldName) in ('ASSESSMENTSUBJECT')) subjectValues
		CROSS JOIN
		(SELECT CategoryOptionCode as Grade, CategoryOptionName as GradeName
		FROM #categoryOptions
		Where upper(DimensionFieldName) in ('GRADELEVEL') and CategoryOptionCode = @reportGrade) grades
		CROSS JOIN 
		(select * from #organizations) org
		
		insert into #zeroCounts(
			ReportCode,
			ReportYear,
			ReportLevel,
			ReportGrade,
			CategorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName, rowSequence)
		select 
			@reportCode,
			@reportYear,
			@reportLevel,
			@reportGrade,
			@categorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, 'StudentAttendanceRate', 'Student Attendance Rate', 'StudentAttendanceRate', 'Student Attendance Rate', GradeLevel, GradeName, 0
		from #zeroCounts
		group by StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, GradeLevel, GradeName

	END
	ELSE
	BEGIN
		insert into #zeroCounts(
			ReportCode,
			ReportYear,
			ReportLevel,
			ReportGrade,
			CategorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName, CategoryOptionCode, CategoryOptionName, rowSequence)
		select 
			@reportCode,
			@reportYear,
			@reportLevel,
			@reportGrade,
			@categorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, Grade, GradeName, CategoryOptionCode, CategoryOptionName,
			ROW_NUMBER() OVER(ORDER BY Grade, CategoryOptionCode, AssessmentSubject, ProficiencyStatus ASC)
		from
		(SELECT CategoryOptionCode as ProficiencyStatus, CategoryOptionName as ProficiencyName
		FROM #categoryOptions
		where upper(DimensionFieldName) in ('PROFICIENCYSTATUS')) proficiencyValues
		CROSS JOIN
		(SELECT CategoryOptionCode as AssessmentSubject, CategoryOptionName as SubjectName
		FROM #categoryOptions
		Where upper(DimensionFieldName) in ('ASSESSMENTSUBJECT')) subjectValues
		CROSS JOIN
		(SELECT CategoryOptionCode as Grade, CategoryOptionName as GradeName
		FROM #categoryOptions
		Where upper(DimensionFieldName) in ('GRADELEVEL') and CategoryOptionCode = @reportGrade) grades
		CROSS JOIN
		(SELECT distinct CategoryOptionCode, CategoryOptionName FROM #categoryOptions
		Where upper(DimensionFieldName) not in ('GRADELEVEL', 'ASSESSMENTSUBJECT','PROFICIENCYSTATUS')
		) Cats
		CROSS JOIN 
		(select * from #organizations) org

		insert into #zeroCounts(
			ReportCode,
			ReportYear,
			ReportLevel,
			ReportGrade,
			CategorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName, CategoryOptionCode, CategoryOptionName, rowSequence)
		select 
			@reportCode,
			@reportYear,
			@reportLevel,
			@reportGrade,
			@categorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, 'StudentAttendanceRate', 'Student Attendance Rate', 'StudentAttendanceRate', 'Student Attendance Rate', GradeLevel, GradeName,
			CategoryOptionCode, CategoryOptionName, 0
		from #zeroCounts
		group by StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, GradeLevel, GradeName, CategoryOptionCode, CategoryOptionName


		insert into #zeroCounts(
			ReportCode,
			ReportYear,
			ReportLevel,
			ReportGrade,
			CategorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName, CategoryOptionCode, CategoryOptionName, rowSequence)
		select 
			@reportCode,
			@reportYear,
			@reportLevel,
			@reportGrade,
			@categorySetCode,
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName,
			'Total', 'Total Students', ROW_NUMBER() OVER(ORDER BY GradeLevel, AssessmentSubject, ProficiencyStatus ASC)
		from #zeroCounts
		group by StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, ProficiencyStatus, ProficiencyName, AssessmentSubject, SubjectName, GradeLevel, GradeName
			
	END

	Update #zeroCounts set rowSequence = 0 where CategoryOptionCode = 'Total' and ProficiencyStatus  = 'StudentAttendanceRate'


	select CAST(ROW_NUMBER() OVER(ORDER BY z.CategoryOptionName, z.rowSequence ASC) AS INT) as FactCustomCountId,
			@reportCode as ReportCode,
			@reportYear as ReportYear,
			@reportLevel as ReportLevel,
			@reportGrade as ReportFilter,
			@categorySetCode as CategorySetCode,
			z.StateANSICode,
			z.StateCode,
			z.StateName,
			z.OrganizationNcesId,
			z.OrganizationStateId,
			z.OrganizationName,
			z.ParentOrganizationStateId,
			z.CategoryOptionName as Category1,
			z.SubjectName as Category2,
			z.GradeLevel as Category3,
			z.ProficiencyName as Category4,
			isnull(c.Col_1, 0.0) as col_1,
			isnull(c.Col_2, 0.0) as col_2,
			isnull(c.Col_3, 0.0) as col_3,
			isnull(c.Col_4, 0.0) as col_4,
			isnull(c.Col_5, 0.0) as col_5,
			isnull(c.Col_6, 0.0) as col_6,
			isnull(c.Col_7, 0.0) as col_7,
			isnull(c.Col_8, 0.0) as col_8,
			col_9,
			col_10,
			col_10a,
			col_10b,
			col_11,
			col_11a,
			col_11b,
			col_11c,
			col_11d,
			col_11e,
			col_12,
			col_12a,
			col_12b,
			col_13,
			col_14,
			col_14a,
			col_14b,
			col_14c,
			col_14d,
			col_15,
			col_16,
			col_17,
			col_18,
			col_18a,
			col_18b,
			col_18c,
			col_18d,
			col_18e,
			col_18f,
			col_18g,
			col_18h,
			col_18i from
	 #zeroCounts z
	left outer join (
	select * from rds.FactCustomCounts
	Where  ReportCode = @reportCode and ReportLevel = @reportLevel and ReportYear = @reportYear and
	ReportFilter = @reportGrade and CategorySetCode = isnull(@categorySetCode, CategorySetCode)) c
	on z.AssessmentSubject = c.Category2 AND z.GradeLevel = c.Category3 AND z.ProficiencyStatus = c.Category4 
	AND isnull(z.CategoryOptionCode, '') = isnull(c.Category1, '')
	AND z.OrganizationStateId = IIF(@reportLevel <> 'sea', c.OrganizationStateId, z.OrganizationStateId)
	order by z.CategoryOptionName, z.rowSequence
	
	drop table #categoryOptions
	drop table #zeroCounts
	drop table #organizations


END