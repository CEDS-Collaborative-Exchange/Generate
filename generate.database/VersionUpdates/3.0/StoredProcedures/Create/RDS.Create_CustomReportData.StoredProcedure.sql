
CREATE PROCEDURE [RDS].[Create_CustomReportData]
	@reportCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

	set nocount on;


	-- Get GenerateReportTypeCode

	declare @generateReportTypeCode as varchar(50)
	select @generateReportTypeCode = t.ReportTypeCode
	from app.GenerateReports r
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where r.ReportCode = @reportCode

	-- Get DataMigrationId and DimFactTypeId

	declare @dataMigrationTypeId as int
	declare @dimFactTypeId as int
	if @generateReportTypeCode = 'datapopulation'
	begin
		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'datapopulation'
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	end
	else 
	begin
		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'submission'
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'
	end


	-- Setup results tables and variables

	declare @results1 as table (
	StateANSICode nvarchar(100),
	StateCode nvarchar(100),
	StateName nvarchar(100),
	OrganizationId int,
	OrganizationNcesId nvarchar(100),
	OrganizationStateId nvarchar(100),
	OrganizationName nvarchar(500),
	ParentOrganizationStateId nvarchar(100),
	col_1 decimal(18,4),
	col_2 decimal(18,4),
	col_3 decimal(18,4),
	col_4 decimal(18,4),
	col_5 decimal(18,4),
	col_6 decimal(18,4),
	col_7 decimal(18,4),
	col_8 decimal(18,4),
	col_9 decimal(18,4),
	col_10 decimal(18,4),
	col_10a decimal(18,4),
	col_10b decimal(18,4),
	col_11 decimal(18,4),
	col_11a decimal(18,4),
	col_11b decimal(18,4),
	col_11c decimal(18,4),
	col_11d decimal(18,4),
	col_11e decimal(18,4),
	col_12 decimal(18,4),
	col_12a decimal(18,4),
	col_12b decimal(18,4),
	col_13 decimal(18,4),
	col_14 decimal(18,4),
	col_14a decimal(18,4),
	col_14b decimal(18,4),
	col_14c decimal(18,4),
	col_14d decimal(18,4),
	col_15 decimal(18,4),
	col_16 decimal(18,4),
	col_17 decimal(18,4),
	col_18 decimal(18,4)
	)


	declare @results2 as table (
	ReportCode varchar(40),
	ReportYear varchar(40),
	ReportLevel varchar(40),
	CategorySetCode varchar(40),
	StateANSICode nvarchar(100),
	StateCode nvarchar(100),
	StateName nvarchar(100),
	OrganizationId int,
	OrganizationNcesId nvarchar(100),
	OrganizationStateId nvarchar(100),
	OrganizationName nvarchar(500),
	ParentOrganizationStateId nvarchar(100),
	Category1 nvarchar(100),
	col_1 decimal(18,4),
	col_2 decimal(18,4),
	col_3 decimal(18,4),
	col_4 decimal(18,4),
	col_5 decimal(18,4),
	col_6 decimal(18,4),
	col_7 decimal(18,4),
	col_8 decimal(18,4),
	col_9 decimal(18,4),
	col_10 decimal(18,4),
	col_10a decimal(18,4),
	col_10b decimal(18,4),
	col_11 decimal(18,4),
	col_11a decimal(18,4),
	col_11b decimal(18,4),
	col_11c decimal(18,4),
	col_11d decimal(18,4),
	col_11e decimal(18,4),
	col_12 decimal(18,4),
	col_12a decimal(18,4),
	col_12b decimal(18,4),
	col_13 decimal(18,4),
	col_14 decimal(18,4),
	col_14a decimal(18,4),
	col_14b decimal(18,4),
	col_14c decimal(18,4),
	col_14d decimal(18,4),
	col_15 decimal(18,4),
	col_16 decimal(18,4),
	col_17 decimal(18,4),
	col_18 decimal(18,4)
	)


	declare @StateANSICode nvarchar(100)
	declare @StateCode nvarchar(100)
	declare @StateName nvarchar(100)
	declare @OrganizationId int
	declare @OrganizationNcesId nvarchar(100)
	declare @OrganizationStateId nvarchar(100)
	declare @OrganizationName nvarchar(500)
	declare @ParentOrganizationStateId int

	declare @col_1 decimal(18,4)
	declare @col_2 decimal(18,4)
	declare @col_3 decimal(18,4)
	declare @col_4 decimal(18,4)
	declare @col_5 decimal(18,4)
	declare @col_6 decimal(18,4)
	declare @col_7 decimal(18,4)
	declare @col_8 decimal(18,4)
	declare @col_9 decimal(18,4)
	declare @col_10 decimal(18,4)
	declare @col_10a decimal(18,4)
	declare @col_10b decimal(18,4)
	declare @col_11 decimal(18,4)
	declare @col_11a decimal(18,4)
	declare @col_11b decimal(18,4)
	declare @col_11c decimal(18,4)
	declare @col_11d decimal(18,4)
	declare @col_11e decimal(18,4)
	declare @col_12 decimal(18,4)
	declare @col_12a decimal(18,4)
	declare @col_12b decimal(18,4)
	declare @col_13 decimal(18,4)
	declare @col_14 decimal(18,4)
	declare @col_14a decimal(18,4)
	declare @col_14b decimal(18,4)
	declare @col_14c decimal(18,4)
	declare @col_14d decimal(18,4)
	declare @col_15 decimal(18,4)
	declare @col_16 decimal(18,4)
	declare @col_17 decimal(18,4)
	declare @col_18 decimal(18,4)


	declare @submissionYearCntr as int
	set @submissionYearCntr = 0


	-- Loop through all submission years
	---------------------------------------------

	declare @submissionYears as table(
		SubmissionYear varchar(50)
	)

	if @reportCode = 'cohortgraduationrate'
	begin
	insert into @submissionYears
		(
			SubmissionYear
		)
		select distinct cs.SubmissionYear from app.CategorySets cs
			inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
			inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1 and dd.DataMigrationTypeId=@dataMigrationTypeId
			Where GenerateReportId in (select GenerateReportId from app.GenerateReports where ReportCode <> 'cohortgraduationrate' and IsLocked=1) 
	end
	else
	begin
		insert into @submissionYears
		(
			SubmissionYear
		)
	select distinct cs.SubmissionYear from app.CategorySets cs
			inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
			inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1 and dd.DataMigrationTypeId=@dataMigrationTypeId
			Where GenerateReportId in (select GenerateReportId from app.GenerateReports where ReportCode <> 'cohortgraduationrate' and IsLocked=1) 
	end

	declare @reportYear as varchar(50)
	
	DECLARE submissionYear_cursor CURSOR FOR 
	SELECT SubmissionYear
	FROM @submissionYears
	order by SubmissionYear desc

	OPEN submissionYear_cursor
	FETCH NEXT FROM submissionYear_cursor INTO @reportYear

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Loop through Category Sets for this Submission Year
		---------------------------------------------
		declare @categorySetId as int
		declare @reportLevel as varchar(5)
		declare @categorySetCode as varchar(50)

		declare @categorySetCnt as int
		
		select @categorySetCnt = count(*) from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
		where r.ReportCode = @reportCode and cs.SubmissionYear = @reportYear

		declare @categorySetCntr as int
		set @categorySetCntr = 0


		DECLARE categoryset_cursor CURSOR FOR 
		SELECT cs.CategorySetId, o.LevelCode, cs.CategorySetCode
		from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
		where r.ReportCode = @reportCode and cs.SubmissionYear = @reportYear

		OPEN categoryset_cursor
		FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			set @categorySetCntr = @categorySetCntr + 1

			delete from @results1
			delete from @results2


		
			-- Log status

			print ''
			print '----------------------------------'
			print @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode
			print '----------------------------------'

			if @runAsTest = 0
			begin
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Report - ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode)
			end


			if @runAsTest = 1 or not exists (select 1 from rds.FactCustomCounts where ReportCode = @reportCode and ReportLevel = @reportLevel and ReportYear = @reportYear and CategorySetCode = @categorySetCode)
			begin
				
								
				if @reportCode = 'indicator4a' or @reportCode = 'indicator4b'
				begin

					declare @organizations as table (
					StateANSICode nvarchar(100),
					StateCode nvarchar(100),
					StateName nvarchar(100),
					OrganizationId int,
					OrganizationNcesId nvarchar(100),
					OrganizationStateId nvarchar(100),
					OrganizationName nvarchar(500),
					ParentOrganizationStateId nvarchar(100)
					)
				delete from @organizations
				
				insert into @organizations
					(
					StateANSICode,
					StateCode,
					StateName,
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId
					)
					select distinct 
					s.StateANSICode,
					s.StateCode,
					s.StateName,
					s.LeaOrganizationId,
					s.LeaNcesIdentifier,
					s.LeaStateIdentifier,
					s.LeaName,
					s.SeaStateIdentifier
					from rds.FactStudentCounts f
					inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
					inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
					inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
					inner join rds.DimLeas l on l.DimLeaID = f.DimLeaId
					where ft.FactTypeCode = 'submission'
					and d.SubmissionYear = @reportYear
					and f.DimSchoolId <> -1
					-- CIID-1963
					and CASE 
							WHEN @reportLevel = 'lea' THEN 
								CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
							WHEN @reportLevel = 'sch' THEN 
								CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
							ELSE 1
					END = 1

					declare @studentCounts as table (
					DimStudentId int,
					LeaOrganizationId int,
					LeaStateIdentifier varchar(100),
					LeaName varchar(500),
					DisabilityEdFactsCode varchar(50),
					StudentCount int
					)

					delete from @studentCounts

					insert into @studentCounts
					(
					DimStudentId,
					LeaOrganizationId,
					LeaStateIdentifier,
					LeaName,
					DisabilityEdFactsCode,
					StudentCount
					)
					select 
					f.DimStudentId,
					s.LeaOrganizationId,
					s.LeaStateIdentifier,
					s.LeaName,
					i.DisabilityEdFactsCode,
					f.StudentCount
					from rds.FactStudentCounts f
					inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
					inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
					inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
					inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
					inner join rds.DimAges a on f.DimAgeId = a.DimAgeId
					inner join rds.DimLeas l on l.DimLeaID = f.DimLeaId
					where ft.FactTypeCode = 'submission'
					and d.SubmissionYear = @reportYear
					and a.AgeValue >= 3 and a.AgeValue <= 21
					and f.DimSchoolId <> -1
					-- CIID-1963
					and CASE 
							WHEN @reportLevel = 'lea' THEN 
								CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
							WHEN @reportLevel = 'sch' THEN 
								CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
							ELSE 1
					END = 1


					declare @studentDisciplines as table (
					DimStudentId int,
					LeaOrganizationId int,
					LeaStateIdentifier varchar(100),
					LeaName varchar(500),
					DisabilityEdFactsCode varchar(50),
					DisciplineDuration decimal(18,4),
					StudentCount int
					)

					delete from @studentDisciplines

					insert into @studentDisciplines
					(
					DimStudentId,
					LeaOrganizationId,
					LeaStateIdentifier,
					LeaName,
					DisabilityEdFactsCode,
					DisciplineDuration
					)
					select 
					f.DimStudentId,
					s.LeaOrganizationId,
					s.LeaStateIdentifier,
					s.LeaName,
					i.DisabilityEdFactsCode,
					sum(f.DisciplineDuration) as DisciplineDuration
					from rds.FactStudentDisciplines f
					inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
					inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
					inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
					inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
					inner join rds.DimAges a on f.DimAgeId = a.DimAgeId
					where ft.FactTypeCode = 'submission'
					and d.SubmissionYear = @reportYear
					and a.AgeValue >= 3 and a.AgeValue <= 21
					and f.DimSchoolId <> -1
					--CIID-1963
					and ISNULL(s.ReportedFederally, 1) = 1
					group by f.DimStudentId,
					s.LeaOrganizationId,
					s.LeaStateIdentifier,
					s.LeaName,
					i.DisabilityEdFactsCode

					update @studentDisciplines set StudentCount = case when DisciplineDuration > 0 then 1 else 0 end

	
					declare @stateWithDisabilities as int
					declare @stateWithoutDisabilities as int
					declare @stateWithDisabilitiesGreater10 as int
					declare @stateWithoutDisabilitiesGreater10 as int
					declare @numberLeasWithDisabilitiesGreater10 as int

					select @stateWithDisabilities = sum(StudentCount) from @studentCounts where DisabilityEdFactsCode <> 'MISSING'
					select @stateWithoutDisabilities = sum(StudentCount) from @studentCounts where DisabilityEdFactsCode = 'MISSING'
					select @stateWithDisabilitiesGreater10 = sum(StudentCount) from @studentDisciplines where DisabilityEdFactsCode <> 'MISSING' and DisciplineDuration > 10.0
					select @stateWithoutDisabilitiesGreater10 = sum(StudentCount) from @studentDisciplines where DisabilityEdFactsCode = 'MISSING' and DisciplineDuration > 10.0

					select @numberLeasWithDisabilitiesGreater10 = count(distinct LeaOrganizationId) from @studentDisciplines where DisabilityEdFactsCode <> 'MISSING' and DisciplineDuration > 10.0 

				end

				if @reportCode = 'indicator4a'
				begin

		
					DECLARE r1_cursor CURSOR FOR 

					select 
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.OrganizationId,
						s.OrganizationNcesId,
						s.OrganizationStateId,
						s.OrganizationName,
						s.ParentOrganizationStateId,
						null as col_1,
						isnull((select sum(StudentCount) from @studentCounts where DisabilityEdFactsCode <> 'MISSING' and LeaOrganizationId = s.OrganizationId), 0) as col_2,
						isnull((select sum(StudentCount) from @studentCounts where DisabilityEdFactsCode = 'MISSING' and LeaOrganizationId = s.OrganizationId), 0) as col_3,
						isnull((select sum(StudentCount) from @studentDisciplines where DisabilityEdFactsCode <> 'MISSING' and LeaOrganizationId = s.OrganizationId and DisciplineDuration > 10.0), 0) as col_4,
						isnull((select sum(StudentCount) from @studentDisciplines where DisabilityEdFactsCode = 'MISSING' and LeaOrganizationId = s.OrganizationId and DisciplineDuration > 10.0), 0) as col_5,
						null as col_6,
						null as col_7,
						case when @stateWithDisabilities > 0 then convert(decimal(18,4),@stateWithDisabilitiesGreater10) / convert(decimal(18,4),@stateWithDisabilities) else null end as col_8,
						case when @stateWithoutDisabilities > 0 then convert(decimal(18,4),@stateWithoutDisabilitiesGreater10) / convert(decimal(18,4),@stateWithoutDisabilities) else null end as col_9,
 						null as col_10a,
						null as col_10b,
						null as col_11a,
						null as col_11b,
						null as col_11c,
						null as col_11d,
						null as col_11e,
						null as col_12,
						null as col_13,
						null as col_14,
						null as col_15
					from @organizations s

					OPEN r1_cursor
					FETCH NEXT FROM r1_cursor INTO @StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10a, @col_10b, @col_11a, @col_11b, @col_11c, @col_11d, @col_11e, @col_12, @col_13, @col_14, @col_15

					WHILE @@FETCH_STATUS = 0
					BEGIN

						set @col_6 = case when @col_2 > 0 then convert(decimal(18,4),@col_4) / convert(decimal(18,4),@col_2) else null end
						set @col_7 = case when @col_3 > 0 then convert(decimal(18,4),@col_5) / convert(decimal(18,4),@col_3) else null end

		
						insert into @results1
						(
							StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							col_1,
							col_2,
							col_3,
							col_4,
							col_5,
							col_6,
							col_7,
							col_8,
							col_9,
							col_10a,
							col_10b,
							col_11a,
							col_11b,
							col_11c,
							col_11d,
							col_11e,
							col_12,
							col_13,
							col_14,
							col_15
						)
						values
						(	
							@StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId,  
							@col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10a, @col_10b, @col_11a, @col_11b, @col_11c, @col_11d, @col_11e, @col_12, @col_13, @col_14, @col_15
						)


						FETCH NEXT FROM r1_cursor INTO @StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10a, @col_10b, @col_11a, @col_11b, @col_11c, @col_11d, @col_11e, @col_12, @col_13, @col_14, @col_15
					END

					CLOSE r1_cursor
					DEALLOCATE r1_cursor


					declare @sum11b as decimal(18,4)
					set @sum11b = 0


					DECLARE r2_cursor CURSOR FOR 

					select 
							StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							col_1,
							col_2,
							col_3,
							col_4,
							col_5,
							col_6,
							col_7,
							col_8,
							col_9,
							col_10a,
							col_10b,
							col_11a,
							col_11b,
							col_11c,
							col_11d,
							col_11e,
							col_12,
							col_13,
							col_14,
							col_15
					from @results1

					OPEN r2_cursor
					FETCH NEXT FROM r2_cursor INTO @StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10a, @col_10b, @col_11a, @col_11b, @col_11c, @col_11d, @col_11e, @col_12, @col_13, @col_14, @col_15

					WHILE @@FETCH_STATUS = 0
					BEGIN
	
						select @col_10a = count(*) from @results1 where col_6 < @col_6
						set @col_10b = case when @numberLeasWithDisabilitiesGreater10 > 0 then convert(decimal(18,4), @col_10a) / convert(decimal(18,4), @numberLeasWithDisabilitiesGreater10) else null end
	
						set @col_11a = @col_6 - @col_9
						set @col_11b = power(convert(decimal(18,4), @col_11a), 2)
						set @col_12 = case when @col_8 > 0 then convert(decimal(18,4), @col_6) / convert(decimal(18,4), @col_8) else null end
						set @col_13 = case when @col_9 > 0 then convert(decimal(18,4), @col_6) / convert(decimal(18,4), @col_9) else null end
						set @col_14 = case when @col_7 > 0 then convert(decimal(18,4), @col_6) / convert(decimal(18,4), @col_7) else null end
						set @col_15 = @col_6 - @col_7

						set @sum11b = @sum11b + isnull(@col_11b, 0)

						insert into @results2
						(
							ReportCode,
							ReportYear,
							ReportLevel,
							CategorySetCode,
							StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							col_1,
							col_2,
							col_3,
							col_4,
							col_5,
							col_6,
							col_7,
							col_8,
							col_9,
							col_10a,
							col_10b,
							col_11a,
							col_11b,
							col_11c,
							col_11d,
							col_11e,
							col_12,
							col_13,
							col_14,
							col_15
						)
						values
						(
							@reportCode, @reportYear, @reportLevel, @categorySetCode,
							@StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, 
							@col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10a, @col_10b, @col_11a, @col_11b, @col_11c, @col_11d, @col_11e, @col_12, @col_13, @col_14, @col_15
						)


						FETCH NEXT FROM r2_cursor INTO @StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10a, @col_10b, @col_11a, @col_11b, @col_11c, @col_11d, @col_11e, @col_12, @col_13, @col_14, @col_15
					END

					CLOSE r2_cursor
					DEALLOCATE r2_cursor

					update @results2 set col_11c = @sum11b,
					col_11d = case when @numberLeasWithDisabilitiesGreater10 - 1 > 0 then SQRT( convert(decimal(18,4), @sum11b) / convert(decimal(18,4), (@numberLeasWithDisabilitiesGreater10 - 1))) else null end

					update @results2 set col_11e = case when col_11d > 0 then convert(decimal(18,4), col_11a) / convert(decimal(18,4), col_11d) else null end

	
				end
				else if @reportCode = 'indicator4b'
				begin

					declare @studentCountsWithRace as table
					(
						DimStudentId int,
						LeaOrganizationId int,
						LeaStateIdentifier varchar(100),
						LeaName varchar(500),
						DisabilityEdFactsCode varchar(50),
						RaceCode varchar(50),
						StudentCount int
					)

					delete from @studentCountsWithRace

					insert into @studentCountsWithRace
					(
						DimStudentId,
						LeaOrganizationId,
						LeaStateIdentifier,
						LeaName,
						DisabilityEdFactsCode,
						RaceCode,
						StudentCount
					)
					select 
						s.DimStudentId,
						s.LeaOrganizationId,
						s.LeaStateIdentifier,
						s.LeaName,
						s.DisabilityEdFactsCode,
						r.RaceCode,
						s.StudentCount
					from @studentCounts s
					inner join rds.BridgeStudentRaces b on s.DimStudentId = b.DimStudentId
					inner join rds.DimRaces r on b.DimRaceId = r.DimRaceId
					inner join rds.DimFactTypes ft on r.DimFactTypeId = ft.DimFactTypeId
					where ft.FactTypeCode = 'submission'

					declare @studentDisciplinesWithRace as table
					(
						DimStudentId int,
						LeaOrganizationId int,
						LeaStateIdentifier varchar(100),
						LeaName varchar(500),
						DisabilityEdFactsCode varchar(50),
						RaceCode varchar(50),
						DisciplineDuration decimal(18,4),
						StudentCount int
					)

					delete from @studentDisciplinesWithRace

					insert into @studentDisciplinesWithRace
					(
						DimStudentId,
						LeaOrganizationId,
						LeaStateIdentifier,
						LeaName,
						DisabilityEdFactsCode,
						RaceCode,
						DisciplineDuration,
						StudentCount
					)
					select 
						s.DimStudentId,
						s.LeaOrganizationId,
						s.LeaStateIdentifier,
						s.LeaName,
						s.DisabilityEdFactsCode,
						r.RaceCode,
						s.DisciplineDuration,
						s.StudentCount
					from @studentDisciplines s
					inner join rds.BridgeStudentRaces b on s.DimStudentId = b.DimStudentId
					inner join rds.DimRaces r on b.DimRaceId = r.DimRaceId
					inner join rds.DimFactTypes ft on r.DimFactTypeId = ft.DimFactTypeId
					where ft.FactTypeCode = 'submission'



					declare @sum10 as decimal(18,4)
					set @sum10 = 0

		
					DECLARE r1_cursor CURSOR FOR 

					select 
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.OrganizationId,
						s.OrganizationNcesId,
						s.OrganizationStateId,
						s.OrganizationName,
						s.ParentOrganizationStateId,
						null as col_1,
						isnull((select sum(StudentCount) from @studentCounts where DisabilityEdFactsCode <> 'MISSING' and LeaOrganizationId = s.OrganizationId), 0) as col_2,
						isnull((select sum(StudentCount) from @studentCountsWithRace where DisabilityEdFactsCode = 'MISSING' and RaceCode = @categorySetCode and LeaOrganizationId = s.OrganizationId), 0) as col_3,
						isnull((select sum(StudentCount) from @studentCounts where DisabilityEdFactsCode = 'MISSING' and LeaOrganizationId = s.OrganizationId), 0) as col_4,
						isnull((select sum(StudentCount) from @studentDisciplines where DisabilityEdFactsCode <> 'MISSING' and LeaOrganizationId = s.OrganizationId and DisciplineDuration > 10.0), 0) as col_5,
						isnull((select sum(StudentCount) from @studentDisciplinesWithRace where DisabilityEdFactsCode <> 'MISSING' and RaceCode = @categorySetCode and LeaOrganizationId = s.OrganizationId and DisciplineDuration > 10.0), 0) as col_6,
						isnull((select sum(StudentCount) from @studentDisciplines where DisabilityEdFactsCode = 'MISSING' and LeaOrganizationId = s.OrganizationId and DisciplineDuration > 10.0), 0) as col_7,
						null as col_8,
						case when @stateWithDisabilities > 0 then convert(decimal(18,4),@stateWithDisabilitiesGreater10) / convert(decimal(18,4),@stateWithDisabilities) else null end as col_9,
						null as col_10,
						null as col_11,
						null as col_12a,
						null as col_12b,
						null as col_13,
						null as col_14a,
						null as col_14b,
						null as col_14c,
						null as col_14d,
						null as col_15,
						null as col_16,
						null as col_17,
						null as col_18
					from @organizations s

					OPEN r1_cursor
					FETCH NEXT FROM r1_cursor INTO @StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10, @col_11, @col_12a, @col_12b, @col_13, @col_14a, @col_14b, @col_14c, @col_14d, @col_15, @col_16, @col_17, @col_18

					WHILE @@FETCH_STATUS = 0
					BEGIN

						set @col_8 = case when @col_4 > 0 then convert(decimal(18,4),@col_7) / convert(decimal(18,4),@col_4) else null end
						set @col_10 = case when @col_3 > 0 then convert(decimal(18,4),@col_6) / convert(decimal(18,4),@col_3) else null end

						set @sum10 = @sum10 + isnull(@col_10, 0)
		
						insert into @results1
						(
							StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							col_1,
							col_2,
							col_3,
							col_4,
							col_5,
							col_6,
							col_7,
							col_8,
							col_9,
							col_10,
							col_11,
							col_12a,
							col_12b,
							col_13,
							col_14a,
							col_14b,
							col_14c,
							col_14d,
							col_15,
							col_16,
							col_17,
							col_18
						)
						values
						(
							@StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId,
							@col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10, @col_11, @col_12a, @col_12b, @col_13, @col_14a, @col_14b, @col_14c, @col_14d, @col_15, @col_16, @col_17, @col_18
						)


						FETCH NEXT FROM r1_cursor INTO @StateANSICode, @StateCode, @StateName,  @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10, @col_11, @col_12a, @col_12b, @col_13, @col_14a, @col_14b, @col_14c, @col_14d, @col_15, @col_16, @col_17, @col_18
					END

					CLOSE r1_cursor
					DEALLOCATE r1_cursor

	
					declare @sum14a as decimal(18,4)
					set @sum14a = 0


					DECLARE r2_cursor CURSOR FOR 

					select 
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						col_1,
						col_2,
						col_3,
						col_4,
						col_5,
						col_6,
						col_7,
						col_8,
						col_9,
						col_10,
						col_11,
						col_12a,
						col_12b,
						col_13,
						col_14a,
						col_14b,
						col_14c,
						col_14d,
						col_15,
						col_16,
						col_17,
						col_18
					from @results1

					OPEN r2_cursor
					FETCH NEXT FROM r2_cursor INTO @StateANSICode, @StateCode, @StateName,  @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId,@col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10, @col_11, @col_12a, @col_12b, @col_13, @col_14a, @col_14b, @col_14c, @col_14d, @col_15, @col_16, @col_17, @col_18

					WHILE @@FETCH_STATUS = 0
					BEGIN


						set @col_11 = case when @numberLeasWithDisabilitiesGreater10 > 0 then convert(decimal(18,4), @sum10) / convert(decimal(18,4), @numberLeasWithDisabilitiesGreater10) else null end
						select @col_12a = count(*) from @results1 where col_10 < col_10
						set @col_12b = case when @numberLeasWithDisabilitiesGreater10 > 0 then convert(decimal(18,4), @col_12a) / convert(decimal(18,4), @numberLeasWithDisabilitiesGreater10) else null end

						set @col_13 = @col_10 - @col_11
						set @col_14a = power(convert(decimal(18,4), @col_13), 2)
						set @col_15 = case when @col_9 > 0 then convert(decimal(18,4), @col_10) / convert(decimal(18,4), @col_9) else null end
						set @col_16 = case when @col_11 > 0 then convert(decimal(18,4), @col_10) / convert(decimal(18,4), @col_11) else null end
						set @col_17 = case when @col_8 > 0 then convert(decimal(18,4), @col_10) / convert(decimal(18,4), @col_8) else null end
						set @col_18 = @col_10 - @col_8

						set @sum14a = @sum14a + isnull(@col_14a, 0)

						insert into @results2
						(
							ReportCode,
							ReportYear,
							ReportLevel,
							CategorySetCode,
							StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							col_1,
							col_2,
							col_3,
							col_4,
							col_5,
							col_6,
							col_7,
							col_8,
							col_9,
							col_10,
							col_11,
							col_12a,
							col_12b,
							col_13,
							col_14a,
							col_14b,
							col_14c,
							col_14d,
							col_15,
							col_16,
							col_17,
							col_18
						)
						values
						(
							@reportCode, @reportYear, @reportLevel, @categorySetCode,
							@StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId,
							@col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10, @col_11, @col_12a, @col_12b, @col_13, @col_14a, @col_14b, @col_14c, @col_14d, @col_15, @col_16, @col_17, @col_18
						)


						FETCH NEXT FROM r2_cursor INTO @StateANSICode, @StateCode, @StateName, @OrganizationId, @OrganizationNcesId, @OrganizationStateId, @OrganizationName, @ParentOrganizationStateId, @col_1, @col_2, @col_3, @col_4, @col_5, @col_6, @col_7, @col_8, @col_9, @col_10, @col_11, @col_12a, @col_12b, @col_13, @col_14a, @col_14b, @col_14c, @col_14d, @col_15, @col_16, @col_17, @col_18
					END

					CLOSE r2_cursor
					DEALLOCATE r2_cursor

	
					update @results2 set col_14b = @sum14a,
					col_14c = case when @numberLeasWithDisabilitiesGreater10 - 1 > 0 then SQRT( convert(decimal(18,4), @sum14a) / convert(decimal(18,4), (@numberLeasWithDisabilitiesGreater10 - 1))) else null end

					update @results2 set col_14d = case when col_14c > 0 then convert(decimal(18,4), col_13) / convert(decimal(18,4), col_14c) else null end


				end
				else if @reportCode = 'cohortgraduationrate'
				begin
					declare @cohortStudentCounts as table (
						StateANSICode nvarchar(100),
						StateCode nvarchar(100),
						StateName nvarchar(100),
						OrganizationId int,
						OrganizationNcesId nvarchar(100),
						OrganizationStateId nvarchar(100),
						OrganizationName nvarchar(500),
						ParentOrganizationStateId nvarchar(100),
						CategoryCode nvarchar(100),
						CohortYear varchar(50),
						CohortTotal decimal(18,2),
						FourYrCohortCount decimal(18,2),
						FiveYrCohortCount decimal(18,2),
						SixYrCohortCount decimal(18,2)
						)

					delete from @cohortStudentCounts


					if @categorySetCode = 'gender'
					begin

						insert into @cohortStudentCounts
						(
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						CategoryCode,
						CohortYear,
						CohortTotal,
						FourYrCohortCount,
						FiveYrCohortCount,
						SixYrCohortCount
						)
						SELECT DISTINCT 			
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,
						SexDescription,
						CohortYear,
						SUM([4]) + SUM([5]) + SUM([6]),
						SUM([4]), 
						SUM([5]), 
						SUM([6])
						FROM (select 
						f.DimStudentId,
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						demo.SexDescription,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
						inner join rds.DimDemographics demo on demo.Dimdemographicid = f.Dimdemographicid
						inner join rds.DimLeas l on l.DimLeaId = f.DimLeaId
						where ft.FactTypeCode = 'submission' and demo.SexEdFactsCode <> 'MISSING'
						-- CIID-1963
						
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear) AS SourceTable
						PIVOT
						(	
							COUNT(StudentCount)
							FOR CohortLength IN ([4],[5],[6])
						) AS PivotTable
						group by StateANSICode,
						StateCode,
						StateName,
						SeaOrganizationId,
						SeaName,
						SeaStateIdentifier,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						CohortYear, SexDescription
				
					end
					else if @categorySetCode = 'disabilitystatus'
					begin

					insert into @cohortStudentCounts
						(
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						CategoryCode,
						CohortYear,
						CohortTotal,
						FourYrCohortCount,
						FiveYrCohortCount,
						SixYrCohortCount
						)
						SELECT DISTINCT 			
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,
						CategoryCode,
						CohortYear,
						SUM([4]) + SUM([5]) + SUM([6]),
						SUM([4]), 
						SUM([5]), 
						SUM([6])
						FROM (select f.DimStudentId,s.StateANSICode,s.StateCode,s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						CASE WHEN i.DisabilityEdFactsCode <> 'MISSING' THEN 'Students With Disabilities (Rate)'
							 WHEN i.DisabilityEdFactsCode = 'MISSING' THEN 'Students Without Disabilities (Rate)' END as CategoryCode,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
						inner join rds.DimLeas l on l.DimLeaID = f.DimLeaId
						where ft.FactTypeCode = 'submission' 
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear
						-- CIID-1963
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						UNION
						select distinct f.DimStudentId,s.StateANSICode,s.StateCode,s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						'All Students (Rate)' as CategoryCode,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimLeas l on l.DimLeaId = f.DimLeaId
						where ft.FactTypeCode = 'submission' 
						-- CIID-1963
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear) AS SourceTable
						PIVOT
						(	
							COUNT(StudentCount)
							FOR CohortLength IN ([4],[5],[6])
						) AS PivotTable
						group by StateANSICode,
						StateCode,
						StateName,
						SeaOrganizationId,
						SeaName,
						SeaStateIdentifier,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier, CohortYear, CategoryCode
						
					end
					else if @categorySetCode = 'disabilitytype'
					begin

						insert into @cohortStudentCounts
						(
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						CategoryCode,
						CohortYear,
						CohortTotal,
						FourYrCohortCount,
						FiveYrCohortCount,
						SixYrCohortCount
						)
						SELECT DISTINCT 			
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,
						DisabilityEdFactsCode as CategoryCode,
						CohortYear,
						SUM([4]) + SUM([5]) + SUM([6]),
						SUM([4]), 
						SUM([5]), 
						SUM([6])
						FROM (select 
						f.DimStudentId,
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						i.DisabilityDescription as DisabilityEdFactsCode,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
						inner join rds.DimLeas l on l.DimLeaId = f.DimLeaId
						where ft.FactTypeCode = 'submission' and i.DisabilityEdFactsCode <> 'MISSING'
						-- CIID-1963
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear) AS SourceTable
						PIVOT
						(	
							COUNT(StudentCount)
							FOR CohortLength IN ([4],[5],[6])
						) AS PivotTable
						group by StateANSICode,
						StateCode,
						StateName,
						SeaOrganizationId,
						SeaName,
						SeaStateIdentifier,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,DisabilityEdFactsCode, CohortYear
						END
					else if @categorySetCode = 'raceethnicity'
					begin

					insert into @cohortStudentCounts
						(
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						CategoryCode,
						CohortYear,
						CohortTotal,
						FourYrCohortCount,
						FiveYrCohortCount,
						SixYrCohortCount
						)
						SELECT DISTINCT 			
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,
						RaceCode,
						CohortYear,
						SUM([4]) + SUM([5]) + SUM([6]),
						SUM([4]), 
						SUM([5]), 
						SUM([6])
						FROM (select 
						f.DimStudentId,
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						r.RaceDescription as RaceCode,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
						inner join rds.BridgeStudentRaces b on students.DimStudentId = b.DimStudentId
						inner join rds.DimRaces r on b.DimRaceId = r.DimRaceId and ft.DimFactTypeId = r.DimFactTypeId
						inner join rds.DimLeas l on l.DimLeaId = f.DimLeaId
						where ft.FactTypeCode = 'submission'
						-- CIID-1963
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear) AS SourceTable
						PIVOT
						(	
							COUNT(StudentCount)
							FOR CohortLength IN ([4],[5],[6])
						) AS PivotTable
						group by StateANSICode,
						StateCode,
						StateName,
						SeaOrganizationId,
						SeaName,
						SeaStateIdentifier,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier, CohortYear, RaceCode
						
					end
					else if @categorySetCode = 'cteparticipation'
					begin

					insert into @cohortStudentCounts
						(
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						CategoryCode,
						CohortYear,
						CohortTotal,
						FourYrCohortCount,
						FiveYrCohortCount,
						SixYrCohortCount
						)
						SELECT DISTINCT 			
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,
						CteProgramEdFactsCode,
						CohortYear,
						SUM([4]) + SUM([5]) + SUM([6]),
						SUM([4]), 
						SUM([5]), 
						SUM([6])
						FROM (select 
						f.DimStudentId,
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						prog.CteProgramDescription as CteProgramEdFactsCode,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
						inner join rds.DimProgramStatuses prog on prog.DimProgramStatusId = f.DimProgramStatusId
						inner join rds.DimLeas l on l.DimLeaId = f.DimLeaId
						where ft.FactTypeCode = 'submission' and prog.CteProgramEdFactsCode <> 'MISSING'
						-- CIID-1963
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear) AS SourceTable
						PIVOT
						(	
							COUNT(StudentCount)
							FOR CohortLength IN ([4],[5],[6])
						) AS PivotTable
						group by StateANSICode,
						StateCode,
						StateName,
						SeaOrganizationId,
						SeaName,
						SeaStateIdentifier,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier, CohortYear, CteProgramEdFactsCode
						
					end
					else if @categorySetCode = 'exitingspeceducation'
					begin

					insert into @cohortStudentCounts
						(
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						CategoryCode,
						CohortYear,
						CohortTotal,
						FourYrCohortCount,
						FiveYrCohortCount,
						SixYrCohortCount
						)
						SELECT DISTINCT 			
						StateANSICode,
						StateCode,
						StateName,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier,
						CategoryCode,
						CohortYear,
						SUM([4]) + SUM([5]) + SUM([6]),
						SUM([4]), 
						SUM([5]), 
						SUM([6])
						FROM (select 
						f.DimStudentId,
						s.StateANSICode,
						s.StateCode,
						s.StateName,
						s.SeaOrganizationId,
						s.SeaName,
						s.SeaStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaOrganizationId
							 when @reportLevel = 'sch' then SchoolOrganizationId
							 else s.SeaOrganizationId end as OrganizationId,
						case when @reportLevel = 'lea' then s.LeaNcesIdentifier
							 when @reportLevel = 'sch' then SchoolNcesIdentifier
							 else s.SeaStateIdentifier end as OrganizationNcesIdentifier,
						case when @reportLevel = 'lea' then s.LeaStateIdentifier
							 when @reportLevel = 'sch' then SchoolStateIdentifier
							 else s.SeaStateIdentifier end as OrganizationStateIdentifier,
						case when @reportLevel = 'lea' then s.LeaName
							 when @reportLevel = 'sch' then SchoolName
							 else s.SeaName end as OrganizationName,
						'Exited Special Education and Returned to Regular Education' as CategoryCode,
						Convert(int,SUBSTRING(Cohort,6,4)) as CohortYear,
						(Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength,
						f.StudentCount
						from rds.FactStudentCounts f
						inner join rds.DimFactTypes ft on f.DimFactTypeId = ft.DimFactTypeId
						inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
						inner join rds.DimStudents students on students.DimStudentId = f.DimStudentId
						inner join rds.DimIdeaStatuses i on f.DimIdeaStatusId = i.DimIdeaStatusId
						inner join rds.DimLeas l on l.DimLeaId = f.DimLeaId
						where ft.FactTypeCode = 'submission' and i.BasisOfExitEdFactsCode <> 'MISSING'
						-- CIID-1963
						and CASE 
								WHEN @reportLevel = 'lea' THEN 
									CASE WHEN ISNULL(l.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END 
								WHEN @reportLevel = 'sch' THEN 
									CASE WHEN ISNULL(s.ReportedFederally, 1) = 1 THEN 1 ELSE 0 END   
								ELSE 1
						END = 1
						and f.DimSchoolId <> -1 and students.Cohort is not null and SUBSTRING(Cohort,6,4) = @reportYear) AS SourceTable
						PIVOT
						(	
							COUNT(StudentCount)
							FOR CohortLength IN ([4],[5],[6])
						) AS PivotTable
						group by StateANSICode,
						StateCode,
						StateName,
						SeaOrganizationId,
						SeaName,
						SeaStateIdentifier,
						OrganizationId,
						OrganizationNcesIdentifier,
						OrganizationStateIdentifier,
						OrganizationName,
						SeaStateIdentifier, CohortYear, CategoryCode
						
					end

					insert into @results2
						(
							ReportCode,
							ReportYear,
							ReportLevel,
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
							col_1,
							col_2,
							col_3,
							col_4,
							col_5,
							col_6,
							col_7,
							col_8,
							col_9,
							col_10,
							col_11,
							col_12a,
							col_12b,
							col_13,
							col_14a,
							col_14b,
							col_14c,
							col_14d,
							col_15,
							col_16,
							col_17,
							col_18
						)
						SELECT	
						@reportCode, CohortYear, @reportLevel, @categorySetCode,
						StateANSICode, StateCode, StateName, OrganizationId, OrganizationNcesId, OrganizationStateId, OrganizationName, ParentOrganizationStateId,CategoryCode,
						null as col_1, CohortTotal, 
						FourYrCohortCount, FiveYrCohortCount, SixYrCohortCount,
						CASE WHEN CohortTotal > 0 THEN FourYrCohortCount / CohortTotal ELSE 0 END,
						CASE WHEN CohortTotal > 0 THEN (FourYrCohortCount + FiveYrCohortCount) / CohortTotal ELSE 0 END,
						CASE WHEN CohortTotal > 0 THEN (FourYrCohortCount + FiveYrCohortCount + SixYrCohortCount) / CohortTotal ELSE 0 END,
						null as col_9,
						null as col_10,
						null as col_11,
						null as col_12a,
						null as col_12b,
						null as col_13,
						null as col_14a,
						null as col_14b,
						null as col_14c,
						null as col_14d,
						null as col_15,
						null as col_16,
						null as col_17,
						null as col_18
						FROM @cohortStudentCounts


				end

			end


			if @runAsTest = 0
			begin

				insert into rds.FactCustomCounts
				(
					ReportCode,
					ReportYear,
					ReportLevel,
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
					col_1,
					col_2,
					col_3,
					col_4,
					col_5,
					col_6,
					col_7,
					col_8,
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
					col_18
				)
				select
					ReportCode,
					ReportYear,
					ReportLevel,
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
					col_1,
					col_2,
					col_3,
					col_4,
					col_5,
					col_6,
					col_7,
					col_8,
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
					col_18
				from @results2


			end
			else
			begin
				select
					ReportCode,
					ReportYear,
					ReportLevel,
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
					col_1,
					col_2,
					col_3,
					col_4,
					col_5,
					col_6,
					col_7,
					col_8,
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
					col_18
				from @results2

			end



			FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode
		END

		CLOSE categoryset_cursor
		DEALLOCATE categoryset_cursor


		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
	END

	CLOSE submissionYear_cursor
	DEALLOCATE submissionYear_cursor


	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1)
		begin
			 update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode
		end

	set nocount off;

end