CREATE PROCEDURE [RDS].[Create_YeartoYearAttendanceReportData]
	@reportCode as varchar(50),
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN


	SET NOCOUNT ON;


	-- Determine Fact/Report Tables

	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @factReportId as varchar(50)
	DECLARE @SQL nvarchar(MAX), @tableSql nvarchar(max)
	DECLARE @DeclareSQL nvarchar(MAX), @InsertSQL nvarchar(MAX), @SelectSQL nvarchar(MAX), @GroupBySQL nvarchar(MAX), @FromSQL nvarchar(MAX)
	declare @dimensionTable as varchar(100), @dimensionPrimaryKey as varchar(100), @dimensionField as varchar(100)
	declare @selectedYear as int
	DECLARE @year1 as varchar(50), @year2 as varchar(50), @year3 as varchar(50), @year4 as varchar(50)
	declare @submittedYears as varchar(50), @pivotYears as varchar(50), @pivotYears1 as varchar(50)
	declare @reportYear as varchar(50)
	

	declare @reportField as nvarchar(100)
	DECLARE @rowField as nvarchar(100), @columnField as nvarchar(100)

	declare @dataMigrationTypeId as int, @dimFactTypeId as int

	select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode
	select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'
	

	-- Determine Fact/Report Tables

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, 
	@factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

		



	-- Loop through all submission years
	---------------------------------------------

	declare @submissionYears as table(
		SubmissionYear varchar(50)
	)

	if @runAsTest = 1
	begin

		insert into @submissionYears
		(
			SubmissionYear
		)
		select distinct cs.SubmissionYear 
		from app.CategorySets cs 
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
		Where ReportCode = @reportCode

	end
	else
	begin			
			insert into @submissionYears
			(
				SubmissionYear
			)
			select distinct cs.SubmissionYear 
			from app.CategorySets cs 
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
			inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1 and dd.DataMigrationTypeId=@dataMigrationTypeId
			Where ReportCode = @reportCode and r.isLocked=1
	end

	
	
	DECLARE submissionYear_cursor CURSOR FOR 
	SELECT SubmissionYear
	FROM @submissionYears ORDER BY SubmissionYear

	OPEN submissionYear_cursor
	FETCH NEXT FROM submissionYear_cursor INTO @reportYear

	WHILE @@FETCH_STATUS = 0
	BEGIN

			
			SET @submittedYears = NULL
			SET @pivotYears = NULL
			SET @pivotYears1 = NULL

			select @selectedYear = [Year]
			from rds.DimDates where SubmissionYear = @reportYear

			select @submittedYears = COALESCE(@submittedYears + ',', '') + Quotename(SubmissionYear, '''') 
			from rds.DimDates
			where [Year] in (@selectedYear, @selectedYear - 1, @selectedYear - 2, @selectedYear - 3)

			select @pivotYears = COALESCE(@pivotYears + ',', '') + '[' + SubmissionYear + ']'
			from rds.DimDates
			where [Year] in (@selectedYear, @selectedYear - 1, @selectedYear - 2, @selectedYear - 3)

			select @pivotYears1 = COALESCE(@pivotYears1 + ',', '') + '[' + 'y' + SubmissionYear + ']'
			from rds.DimDates
			where [Year] in (@selectedYear, @selectedYear - 1, @selectedYear - 2, @selectedYear - 3)

			select @year1 = SubmissionYear
			from rds.DimDates
			where [Year] in (@selectedYear)

			select @year2 = SubmissionYear
			from rds.DimDates
			where [Year] in (@selectedYear - 1)

			select @year3 = SubmissionYear
			from rds.DimDates
			where [Year] in (@selectedYear - 2)

			select @year4 = SubmissionYear
			from rds.DimDates
			where [Year] in (@selectedYear - 3)


			
			-- Get Category Sets for this Submission Year

			declare @categorySets as table(
				CategorySetId int,
				ReportLevel varchar(5),
				CategorySetCode varchar(50),
				Categories varchar(2000),
				ReportFields varchar(2000),
				TableTypeAbbrv varchar(50),
				TotalIndicator varchar(5)
			)
			delete from @categorySets
		
			insert @categorySets
			(	
				CategorySetId,
				ReportLevel,
				CategorySetCode,
				Categories,
				ReportFields,
				TableTypeAbbrv,
				TotalIndicator
			)
			select	
				cs.CategorySetId,
				o.LevelCode,
				cs.CategorySetCode,
				isnull(app.Get_CategoriesByCategorySet(cs.CategorySetId, 1, 0), '') as Categories,
				isnull(app.Get_CategoriesByCategorySet(cs.CategorySetId, 1, 1), '') as ReportFields,
				isnull(tt.TableTypeAbbrv, '') as TableTypeAbbrv,
				CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
					 ELSE 'N'
				END as TotalIndicator
			from app.CategorySets cs 
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
			left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode
			and cs.SubmissionYear = @reportYear
			order by o.OrganizationLevelId, cs.CategorySetCode

			-- Loop through Category Sets for this Submission Year
		---------------------------------------------
			declare @categorySetId as int
			declare @reportLevel as varchar(5)
			declare @categorySetCode as varchar(50)
			declare @categorySetCategoryList as varchar(2000)
			declare @categorySetReportFieldList as varchar(2000)
			declare @tableTypeAbbrv as varchar(50)
			declare @totalIndicator as varchar(5)

			declare @categorySetCnt as int
			select @categorySetCnt = count(*) from @categorySets
			declare @categorySetCntr as int
			set @categorySetCntr = 0
			declare @reportDescription as varchar(2000)

			DECLARE categoryset_cursor CURSOR FOR 
			SELECT CategorySetId, ReportLevel, CategorySetCode, Categories, ReportFields, TableTypeAbbrv, TotalIndicator
			FROM @categorySets

			OPEN categoryset_cursor
			FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator

			WHILE @@FETCH_STATUS = 0
			BEGIN

				set @categorySetCntr = @categorySetCntr + 1

				
				-- Log status

				print ''
				print '----------------------------------'
				print '-- ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode + ' - ' + @categorySetCategoryList
				print '----------------------------------'
				SET @reportDescription = @reportCode + '-' + @reportYear + '-' + @categorySetCode + ' - ' + @categorySetCategoryList

				if @runAsTest = 0
				begin
					insert into app.DataMigrationHistories
					(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					values	(getutcdate(), @dataMigrationTypeId, 'Submission Report - ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode)
				end


				SET @SQL = '		
				create table #organizations
				(
					[OrganizationId] [int] NOT NULL,
					[OrganizationName] [nvarchar](1000) NOT NULL,
					[OrganizationNcesId] [nvarchar](100) NOT NULL,
					[OrganizationStateId] [nvarchar](100) NOT NULL,
					[ParentOrganizationStateId] [nvarchar](100) NULL,
					[StateANSICode] [nvarchar](100) NOT NULL,
					[StateCode] [nvarchar](100) NOT NULL,
					[StateName] [nvarchar](500) NOT NULL,
				)

				create table #studentDropouts
				(
					StudentIdentifier nvarchar(50)
				)
				
				create table #studentCounts
				(
					DimOrgId int NOT NULL,
					DimDateId int NOT NULL,
					StudentIdentifier nvarchar(50) NOT NULL,
					ProficiencyStatus varchar(100) NOT NULL,
					AssessmentSubject varchar(100) NULL,
					GradeLevel varchar(100) NOT NULL,
					Category1 varchar(100) NULL
				 )

				create table #studentAttendanceRate
				(
					DimOrgId int NOT NULL,
					DimDateId int NOT NULL,
					StudentIdentifier nvarchar(50) NOT NULL,
					StudentAttendanceRate decimal(18, 3) NOT NULL
				 )

				 create table #factCustomCounts
				(
					ReportCode nvarchar(50) NOT NULL,
					ReportYear nvarchar(50) NOT NULL,
					ReportLevel nvarchar(50) NOT NULL,
					ReportFilter nvarchar(50) NOT NULL,
					CategorySetCode nvarchar(50) NOT NULL,
					StateANSICode nvarchar(50) NOT NULL,
					StateCode nvarchar(50) NOT NULL,
					StateName nvarchar(50) NOT NULL,
					OrganizationId int NOT NULL,
					OrganizationNcesId nvarchar(100) NOT NULL,
					OrganizationStateId nvarchar(100) NOT NULL,
					OrganizationName nvarchar(1000) NOT NULL,
					ParentOrganizationStateId nvarchar(100) NULL,
					Category1 nvarchar(100) NULL,
					Category2 nvarchar(50) NULL,
					Category3 nvarchar(50) NULL,
					Category4 nvarchar(50) NULL,
					col_1 decimal(18, 2) NULL,
					col_2 decimal(18, 2) NULL,
					col_3 decimal(18, 2) NULL,
					col_4 decimal(18, 2) NULL,
					col_5 decimal(18, 2) NULL,
					col_6 decimal(18, 2) NULL,
					col_7 decimal(18, 2) NULL,
					col_8 decimal(18, 2) NULL
				 )
     			'

			SET @SQL = @SQL + '
			
			insert into #studentDropouts(StudentIdentifier)
			select distinct s.StateStudentIdentifier
			from rds.' + @factTable +  ' f
			inner join rds.DimStudents s on f.DimStudentId = s.DimStudentId
			inner join rds.DimEnrollmentStatuses enrStatus on f.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
			inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
			inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
			Where enrStatus.ExitOrWithdrawalCode = ''01927'' and ft.FactTypeCode = ''' + @factTypeCode + ''' and d.SubmissionYear = ''' + @reportYear +	'''
			'

			SET @SQL = @SQL + '
			
			insert into #studentAttendanceRate(DimOrgId,DimDateId,StudentIdentifier,StudentAttendanceRate)
			select distinct case when @reportLevel = ''lea'' then DimLeaId else DimSchoolId end as DimOrgId, f.DimCountDateId, s.StateStudentIdentifier, 
			isnull(sum(f.StudentAttendanceRate), 0.0)
			from rds.FactK12StudentAttendance f
			inner join rds.DimStudents s on f.DimStudentId = s.DimStudentId
			inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
			inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
			inner join #studentDropouts dropOuts on s.StateStudentIdentifier = dropOuts.StudentIdentifier
			Where d.SubmissionYear in (' + @submittedYears + ') and ft.FactTypeCode = ''' + @factTypeCode + '''
			group by case when @reportLevel = ''lea'' then DimLeaId else DimSchoolId end, f.DimCountDateId, s.StateStudentIdentifier
			'


			if(@categorySetCode = 'All')
			BEGIN
				SET @InsertSQL = '
				INSERT INTO #studentCounts(DimOrgId, DimDateId, StudentIdentifier,AssessmentSubject,GradeLevel,ProficiencyStatus)' 
			END
			ELSE
			BEGIN
				SET @InsertSQL = '
				INSERT INTO #studentCounts(DimOrgId, DimDateId, StudentIdentifier,AssessmentSubject,GradeLevel,ProficiencyStatus,Category1)' 
			END

									

				SET @SelectSQL = '
				select distinct case when @reportLevel = ''lea'' then DimLeaId else DimSchoolId end as DimOrgId, f.DimCountDateId, s.StateStudentIdentifier,
				CAT_AssessmentSubject.AssessmentSubjectEdFactsCode, CAT_GradeLevel.GradeLevelEdFactsCode,
							case 
								WHEN assmnt.PerformanceLevelEdFactsCode =''MISSING'' THEN ''MISSING''
								when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''PROFICIENT''	
								when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''BELOWPROFICIENT''
								else ''MISSING''
							end'

				SET @FromSQL = 	'
				from rds.' + @factTable +	' f
				inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
				inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
				inner join #organizations org on org.OrganizationId = case when @reportLevel = ''lea'' then f.DimLeaId else f.DimSchoolId end
				inner join rds.DimStudents s on f.DimStudentId = s.DimStudentId
				inner join #studentDropouts dropouts on dropouts.StudentIdentifier = s.StateStudentIdentifier
				inner join rds.DimGradelevels CAT_GradeLevel ON f.DimGradeLevelId = CAT_GradeLevel.DimGradeLevelId
				inner join rds.DimAssessments CAT_AssessmentSubject on f.DimAssessmentId = CAT_AssessmentSubject.DimAssessmentId
				'

				SET @GroupBySQL = 'group by case when @reportLevel = ''lea'' then DimLeaId else DimSchoolId end, f.DimCountDateId, s.StateStudentIdentifier,
				CAT_AssessmentSubject.AssessmentSubjectEdFactsCode, CAT_GradeLevel.GradeLevelEdFactsCode,
							case 
								WHEN assmnt.PerformanceLevelEdFactsCode =''MISSING'' THEN ''MISSING''
								when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int)										THEN  ''PROFICIENT''	
								when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)										THEN  ''BELOWPROFICIENT''
								else ''MISSING''
							end'

				-- Get Categories used in this report

				declare @DimensionsInCategorySet as table(
					DimensionField varchar(100),
					DimensionTable varchar(100)
				)

				delete from @DimensionsInCategorySet
				
			
				insert into @DimensionsInCategorySet
				(DimensionField, DimensionTable)
				select upper(d.DimensionFieldName), dt.DimensionTableName
				from app.Dimensions d 
				inner join app.Dimensiontables dt on d.DimensionTableId = dt.DimensionTableId
				inner join app.Category_Dimensions cd on d.DimensionId = cd.DimensionId
				inner join app.Categories c on cd.CategoryId = c.CategoryId
				inner join app.CategorySet_Categories csc on c.CategoryId = csc.CategoryId
				inner join app.CategorySets cs on csc.CategorySetId = cs.CategorySetId
				inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
				where r.ReportCode = @reportCode
				and cs.SubmissionYear = @reportYear
				and o.LevelCode = @reportLevel
				and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
				and d.DimensionFieldName not in ('AssessmentSubject','GradeLevel','ProficiencyStatus')
				

				if @reportLevel = 'sea'
				begin
					SET @SQL = @SQL + '
					insert into #organizations(OrganizationId, OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, 
					StateCode, StateName)
					select distinct DimSchoolId, SeaName, SeaStateIdentifier, SeaStateIdentifier, StateANSICode, StateCode, StateName 
					from rds.DimSchools
					where RecordEndDateTime IS NULL and DimSchoolId <> -1

					'
				end
				else if @reportLevel = 'lea'
				begin
					SET @SQL = @SQL + '
					insert into #organizations(OrganizationId, OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, 
					StateName, ParentOrganizationStateId)
					select DimLeaId, LeaName, ISNULL(LeaNcesIdentifier, ''''), LeaStateIdentifier, StateANSICode, StateCode, 
					StateName, SeaStateIdentifier 
					from rds.DimLeas
					where RecordEndDateTime IS NULL and DimLeaId <> -1

					'
				end
				else if @reportLevel = 'sch'
				begin
					SET @SQL = @SQL + '
					insert into #organizations(OrganizationId, OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, 
					StateName, ParentOrganizationStateId)
					select DimSchoolId, SchoolName, SchoolNcesIdentifier, SchoolStateIdentifier, StateANSICode, StateCode, StateName, LeaStateIdentifier
					from rds.DimSchools 
					where RecordEndDateTime IS NULL and DimSchoolId <> -1

					'
				end

			
							
				DECLARE dimensionField_cursor CURSOR FOR   
				select DimensionField, DimensionTable FROM @DimensionsInCategorySet

				OPEN dimensionField_cursor  
  
				FETCH NEXT FROM dimensionField_cursor INTO @dimensionField, @dimensionTable
				WHILE @@FETCH_STATUS = 0  
				BEGIN  

						if @dimensionTable = 'DimAssessments'
						begin
							set @dimensionPrimaryKey = 'DimAssessmentId'
						end
						else if @dimensionTable = 'DimGradeLevels'
						begin
							set @dimensionPrimaryKey = 'DimGradeLevelId'
						end
						else if @dimensionTable = 'DimIdeaStatuses'
						begin
							set @dimensionPrimaryKey = 'DimIdeaStatusId'
						end
						else if @dimensionTable = 'DimRaces'
						begin
							set @dimensionPrimaryKey = 'DimRaceId'
						end
						else if @dimensionTable = 'DimDemographics'
						begin
							set @dimensionPrimaryKey = 'DimDemographicId'
						end
						else if @dimensionTable = 'DimTitle1Statuses'
						begin
							set @dimensionPrimaryKey = 'DimTitle1StatusId'
						end
												
						
						IF(@dimensionField = 'TITLE1SCHOOLSTATUS')
						BEGIN
							SET @SelectSQL = @SelectSQL + ', case when CAT_' + @dimensionField + '.' + @dimensionField + 'EDFactsCode <> ''MISSING'' then ''Title1'' 
																															else ''NotTitle1'' end'
							SET @GroupBySQL = @GroupBySQL + ', case when CAT_' + @dimensionField + '.' + @dimensionField + 'EDFactsCode <> ''MISSING'' then ''Title1'' 
																																else ''NotTitle1'' end'
						END
						ELSE IF(@dimensionField = 'MIGRANTSTATUS')
						BEGIN
							SET @SelectSQL = @SelectSQL + ', case when CAT_' + @dimensionField + '.' + @dimensionField + 'EDFactsCode <> ''MISSING'' then ''Migrant'' 
																														else ''NonMigrant'' end'
							SET @GroupBySQL = @GroupBySQL + ', case when CAT_' + @dimensionField + '.' + @dimensionField + 'EDFactsCode <> ''MISSING'' then ''Migrant'' 
																																else ''NonMigrant'' end'
						END 
						ELSE if @dimensionField = 'RACE'
						begin
							SET @SelectSQL = @SelectSQL + ', CAT_' + @dimensionField + '.' + @dimensionField + 'Code'
							SET @GroupBySQL = @GroupBySQL + ', CAT_' + @dimensionField + '.' + @dimensionField + 'Code'
						end
						ELSE
						BEGIN
							SET @SelectSQL = @SelectSQL + ', CAT_' + @dimensionField + '.' + @dimensionField + 'EDFactsCode'
							SET @GroupBySQL = @GroupBySQL + ', CAT_' + @dimensionField + '.' + @dimensionField + 'EDFactsCode'
						END
						
						

						SET @FromSQL = @FromSQL + 'inner join rds.' + @dimensionTable + ' CAT_' + @dimensionField + 
							' ON f.' + @dimensionPrimaryKey + ' = CAT_' + @dimensionField + '.' + @dimensionPrimaryKey + '
							'



					FETCH NEXT FROM dimensionField_cursor INTO @dimensionField, @dimensionTable
				END
				CLOSE dimensionField_cursor;  
				DEALLOCATE dimensionField_cursor;
				

				SET @FromSQL = @FromSQL + ' inner join rds.DimAssessments assmnt on f.DimAssessmentId = assmnt.DimAssessmentId
					inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = CAT_GradeLevel.GradeLevelCode 
					and tgglAssmnt.Subject = assmnt.AssessmentSubjectEdFactsCode	
					AND tgglAssmnt.AssessmentTypeCode = assmnt.AssessmentTypeEdFactsCode
					Where d.SubmissionYear in (' + @submittedYears + ')
					'	
				
				
				SET @SQL = @SQL + @InsertSQL + @SelectSQL + @FromSQL + @GroupBySQL


				----------------------------------------------------------------------------------
				--ISNULL(CAST(SUM([' + 'y' + @year1 + ']) as decimal(18, 2)), 0) as col_1,   Student Rate for the Dropout Year
				--ISNULL(CAST(SUM([' + @year1 + ']) as decimal(18, 2)), 0) as col_2,         Student Count for the Dropout Year
				--ISNULL(CAST(SUM([' + 'y'+ @year2 + ']) as decimal(18, 2)), 0) as col_3,	 Student Rate for the Dropout Year minus 1
				--ISNULL(CAST(SUM([' + @year2 + ']) as decimal(18, 2)), 0) as col_4,		 Student Count for the Dropout Year minus 1
				--ISNULL(CAST(SUM([' + 'y' + @year3 + ']) as decimal(18, 2)), 0) as col_5,   Student Rate for the Dropout Year minus 2
				--ISNULL(CAST(SUM([' + @year3 + ']) as decimal(18, 2)), 0) as col_6,		 Student Count for the Dropout Year minus 2
				--ISNULL(CAST(SUM([' + 'y' + @year4 + ']) as decimal(18, 2)), 0) as col_7,   Student Rate for the Dropout Year minus 3
				--ISNULL(CAST(SUM([' + @year4 + ']) as decimal(18, 2)), 0) as col_8			 Student Count for the Dropout Year minus 3

				
				

				SET @SQL = @SQL + '

					INSERT INTO #factCustomCounts(
						ReportCode,
						ReportYear,
						ReportLevel,
						ReportFilter,
						CategorySetCode,
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						Category2,
						Category3,
						Category4,
						col_1,
						col_2,
						col_3,
						col_4,
						col_5,
						col_6,
						col_7,
						col_8
					)
					SELECT @reportCode, @reportYear, @reportLevel, GradeLevel, @categorySetCode,
					StateANSICode,StateCode,StateName,OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName, ParentOrganizationStateId,
					options.CategoryOptionCode as Category1,AssessmentSubject as Category2,GradeLevel as Category3,ProficiencyStatus as Category4,
					isnull(col_1, 0.0) as col_1,isnull(col_2, 0) as col_2,isnull(col_3, 0.0) as col_3,isnull(col_4, 0) as col_4,isnull(col_5, 0.0) as col_5,
					isnull(col_6, 0) as col_6,isnull(col_7, 0.0) as col_7,isnull(col_8, 0) as col_8
					FROM
						(select StateANSICode,StateCode,StateName,OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,
							   ParentOrganizationStateId, AssessmentSubject, GradeLevel, ProficiencyStatus, Category, 
								ISNULL(CAST(SUM([' + 'y' + @year1 + ']) as decimal(18, 2)), 0) as col_1, 
								ISNULL(CAST(SUM([' + @year1 + ']) as decimal(18, 2)), 0) as col_2,
								ISNULL(CAST(SUM([' + 'y'+ @year2 + ']) as decimal(18, 2)), 0) as col_3,
								ISNULL(CAST(SUM([' + @year2 + ']) as decimal(18, 2)), 0) as col_4,
								ISNULL(CAST(SUM([' + 'y' + @year3 + ']) as decimal(18, 2)), 0) as col_5,
								ISNULL(CAST(SUM([' + @year3 + ']) as decimal(18, 2)), 0) as col_6,
								ISNULL(CAST(SUM([' + 'y' + @year4 + ']) as decimal(18, 2)), 0) as col_7,
								ISNULL(CAST(SUM([' + @year4 + ']) as decimal(18, 2)), 0) as col_8
						FROM
						(
							select StateANSICode,StateCode,StateName,OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,
									ParentOrganizationStateId, d.SubmissionYear as ReportYear, ''y'' + d.SubmissionYear as ReportYear1, 
									AssessmentSubject,GradeLevel,ProficiencyStatus, Category1 as Category, 
							count(distinct s.StudentIdentifier) as StudentCount, sum(rate.StudentAttendanceRate) as AttendanceRate
							from #studentCounts s
							inner join #studentAttendanceRate rate on s.DimOrgId = rate.DimOrgId and s.DimDateId = rate.DimDateId and s.StudentIdentifier = rate.StudentIdentifier
							inner join rds.DimDates d on d.DimDateId = s.DimDateId
							inner join #organizations o on s.DimOrgId = o.OrganizationId
							Where AssessmentSubject in (''MATH'',''RLA'') and ProficiencyStatus <> ''MISSING''
							group by StateANSICode,StateCode,StateName,OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,
									ParentOrganizationStateId, d.SubmissionYear, AssessmentSubject,GradeLevel,ProficiencyStatus,Category1
						) as SourceTable
						PIVOT
						(	
							SUM(StudentCount)
							FOR ReportYear IN (' + @pivotYears + ')
						) AS p1
						PIVOT
						(	
							SUM(AttendanceRate)
							FOR ReportYear1 IN (' + @pivotYears1 + ')
						) AS p2
						group by StateANSICode,StateCode,StateName,OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,
								ParentOrganizationStateId, AssessmentSubject,GradeLevel,ProficiencyStatus, Category
						) r
						left outer join (SELECT distinct co.CategoryOptionCode, co.CategoryOptionName FROM 
						app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear 
						and cs.CategorySetCode = @categorySetCode and c.CategoryCode not in (''TITLEISCHSTATUS'',''MIGRNTSTATUS'')
						UNION
						SELECT ''Title1'' as CategoryOptionCode, ''Title I'' as CategoryOptionName 
						UNION
						SELECT ''NotTitle1'' as CategoryOptionCode, ''Not Title I'' as CategoryOptionName
						UNION
						SELECT ''Migrant'' as CategoryOptionCode, ''Migrant Students'' as CategoryOptionName 
						UNION
						SELECT ''NonMigrant'' as CategoryOptionCode, ''Non Migrant Students'' as CategoryOptionName
						 ) options	on r.Category = options.CategoryOptionCode
						 
						
						INSERT INTO #factCustomCounts(ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
									OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,
									Category1,Category2,Category3,Category4,col_1,col_2,col_3,col_4,col_5,col_6,col_7,col_8
						)
						SELECT ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
									OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,
									Category1,''StudentAttendanceRate'',Category3,''StudentAttendanceRate'',
								sum(col_1),sum(col_2),sum(col_3),sum(col_4),sum(col_5),sum(col_6),sum(col_7),sum(col_8)
						FROM #factCustomCounts
						group by ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
									OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,Category1,Category3

						if(@categorySetCode <> ''All'')
						BEGIN

								INSERT INTO #factCustomCounts(ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
									OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,
									Category1,Category2,Category3,Category4,col_1,col_2,col_3,col_4,col_5,col_6,col_7,col_8)
								SELECT ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
									OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,
									''Total'',Category2,Category3,Category4,sum(col_1),sum(col_2),sum(col_3),sum(col_4),sum(col_5),sum(col_6),sum(col_7),sum(col_8)
								FROM #factCustomCounts
								Where Category1 <> ''MISSING''
								group by ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
								OrganizationId,OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,Category2,Category3,Category4
						
						END

						
						'



						SET @SQL = @SQL + '

						if @reportLevel = ''sea''
						BEGIN
							
							INSERT INTO rds.FactCustomCounts(ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
										OrganizationNcesId,OrganizationStateId,OrganizationName,
										Category1,Category2,Category3,Category4,col_1,col_2,col_3,col_4,col_5,col_6,col_7,col_8)
							SELECT ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,StateCode,StateCode,StateName,
										Category1,Category2,Category3,Category4,sum(col_1),sum(col_2),sum(col_3),sum(col_4),sum(col_5),sum(col_6),sum(col_7),sum(col_8)
							FROM  #factCustomCounts
							group by ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,Category1,Category2,Category3,Category4

						END
						ELSE
						BEGIN

							INSERT INTO rds.FactCustomCounts(ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
										OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,
										Category1,Category2,Category3,Category4,col_1,col_2,col_3,col_4,col_5,col_6,col_7,col_8)
							SELECT ReportCode,ReportYear,ReportLevel,ReportFilter,CategorySetCode,StateANSICode,StateCode,StateName,
										OrganizationNcesId,OrganizationStateId,OrganizationName,ParentOrganizationStateId,
										Category1,Category2,Category3,Category4,col_1,col_2,col_3,col_4,col_5,col_6,col_7,col_8
							FROM  #factCustomCounts
						END
											

					'


					SET @SQL = @SQL + '
					
					drop table #factCustomCounts
					drop table #studentCounts
					drop table #studentAttendanceRate
					drop table #studentDropouts
					drop table #organizations
		
				'

				if( @runAsTest = 0)
				BEGIN

						declare @ParmDefinition as nvarchar(max)
						SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100)';  
						EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, 
												@categorySetCode = @categorySetCode

						print 'Report Creation Completed'

				END
				ELSE
				BEGIN

						DECLARE @printString NVARCHAR(MAX);
						set @printString = @SQL;
						DECLARE @CurrentEnd BIGINT; /* track the length of the next substring */
						DECLARE @offset tinyint; /*tracks the amount of offset needed */
						set @printString = replace(  replace(@printString, char(13) + char(10), char(10))   , char(13), char(10))

						WHILE LEN(@printString) > 1
						BEGIN
							IF CHARINDEX(CHAR(10), @printString) between 1 AND 4000
							BEGIN
									SET @CurrentEnd =  CHARINDEX(char(10), @printString) -1
									set @offset = 2
							END
							ELSE
							BEGIN
									SET @CurrentEnd = 4000
									set @offset = 1
							END   
							PRINT SUBSTRING(@printString, 1, @CurrentEnd) 
							set @printString = SUBSTRING(@printString, @CurrentEnd+@offset, LEN(@printString))   
						END

				END

				


		FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator
		END

		CLOSE categoryset_cursor
		DEALLOCATE categoryset_cursor

		 
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
	END

	CLOSE submissionYear_cursor
	DEALLOCATE submissionYear_cursor

	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1)
	begin
			update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1
	end

				

	SET NOCOUNT OFF;


END
