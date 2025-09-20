CREATE FUNCTION [RDS].[Get_CountSQL] (
	@reportCode as nvarchar(150),
	@reportLevel as nvarchar(10),
	@reportYear as nvarchar(10),
	@categorySetCode as nvarchar(150),	
	@sqlType as nvarchar(50),
	@includeOrganizations as bit,
	@isFileGenerator as bit,
	@tableTypeAbbrvs as nvarchar(150) = '',
	@totalIndicators as nvarchar(1) = '',
	@factTypeCode as varchar(50)
)
RETURNS nvarchar(MAX)
AS
BEGIN

--For debugging

--declare
--	@reportCode as nvarchar(150) = '002',
--	@reportLevel as nvarchar(10) = 'SCH',
--	@reportYear as nvarchar(10) = '2024',
--	@categorySetCode as nvarchar(150)  = 'TOT',	
--	@sqlType as nvarchar(50) = 'zero',
--	@includeOrganizations as bit  = 1,
--	@isFileGenerator as bit = 1,
--	@tableTypeAbbrvs as nvarchar(150) = 'IDEADISAB',
--	@totalIndicators as nvarchar(1) = 'YES',
--	@factTypeCode as varchar(50) = 'childcount'
	
	declare @sql as nvarchar(max)
	set @sql = ''

	declare @cohortYear varchar(50), @cohortYearTotal varchar(10), @dimFactTypeId as int, @year int, @calculatedMemberDate varchar(10), @calculatedSYStartDate varchar(10), @calculatedSYEndDate varchar(10)

	-- Get GenerateReportTypeCode
	declare @generateReportTypeCode as varchar(50)
	select @generateReportTypeCode = t.ReportTypeCode
	from app.GenerateReports r
	inner join app.GenerateReportTypes t 
		on r.GenerateReportTypeId = t.GenerateReportTypeId
	where r.ReportCode = @reportCode

	-- @dimFactTypeId
	select @dimFactTypeId = DimFactTypeId 
	from rds.DimFactTypes 
	where FactTypeCode = @factTypeCode
	
	-- Get DimSchoolYearId
	declare @dimSchoolYearId as int
	select @dimSchoolYearId = DimSchoolYearId, @year = SchoolYear 
	from rds.DimSchoolYears 
	where SchoolYear = @reportYear

	
	set @calculatedSYStartDate = '07/01/' + CAST(@year - 1 as varchar(4))
	set @calculatedSYEndDate = '06/30/' + CAST(@year as varchar(4))

	-- Get TableTypeAbbrv and TotalIndicator
	declare @tableTypeAbbrv as nvarchar(150)
	declare @totalIndicator as nvarchar(1)

	if (@reportCode in ('204', '150', '151','033','116', '175', '178', '179', '185', '188', '189'))
	begin
		set @tableTypeAbbrv=@tableTypeAbbrvs
		set @totalIndicator=@totalIndicators
	end
	else
	begin
		select 
			@tableTypeAbbrv = isnull(tt.TableTypeAbbrv, ''),
			@totalIndicator = 
			CASE 
				WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
				ELSE 'N'
			END
		from app.CategorySets cs
		inner join app.GenerateReports r 
			on cs.GenerateReportId = r.GenerateReportId
		inner join app.OrganizationLevels o 
			on cs.OrganizationLevelId = o.OrganizationLevelId
		left outer join app.TableTypes tt 
			on cs.TableTypeId = tt.TableTypeId
		where r.ReportCode = @reportCode
		and cs.CategorySetCode = @categorySetCode
		and cs.SubmissionYear = @reportYear 
		and o.LevelCode = @reportLevel 
	end

	declare @toggleGrade13 as bit
 	declare @toggleUngraded as bit
	declare @toggleAdultEd as bit
	declare @istoggleGradOther as bit
	declare @toggleEnglishLearnerProf as bit
	declare @toggleEnglishLearnerTitleIII as bit
	declare @toggleDisplacedHomemakers as bit
	declare @toggleCteDiploma as varchar(100)
	declare @toggleCtePerkDisab as varchar(50)
	declare @toggleMaxAge as varchar(50)
	declare @istoggleMinAge as bit
	declare @toggleMinAgeGrad as varchar(50)
	declare @toggleBasisOfExit as bit
	declare @istoggleAlternateDiploma as bit
	declare @toggleCatchmentSea as varchar(75)
	declare @toggleCatchmentLea as varchar(75)
	declare @toggleChildCountDate as varchar(10)
	declare @istoggleExcludeCorrectionalAge5to11 as bit
	declare @istoggleExcludeCorrectionalAge12to17 as bit
	declare @istoggleExcludeCorrectionalAge18to21 as bit
	declare @istoggleExcludeCorrectionalAgeAll as bit
	declare @istoggleRaceMap as bit
	declare @toggleFreeLunch as varchar(30)

	-- Get Custom Child Count Date (if available)
	select @toggleChildCountDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	IF LEN(ISNULL(@toggleChildCountDate,'')) <= 0
		set @toggleChildCountDate = '11/01/' + CAST(@year - 1 as varchar(4))
	ELSE 
		set @toggleChildCountDate = CAST(MONTH(@toggleChildCountDate) AS VARCHAR(2)) + '/' + CAST(DAY(@toggleChildCountDate) AS VARCHAR(2)) + '/' + CAST(@Year - 1 AS CHAR(4))

	select @calculatedMemberDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'MEMBERDTE'

	IF LEN(ISNULL(@calculatedMemberDate,'')) <= 0
		set @calculatedMemberDate = '10/01/' + CAST(@year - 1 as varchar(4))
	ELSE 
		set @calculatedMemberDate = CAST(MONTH(@calculatedMemberDate) AS VARCHAR(2)) + '/' + CAST(DAY(@calculatedMemberDate) AS VARCHAR(2)) + '/' + CAST(@Year - 1 AS CHAR(4))

	select @toggleUngraded = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CCDUNGRADED'

	select @toggleGrade13 = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CCDGRADE13'

	select @toggleAdultEd = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ADULTEDU'

	select @toggleEnglishLearnerProf = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ASSESSENGLEARNPROF'

	select @toggleEnglishLearnerTitleIII = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ASSESSENGLEARNPROFTTLEIII'

	select @toggleDisplacedHomemakers = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CTEDISPLCDHMMKRATSECDLVL'

	select @toggleCtePerkDisab = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CTEPERKDISAB'

	select @toggleMaxAge = replace(ResponseValue, ' Years', '')
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXMAXAGE' and ISNULL(ResponseValue,'None') not in ('None')
	
	select @istoggleMinAge = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXMINAGEIF'

	if(@istoggleMinAge = 1)
	begin
		select @toggleMinAgeGrad = replace(ResponseValue, ' Years', '')
		from app.ToggleResponses r
		inner join app.ToggleQuestions q 
			on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'DEFEXMINAGENUM'
	end

	select @toggleBasisOfExit = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXCERT'

	select @istoggleAlternateDiploma = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXDLPDIS'

	select @toggleCatchmentSea = r.ResponseValue
	from app.ToggleQuestions q
	left outer join app.ToggleResponses r
		on r.ToggleQuestionId = q.ToggleQuestionId
	WHERE q.EmapsQuestionAbbrv = 'DEFEXMOVCONSEA'

	select @toggleCatchmentLea = r.ResponseValue
	from app.ToggleQuestions q
	left outer join app.ToggleResponses r
		on r.ToggleQuestionId = q.ToggleQuestionId
	WHERE q.EmapsQuestionAbbrv = 'DEFEXMOVCONLEA'

	select @toggleFreeLunch = r.ResponseValue
	from app.ToggleQuestions q
	left outer join app.ToggleResponses r
		on r.ToggleQuestionId = q.ToggleQuestionId
	WHERE q.EmapsQuestionAbbrv = 'LUNCHCOUNTS'

	-- Get Toggle Values
	---------------------------------------------
	-- Developmental Delay Ages
	declare @toggleDevDelayAges as varchar(1000)
	declare @toggleDevDelay3to5 as varchar(1000)
	declare @toggleDevDelay6to9 as varchar(1000)

	select @toggleDevDelayAges = COALESCE(@toggleDevDelayAges + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
	on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
	
	IF @toggleDevDelayAges LIKE '%5%'
	BEGIN
		SET @toggleDevDelayAges = @toggleDevDelayAges + ', ''AGE05K'', ''AGE05NOTK'''
	END

	select @toggleDevDelay3to5 = COALESCE(@toggleDevDelay3to5 + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
	and ResponseValue in ('3 Years', '4 Years', '5 Years')
	select @toggleDevDelay3to5 = @toggleDevDelay3to5 + ', ''AGE05NOTK'''

	
	IF @reportYear IN ('2017-18', '2018-19', '2019-20')
	BEGIN
		select @toggleDevDelay6to9 = COALESCE(@toggleDevDelay6to9 + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
		from app.ToggleResponses r
		inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId 
		where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
		and ResponseValue in ('6 Years', '7 Years', '8 Years', '9 Years')
	END
	ELSE
	BEGIN
	    select @toggleDevDelay6to9 = COALESCE(@toggleDevDelay6to9 + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
	    from app.ToggleResponses r
	    inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
	    where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
	    and ResponseValue in ('5 Years', '6 Years', '7 Years', '8 Years', '9 Years')
		select @toggleDevDelay6to9 = @toggleDevDelay6to9 + ', ''AGE05K'''
	END
	
	select @istoggleGradOther = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'GRADRPT'
	
	select @toggleCteDiploma = COALESCE(@toggleCteDiploma + ', ''', '''') + 
		case 
			when ResponseValue = 'Regular secondary school diploma' THEN 'REGDIP'
			When ResponseValue ='Other state-recognized equivalent' THEN 'OTHCOM' 
			When ResponseValue ='General Education Development (GED) credential' THEN 'HSDGED'
			else 'HSDPROF'
		end + ''''
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'CTEDIPLOMA'
	
	
	select @istoggleExcludeCorrectionalAge5to11 = ISNULL( case when (CHARINDEX('12-17', ResponseValue) > 0 AND CHARINDEX('18-21', ResponseValue) > 0) then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ENVSACORFAC'
	
	select @istoggleExcludeCorrectionalAge12to17 = ISNULL( case when (CHARINDEX('6-11', ResponseValue) > 0 AND CHARINDEX('18-21', ResponseValue) > 0) then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ENVSACORFAC'
	
	select @istoggleExcludeCorrectionalAge18to21 = ISNULL( case when (CHARINDEX('6-11', ResponseValue) > 0 AND CHARINDEX('12-17', ResponseValue) > 0) then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ENVSACORFAC'
	
	select @istoggleExcludeCorrectionalAgeAll = ISNULL( case when ResponseValue = 'Does not permit' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ENVSACORFAC'
	
	select @istoggleRaceMap = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ASSESSRACEMAP'
	
	-- Determine Fact/Report Tables
	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	
	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
	from app.FactTables ft 
	inner join app.GenerateReports r 
		on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode
	
	-- TODO - make this metadata-driven
	declare @personField as nvarchar(50)
	set @personField = 'K12StudentId'

	if @factTable = 'FactK12StaffCounts'
	begin
		set @personField = 'K12StaffCountId'
	end
	
	declare @idFieldsSQL as nvarchar(max)
	set @idFieldsSQL = ''
	
	if @reportLevel = 'sea'
	begin
		set @idFieldsSQL = '
		s.StateANSICode as OrganizationIdentifierNces,
		s.SeaOrganizationIdentifierSea as OrganizationIdentifierSea,
		s.SeaOrganizationName as OrganizationName,
		null as ParentOrganizationIdentifierSea'
	end
	else if @reportLevel = 'lea'
	begin
		set @idFieldsSQL = '
		isnull(s.LeaIdentifierNces, '') as OrganizationIdentifierNces,
		s.LeaIdentifierSea as OrganizationIdentifierSea,
		s.LeaOrganizationName as OrganizationName,
		s.StateANSICode as ParentOrganizationIdentifierSea'
	end
	else if @reportLevel = 'sch'
	begin
		set @idFieldsSQL = '
		isnull(s.SchoolIdentifierNces, '') as OrganizationIdentifierNces,
		s.SchoolIdentifierSea as OrganizationIdentifierSea,
		s.NameOfInstitution as OrganizationName,
		s.LeaIdentifierSea as ParentOrganizationIdentifierSea'
	end

	-- not Actual sql types
	if @sqlType = 'zero' or @sqlType = 'zero-performance' or @sqlType = 'zero-discipline' or @sqlType = 'zero-educenv' or @sqlType = 'zero-programs' 
	begin
		if(@includeOrganizations = 1)
		begin
			set @sql  = '
			declare @dimSchoolYearId as int
			set @dimSchoolYearId = ' + convert(varchar(20), @dimSchoolYearId) + ' 
			declare @dimFactTypeId as int
			set @dimFactTypeId = ' + convert(varchar(20), @dimFactTypeId) + '

			if OBJECT_ID(''tempdb..#cat_Organizations'') is not null drop table #cat_Organizations
			if OBJECT_ID(''tempdb..#categoryset'') is not null drop table #categoryset

			----------------------------
			-- Category Options
			----------------------------
			-- Organizations
			---------------------------
			create table #CAT_Organizations (
				[StateANSICode] [nvarchar](100) NULL,
				[StateAbbreviationCode] [nvarchar](100) NULL,
				[StateAbbreviationDescription] [nvarchar](500) NULL,
				[OrganizationIdentifierNces] [nvarchar](100) NULL,
				[OrganizationIdentifierSea] [nvarchar](100) NULL,
				[OrganizationName] [nvarchar](1000) NULL,
				[ParentOrganizationIdentifierSea] [nvarchar](100) NULL
			)
			CREATE INDEX IDX_CAT_Organizations ON #CAT_Organizations (OrganizationIdentifierSea)

			truncate table #CAT_Organizations

			-- temp Category organizations table
			insert into #CAT_Organizations
			select distinct 
				s.StateANSICode,
				s.StateAbbreviationCode,
				s.StateAbbreviationDescription, ' +
			@idFieldsSQL + '
			from ' 
			+ case when @reportLevel = 'lea' then 'rds.DimLeas s'
					else 'rds.DimK12Schools s' end  +  
			' inner join (
			select ' +  
			case when @reportLevel = 'lea' 
					then 'LEAIdentifierSea as stateIdentifier, max(OperationalStatusEffectiveDate) as OperationalStatusEffectiveDate'  
					else 'SchoolIdentifierSea as stateIdentifier, max(SchoolOperationalStatusEffectiveDate) as OperationalStatusEffectiveDate' end  +  
			' from rds.FactOrganizationCounts f inner join ' + case when @reportLevel = 'lea' then 'rds.DimLeas l'  else 'rds.DimK12Schools l' end  +  
			' on ' +  case when @reportLevel = 'lea' then 'f.LeaId = l.DimLeaId '  else 'f.K12SchoolId = l.DimK12SchoolId ' end  +

			--exclude 'NSLP No' Schools from the c033 School level	
			case when @reportCode = '033' and @reportLevel = 'sch' 
				then ' inner join rds.DimK12SchoolStatuses rdkss on f.K12SchoolStatusId = rdkss.DimK12SchoolStatusId ' 
				else ''
			end +

			' where f.SchoolYearId = ' + CAST(@dimSchoolYearId as varchar(10)) +

			--exclude Reportable Programs from c033/c052 School level	
			case when @reportCode in ('033','052') and @reportLevel = 'sch' 
				then 'and l.SchoolTypeCode <> ''Reportable'' '
				else ''
			end +

			--exclude 'NSLP No' Schools from the c033 School level	
			case when @reportCode in ('033') and @reportLevel = 'sch' 
				then ' and rdkss.NslpStatusEdFactsCode <> ''NSLPNO'' ' 
				else ''
			end +

			' group by ' +  case when @reportLevel = 'lea' then 'LEAIdentifierSea'  else 'SchoolIdentifierSea' end + 
			') status on status.OperationalStatusEffectiveDate = ' +  case when @reportLevel = 'lea' then 's.OperationalStatusEffectiveDate'  else 's.SchoolOperationalStatusEffectiveDate' end 
			+ '	AND status.stateIdentifier = s.' +  case when @reportLevel = 'lea' then 'LEAIdentifierSea'  else 'SchoolIdentifierSea' end
			+ ' where s.ReportedFederally = 1 and ' + case when @reportLevel = 'lea' then 's.DimLeaId <> -1 
			and s.LEAOperationalStatus not in (''Closed'', ''FutureAgency'', ''Inactive'', ''MISSING'')'
			else 's.DimK12SchoolId <> -1 
			and s.SchoolOperationalStatus	not in (''Closed'', ''FutureSchool'', ''Inactive'', ''MISSING'')
			' end  

			IF(@reportCode in ('052'))
			begin
				set @sql  = @sql + case when @reportLevel = 'lea' then ' AND CONVERT(date,s.OperationalStatusEffectiveDate,101)'
										else ' AND CONVERT(date,s.SchoolOperationalStatusEffectiveDate,101)' 
									end  
									+  ' between CONVERT(date, ''' + @calculatedSYStartDate + ''',101) AND CONVERT(date, ''' + @calculatedMemberDate + ''',101)'
			end
			else if(@reportCode in ('002','089'))
			begin
				set @sql  = @sql + case when @reportLevel = 'lea' then ' AND CONVERT(date,s.OperationalStatusEffectiveDate,101)'
										else ' AND CONVERT(date,s.SchoolOperationalStatusEffectiveDate,101)' 
									end  
									+  ' between CONVERT(date, ''' + @calculatedSYStartDate + ''',101) AND CONVERT(date, ''' + @toggleChildCountDate + ''',101)'
			end
			else
			begin
				set @sql  = @sql + case when @reportLevel = 'lea' then ' AND CONVERT(date,s.OperationalStatusEffectiveDate,101)'
										else ' AND CONVERT(date,s.SchoolOperationalStatusEffectiveDate,101)' 
									end  
									+  ' between CONVERT(date, ''' + @calculatedSYStartDate + ''',101) AND CONVERT(date, ''' + @calculatedSYEndDate + ''',101)'
			end
			
			--remove the schools that do not have student counts in 052
			if @reportCode in ('033')
			begin
				select @sql = @sql + char(10) + char(10)

				if @ReportLevel = 'sch'
				begin
					select @sql = @sql + 
						'if OBJECT_ID(''tempdb..#Membership'') is not null drop table #Membership' + char(10)
							
					select @sql = @sql + 
						'
						select distinct OrganizationIdentifierSea
						into #Membership
						from rds.ReportEDFactsK12StudentCounts c52 
						where c52.ReportCode = ''052''
						and c52.reportLevel = ''sch'' 
						and c52.reportyear = ''' + @reportYear + '''
						and c52.CategorySetCode = ''TOT'' 
						and c52.studentCount > 0
						' + char(10)

					select @sql = @sql + 
						'CREATE INDEX IDX_Membership ON #Membership (OrganizationIdentifierSea)' + char(10) + char(10) + char(10)

					set @sql = @sql + '  delete a 
						from #CAT_Organizations a
						left join #membership m
							on a.OrganizationIdentifierSea = m.OrganizationIdentifierSea
						where m.OrganizationIdentifierSea is NULL'
				end
			end
		end
		else
		begin
			set @sql = ''
		end
	end

	-- Actual sql type
	if @sqlType = 'actual'
	begin
		
		set @sql  = @sql + '
			----------------------------
			-- Category Options
			----------------------------
		'
		-- JW 10/20/2023 ----------------------------------------------------------------------------
		select @sql = @sql + char(10) + 							
		'			IF OBJECT_ID(''tempdb..#categoryset'') IS NOT NULL DROP TABLE #categoryset' + char(10) + char(10)
		---------------------------------------------------------------------------------------------

		--pull the list of students to use in these reports into the #Students temp table 
		if (@factReportTable <> 'ReportEDFactsK12StaffCounts')
		begin
			-- JW 6/28/2023 Fixed Membership performance issues by using #temp table rather than "In subselect"
			-- JW 6/30/2023 Fixed GRADE join performance by using #temp table rather than "In subselect"
			if @reportCode in ('052')
			begin
				select @sql = @sql + char(10) + char(10)

				if @ReportLevel in ('LEA', 'SCH')
				begin
					select @sql = @sql + 
					'if OBJECT_ID(''tempdb..#Grades'') is not null drop table #Grades' + char(10)
					select @sql = @sql + 
					'SELECT distinct OrganizationStateId, GRADELEVEL 
					into #Grades
					From rds.ReportEDFactsOrganizationCounts c39 where c39.ReportCode = ''039''
					and c39.reportLevel = ''' + @reportLevel + ''' and c39.reportyear = ''' + @reportYear + '''' + char(10)

					select @sql = @sql + 
					'CREATE INDEX IDX_Grades ON #Grades (OrganizationStateId, Gradelevel)' + char(10)
				end

				select @sql = @sql + 
				'if OBJECT_ID(''tempdb..#Students'') is not null drop table #Students' + char(10)

				select @sql = @sql +
				'select	distinct fact.K12StudentId, people.K12StudentStudentIdentifierState'

				--this condition was added to ensure the Reportable Program schools are removed for 052 in the 
				--	later code by joining on the School as well as Student Id.  If a student has more than 
				--	1 enrollment in the SY and one of them is a Reportable Program, it was being included 
				--	because the join was only on Student Id 
				if @reportLevel = 'SCH'
				begin
					select @sql = @sql + ', fact.K12SchoolId'
				end 

				select @sql = @sql +
				char(10) + 'into #Students
				from rds.' + @factTable + ' fact
				inner join rds.DimPeople people
					on fact.K12StudentId = people.DimPersonId' + char(10)
					
				if @reportLevel = 'SEA'
				begin

					declare @MembershipgradeList as varchar(2000)
							
					set @MembershipgradeList = '''PK'',''KG'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'''

					IF(@toggleGrade13 = 1)
					BEGIN
						set @MembershipgradeList = @MembershipgradeList + ',''13'''
					END

					IF(@toggleUngraded = 1)
					BEGIN
						set @MembershipgradeList = @MembershipgradeList + ',''UG'''
					END

					IF(@toggleAdultEd = 1)
					BEGIN
						set @MembershipgradeList = @MembershipgradeList + ',''AE'''
					END

					select @sql = @sql + '
					inner join rds.DimGradeLevels gl 
						on fact.GradeLevelId = gl.DimGradeLevelId
						and gl.GradeLevelEdFactsCode in (' + @Membershipgradelist + ')' + char(10)
				end

				if @reportLevel = 'LEA'
				begin
					select @sql = @sql +
					'inner join rds.DimLeas s 
						on fact.LeaId = s.DimLeaId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and fact.LeaId <> -1
						inner join rds.DimGradeLevels gl 
							on fact.GradeLevelId = gl.DimGradeLevelId
						inner join #Grades grades on grades.GRADELEVEL = gl.GradeLevelEdFactsCode
										and grades.OrganizationStateId = s.LeaIdentifierSea'  + char(10)
				end

				if @reportLevel = 'SCH'
				begin
					select @sql = @sql +
					'inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and s.SchoolTypeCode <> ''Reportable''
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and fact.K12SchoolId <> -1
					inner join rds.DimGradeLevels gl 
						on fact.GradeLevelId = gl.DimGradeLevelId
					inner join #Grades grades 
						on grades.GRADELEVEL = gl.GradeLevelEdFactsCode
						and grades.OrganizationStateId = s.SchoolIdentifierSea' + char(10) 
				end

				select @sql = @sql + '
				where fact.SchoolYearId = ' + convert(varchar, @dimSchoolYearid) + 
				' and fact.FactTypeId = ' + convert(varchar, @dimFactTypeId)


				select @sql = @sql + char(10) + 
				'CREATE INDEX IDX_Students ON #Students (K12StudentId, K12StudentStudentIdentifierState)' + char(10) + char(10)

			end

			if @reportCode in ('009')
			begin

				if @toggleCatchmentSea = 'Entire state (students moving out of state)'
				begin

					select @sql = @sql + char(10) +
						'			if OBJECT_ID(''tempdb..#excludeStudents'') is not null drop table #excludeStudents' + char(10)

					select @sql = @sql + 
					'
					select distinct StudentIdentifierState
					into #excludeStudents
					from staging.ProgramParticipationSpecialEducation
					where IDEAIndicator = 1
					and isnull(ProgramParticipationEndDate, ''' + @calculatedSYEndDate + ''') >= ''' + @calculatedSYEndDate + '''
					order by StudentIdentifierState
					' + char(10)

					select @sql = @sql + 
						'			CREATE INDEX IDX_excludeStudents ON #excludeStudents (StudentIdentifierState)' + char(10)

				end

			end	

			if @reportCode in ('040')
			begin
				select @sql = @sql + char(10) + char(10)

				if @ReportLevel in ('LEA', 'SCH')
				begin
					select @sql = @sql + 
						'if OBJECT_ID(''tempdb..#Grades'') is not null drop table #Grades' + char(10)

					select @sql = @sql + 
						'if OBJECT_ID(''tempdb..#Membership'') is not null drop table #Membership' + char(10)
							
					select @sql = @sql + 
						'
						SELECT distinct OrganizationStateId 
						into #Grades
						From rds.ReportEDFactsOrganizationCounts c39 where c39.ReportCode = ''039''
						and c39.reportLevel = ''' + @reportLevel + ''' and c39.reportyear = ''' + @reportYear + '''
						and c39.gradelevel = ''12''' + char(10)

					select @sql = @sql + 
						'
						SELECT distinct OrganizationIdentifierSea
						into #Membership
						From rds.ReportEDFactsK12StudentCounts c52 where c52.ReportCode = ''052''
						and c52.reportLevel = ''' + @reportLevel + ''' and c52.reportyear = ''' + @reportYear + '''
						and c52.CategorySetCode = ''TOT'' and c52.studentCount > 0
						' + char(10)

					select @sql = @sql + 
						'CREATE INDEX IDX_Grades ON #Grades (OrganizationStateId)' + char(10)

					select @sql = @sql + 
						'CREATE INDEX IDX_Membership ON #Membership (OrganizationIdentifierSea)' + char(10)
				end
			end

			if @reportCode in ('033')
			begin
				select @sql = @sql + char(10) + char(10)

				if @ReportLevel = 'sch'
				begin
					select @sql = @sql + 
						'if OBJECT_ID(''tempdb..#Membership'') is not null drop table #Membership' + char(10)
							
					select @sql = @sql + 
						'
						select distinct OrganizationIdentifierSea
						into #Membership
						From rds.ReportEDFactsK12StudentCounts c52 where c52.ReportCode = ''052''
						and c52.reportLevel = ''sch'' and c52.reportyear = ''' + @reportYear + '''
						and c52.CategorySetCode = ''TOT'' and c52.studentCount > 0
						' + char(10)

					select @sql = @sql + 
						'CREATE INDEX IDX_Membership ON #Membership (OrganizationIdentifierSea)' + char(10)
				end
			end

			if @ReportCode in ('002', '089')
			begin -- C002/C089
				-- JW 11/10/2023 Fixed C002 Performance by using #temp table rather than join to subselect
				select @sql = @sql + char(10) + char(9) + char(9) + char(9)
				select @sql = @sql + 'IF OBJECT_ID(''tempdb..#RULES'') IS NOT NULL DROP TABLE #RULES' + char(10) 
	
				select @sql = @sql + '
	
				select distinct fact.K12StudentId, rdidt.DimIdeaDisabilityTypeId, rdp.K12StudentStudentIdentifierState' 
				+ CASE WHEN (@year > 2019 AND @reportCode = '002') THEN ' ,rdgl.DimGradeLevelId' ELSE '' END + char(10) +
				'into #RULES
				from rds.' + @factTable + ' fact '
	
				if @reportLevel = 'lea'
				begin
					set @sql = @sql + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sql = @sql + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end
	
				set @sql = @sql + '
				inner join rds.DimAges rda 
					on fact.AgeId = rda.DimAgeId
					and rda.AgeValue >= ' + CAST(IIF(@year > 2019 AND @reportCode = '002',5,6) as varchar(10)) + ' and rda.AgeValue <= 21
				inner join rds.DimK12Schools rds
					on fact.K12SchoolId = rds.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
				inner join rds.DimPeople rdp
					on fact.K12StudentId = rdp.DimPersonId
				inner join rds.DimIdeaStatuses rdis 
					on fact.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimIdeaDisabilityTypes rdidt 
					on fact.PrimaryDisabilityTypeId = rdidt.DimIdeaDisabilityTypeId'
				+ CASE WHEN (@year > 2019 AND @reportCode = '002') THEN  '
				inner join rds.DimGradeLevels rdgl
					on fact.GradeLevelId = rdgl.DimGradeLevelId
					and (CASE WHEN rda.AgeValue = 5 and rdgl.GradeLevelEdFactsCode in (''MISSING'',''PK'')
						THEN ''''
						ELSE rdgl.GradeLevelEdFactsCode
						END) = rdgl.GradeLevelEdFactsCode' 
					ELSE '' END + '
				where rdis.IdeaIndicatorEdFactsCode = ''IDEA'''
	
				-- JW 10/20/2023 Fixed 002 SCH Performance by using a #temp table rather than "In subselect"
				if not @toggleDevDelayAges is null
				begin
					select @sql = @sql + char(10) + char(10)
					select @sql = @sql + 
	
								'IF OBJECT_ID(''tempdb..#EXCLUDE'') IS NOT NULL DROP TABLE #EXCLUDE
	
								select distinct fact.K12StudentId
								into #EXCLUDE
								from rds.FactK12StudentCounts fact
								inner join rds.DimAges age 
									on fact.AgeId = age.DimAgeId
									and not age.AgeCode in (' + @toggleDevDelayAges + ') 
								inner join rds.DimK12Schools s 
									on fact.K12SchoolId = s.DimK12SchoolId
									and fact.SchoolYearId = @dimSchoolYearId
									and fact.FactTypeId = @dimFactTypeId
									and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
								inner join rds.DimIdeaDisabilityTypes idea 
									on fact.PrimaryDisabilityTypeId = idea.DimIdeaDisabilityTypeId
								where idea.IdeaDisabilityTypeEdFactsCode = ''DD''
								'
	
					 + char(10) + char(10)
	
				end
			end -- 002/089

			-- JW 7/20/2023 Fixed FS141 performance issues by using #temp table rather than "In subselect"
			if @reportCode in ('141')
			begin
				select @sql = @sql + char(10) + char(10)

				select @sql = @sql + 
				'if OBJECT_ID(''tempdb..#Students'') is not null drop table #Students' + char(10)

				select @sql = @sql +
					'select distinct 
						fact.K12StudentId,  
						m.DimEnglishLearnerStatusId, 
						g.DimGradelevelId, 
						people.K12StudentStudentIdentifierState
					into #Students
					from rds.' + @factTable + ' fact
					inner join rds.DimPeople people
						on fact.K12StudentId = people.DimPersonId' + char(10)
					select @sql = @sql +
						'inner join rds.DimEnglishLearnerStatuses m 
							on fact.EnglishLearnerStatusId = m.DimEnglishLearnerStatusId
						inner join rds.DimGradeLevels g 
							on fact.GradelevelId = g.DimGradelevelId' + char(10)

				if @reportLevel = 'LEA'
					begin
						select @sql = @sql +
						'inner join rds.DimLeas s 
							on fact.LeaId = s.DimLeaId
							and fact.SchoolYearId = @dimSchoolYearId
							and fact.FactTypeId = @dimFactTypeId
							and fact.LeaId <> -1' + char(10)
					end

				if @reportLevel = 'SCH'
					begin
						select @sql = @sql +
						'inner join rds.DimK12Schools s 
							on fact.K12SchoolId = s.DimK12SchoolId
							and fact.SchoolYearId = @dimSchoolYearId
							and fact.FactTypeId = @dimFactTypeId
							and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' + char(10) 
					end

				select @sql = @sql + '
				where fact.SchoolYearId = ' + convert(varchar, @dimSchoolYearid) + 
				' and fact.FactTypeId = ' + convert(varchar, @dimFactTypeId) +
				' and m.EnglishLearnerStatusCode = ''Yes'' -- JW 7/19/2023
					and g.GradeLevelEdFactsCode in (''KG'',''01'', ''02'', ''03'', ''04'', ''05'', ''06'', ''07'', ''08'', ''09'', ''10'', ''11'', ''12'', ''13'', ''UG'', ''MISSING'')' + char(10)

				select @sql = @sql + char(10) + 
				'CREATE INDEX IDX_Students ON #Students (K12StudentId, K12StudentStudentIdentifierState)' + char(10) + char(10)

			end

			-- JW 7/20/2022 Fixed Discipline performance issues by using #temp table for #Students rather than "In subselect"
			if @reportCode in ('088','143')
			begin
				select @sql = @sql + char(10)
				select @sql = @sql + 

				'select rdp.K12StudentStudentIdentifierState'

				if @reportLevel = 'lea'
				begin
					select @sql = @sql + 
					', LeaId '
				end 

				select @sql = @sql + 
				' into #Students
				from RDS.FactK12StudentDisciplines rfksd '

				if @reportLevel = 'lea'
				begin
					select @sql = @sql + 
					'inner join rds.DimLeas dl
						on dl.DimLeaId = rfksd.LeaId' + char(10)
				end 
				select @sql = @sql + 
				'inner join rds.DimPeople rdp 
					on rfksd.K12StudentId = rdp.DimPersonId
					and rfksd.SchoolYearId = @dimSchoolYearId
					and rfksd.FactTypeId = @dimFactTypeId
				inner join rds.DimIdeaStatuses rdis 
					on rfksd.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimDisciplineStatuses rdd 
					on rfksd.DisciplineStatusId = rdd.DimDisciplineStatusId
				where rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
					and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
					and (rdd.DisciplineMethodOfChildrenWithDisabilitiesCode <> ''MISSING''
						or rdd.DisciplinaryActionTakenCode IN (''03086'', ''03087'')
						or rdd.IdeaInterimRemovalReasonCode <> ''MISSING''
						or rdd.IdeaInterimRemovalCode <> ''MISSING'')
				group by rdp.K12StudentStudentIdentifierState '

				if @reportLevel = 'lea'
				begin
					select @sql = @sql + 
					', LeaId' + char(10)
				end 

				select @sql = @sql + 
				'having sum(rfksd.DurationOfDisciplinaryAction) >= 0.5' + char(10)

				select @sql = @sql + char(10) + 
				'CREATE INDEX IDX_Students ON #Students (K12StudentStudentIdentifierState)' + char(10) + char(10)

				-- JW CIID-6435 -----------------------------------------------------------------------------------------
				-- Fixed C088/C143 Performance by using #temp table for #RULES rather than join to subselect
				select @sql = @sql + char(10) + char(9) + char(9) + char(9)
				select @sql = @sql + 'IF OBJECT_ID(''tempdb..#RULES'') IS NOT NULL DROP TABLE #RULES' + char(10) 

				select @sql = @sql + '
				select distinct rdp.K12StudentStudentIdentifierState, rdis.DimIdeaStatusId, rdds.DimDisciplineStatusId
				into #RULES
				from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sql = @sql + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sql = @sql + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sql = @sql + '
					inner join rds.DimPeople rdp
						on fact.K12StudentId = rdp.DimPersonId
					inner join #Students Students
						on Students.K12StudentStudentIdentifierState = rdp.K12StudentStudentIdentifierState '

				if @reportLevel = 'lea'
				begin
					select @sql = @sql + '
						and Students.LeaId = fact.LeaId'                             
				end

				set @sql = @sql + '
					inner join rds.DimAges age 
						on fact.AgeId = age.DimAgeId
						and age.AgeValue >= 3 
						and age.AgeValue <= 21
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and CASE 
							WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
							WHEN fact.LeaId > 0 THEN fact.LeaId
							WHEN fact.SeaId > 0 THEN fact.SeaId
							ELSE -1
						END <> -1
					inner join rds.DimIdeaStatuses rdis
						on fact.IdeaStatusId = rdis.DimIdeaStatusId
					inner join rds.DimDisciplineStatuses rdds
						on fact.DisciplineStatusId = rdds.DimDisciplineStatusId
					where rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
						and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
						and (rdds.DisciplineMethodOfChildrenWithDisabilitiesCode <> ''MISSING''
							or rdds.DisciplinaryActionTakenCode IN (''03086'', ''03087'')
							or rdds.IdeaInterimRemovalReasonCode <> ''MISSING''
							or rdds.IdeaInterimRemovalCode <> ''MISSING'')

				'
				 + char(10) + char(10)

				select @sql = @sql + 'CREATE INDEX IDX_Rules ON #Rules (K12StudentStudentIdentifierState, DimIdeaStatusId, DimDisciplineStatusId)' + char(10) + char(10)

				-- END CIID-6435 -----------------------------------------------

			end
			else if @reportCode in ('007')
			begin
				select @sql = @sql + char(10)
				select @sql = @sql + 

				'				select rdp.K12StudentStudentIdentifierState
				into #Students
				from RDS.FactK12StudentDisciplines rfksd 
				inner join rds.DimPeople rdp 
					on rfksd.K12StudentId = rdp.DimPersonId
					and rfksd.SchoolYearId = @dimSchoolYearId
					and rfksd.FactTypeId = @dimFactTypeId
				inner join rds.DimIdeaStatuses rdis 
					on rfksd.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimDisciplineStatuses rdds 
					on rfksd.DisciplineStatusId = rdds.DimDisciplineStatusId
				where rdds.IdeaInterimRemovalCode = ''REMDW''
					and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
				group by rdp.K12StudentStudentIdentifierState
					, rdds.IdeaInterimRemovalCode
					, rdds.IdeaInterimRemovalReasonCode' + char(10)

				select @sql = @sql + char(10) + 
				'CREATE INDEX IDX_Students ON #Students (K12StudentStudentIdentifierState)' + char(10) + char(10)
			end
			else if @reportCode = '005'
			begin
				select @sql = @sql + char(10)
				select @sql = @sql + 

				'select rdp.K12StudentStudentIdentifierState
				into #Students
				from RDS.FactK12StudentDisciplines rfksd 
				inner join rds.DimPeople rdp 
					on rfksd.K12StudentId = rdp.DimPersonId
					and rfksd.SchoolYearId = @dimSchoolYearId
					and rfksd.FactTypeId = @dimFactTypeId
				inner join rds.DimIdeaStatuses rdis 
					on rfksd.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimDisciplineStatuses rdds 
					on rfksd.DisciplineStatusId = rdds.DimDisciplineStatusId
				where rdds.IdeaInterimRemovalEdFactsCode in (''REMDW'', ''REMHO'')
					and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
				group by rdp.K12StudentStudentIdentifierState' + char(10)

				select @sql = @sql + char(10) + 
				'CREATE INDEX IDX_Students ON #Students (K12StudentStudentIdentifierState)' + char(10) + char(10)

			end
		end
	end

	-- SQL variables
	declare @sqlZeroCountConditions as nvarchar(max)
	set @sqlZeroCountConditions = ''
	declare @sqlCategoryOptions as nvarchar(max)
	set @sqlCategoryOptions = ''
	declare @sqlCategoryOptionJoins as nvarchar(max)
	set @sqlCategoryOptionJoins = ''
	declare @sqlCategoryFields as nvarchar(max)
	set @sqlCategoryFields = ''
	declare @sqlCategoryQualifiedFields as nvarchar(max)
	set @sqlCategoryQualifiedFields = ''
	declare @sqlCategoryFieldDefs as nvarchar(max)
	set @sqlCategoryFieldDefs = ''
	declare @sqlCategoryQualifiedDimensionFields as nvarchar(max)
	set @sqlCategoryQualifiedDimensionFields = ''
	declare @sqlCategoryReturnField as nvarchar(max)
	set @sqlCategoryReturnField = ''
	declare @sqlRemoveMissing as nvarchar(max)
	set @sqlRemoveMissing = ''
	declare @sqlCategoryQualifiedDimensionGroupFields as nvarchar(max)
	set @sqlCategoryQualifiedDimensionGroupFields = ''
	declare @sqlHavingClause as nvarchar(max)
	set @sqlHavingClause = ''
	declare @sqlCountJoins as nvarchar(max)
	set @sqlCountJoins = ''
	declare @sqlCountTotalJoins as nvarchar(max)
	set @sqlCountTotalJoins = ''
	declare @sqlCategoryQualifiedSubDimensionFields as nvarchar(max)
	set @sqlCategoryQualifiedSubDimensionFields = ''
	declare @sqlCategoryQualifiedSubGroupDimensionFields as nvarchar(max)
	set @sqlCategoryQualifiedSubGroupDimensionFields = ''
	declare @sqlCategoryQualifiedSubSelectDimensionFields as nvarchar(max)
	set @sqlCategoryQualifiedSubSelectDimensionFields = ''
	declare @sqlPerformanceLevelJoins as nvarchar(max)
	set @sqlPerformanceLevelJoins = ''

	if(@includeOrganizations = 1)
	begin
		if(@isFileGenerator = 1)
		begin
			declare @dimension nvarchar(100)
			DECLARE reportField_cursor CURSOR FOR 
			
			select distinct upper(d.DimensionFieldName)
			from app.CategorySets cs
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels o 
				on cs.OrganizationLevelId = o.OrganizationLevelId
			inner join app.CategorySet_Categories csc 
				on cs.CategorySetId = csc.CategorySetId
			inner join app.Categories c 
				on csc.CategoryId = c.CategoryId
			inner join app.Category_Dimensions cd 
				on c.CategoryId = cd.CategoryId
			inner join app.Dimensions d 
				on cd.DimensionId = d.DimensionId
			inner join App.DimensionTables dt 
				on dt.DimensionTableId = d.DimensionTableId
			left outer join app.TableTypes tt 
				on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode
			and cs.SubmissionYear = @reportYear
			and o.LevelCode = @reportLevel

			OPEN reportField_cursor
			FETCH NEXT FROM reportField_cursor INTO @dimension
			WHILE @@FETCH_STATUS = 0
			BEGIN
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				-- ' + @dimension + '
				---------------------------
				IF OBJECT_ID(''tempdb..#cat_' + @dimension + ''') IS NOT NULL DROP TABLE #cat_' + @dimension + char(10) +

				'				create table #cat_' + @dimension + '  (
					Code varchar(100)
				)
				'
				FETCH NEXT FROM reportField_cursor INTO @dimension
  			END
			CLOSE reportField_cursor
			DEALLOCATE reportField_cursor
		end
	end

	-- Loop through category set  cursor
	declare @categoryCnt as int
	set @categoryCnt = 0			-- reset count to 0

	declare @reportField as nvarchar(150)
	declare @dimensionField as nvarchar(150)
	declare @categoryCode as nvarchar(150)
	declare @categorySetId as int
	declare @dimensionTable as nvarchar(150)
	declare @dimensionPrimaryKey as nvarchar(150)
	declare @factKey as nvarchar(150)

	DECLARE categoryset_cursor CURSOR FOR 
	select cs.CategorySetId, 
		upper(d.DimensionFieldName) as ReportField, 
		case
			when d.IsOrganizationLevelSpecific = 1 then @reportLevel + 
				case
					when d.DimensionFieldName = 'YEAR' then d.DimensionFieldName
					when @reportCode = 'yeartoyearexitcount' and @categorySetCode in ('exitOnly','exitWithSex','exitWithDisabilityType','exitWithLEPStatus','exitWithRaceEthnic','exitWithAge') and d.DimensionFieldName <>'SpecialEducationExitReason' then d.DimensionFieldName + 'Description'
					when @reportCode = 'yeartoyearremovalcount' and @categorySetCode in ('removaltype','removaltypewithgender','removaltypewithdisabilitytype','removaltypewithlepstatus','removaltypewithraceethnic','removaltypewithage') and d.DimensionFieldName <>'IdeaInterimRemoval' then d.DimensionFieldName + 'Description'
					when @generateReportTypeCode = 'datapopulation' then d.DimensionFieldName + 'Code'
					else d.DimensionFieldName + 'EdFactsCode'
				end
			else case
					when d.DimensionFieldName = 'YEAR' then d.DimensionFieldName
					when @reportCode = 'yeartoyearexitcount' and @categorySetCode in ('exitOnly','exitWithSex','exitWithDisabilityType','exitWithLEPStatus','exitWithRaceEthnic','exitWithAge') and d.DimensionFieldName <>'SpecialEducationExitReason' then d.DimensionFieldName + 'Description'
					when @reportCode = 'yeartoyearremovalcount' and @categorySetCode in ('removaltype','removaltypewithgender','removaltypewithdisabilitytype','removaltypewithlepstatus','removaltypewithraceethnic','removaltypewithage') and d.DimensionFieldName <>'IdeaInterimRemoval' then d.DimensionFieldName + 'Description'
					when @generateReportTypeCode = 'datapopulation' then d.DimensionFieldName + 'Code'
					else d.DimensionFieldName + 'EdFactsCode'
				end
		end as DimensionField,
		c.CategoryCode, 
		dt.DimensionTableName as DimensionTable
	from app.CategorySets cs
	inner join app.GenerateReports r 
		on cs.GenerateReportId = r.GenerateReportId
	inner join app.OrganizationLevels o 
		on cs.OrganizationLevelId = o.OrganizationLevelId
	inner join app.CategorySet_Categories csc 
		on cs.CategorySetId = csc.CategorySetId
	inner join app.Categories c 
		on csc.CategoryId = c.CategoryId
	inner join app.Category_Dimensions cd 
		on c.CategoryId = cd.CategoryId
	inner join app.Dimensions d 
		on cd.DimensionId = d.DimensionId
	inner join App.DimensionTables dt 
		on dt.DimensionTableId = d.DimensionTableId
	left outer join app.TableTypes tt 
		on cs.TableTypeId = tt.TableTypeId
	where r.ReportCode = @reportCode
	and cs.CategorySetCode = @categorySetCode 
	and cs.SubmissionYear = @reportYear 
	and o.LevelCode = @reportLevel
	and isnull(tt.TableTypeAbbrv, '')  = @tableTypeAbbrv

	OPEN categoryset_cursor
	FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportField, @dimensionField, @categoryCode, @dimensionTable

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- set @cohortYear = '', @cohortYearTotal = ''
		set @cohortYear = ''
		set @cohortYearTotal = ''
		set @categoryCnt = @categoryCnt + 1
		if @reportcode in ('yeartoyearenvironmentcount')
		begin		
			if(@reportField <> 'AGE')
			begin
				set @sqlCategoryFields = @sqlCategoryFields + ', ' + @reportField
				set @sqlCategoryFieldDefs = @sqlCategoryFieldDefs + ', ' + @reportField + ' varchar(100)'		
			end
		end
		else if @reportcode in ('studentssummary') and (@categorySetCode in ('earlychildhood','genderwithearlychildhood','disabilitywithearlychildhood','raceethnicwithearlychildhood',
																			'lepstatuswithearlychildhood','earlychildhoodwithdisability','earlychildhoodwithraceethnic','earlychildhoodwithgender',
																			'earlychildhoodwithlepstatus','schoolage','schoolagewithgender','genderwithschoolage','schoolagewithdisability',
																			'disabilitywithschoolage','schoolagewithraceethnic','raceethnicwithschoolage','schoolagewithlepstatus','lepstatuswithschoolage'))
		begin
			if(@reportField <> 'AGE')
			begin
				set @sqlCategoryFields = @sqlCategoryFields + ', ' + @reportField
				set @sqlCategoryFieldDefs = @sqlCategoryFieldDefs + ', ' + @reportField + ' varchar(100)'		
			end
		end
		else
		begin
			set @sqlCategoryFields = @sqlCategoryFields + ', ' + @reportField
			set @sqlCategoryFieldDefs = @sqlCategoryFieldDefs + ', ' + @reportField + ' varchar(100)'		
		end
		set @sqlZeroCountConditions = @sqlZeroCountConditions + 'and ' + @reportField + ' = CAT_' + @reportField + '.Code '
		set @sqlCategoryQualifiedFields = @sqlCategoryQualifiedFields + ', CAT_' + @reportField + '.Code'
		set @sqlCategoryOptionJoins = @sqlCategoryOptionJoins + '
		cross join  #cat_' + @reportField + ' CAT_' + @reportField
		
		-- TODO: Add this to RDS.DimensionTables
		set @dimensionPrimaryKey = ''

		if @dimensionTable = 'DimAges'
		begin
			set @dimensionPrimaryKey = 'DimAgeId'
		end
		else if @dimensionTable = 'DimAssessments'
		begin
			set @dimensionPrimaryKey = 'DimAssessmentId'
		end
		else if @dimensionTable = 'DimAssessmentRegistrations'
		begin
			set @dimensionPrimaryKey = 'DimAssessmentRegistrationId'
		end
		else if @dimensionTable = 'DimAssessmentStatuses'
		begin
			set @dimensionPrimaryKey = 'DimAssessmentStatusId'
		end
		else if @dimensionTable = 'DimCohortStatuses'
		begin
			set @dimensionPrimaryKey = 'DimCohortStatusId'
		end
		else if @dimensionTable ='DimCteStatuses'
		begin
			set @dimensionPrimaryKey = 'DimCteStatusId'
		end
		else if @dimensionTable = 'DimDisabilityStatuses'
		begin
			set @dimensionPrimaryKey = 'DimDisabilityStatusId'
		end
		else if @dimensionTable = 'DimDisciplineStatuses'
		begin
			set @dimensionPrimaryKey = 'DimDisciplineStatusId'
		end
		else if @dimensionTable = 'DimDisciplineReasons'
		begin
			set @dimensionPrimaryKey = 'DimDisciplineReasonId'
		end
		else if @dimensionTable ='DimEnglishLearnerStatuses'
		begin
			set @dimensionPrimaryKey = 'DimEnglishLearnerStatusId'
		end
		else if @dimensionTable ='DimEconomicallyDisadvantagedStatuses'
		begin
			set @dimensionPrimaryKey = 'DimEconomicallyDisadvantagedStatusId'
		end
		else if @dimensionTable = 'DimFirearms'
		begin
			set @dimensionPrimaryKey = 'DimFirearmId'
		end
		else if @dimensionTable = 'DimFirearmDisciplineStatuses'
		begin
			set @dimensionPrimaryKey = 'DimFirearmDisciplineStatusId'
		end
		else if @dimensionTable = 'DimFosterCareStatuses'
		begin
			set @dimensionPrimaryKey = 'DimFosterCareStatusId'
		end
		else if @dimensionTable = 'DimGradeLevels'
		begin
			set @dimensionPrimaryKey = 'DimGradeLevelId'
		end
		else if @dimensionTable = 'DimHomelessnessStatuses'
		begin
			set @dimensionPrimaryKey = 'DimHomelessnessStatusId'
		end
		else if @dimensionTable = 'DimIdeaStatuses'
		begin
			set @dimensionPrimaryKey = 'DimIdeaStatusId'
		end
		else if @dimensionTable = 'DimIdeaDisabilityTypes'
		begin
			set @dimensionPrimaryKey = 'DimIdeaDisabilityTypeId'
		end
		else if @dimensionTable = 'DimImmigrantStatuses'
		begin
			set @dimensionPrimaryKey = 'DimImmigrantStatusId'
		end
		else if @dimensionTable = 'DimK12AcademicAwardStatuses'
		begin
			set @dimensionPrimaryKey = 'DimK12AcademicAwardStatusId'
		end
		else if @dimensionTable = 'DimK12Demographics'
		begin
			set @dimensionPrimaryKey = 'DimK12DemographicId'
		end
		else if @dimensionTable ='DimK12EnrollmentStatuses'
		begin
			set @dimensionPrimaryKey = 'DimK12EnrollmentStatusId'
		end
		else if @dimensionTable = 'DimK12StaffStatuses'
		begin
			set @dimensionPrimaryKey = 'DimK12StaffStatusId'
		end
		else if @dimensionTable = 'DimK12StaffCategories'
		begin
			set @dimensionPrimaryKey = 'DimK12StaffCategoryId'
		end
		else if @dimensionTable = 'DimLanguages'
		begin
			set @dimensionPrimaryKey = 'DimLanguageId'
		end
		else if @dimensionTable = 'DimMigrantStatuses'
		begin
			set @dimensionPrimaryKey = 'DimMigrantStatusId'
		end
		else if @dimensionTable = 'DimMilitaryStatuses'
		begin
			set @dimensionPrimaryKey = 'DimMilitaryStatusId'
		end
		else if @dimensionTable ='DimNOrDStatuses'
		begin
			set @dimensionPrimaryKey = 'DimNOrDStatusId'
		end
		else if @dimensionTable = 'DimOrganizationTitleIStatuses'
		begin
			set @dimensionPrimaryKey = 'DimOrganizationTitleIStatusId'
		end
		else if @dimensionTable ='DimPeople'
		begin
			set @dimensionPrimaryKey = 'DimPersonId'
		end
		else if @dimensionTable = 'DimRaces'
		begin
			set @dimensionPrimaryKey = 'DimRaceId'
		end
		else if @dimensionTable = 'DimTitleIStatuses'
		begin
			set @dimensionPrimaryKey = 'DimTitleIStatusId'
		end
		else if @dimensionTable = 'DimTitleIIIStatuses'
		begin
			set @dimensionPrimaryKey = 'DimTitleIIIStatusId'
		end
		else if @dimensionTable = 'DimAssessmentAdministrations'
		begin
			set @dimensionPrimaryKey = 'DimAssessmentAdministrationId'
		end
			
		set @factKey = REPLACE(@dimensionPrimaryKey, 'Dim', '')

		if @dimensionTable = 'DimIdeaDisabilityTypes'
		begin
			set @factKey = 'PrimaryDisabilityTypeId'
		end

		if @dimensionTable = 'DimGradeLevels' and @reportCode in ('175','178','179','185','188','189')
		begin
			set @factKey = 'GradeLevelWhenAssessedId'
		end

		if @dimensionTable = 'DimSchoolYears'
		begin
			set @dimensionPrimaryKey = 'DimSchoolYearId'
			set @factKey = 'SchoolYearId'
		end

		if(@includeOrganizations = 1)
		begin
			if(@isFileGenerator = 0)
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					-- ' + @reportField + '
					---------------------------
					IF OBJECT_ID(''tempdb..#cat_' + @reportField + ''') IS NOT NULL DROP TABLE #cat_' + @reportField + char(10) +

					'				create table #cat_' + @reportField + ' (
						Code varchar(100)
					)
					'
			end
		end

		set @sqlCategoryOptions = @sqlCategoryOptions + ' 
			DELETE FROM #cat_' + @reportField + '
			'						

		-- Get Category Option Values
		-------------------------------------
		if @generateReportTypeCode = 'datapopulation'
		begin

			-- Create CAT table based on category code in category set
			if @categoryCode = 'SEX'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into #cat_' + @reportField + '
			select distinct Code
			from dbo.RefSex

			insert into #cat_' + @reportField + '
			select ''MISSING''
				'

			end
			else if @categoryCode = 'RACEETHNIC'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into #cat_' + @reportField + '
			select distinct Code
			from dbo.RefRace

			insert into #cat_' + @reportField + '
			select ''MISSING''

			insert into #cat_' + @reportField + '
			select ''HispanicorLatinoEthnicity''
			'

			end
			else if @categoryCode = 'ECODIS'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into #cat_' + @reportField + '
			select ''MISSING''

			insert into #cat_' + @reportField + '
			select ''EconomicDisadvantage''
			'

			end
			else if @categoryCode = 'HOMELSENRLSTAT'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into #cat_' + @reportField + '
			select ''MISSING''

			insert into #cat_' + @reportField + '
			select ''HomelessUnaccompaniedYouth''
			'
			end
			else if @categoryCode = 'MIGRNTSTATUS'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into #cat_' + @reportField + '
			select ''MISSING''

			insert into #cat_' + @reportField + '
			select ''Migrant''
			'

			end
			else
			begin
				if @reportCode = 'studentswdtitle1'
				begin
					-- (no category sets ARE available)
					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into #cat_' + @reportField + '
						SELECT distinct o.CategoryOptionCode
						from app.CategoryOptions o
						inner join app.Categories c on o.CategoryId = c.CategoryId
						and c.CategoryCode = ''' +  @categoryCode + '''
						and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
						where 1 = 1
							'
				end
				else
				begin
					-- DataPopulation - Default
					-- (no category sets available)
					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into #cat_' + @reportField + '
						SELECT distinct o.CategoryOptionCode
						from app.CategoryOptions o
						inner join app.Categories c on o.CategoryId = c.CategoryId
						and c.CategoryCode = ''' +  @categoryCode + '''
						where 1 = 1
								'
				end
			end
		end
		else if @generateReportTypeCode = 'sppaprreport' 
		begin
			-- (no category sets available)
			set @sqlCategoryOptions = @sqlCategoryOptions + '
				insert into #cat_' + @reportField + '
				SELECT distinct o.CategoryOptionCode
				from app.CategoryOptions o
				inner join app.Categories c on o.CategoryId = c.CategoryId
				and c.CategoryCode = ''' +  @categoryCode + '''
				where 1 = 1
						'
		end										
		else if @generateReportTypeCode = 'edfactsreport' 
		begin
			if @categoryCode IN ('AGEEC', 'AGESA', 'AGEPK')
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
					where o.CategoryOptionCode <> ''NOTCOLLECT''
					'
			end
			else if @categoryCode in ('GRADELVL','AGEGRDWO13','GRADELDROP','GRADELVMEM','GRADELVBASICW13')
			begin
				declare @gradeList as varchar(100)
				set @gradeList = '''PK'',''KG'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'''

				-- JW FS032 Change 11/14/2023 ----------------------------
				IF(@categoryCode = 'GRADELDROP')
				BEGIN
					set @gradeList = '''BELOW7'',''07'',''08'',''09'',''10'',''11'',''12'''
				END
				----------------------------------------------------------

				IF(@categoryCode = 'GRADELVBASICW13')
				BEGIN
					set @gradeList = '''KG'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'''
				END

				IF(@categoryCode = 'AGEGRDWO13')
				BEGIN
					set @gradeList = @gradeList + ',''UNDER3'',''3TO5NOTK'',''OOS'''
				END

				IF(@toggleGrade13 = 1)
				BEGIN
					set @gradeList = @gradeList + ',''13'''
				END

				IF(@toggleUngraded = 1)
				BEGIN
					set @gradeList = @gradeList + ',''UG'''
				END

				IF(@toggleAdultEd = 1)
				BEGIN
					set @gradeList = @gradeList + ',''AE'''
				END

				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
					Where o.CategoryOptionCode in (' + @gradeList + ')
					'
			end

			---Begin New Code for c118

			else if @categoryCode in ('AGE3TOGRADE13')
			begin
				set @gradeList = '''KG'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''3TO5NOTK'''

				IF(@toggleGrade13 = 1)
				BEGIN
					set @gradeList = @gradeList + ',''13'''
				END

				IF(@toggleUngraded = 1)
				BEGIN
					set @gradeList = @gradeList + ',''UG'''
				END

				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
					Where o.CategoryOptionCode in (' + @gradeList + ')
					'
			end

			---End New Code for c118
			else if @categoryCode IN ('EDENVIDEAEC', 'EDENVIRIDEASA')
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
					where o.CategoryOptionCode <> ''NOTCOLLECT''
					'
			end
			else if @categoryCode in ('DISABCATIDEA', 'DISABCATIDEAEXIT')
			begin
				-- Check Toggle settings
				if exists (select 1 from app.ToggleResponses r
							inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
							where q.EmapsQuestionAbbrv = 'CHDCTDISCAT')
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into #cat_' + @reportField + '
						SELECT distinct o.CategoryOptionCode
						from app.CategoryOptions o
						inner join app.Categories c on o.CategoryId = c.CategoryId
						and c.CategoryCode = ''' +  @categoryCode + '''
						and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
						inner join app.ToggleResponses r on o.CategoryOptionName = 
								case
									when o.CategoryOptionCode = ''MISSING'' then o.CategoryOptionName
									else r.ResponseValue
								end
						inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
						where q.EmapsQuestionAbbrv = ''CHDCTDISCAT''
						'
				end
				else
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into #cat_' + @reportField + '
						SELECT distinct o.CategoryOptionCode
						from app.CategoryOptions o
						inner join app.Categories c on o.CategoryId = c.CategoryId
						and c.CategoryCode = ''' +  @categoryCode + '''
						and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
						where 1 = 1
						'
				end
			end
			else if @categoryCode in ('DIPLCREDTYPE')
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
					inner join app.ToggleResponses r on o.CategoryOptionCode = 
							case
								when o.CategoryOptionCode = ''MISSING'' then o.CategoryOptionCode
								when o.CategoryOptionCode = ''REGDIP'' then o.CategoryOptionCode
								else
									case when ISNULL(r.ResponseValue, ''false'') =''true'' Then ''OTHCOM'' end
							end
					inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
					where q.EmapsQuestionAbbrv = ''GRADRPT''
					'
			end
			else if @categoryCode in ('DISCIPLINEACTION', 'ASSESSMENTSUBJECT', 'PERSONNELTYPE')
			begin
				-- No category sets available
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					where 1 = 1
							'
			end
			else
			begin
				-- EdFactsReport - Default
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into #cat_' + @reportField + '
					SELECT distinct o.CategoryOptionCode
					from app.CategoryOptions o
					inner join app.Categories c on o.CategoryId = c.CategoryId
					and c.CategoryCode = ''' +  @categoryCode + '''
					and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
					where 1 = 1
					'
			end
		end
		else  
		begin
			set @sqlCategoryOptions = @sqlCategoryOptions + '
				insert into #cat_' + @reportField + '
				SELECT distinct o.CategoryOptionCode
				from app.CategoryOptions o
				inner join app.Categories c on o.CategoryId = c.CategoryId
				and c.CategoryCode = ''' +  @categoryCode + '''
				and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
				where 1 = 1
				'
		end

		-- Remove options based on report
		if @reportCode in ('002')
		begin
			if @categoryCode = 'EDUCENV' and @reportLevel = 'sch'
			begin 
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''PPPS'', ''HH'') '
			end
		end
		else if @reportCode in ('005')
		begin
			if @categoryCode = 'EDUCENV'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''PPPS'') '
			end
							
		end
		else if @reportCode in ('007')
		begin
			if @categoryCode = 'EDUCENV'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''PPPS'') '
			end
			if @categoryCode = 'REMOVALTYPE'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode IN (''REMDW'') '
			end
			if @categoryCode = 'REMOVALREASON'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''MISSING'') '
			end
		end
		else if @reportCode in ('006', '088', '143')
		begin
			if @categoryCode = 'EDUCENV'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''PPPS'') '
			end
		end 
		else if @reportCode in ('137')
		begin
			if @categoryCode = 'PARTSTATUS' AND @toggleEnglishLearnerProf = 0
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''MEDICAL'') '
			end
		end 
		else if @reportCode in ('138')
		begin
			if @categoryCode = 'PARTSTATUS' AND @toggleEnglishLearnerTitleIII = 0
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''MEDICAL'') '
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''MEDEXEMPT'') '
			end
		end 
		else if @reportCode in ('144')
		begin
			if @categoryCode = 'EDUCENV'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''PPPS'') '
			end
		end
		else if @generateReportTypeCode = 'sppaprreport'
		begin
			if @categoryCode = 'RACE'
			begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
				and o.CategoryOptionCode NOT IN (''MISSING'') '
			end
		end		
		if @sqlType = 'actual'
		begin

			-- Remove Exiting counts for MKC students still in SPED at SY End					
			if @generateReportTypeCode = 'edfactsreport'
			begin
				if @reportCode = '009' 
					and @toggleCatchmentSea = 'Entire state (students moving out of state)'
					and @reportField = 'SpecialEducationExitReason'
				begin
					set @sqlRemoveMissing = @sqlRemoveMissing + '
						-- Remove MKC counts for Students still in SPED at SY End' + char(10) + '
						if exists (select 1 from #categorySet
							where ' + @reportField + ' = ''MKC'')
						begin
							delete c from #categorySet c
							left join #excludeStudents e 
								on c.K12StudentStudentIdentifierState = e.StudentIdentifierState
							where ' + @reportField + ' = ''MKC''
							and e.StudentIdentifierState is not null
						end
					'
				end
			end

			-- Remove MISSING counts when needed					
			-- (if at least one non-MISSING count exists, remove MISSING Categories, otherwise remove all except MISSING)
			if @generateReportTypeCode = 'edfactsreport'
			begin
				set @sqlRemoveMissing = @sqlRemoveMissing + '
					-- Remove MISSING counts - ' + @reportField + '
					if exists (select 1 from #categorySet
						where ' + @reportField + ' <> ''MISSING'' and ' + @factField + ' > 0)
					begin
						delete from #categorySet where ' + @reportField + ' = ''MISSING''
					end
					else
					begin
						delete from #categorySet where ' + @reportField + ' <> ''MISSING''					
					end
				'

			end
		end
		
		if @sqlType = 'zero'
		begin
			-- Remove MISSING counts when needed					
			-- (if at least one non-MISSING count exists, remove MISSING Categories, otherwise remove all except MISSING)
			if @generateReportTypeCode = 'edfactsreport'
			begin

				set @sqlRemoveMissing = @sqlRemoveMissing + '
					-- Remove MISSING counts - ' + @reportField + '
					if exists (select 1 from @reportData
						where ' + @reportField + ' <> ''MISSING'' and ' + @factField + ' >= 0)
					begin
						delete from @reportData where ' + @reportField + ' = ''MISSING''
					end
					else 
					if exists (select 1 from @reportData where ' + @factField + ' > 0)
					begin
						delete from @reportData where ' + @reportField + ' = ''MISSING''					
					end
					else
					begin
						delete from @reportData where ' + @reportField + ' <> ''MISSING''					
					end
				'

				if @reportCode = '141' and @categorySetCode = 'csb'
				begin
					set @sqlRemoveMissing = @sqlRemoveMissing + '
						if exists (select 1 from @reportData where ' + @factField + ' > 0)
						begin
							delete from @reportData where ' + @reportField + ' <> ''MISSING'' AND ' + @factField + ' = 0
						end
					'
				end

				--Based on toggle, remove the unreported counts from the submission file
				if @reportCode = '033'
				begin
					if @toggleFreeLunch = 'Free and Reduced Only'
					begin
						set @sqlRemoveMissing = @sqlRemoveMissing + '
							delete from @reportData where TableTypeAbbrv = ''DIRECTCERT''
						'
					end
					else if @toggleFreeLunch = 'Direct Certification Only'
					begin
						set @sqlRemoveMissing = @sqlRemoveMissing + '
							delete from @reportData where TableTypeAbbrv = ''LUNCHFREERED''
						'
					end
				end
			end
		end

		if @sqlType = 'actual'
		begin
			-- Determine Return Values for option values based on category and/or report
			declare @categoryReturnFieldIsAggregate as bit
			set @categoryReturnFieldIsAggregate = 0

			-- TODO - make use of IsCalculated field to drive this via metadata
			if @categoryCode = 'REMOVALLENSUS'
			begin
				set @sqlCategoryReturnField = '
				case 
					when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) < 0.5 then ''MISSING''
					when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) <= 10.0 then ''LTOREQ10''
					else ''GREATER10''
				end'
				set @categoryReturnFieldIsAggregate = 1
			end
			else if @categoryCode = 'REMOVALLENIDEA'
			begin
				set @sqlCategoryReturnField = '
				case 
					when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) < 0.5 then ''MISSING''
					when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) >= 0.5 AND sum(isnull(fact.DurationOfDisciplinaryAction, 0)) < 1.5 then ''LTOREQ1''
					when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) <= 10.0 then ''2TO10''
					else ''GREATER10''
				end'
				set @categoryReturnFieldIsAggregate = 1
			end
			else if @categoryCode = 'RACEETHNIC'
			begin
				if @reportCode in ('yeartoyearexitcount','yeartoyearremovalcount') and @categorySetCode not in ('raceethnic','raceethnicity')
				begin
					set @sqlCategoryReturnField = 'CAT_' + @reportField + '.RaceDescription'
				end
				else if @factTypeCode = 'datapopulation'
				begin
					set @sqlCategoryReturnField = 'CAT_' + @reportField + '.RaceCode'
				end
				else
				begin
					set @sqlCategoryReturnField = 'CAT_' + @reportField + '.RaceEdFactsCode'
				end
			end
			else if @categoryCode = 'MAJORREG'
			begin
				IF @istoggleRaceMap = 1
				BEGIN
					set @sqlCategoryReturnField = '
						case 
							when CAT_' + @reportField + '.RaceEdFactsCode = ''AM7'' then ''MAN''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''AS7'' then ''MAP''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''BL7'' then ''MB''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''HI7'' then ''MHL''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''MU7'' then ''MM''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''PI7'' then ''MAP''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''WH7'' then ''MW''
							else ''MISSING''
							end'
				END
				ELSE
				BEGIN
					set @sqlCategoryReturnField = '
						case 
							when CAT_' + @reportField + '.RaceEdFactsCode = ''AM7'' then ''MAN''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''AS7'' then ''MA''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''BL7'' then ''MB''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''HI7'' then ''MHL''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''MU7'' then ''MM''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''PI7'' then ''MNP''
							when CAT_' + @reportField + '.RaceEdFactsCode = ''WH7'' then ''MW''
							else ''MISSING''
							end'
				END
			end
			else if @categoryCode in ('DISABSTATIDEA', 'DISABSTATUS', 'DISABIDEASTATUS')
			begin
				if @reportCode = '175'
				begin
					set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.IdeaIndicatorCode = ''MISSING'' then ''MISSING''
						else ''WDIS''
					end'
				end
				else if @reportCode = '118'
				begin
					set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.IdeaIndicatorEdFactsCode = ''IDEA'' then ''WDIS''
						else ''MISSING''
					end'
				end
				else
				begin
					set @sqlCategoryReturnField = '
					case 
						when CAT_' + @reportField + '.IdeaIndicatorEdFactsCode = ''IDEA'' then ''WDIS''
						else ''WODIS''
					end'
				end
			end		
			else if @categoryCode in ('DISABCATIDEA', 'DISABCATIDEAEXIT') and @year <= 2020
			begin
					
				set @sqlCategoryReturnField = ' 
							case 
								when CAT_' + @reportField + '.PrimaryDisabilityTypeCode = ''ID'' then ''MR''
								else CAT_' + @reportField + '.' + @dimensionField + '
							end'

			end
			else if @categoryCode in ('PARTSTATUS') 
			begin
				if( @reportCode in ( 'stateassessmentsperformance')	)
				BEGIN
					set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.ParticipationStatusCode = ''MISSING'' then ''MISSING''
						when CAT_' + @reportField + '.ParticipationStatusCode = ''NPART'' then ''NPART''
						else ''PART''
					end'
				END
				ELSE If @reportCode in ( '138', '137')
				BEGIN
					set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.AssessmentRegistrationParticipationIndicatorCode = ''MISSING'' then ''MISSING''						
						when CAT_' + @reportField + '.AssessmentRegistrationParticipationIndicatorCode = ''NPART'' then ''NPART''
						when CAT_' + @reportField + '.AssessmentRegistrationParticipationIndicatorCode = ''MEDEXEMPT'' then ''MEDICAL''
						else ''PART''
					end'
				END
			end
			else if @categoryCode = 'LUNCHPROG'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.EligibilityStatusForSchoolFoodServiceProgramsCode = ''FREE'' then ''FL''
						when CAT_' + @reportField + '.EligibilityStatusForSchoolFoodServiceProgramsCode = ''REDUCEDPRICE'' then ''RPL''
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end

			else if @categoryCode = 'HOMELESS'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.HomelessnessStatusCode = ''Yes'' then ''H''					
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end
			else if @categoryCode = 'DISABSTATUS504'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.Section504StatusCode = ''YES'' then ''DISAB504STAT''					
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end
			else if @categoryCode = 'GRADELDROP'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.GradeLevelCode in (''PK'',''KG'',''01'',''02'',''03'',''04'',''05'',''06'') then ''BELOW7''
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end
			else if @categoryCode = 'GRADELVLHS' and @reportCode in ('175', '178', '185', '188')
			begin
				set @sqlCategoryReturnField = ' 
					case when tgglAssmnt.Grade = ''HS''
							and CAT_GradeLevel.GradeLevelEdFactsCode IN (''09'',''10'',''11'',''12'') then ''HS''
						when tgglAssmnt.Grade IN (''09'',''10'',''11'',''12'')
							and CAT_GradeLevel.GradeLevelEdFactsCode = ''HS'' then tgglAssmnt.Grade
						else CAT_GradeLevel.GradeLevelEdFactsCode 
					end'	
			end

			else if @categoryCode = 'GRADELVLHSSCI' and @reportCode in ('179', '189')
			begin
				set @sqlCategoryReturnField = ' 
					case when tgglAssmnt.Grade = ''HS''
							and CAT_GradeLevel.GradeLevelEdFactsCode IN (''10'',''11'',''12'') then ''HS''
						when tgglAssmnt.Grade IN (''10'',''11'',''12'')
							and CAT_GradeLevel.GradeLevelEdFactsCode = ''HS'' then tgglAssmnt.Grade
						else CAT_GradeLevel.GradeLevelEdFactsCode 
					end'	
			end

			---Begin New Code for c118
			else if @categoryCode in ('AGE3TOGRADE13', 'AGEGRDWO13')
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when isnull(da.AgeCode, ''99'') IN (''3'', ''4'', ''5'')
								and isnull(CAT_GRADELEVEL.GradeLevelEdFactsCode, ''PK'') in (''PK'',''MISSING'') THEN ''3TO5NOTK''
						else CAT_GRADELEVEL.GradeLevelEdFactsCode END'
			end
--this condition was included in the case above, can't find the equivalent requirement in the file spec
--								when isnull(da.AgeCode, ''99'') IN (''0'',''1'',''2'') then ''UNDER3''

			---End New Code for c118

			else if @categoryCode = 'AGEPK'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.AgeCode in (''0'',''1'',''2'') then ''UNDER3''
						when CAT_' + @reportField + '.AgeCode in (''3'',''4'',''5'') then ''3TO5NOTK''
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end
			else if @categoryCode = 'FSTRCRSTS'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.ProgramParticipationFosterCareCode = ''Yes'' then ''FCS''					
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end
			else if (@categoryCode like 'PARTSTATUS%LG')
			begin
				IF (@reportCode  IN ('188'))
				BEGIN
					set @sqlCategoryReturnField = ' 
						case 
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''REGASSWOACC'' THEN ''REGPARTWOACC''	
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''REGASSWACC'' THEN ''REGPARTWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ALTASSALTACH'' THEN ''ALTPARTALTACH''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWOACC'' THEN ''PADVASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWACC'' THEN ''PADVASMWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWOACC'' THEN ''PIADAPLASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWACC'' THEN ''PIADAPLASMWACC''
							WHEN rdar.ReasonNotTestedCode = ''03454'' THEN ''MEDEXEMPT''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode = ''DidNotParticipate'' THEN ''NPART''
							WHEN assmnt.AssessmentTypeAdministeredToEnglishLearnersCode in (''REGELPASMNT'', ''ALTELPASMNTALT'') then ''PARTELP''
							else ''MISSING''
						end'
				END
				ELSE
				BEGIN
					set @sqlCategoryReturnField = ' 
						case 
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''REGASSWOACC'' THEN ''REGPARTWOACC''	
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''REGASSWACC'' THEN ''REGPARTWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ALTASSALTACH'' THEN ''ALTPARTALTACH''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWOACC'' THEN ''PADVASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWACC'' THEN ''PADVASMWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWOACC'' THEN ''PIADAPLASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWACC'' THEN ''PIADAPLASMWACC''
							WHEN rdar.ReasonNotTestedCode = ''03454'' THEN ''MEDEXEMPT''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode = ''DidNotParticipate'' THEN ''NPART''
							else ''MISSING''
						end'
				END
			end
			else if (@categoryCode like 'PARTSTATUS%HS')
			begin
				IF (@reportCode  IN ('188'))
				BEGIN
					set @sqlCategoryReturnField = ' 
						case 
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMTIWOACC'' THEN ''PHSRGASMIWOACC''	
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMTIWACC'' THEN ''PHSRGASMIWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ALTASSALTACH'' THEN ''ALTPARTALTACH''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT2WOACC'' THEN ''PHSRGASM2WOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT2WACC'' THEN ''PHSRGASM2WACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT3WOACC'' THEN ''PHSRGASM3WOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT3WACC'' THEN ''PHSRGASM3WACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWOACC'' THEN ''PADVASMWOACC''	
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWACC'' THEN ''PADVASMWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWOACC'' THEN ''PIADAPLASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWACC'' THEN ''PIADAPLASMWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''LSNRHSASMTWOACC'' THEN ''PLSNRHSASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''LSNRHSASMTWACC'' THEN ''PLSNRHSASMWACC''
							WHEN rdar.ReasonNotTestedCode = ''03454'' THEN ''MEDEXEMPT''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode = ''DidNotParticipate'' THEN ''NPART''
							WHEN assmnt.AssessmentTypeAdministeredToEnglishLearnersCode in (''REGELPASMNT'', ''ALTELPASMNTALT'') then ''PARTELP''
							else ''MISSING''
						end'
				END
				ELSE
				BEGIN
					set @sqlCategoryReturnField = ' 
						case 
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMTIWOACC'' THEN ''PHSRGASMIWOACC''	
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMTIWACC'' THEN ''PHSRGASMIWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ALTASSALTACH'' THEN ''ALTPARTALTACH''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT2WOACC'' THEN ''PHSRGASM2WOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT2WACC'' THEN ''PHSRGASM2WACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT3WOACC'' THEN ''PHSRGASM3WOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''HSREGASMT3WACC'' THEN ''PHSRGASM3WACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWOACC'' THEN ''PADVASMWOACC''	
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''ADVASMTWACC'' THEN ''PADVASMWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWOACC'' THEN ''PIADAPLASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''IADAPLASMTWACC'' THEN ''PIADAPLASMWACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''LSNRHSASMTWOACC'' THEN ''PLSNRHSASMWOACC''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode <> ''DidNotParticipate'' and assmnt.AssessmentTypeAdministeredCode =''LSNRHSASMTWACC'' THEN ''PLSNRHSASMWACC''
							WHEN rdar.ReasonNotTestedCode = ''03454'' THEN ''MEDEXEMPT''
							WHEN rdar.AssessmentRegistrationParticipationIndicatorCode = ''DidNotParticipate'' THEN ''NPART''
							else ''MISSING''
						end'
				END
			end
			else if (@categoryCode = 'PROFSTATUS' and @reportCode  IN ('yeartoyearprogress','175','178','179'))
			begin
						
				set @sqlCategoryReturnField = ' 
					case 
						WHEN assmntPerfLevl.AssessmentPerformanceLevelIdentifier =''MISSING'' THEN ''MISSING''
						when CAST(SUBSTRING( assmntPerfLevl.AssessmentPerformanceLevelIdentifier, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''PROFICIENT''		
						when CAST(SUBSTRING( assmntPerfLevl.AssessmentPerformanceLevelIdentifier, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)  THEN  ''NOTPROFICIENT''
						else ''MISSING''
					end'
			end
			else if @categoryCode = 'PROFSTATUS' and @reportCode='142'
			begin
				set @sqlCategoryReturnField = ' 
					case 
						WHEN assmntPerfLevl.AssessmentPerformanceLevelIdentifier =''MISSING'' THEN ''NODETERM''
						when CAST(SUBSTRING( assmntPerfLevl.AssessmentPerformanceLevelIdentifier, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''PROFICIENT''		
						when CAST(SUBSTRING( assmntPerfLevl.AssessmentPerformanceLevelIdentifier, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)  THEN  ''NOTPROFICIENT''
						else ''MISSING''
					end'
			end
			else if @categoryCode = 'TESRES' and @reportCode='157'
			begin
				set @sqlCategoryReturnField = ' 
								case 
								WHEN  CAT_' + @reportField + '.PerformanceLevelEdFactsCode =''MISSING'' THEN ''MISSING''
								when CAST(SUBSTRING( CAT_' + @reportField + '.PerformanceLevelEdFactsCode, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''PSD''		
								when CAST(SUBSTRING( CAT_' + @reportField + '.PerformanceLevelEdFactsCode, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)  THEN  ''DN''								
								else ''MISSING''
								end'
			end
			else if @categoryCode = 'DISABSTATADA'
			begin
				if @toggleCtePerkDisab = 'ADA Disability'
				begin
					set @sqlCategoryReturnField = '
					case 
						when CAT_' + @reportField + '.PrimaryDisabilityTypeCode = ''MISSING'' then ''MISSING''
						else ''DISADA''
					end'
				end
				else
				begin
					set @sqlCategoryReturnField = '
					case 
						when CAT_' + @reportField + '.PrimaryDisabilityTypeCode = ''MISSING'' then ''MISSING''
						else ''WDIS''
					end'
				end
			end
			else if @categoryCode in ('ACADSUBASSESNOSCI','ACADSUBASSES')
			begin
				set @sqlCategoryReturnField = ' 
					case 
						when CAT_' + @reportField + '.AssessmentAcademicSubjectEdFactsCode = ''MATH'' then ''M''	
						when CAT_' + @reportField + '.AssessmentAcademicSubjectEdFactsCode = ''SCIENCE'' then ''S''				
						else CAT_' + @reportField + '.' + @dimensionField + '
					end'
			end
			else if @categoryCode IN ('AGESA','AGEEC') and @reportCode in ('002', '089') and @year > 2018
			begin
				set @sqlCategoryReturnField = 'CAT_' + @reportField + '_temp.Code'
			end
			else
			begin
				-- Default
				set @sqlCategoryReturnField = 'CAT_' + @reportField + '.' + @dimensionField
			end

			-- Add return value for this category to the list of fields
			IF(@reportCode = '006')
			begin
				set @sqlCategoryQualifiedSubSelectDimensionFields = @sqlCategoryQualifiedSubSelectDimensionFields + ', ' + REPLACE(@sqlCategoryReturnField,'CAT_' + @reportField,'fact')
			end
			IF @reportCode in ('yeartoyearenvironmentcount')
			begin
				if @reportField <> 'AGE'
					set @sqlCategoryQualifiedDimensionFields = @sqlCategoryQualifiedDimensionFields + ', ' + @sqlCategoryReturnField
			end
			else if @reportcode in ('studentssummary') and (@categorySetCode in ('earlychildhood','genderwithearlychildhood','disabilitywithearlychildhood','raceethnicwithearlychildhood',
																			'lepstatuswithearlychildhood','earlychildhoodwithdisability','earlychildhoodwithraceethnic','earlychildhoodwithgender',
																				'earlychildhoodwithlepstatus','schoolage','schoolagewithgender','genderwithschoolage','schoolagewithdisability',
															'disabilitywithschoolage','schoolagewithraceethnic','raceethnicwithschoolage','schoolagewithlepstatus','lepstatuswithschoolage'))
			begin
				if(@reportField <> 'AGE')
					set @sqlCategoryQualifiedDimensionFields = @sqlCategoryQualifiedDimensionFields + ', ' + @sqlCategoryReturnField	
			end
			else
			begin
				set @sqlCategoryQualifiedDimensionFields = @sqlCategoryQualifiedDimensionFields + ', ' + @sqlCategoryReturnField		
			end
			if(@reportCode = '006' AND @dimensionField <> 'RemovalLengthEdFactsCode')
			begin
				if @categoryCode = 'RACEETHNIC'
				begin
					set @sqlCategoryQualifiedSubDimensionFields = @sqlCategoryQualifiedSubDimensionFields + ', RaceEdFactsCode'
					set @sqlCategoryQualifiedSubGroupDimensionFields = @sqlCategoryQualifiedSubGroupDimensionFields + ', RaceEdFactsCode'
				end
				else
				begin
					set @sqlCategoryQualifiedSubDimensionFields = @sqlCategoryQualifiedSubDimensionFields + ', ' + 'CAT_' + @reportField + '.' + @dimensionField
					set @sqlCategoryQualifiedSubGroupDimensionFields = @sqlCategoryQualifiedSubGroupDimensionFields + ', fact.' + @dimensionField
				end
			end

			----Begin New Code for c118
			if(@reportCode in ('118', '054'))
			begin
				if @categoryCode in ('AGE3TOGRADE13','AGEGRDWO13')
				begin
					set @sqlCategoryQualifiedDimensionGroupFields = @sqlCategoryQualifiedDimensionGroupFields + ', da.AgeCode'
				end
			end
			----End New Code for c118

			if @categoryReturnFieldIsAggregate = 0
			begin
				IF @reportCode in ('yeartoyearenvironmentcount')
				begin
					if @reportField <> 'AGE'
						set @sqlCategoryQualifiedDimensionGroupFields = @sqlCategoryQualifiedDimensionGroupFields + ', ' + @sqlCategoryReturnField
				end
				else if @reportcode in ('studentssummary') and (@categorySetCode in ('earlychildhood','genderwithearlychildhood','disabilitywithearlychildhood','raceethnicwithearlychildhood',
																					'lepstatuswithearlychildhood','earlychildhoodwithdisability','earlychildhoodwithraceethnic','earlychildhoodwithgender',
																					'earlychildhoodwithlepstatus','schoolage','schoolagewithgender','genderwithschoolage','schoolagewithdisability',
																					'disabilitywithschoolage','schoolagewithraceethnic','raceethnicwithschoolage','schoolagewithlepstatus','lepstatuswithschoolage'))
				begin
					if @reportField <> 'AGE'
						set @sqlCategoryQualifiedDimensionGroupFields = @sqlCategoryQualifiedDimensionGroupFields + ', ' + @sqlCategoryReturnField
				end
				else
				begin
					set @sqlCategoryQualifiedDimensionGroupFields = @sqlCategoryQualifiedDimensionGroupFields + ', ' + @sqlCategoryReturnField	
				end	
			end
			else
			begin
				if @sqlHavingClause = ''
				begin
					set @sqlHavingClause = ' having 1 = 1 '
				end
				set @sqlHavingClause = @sqlHavingClause + ' and ' + @sqlCategoryReturnField + ' in (select Code from #cat_' + @reportField + ')'
			end

		-- Build join conditions for actual counts
			if @reportField = 'RACE' and @reportCode in ('yeartoyearremovalcount','yeartoyearexitcount') and @categorySetCode not in ('raceethnicity','raceethnic')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimRaces CAT_' + @reportField + ' 
					on fact.RaceId = CAT_' + @reportField + '.DimRaceId 
				inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
					on CAT_RACE.RaceEdFactsCode = CAT_' + @reportField + '_temp.Code'
			end
			else if @reportField = 'RACE' and @reportCode in ('175', '178', '179', '185', '188', '189')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.BridgeK12StudentAssessmentRaces b 
					on fact.FactK12StudentAssessmentId = b.FactK12StudentAssessmentId
				inner join rds.DimRaces CAT_' + @reportField + ' 
					on b.RaceId = CAT_' + @reportField + '.DimRaceId 
				inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
					on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
			end
			else if @reportField = 'RACE'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimRaces CAT_' + @reportField + ' 
					on fact.RaceId = CAT_' + @reportField + '.DimRaceId 
				inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
					on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
			end
			else if (@reportField = 'PROFICIENCYSTATUS' and @reportCode in ('yeartoyearprogress','175','178','179'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' 
						on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					inner join RDS.DimAssessments assmnt 
						on fact.AssessmentId = assmnt.DimAssessmentId 
					inner join RDS.DimAssessmentPerformanceLevels assmntPerfLevl 
						on fact.AssessmentPerformanceLevelId = assmntPerfLevl.DimAssessmentPerformanceLevelId
					inner join RDS.DimGradeLevels grades 
						on fact.GradeLevelWhenAssessedId = grades.DimGradeLevelId
					inner join APP.ToggleAssessments tgglAssmnt 
						on tgglAssmnt.Grade = grades.GradeLevelCode 
						and tgglAssmnt.Subject = assmnt.AssessmentAcademicSubjectEdFactsCode	
						and tgglAssmnt.AssessmentTypeCode = assmnt.AssessmentTypeAdministeredCode			
					inner join #cat_' + + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
					'
			END	
			else if (@reportField = 'GRADELEVEL' and @reportCode in ('185', '188', '189'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' 
						on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					inner join rds.DimAssessments assmnt 
						on fact.AssessmentId = assmnt.DimAssessmentId
					inner join rds.DimAssessmentRegistrations rdar 
						on fact.AssessmentRegistrationId = rdar.DimAssessmentRegistrationId
					inner join APP.ToggleAssessments tgglAssmnt 
						on tgglAssmnt.Grade = CAT_GradeLevel.GradeLevelCode 
						and tgglAssmnt.Subject = assmnt.AssessmentAcademicSubjectEdFactsCode	
						and tgglAssmnt.AssessmentTypeCode = assmnt.AssessmentTypeAdministeredCode			
					inner join #cat_' + + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
					'
			END	
			---Begin New Code for c118

			else if(@reportField = 'GRADELEVEL' and @reportCode in ('118'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					left join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					left join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode = CAT_' + @reportField + '_temp.Code
						and ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode NOT IN (''AE'')
					left join RDS.DimAges da ON fact.AgeId = da.DimAgeId
						and da.AgeCode IN (''3'', ''4'', ''5'')
					'
			END
			---End New Code

			else if(@reportField = 'GRADELEVEL' and @reportCode in ('134'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					left join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					left join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode = CAT_' + @reportField + '_temp.Code
						and ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode NOT IN (''AE'')
					left join RDS.DimAges da ON fact.AgeId = da.DimAgeId
					'
			END

			else if(@reportField = 'GRADELEVEL' and @reportCode in ('054'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					left join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					left join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode = CAT_' + @reportField + '_temp.Code
						and ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode NOT IN (''AE'')
					left join RDS.DimAges da ON fact.AgeId = da.DimAgeId
						and da.AgeCode IN (''0'', ''1'', ''2'', ''3'', ''4'', ''5'')
					'
			END
			else if(@reportField = 'PROFICIENCYSTATUS' and @reportCode in ('142'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					inner join RDS.DimGradeLevels grdlevel on fact.GradeLevelId = grdlevel.DimGradeLevelId
					inner join RDS.DimAssessments assmnt on fact.AssessmentId = assmnt.DimAssessmentId 
					inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = grdlevel.GradeLevelCode and tgglAssmnt.Subject = assmnt.AssessmentAcademicSubjectEdFactsCode				
					inner join #cat_' + + @reportField + ' CAT_' + @reportField + '_temp
					on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
					inner join rds.DimCteStatuses cteStatus on fact.CteStatusId = cteStatus.DimCteStatusId			
							and cteStatus.CteProgramCode =''CTECONC'''
			END				
			else if(@reportField = 'TESTRESULT' and  @reportCode in ('157'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					inner join RDS.DimGradeLevels grdlevel on fact.GradeLevelId = grdlevel.DimGradeLevelId
					inner join RDS.DimAssessments assmnt on fact.AssessmentId = assmnt.DimAssessmentId 
					inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = grdlevel.GradeLevelCode and tgglAssmnt.Subject = assmnt.AssessmentAcademicSubjectEdFactsCode	
					inner join #cat_' + + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
					inner join rds.DimCteStatuses cteStatus on fact.CteStatusId = cteStatus.DimCteStatusId			
							and cteStatus.CteProgramCode =''CTECONC'''
			END	
			else if(@reportCode in ('002','089') and @year > 2018 and @reportField IN ('AGE'))
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
					inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
						on CAT_' + @reportField + '.' + @reportField + 'EdfactsCode' + ' = IIF(CAT_' + @reportField + '_temp.Code ' + 'in (''AGE05K'',''AGE05NOTK''), ''5'',' + ' CAT_' + @reportField + '_temp.Code)'
			end
			else if(@reportCode in ('yeartoyearchildcount', 'yeartoyearenvironmentcount','yeartoyearexitcount','yeartoyearremovalcount','studentssummary'))
			BEGIN
				if @dimensionTable='DimSchoolYears'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.SchoolYearId = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
					inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
				end
				else
				begin
				if(@reportCode in ('yeartoyearexitcount') and @categorySetCode in ('exitOnly','exitWithSex','exitWithDisabilityType','exitWithLEPStatus','exitWithRaceEthnic','exitWithAge')
				and @reportField IN ('SEX','IdeaDisabilityType','RACE','LEPSTATUS','AGE'))
				begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
						inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
							on ' + LEFT(@sqlCategoryReturnField ,(len(@sqlCategoryReturnField)- 11)) + 'EdfactsCode = CAT_' + @reportField + '_temp.Code'
				end
				else if(@reportCode in ('yeartoyearremovalcount') and @categorySetCode in ('removaltype','removaltypewithgender','removaltypewithdisabilitytype','removaltypewithlepstatus','removaltypewithraceethnic','removaltypewithage') and @reportField IN ('SEX','IdeaDisabilityType','RACE','LEPSTATUS','AGE'))
				begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
						inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
							on ' + LEFT(@sqlCategoryReturnField ,(len(@sqlCategoryReturnField)- 11)) + 'EdfactsCode = CAT_' + @reportField + '_temp.Code'
				end
				else
				begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
						inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
							on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
				end
			end
		END		
		else
		begin
			if @categoryReturnFieldIsAggregate = 0
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @factKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
				inner join #cat_' + @reportField + ' CAT_' + @reportField + '_temp
					on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
			end
		end
	end		-- END if @sqlType = 'actual'

		FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportField, @dimensionField, @categoryCode, @dimensionTable
	END
	CLOSE categoryset_cursor
	DEALLOCATE categoryset_cursor


	if @sqlType = 'actual' or @sqlType = 'zero' or @sqlType = 'zero-performance' or @sqlType = 'zero-discipline' or @sqlType = 'zero-educenv' or @sqlType = 'zero-programs'
	begin		
		set @sql = @sql + @sqlCategoryOptions
	end

	if @sqlType = 'actual'
	begin

		declare @categorySetReportFieldList as nvarchar(1000)
		set @categorySetReportFieldList = ''
		select @categorySetReportFieldList = isnull(app.Get_CategoriesByCategorySet(@categorySetId, 1, 1), '') 
		declare @categorySetCategoryList as nvarchar(max)
		set @categorySetCategoryList = ''
		select @categorySetCategoryList = isnull(app.Get_CategoriesByCategorySet(@categorySetId, 1, 0), '')

		
		-- Filter facts based on report
		----------------------------------		
		declare @reportFilterJoin as nvarchar(max)
		set @reportFilterJoin = ''
		declare @reportFilterCondition as nvarchar(max)
		set @reportFilterCondition = ''

			
		if @reportCode in ('175', '178', '179', '185', '188', '189')
		begin
			IF CHARINDEX('IdeaIndicator', @categorySetReportFieldList) > 0  
			begin
				set @reportFilterJoin = 'inner join rds.DimIdeaStatuses idea on fact.IdeaStatusId = idea.DimIdeaStatusId'
				set @reportFilterCondition = @reportFilterCondition + ' and idea.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode not in (''PPPS'')'
			end				

		end						
		if @reportCode in ('002','edenvironmentdisabilitiesage6-21','089','disciplinaryremovals','006','005')
		begin

			IF CHARINDEX('IdeaDisabilityType', @categorySetReportFieldList) = 0 
			begin
				set @reportFilterJoin = 'inner join rds.DimIdeaDisabilityTypes idea on fact.PrimaryDisabilityTypeId = idea.DimIdeaDisabilityTypeId'

				if @reportCode not in ('002','089')
				begin
					set @reportFilterCondition = 'and idea.IdeaDisabilityTypeEdFactsCode <> ''MISSING'''
				end

				IF @reportLevel = 'sch' and @reportCode = '002'
				begin
					set @reportFilterJoin = 'inner join rds.DimIdeaStatuses idea on fact.IdeaStatusId = idea.DimIdeaStatusId'
					set @reportFilterCondition = ' and idea.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode not in (''HH'', ''PPPS'')'
				end
			end
			ELSE IF @reportLevel = 'sch' AND CHARINDEX('IdeaDisabilityType', @categorySetReportFieldList) > 0 and @reportCode = '002'
			begin
				set @reportFilterJoin = 'inner join rds.DimIdeaStatuses IdeaEducationalEnvironment on fact.IdeaStatusId = IdeaEducationalEnvironment.DimIdeaStatusId'
				set @reportFilterCondition = 'and IdeaEducationalEnvironment.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode not in (''HH'', ''PPPS'')'
			end

			IF @year > 2018 AND @reportCode = '002' AND EXISTS (SELECT 1 FROM App.Split(@categorySetReportFieldList, ',') WHERE item = 'AGE')
			begin
				set @reportFilterJoin = @reportFilterJoin + '
				inner join rds.DimGradeLevels g on fact.GradeLevelId = g.DimGradeLevelId 
                and (CASE WHEN CAT_AGE_temp.Code = ''AGE05K'' and g.GradeLevelEdFactsCode in (''MISSING'',''PK'')
                    THEN ''''
                    ELSE g.GradeLevelEdFactsCode
                    END) = g.GradeLevelEdFactsCode' 
			end
			ELSE IF @year > 2018 AND @reportCode = '089' AND EXISTS (SELECT 1 FROM App.Split(@categorySetReportFieldList, ',') WHERE item = 'AGE') 
			begin
				set @reportFilterJoin = @reportFilterJoin + '
				inner join rds.DimGradeLevels g on fact.GradeLevelId = g.DimGradeLevelId 
				and (CASE WHEN CAT_AGE_temp.Code IN (''3'', ''4'') OR (CAT_AGE_temp.Code = ''AGE05NOTK'' and g.GradeLevelEdFactsCode in (''MISSING'',''PK''))
					THEN g.GradeLevelEdFactsCode
					ELSE ''''
					END) = g.GradeLevelEdFactsCode'			
			end
		end
		else if @reportCode in ('116')
		begin
			set @reportFilterJoin = 'inner join RDS.DimPeople rules
										on rules.DimPersonId = fact.K12StudentId
									inner join rds.DimTitleIIIStatuses titleIII on fact.TitleIIIStatusId = titleIII.DimTitleIIIStatusId'
			set @reportFilterCondition = 'and titleIII.TitleIIILanguageInstructionProgramTypeCode <> ''MISSING'''
		end
		else if @reportCode in ('157')
		begin
			set @reportFilterJoin = '
							inner join RDS.DimAssessments assmntSubject on fact.AssessmentId = assmntSubject.DimAssessmentId'
			set @reportFilterCondition = '
			and assmntSubject.AssessmentAcademicSubjectCode = ''73065'''
		end
		else if @reportCode in ('143')
		begin
			set @reportFilterJoin = 'inner join RDS.DimDisciplineStatuses CAT_DisciplinaryActionTaken 
			on fact.DisciplineStatusId = CAT_DisciplinaryActionTaken.DimDisciplineStatusId
			inner join RDS.DimDisciplineStatuses CAT_IdeaInterimRemoval on fact.DisciplineStatusId = CAT_IdeaInterimRemoval.DimDisciplineStatusId
			inner join RDS.DimIdeaStatuses CAT_IdeaEducationalEnvironment on fact.IdeaStatusId = CAT_IdeaEducationalEnvironment.DimIdeaStatusId																									
			'
			set @reportFilterCondition = ' 
			and CAT_IdeaEducationalEnvironment.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
			and CAT_IdeaEducationalEnvironment.IdeaIndicatorEdFactsCode = ''IDEA'''
		end
		else if @reportCode in ('144')
		begin
			set @reportFilterJoin = 'inner join RDS.DimDisciplineStatuses CAT_DisciplinaryActionTaken 
			on fact.DisciplineStatusId = CAT_DisciplinaryActionTaken.DimDisciplineStatusId
			inner join RDS.DimIdeaStatuses CAT_IdeaEducationalEnvironment on fact.IdeaStatusId = CAT_IdeaEducationalEnvironment.DimIdeaStatusId
			'
			set @reportFilterCondition = ' 
			and (CAT_DisciplinaryActionTaken.DisciplinaryActionTakenEdFactsCode IN (''03086'', ''03087''))
			and CAT_IdeaEducationalEnvironment.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS'''
		end

		-- Filter facts based on report
		----------------------------------
		declare @queryFactFilter as nvarchar(max)
		set @queryFactFilter = ''
								
		if @reportCode in ('002','edenvironmentdisabilitiesage6-21')
		begin
			-- Ages 6-21, Has Disability
			set @sqlCountJoins = @sqlCountJoins + '
				inner join #RULES rules ' + char(10) + 
				'on fact.K12StudentId = rules.K12StudentId and fact.PrimaryDisabilityTypeId = rules.DimIdeaDisabilityTypeId'
				+ CASE WHEN (@year > 2019 AND @reportCode = '002') THEN char(10) + ' and fact.GradeLevelId = rules.DimGradeLevelId' ELSE '' END + '
				' + char(10)

			if not @toggleDevDelayAges is null
			begin
				-- Exclude DD from counts for invalid ages
				-- JW 10/20/2023 ------------------------------------------------------
				set @sqlCountJoins = @sqlCountJoins + '
								left join #EXCLUDE exclude
						on fact.K12StudentId = exclude.K12StudentId' + char(10) + char(10)

				set @queryFactFilter = @queryFactFilter + '
				and exclude.K12StudentId IS NULL'

				if @toggleDevDelay6to9 is null and CHARINDEX('IdeaDisabilityType', @categorySetReportFieldList) > 0
				begin
					set @sqlRemoveMissing = @sqlRemoveMissing + '

					-- Remove DD counts for invalid ages
					delete from #categorySet where IdeaDisabilityType = ''DD''
					'
				end
			end
			else
			begin
				if CHARINDEX('IdeaDisabilityType', @categorySetReportFieldList) > 0
				begin
					set @sqlRemoveMissing = @sqlRemoveMissing + '

					-- Remove DD counts for invalid ages
					delete from #categorySet where IdeaDisabilityType = ''DD''
					'
				end
			end
		end
		else if @reportCode in ('005')
		begin
			-- Ages 3-21, Has Disability
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct rdp.K12StudentStudentIdentifierState, rdis.DimIdeaStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople rdp 
					on fact.K12StudentId = rdp.DimPersonId
				left join #Students Students
					on Students.K12StudentStudentIdentifierState = rdp.K12StudentStudentIdentifierState
				inner join rds.DimAges rda 
					on fact.AgeId = rda.DimAgeId
					and rda.AgeValue >= 3 
					and rda.AgeValue <= 21
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
				inner join rds.DimIdeaStatuses rdis 
					on fact.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimDisciplineStatuses rdds 
					on rdds.DimDisciplineStatusId = fact.DisciplineStatusId
				where rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
					and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
					and rdds.IdeaInterimRemovalCode in (''REMDW'', ''REMHO'')
					and Students.K12StudentStudentIdentifierState IS NOT NULL
			) rules 
				on stu.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState 
				and fact.IdeaStatusId = rules.DimIdeaStatusId '
				
		end
		else if @reportCode in ('007')
		begin
			-- Ages 3-21, Has Disability
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct rdp.K12StudentStudentIdentifierState, rdis.DimIdeaStatusId, fact.DisciplineStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople rdp
					on fact.K12StudentId = rdp.DimPersonId
				left join #Students Students
					on Students.K12StudentStudentIdentifierState = rdp.K12StudentStudentIdentifierState
				inner join rds.DimAges rda 
					on fact.AgeId = rda.DimAgeId
					and rda.AgeValue >= 3 
					and rda.AgeValue <= 21
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
				inner join rds.DimIdeaStatuses rdis 
					on fact.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimDisciplineStatuses rdds 
					on rdds.DimDisciplineStatusId = fact.DisciplineStatusId
				where rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
					and rdis.IdeaIndicatorEdFactsCode = ''IDEA'' 
					and rdds.IdeaInterimRemovalCode = ''REMDW''
					and Students.K12StudentStudentIdentifierState IS NOT NULL
			)  rules 
				on stu.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState 
				and fact.IdeaStatusId = rules.DimIdeaStatusId 
				and fact.DisciplineStatusId = rules.DisciplineStatusId '
					
			-- JW 7/20/2022
			/*
			and fact.K12StudentId NOT IN (SELECT K12StudentId FROM RDS.FactK12StudentDisciplines rfksd
											inner join rds.DimDisciplineStatuses rdds on rdds.DimDisciplineStatusId = rfksd.DisciplineStatusId
											inner join rds.DimIdeaStatuses rdis on rfksd.IdeaStatusId = rdis.DimIdeaStatusId
											and rdds.IdeaInterimRemovalCode = ''REMDW''
											and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
										GROUP BY K12StudentId, rdis.IdeaInterimRemovalCode, rdis.IdeaInterimRemovalReasonCode  HAVING SUM(rfksd.DurationOfDisciplinaryAction) > 45)'
			*/
		end
		else if @reportCode = '009'
		begin
			-- Ages 14-21, Has Disability
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select p.K12StudentStudentIdentifierState, idea.DimIdeaStatusId, lea.DimLeaId, MAX(d.DateValue) as SpecialEducationServiceExitDate
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end
			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimAges age 
					on fact.AgeId = age.DimAgeId
					and age.AgeValue >= 14 and age.AgeValue <= 21
				inner join rds.DimLeas lea
					on fact.LeaId = lea.DimLeaId
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
				inner join rds.DimDates d 
					on fact.SpecialEducationServicesExitDateId = d.DimDateId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
				inner join rds.DimIdeaStatuses idea 
					on fact.IdeaStatusId = idea.DimIdeaStatusId
				where idea.SpecialEducationExitReasonEdFactsCode <> ''MISSING'''
			
			if(@toggleBasisOfExit = 0)
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '
				and idea.SpecialEducationExitReasonEdFactsCode <> ''RC'''
			END

			if(@istoggleAlternateDiploma = 0)
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '
				and idea.SpecialEducationExitReasonEdFactsCode <> ''GRADALTDPL'''
			END

			set @sqlCountJoins = @sqlCountJoins + '
				and idea.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode <> ''PPPS''
				group by p.K12StudentStudentIdentifierState, idea.DimIdeaStatusId, lea.DimLeaId 
			) rules 
				on p.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState
				and fact.IdeaStatusId = rules.DimIdeaStatusId 
				and fact.LeaId = rules.DimLeaId
			inner join rds.DimDates exitDate 
				on rules.SpecialEducationServiceExitDate = exitDate.DateValue 
				and fact.SpecialEducationServicesExitDateId = exitDate.DimDateId '
		end
		else if @reportCode = '086'
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct rdp.K12StudentStudentIdentifierState, df.DimFirearmId, fact.IncidentIdentifier
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople rdp 
					on fact.K12StudentId = rdp.DimPersonId
				inner join rds.DimLeas l 
					on fact.LeaId = l.DimLeaId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
				inner join rds.DimFirearms df 
					on fact.FirearmId = df.DimFirearmId
				where df.FirearmTypeEdFactsCode <> ''MISSING''
			) rules 
				on stu.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState 
				and fact.FirearmId = rules.DimFirearmId 
				and fact.IncidentIdentifier = rules.IncidentIdentifier'
		end
		else if @reportCode in ('089','edenvironmentdisabilitiesage3-5')
		begin
			if @year > 2019
			begin				
				-- Ages 3-5, Has Disability
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, rdp.K12StudentStudentIdentifierState, rdidt.DimIdeaDisabilityTypeId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimAges rda
						on fact.AgeId = rda.DimAgeId
						and rda.AgeValue >= 3 
						and rda.AgeValue <= 5
					inner join rds.DimPeople rdp
						on fact.K12StudentId = rdp.DimPersonId
					inner join rds.DimGradeLevels rdgl 
						on fact.GradeLevelId = rdgl.DimGradeLevelId
					inner join rds.DimK12Schools rdks 
						on fact.K12SchoolId = rdks.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and CASE 
							WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
							WHEN fact.LeaId > 0 THEN fact.LeaId
							WHEN fact.SeaId > 0 THEN fact.SeaId
							ELSE -1
						END <> -1
					inner join rds.DimIdeaStatuses rdis 
						on fact.IdeaStatusId = rdis.DimIdeaStatusId
					inner join rds.DimIdeaDisabilityTypes rdidt 
						on fact.PrimaryDisabilityTypeId = rdidt.DimIdeaDisabilityTypeId
					where rdis.IdeaIndicatorEdFactsCode = ''IDEA''
					and (rda.AgeValue IN (3, 4) OR (rda.AgeValue = 5 
					and rdgl.GradeLevelCode IN (''MISSING'',''PK'')))
				) rules		
					on fact.K12StudentId = rules.K12StudentId 
					and fact.PrimaryDisabilityTypeId = rules.DimIdeaDisabilityTypeId '

			end 
			else if @year <= 2019
			begin
				-- 2019-20 or earlier 
				-- Ages 3-5, Has Disability
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, rdidt.DimIdeaDisabilityTypeId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimAges rda
						on fact.DimAgeId = rda.DimAgeId
						and rda.AgeValue >= 3 
						and rda.AgeValue <= 5
					inner join rds.DimK12Schools rdks 
						on fact.K12SchoolId = rdks.DimK12SchoolId
						and fact.DimCountDateId = @dimSchoolYearId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimIdeaDisabilityTypes rdidt 
						on fact.PrimaryDisabilityTypeId = rdidt.DimIdeaDisabilityTypeId
				) rules 
					on fact.K12StudentId = rules.K12StudentId 
					and fact.PrimaryDisabilityTypeId = rules.DimIdeaDisabilityTypeId '
			end

			if not @toggleDevDelayAges is null
			begin
				set @queryFactFilter = @queryFactFilter + '
					and not fact.K12StudentId  in (
						select distinct fact.K12StudentId
						from rds.' + @factTable + ' fact
						inner join rds.DimAges age 
							on fact.AgeId = age.DimAgeId
							and not age.AgeCode in (' + @toggleDevDelayAges + ')
						inner join rds.DimK12Schools s 
							on fact.K12SchoolId = s.DimK12SchoolId
							and fact.SchoolYearId = @dimSchoolYearId
							and fact.FactTypeId = @dimFactTypeId
							and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
						inner join rds.DimIdeaDisabilityTypes idea 
							on fact.PrimaryDisabilityTypeId = idea.DimIdeaDisabilityTypeId
						where idea.IdeaDisabilityTypeEdFactsCode = ''DD''
					)'
						
				if @toggleDevDelay3to5 is null and CHARINDEX('IdeaDisabilityType', @categorySetReportFieldList) > 0
				begin
					set @sqlRemoveMissing = @sqlRemoveMissing + '
						-- Remove DD counts for invalid ages
						delete from #categorySet where IdeaDisabilityType = ''DD''
					'
				end
			end
		end
		else if @reportCode in ('006')
		begin
			-- Ages 3-21, Has Disability, Duration >= 0.5 
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct rdp.K12StudentStudentIdentifierState, rdis.DimIdeaStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople rdp
					on fact.K12StudentId = rdp.DimPersonId
				inner join rds.DimAges age 
					on fact.AgeId = age.DimAgeId
					and age.AgeValue >= 3 
					and age.AgeValue <= 21
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
				inner join rds.DimIdeaStatuses rdis 
					on fact.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimDisciplineStatuses rdds 
					on fact.DisciplineStatusId = rdds.DimDisciplineStatusId
				where rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
					and rdis.IdeaIndicatorEdFactsCode = ''IDEA''
					and rdds.IdeaInterimRemovalEDFactsCode NOT IN (''REMDW'', ''REMHO'')
			) rules 
				on stu.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState
				and fact.IdeaStatusId = rules.DimIdeaStatusId '

		end
		else if @reportCode in ('088', '143')
		begin
			-- Ages 3-21, Has Disability, Duration >= 0.5 
			set @sqlCountJoins = @sqlCountJoins + '
				inner join #RULES rules 
					on stu.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState
					and fact.IdeaStatusId = rules.DimIdeaStatusId 
					and fact.DisciplineStatusId = rules.DimDisciplineStatusId '

			if CHARINDEX('DisciplinaryActionTaken', @categorySetReportFieldList) > 0 and CHARINDEX('IdeaInterimRemoval', @categorySetReportFieldList) > 0
			begin
				set @sqlCountJoins = @sqlCountJoins + ' 
				and CAT_IdeaInterimRemoval.IdeaInterimRemovalEdFactsCode <> ''MISSING''
				'
			end

		end
		else if @reportCode in ('134')
		BEGIN
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState,  titleI.DimTitleIStatusId	
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimTitleIStatuses titleI 
					on fact.TitleIStatusId = titleI.DimTitleIStatusId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				where titleI.TitleIIndicatorCode in (''01'',''02'',''03'',''04'')
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.TitleIStatusId = rules.DimTitleIStatusId'	
		END
		else if @reportCode in ('137') and @categorySetCode = 'CSB'
		BEGIN

			-- Assessment type = LanguageProficiency
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, assessment.DimAssessmentID, 
					min(adm.AssessmentAdministrationStartDate) as AssessedFirstTime	
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimAssessments assessment 
					on fact.AssessmentID = assessment.DimAssessmentID
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimAssessmentAdministrations adm on fact.AssessmentAdministrationId = adm.DimAssessmentAdministrationId
								and adm.AssessmentIdentifier = assessment.AssessmentIdentifierState
				where assessment.AssessmentTypeEdFactsCode = ''LanguageProficiency''
				group by fact.K12StudentId, p.K12StudentStudentIdentifierState, assessment.DimAssessmentID

			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.AssessmentID = rules.DimAssessmentID
				inner join RDS.DimAssessmentAdministrations CAT_ASSESSEDFIRSTTIME 
					on fact.AssessmentAdministrationId = CAT_ASSESSEDFIRSTTIME.DimAssessmentAdministrationId
					and rules.AssessedFirstTime = CAT_ASSESSEDFIRSTTIME.AssessmentAdministrationStartDate
				'	
			
		END
		else if @reportCode in('138' , '137', '139')
		BEGIN
			-- Assessment type = LanguageProficiency
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, assessment.DimAssessmentID	
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimAssessments assessment 
					on fact.AssessmentID = assessment.DimAssessmentID
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				where assessment.AssessmentTypeEdFactsCode = ''LanguageProficiency''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.AssessmentID = rules.DimAssessmentID'	
			
			if(@reportCode = '138')
			BEGIN
				set @sqlCountJoins = @sqlCountJoins +  '
										and fact.TitleIIIStatusId <> -1'
			END
		END
		else if @reportCode in ('144')
        begin
            -- Ages 3-21 (if has disability), Grads K-12 (if no disability)
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct rdp.K12StudentStudentIdentifierState, fact.IdeaStatusId, fact.GradeLevelId, fact.K12SchoolId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople rdp
					on fact.K12StudentId = rdp.DimPersonId
                inner join rds.DimAges rda 
					on fact.AgeId = rda.DimAgeId
                inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and CASE 
						WHEN fact.K12SchoolId > 0 THEN fact.K12SchoolId
						WHEN fact.LeaId > 0 THEN fact.LeaId
						WHEN fact.SeaId > 0 THEN fact.SeaId
						ELSE -1
					END <> -1
                inner join rds.DimIdeaStatuses rdis 
					on fact.IdeaStatusId = rdis.DimIdeaStatusId
				inner join rds.DimGradeLevels rdgl 
					on fact.GradeLevelId = rdgl.DimGradeLevelId
                where rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> ''PPPS''
					and ((rdis.IDEAIndicatorEdFactsCode = ''IDEA'' 
							and rda.AgeValue >= 3 and rda.AgeValue <= 21)
							or (rdis.IDEAIndicatorEdFactsCode = ''MISSING'' 
								and rdgl.GradeLevelCode in (''KG'', ''01'', ''02'', ''03'', ''04'', ''05'', ''06'', ''07'', ''08'', ''09'', ''10'', ''11'', ''12'')))
            ) rules 
				on stu.K12StudentStudentIdentifierState = rules.K12StudentStudentIdentifierState
				and fact.IdeaStatusId = rules.IdeaStatusId
				and fact.GradeLevelId = rules.GradeLevelId 
				and fact.K12SchoolId = rules.K12SchoolId
            '
		end
		else if @reportCode in ('175', '178', '179')
		begin
			set @queryFactFilter = 'and CAT_ASSESSMENTTYPEADMINISTERED.AssessmentAcademicSubjectEdFactsCode = '
			if(@reportCode = '175')
			begin
				set @queryFactFilter = @queryFactFilter + '''MATH'''
			end
			else if(@reportCode = '178')
			begin
				set @queryFactFilter = @queryFactFilter + '''RLA'''
			end
			else if(@reportCode = '179')
			begin
				set @queryFactFilter = @queryFactFilter + '''SCIENCE'''
			end
		end
		else if @reportCode in ('185', '188', '189')
		begin
			set @queryFactFilter = 'and assmnt.AssessmentAcademicSubjectEdFactsCode = '
			if(@reportCode = '185')
			begin
				set @queryFactFilter = @queryFactFilter + '''MATH'''
			end
			else if(@reportCode = '188')
			begin
				set @queryFactFilter = @queryFactFilter + '''RLA'''
			end
			else if(@reportCode = '189')
			begin
				set @queryFactFilter = @queryFactFilter + '''SCIENCE'''
			end
		end
		else if @reportCode in ('studentswdtitle1','037')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12SchoolId, p.K12StudentStudentIdentifierState, titleI.DimTitleIStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimTitleIStatuses titleI 
					on fact.TitleIStatusId = titleI.DimTitleIStatusId
				where titleI.TitleIIndicatorCode in (''01'',''02'',''03'',''04'')
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.TitleIStatusId = rules.DimTitleIStatusId'	
		end

		else if @reportCode in ('yeartoyearenvironmentcount')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, ideaStatus.DimIdeaStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimIdeaStatuses ideaStatus 
					on fact.IdeaStatusId = ideaStatus.DimIdeaStatusId
				where ideaStatus.IdeaEducationalEnvironmentForSchoolAgeCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.IdeaStatusId = rules.DimIdeaStatusId'
		end
		else if @reportCode in ('yeartoyearexitcount')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, ideaStatus.DimIdeaStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimIdeaStatuses ideaStatus 
					on fact.IdeaStatusId = ideaStatus.DimIdeaStatusId
				where ideaStatus.SpecialEducationExitReasonCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.IdeaStatusId = rules.DimIdeaStatusId'
		end
		else if @reportCode in ('yeartoyearremovalcount')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState disc.DimDisciplineStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimDisciplineStatuses disc 
					on fact.DisciplineStatusId = disc.DimDisciplineStatusId
				where disc.IdeaInterimRemovalCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.DisciplineStatusId = rules.DimDisciplineStatusId'
		end
		else if @reportCode in ('studentssummary')
		begin
			if @categorySetCode like ('disability%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, ideaStatus.DimIdeaDisabilityTypeId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId					
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimIdeaDisabilityTypes ideaStatus 
						on fact.PrimaryDisabilityTypeId = ideaStatus.DimIdeaDisabilityTypeId
					where ideaStatus.IdeaDisabilityTypeEdFactsCode <> ''MISSING''
				) rules 
					on fact.K12StudentId = rules.K12StudentId 
					and fact.PrimaryDisabilityTypeId = rules.DimIdeaDisabilityTypeId'
			end
			else if @categorySetCode like ('gender%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, demo.DimK12DemographicId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimK12Demographics demo 
						on fact.K12DemographicId = demo.DimK12DemographicId
					where demo.SexEdFactsCode <> ''MISSING''
				) rules 
					on fact.K12StudentId = rules.K12StudentId
					and fact.K12DemographicId = rules.DimK12DemographicId'
			end
			else if @categorySetCode like ('age%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, age.DimAgeId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimAges age 
						on fact.AgeId = age.DimAgeId
					where age.AgeEdFactsCode <> ''MISSING''
				) rules 
					on fact.K12StudentId = rules.K12StudentId 
					and fact.AgeId = rules.DimAgeId'
			end
			else if @categorySetCode like ('lepstatus%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, el.DimEnglishLearnerStatusId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimEnglishLearnerStatuses el 
						on fact.EnglishLearnerStatusId = el.DimEnglishLearnerStatusId
					where el.EnglishLearnerStatusEdFactsCode <> ''MISSING''
				) rules 
					on fact.K12StudentId = rules.K12StudentId 
					and fact.EnglishLearnerStatusId = rules.DimEnglishLearnerStatusId'
			end
			else if @categorySetCode like ('earlychildhood%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, ideaStatus.DimIdeaStatusId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimIdeaStatuses ideaStatus 
						on fact.IdeaStatusId = ideaStatus.DimIdeaStatusId
					where ideaStatus.IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode <> ''MISSING''
				) rules 
					on fact.K12StudentId = rules.K12StudentId 
					and fact.IdeaStatusId = rules.DimIdeaStatusId'
			end
			else if @categorySetCode like ('schoolage%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState, ideaStatus.DimIdeaStatusId
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimIdeaStatuses ideaStatus 
						on fact.IdeaStatusId = ideaStatus.DimIdeaStatusId
					where ideaStatus.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode <> ''MISSING''
				) rules 
					on fact.K12StudentId = rules.K12StudentId 
					and fact.IdeaStatusId = rules.DimIdeaStatusId'
			end
			else if @categorySetCode like ('raceethnic%')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimRaces race 
						on fact.RaceId = race.DimRaceId
				) rules 
					on fact.K12StudentId = rules.K12StudentId'
			end
		end
		else if @reportCode in ('indicator9', 'indicator10')
		begin
			-- Ages 6-21
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select  distinct fact.K12StudentId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimAges age 
					on fact.AgeId = age.DimAgeId
					and age.AgeValue >= 6 and age.AgeValue <= 21
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
			) rules		
				on fact.K12StudentId = rules.K12StudentId'
		end
		else if @reportCode in ('045')
		begin
			-- Ages 3-21
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimAges age 
					on fact.AgeId = age.DimAgeId
					and age.AgeValue >= 3 
					and age.AgeValue <= 21
				inner join rds.DimImmigrantStatuses immigrant 
					on fact.ImmigrantStatusId = immigrant.DimImmigrantStatusId
					and immigrant.TitleIIIImmigrantParticipationStatusEdFactsCode = ''IMMIGNTTTLIII''
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
			) rules 
				on fact.K12StudentId = rules.K12StudentId'
		end
		else if @reportCode in ('indicator4a', 'indicator4b')
		begin
			-- Ages 3-21
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimAges age 
					on fact.AgeId = age.DimAgeId
					and age.AgeValue >= 3 
					and age.AgeValue <= 21
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
			) rules 
				on fact.K12StudentId = rules.K12StudentId'
		end
		else if @reportCode in ('exitspecialeducation')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, idea.DimIdeaStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimIdeaStatuses idea 
					on fact.IdeaStatusId = idea.DimIdeaStatusId
				where idea.SpecialEducationExitReasonCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.IdeaStatusId = rules.DimIdeaStatusId'
		end
		else if @reportCode in ('121')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, ss.DimK12StudentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimK12StudentStatuses ss 
					on fact.K12StudentStatusId = ss.DimK12StudentStatusId
				where ss.MobilityStatus36moCode = ''QAD36''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.K12StudentStatusId = rules.DimK12StudentStatusId'
		end
		else if @reportCode in ('122')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, m.DimMigrantStatusId, studentStatuses.DimK12StudentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimMigrantStatuses m 
					on fact.MigrantStatusId = m.DimMigrantStatusId
				inner join rds.DimK12StudentStatuses studentStatuses 
					on fact.K12StudentStatusId = studentStatuses.DimK12StudentStatusId
				where m.MigrantEducationProgramEnrollmentTypeCode = ''MEPSUM'' 
					and studentStatuses.MobilityStatus36moCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.MigrantStatusId = rules.DimMigrantStatusId 
				and fact.K12StudentStatusId = rules.DimK12StudentStatusId'
		end
		else if @reportCode in ('127', '119')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, n.DimNorDStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimNOrDStatuses n 
					on fact.NorDStatusId = n.DimNorDStatusId
				where n.NeglectedOrDelinquentProgramTypeCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.NorDStatusId = rules.DimNorDStatusId'
		end
		else if @reportCode in ('054')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, m.DimMigrantStatusId, dgl.DimGradeLevelId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
				inner join rds.DimGradeLevels dgl 
					on fact.GradeLevelId = dgl.DimGradeLevelId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimMigrantStatuses m 
					on fact.MigrantStatusId = m.DimMigrantStatusId
				where m.MigrantStatusCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.MigrantStatusId = rules.DimMigrantStatusId 
				and fact.GradeLevelId = rules.DimGradeLevelId'
		end
		else if @reportCode in ('165')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, m.DimMigrantStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimMigrantStatuses m 
					on fact.MigrantStatusId = m.DimMigrantStatusId
				where m.MigrantStatusCode <> ''MISSING''
			) rules 
				on fact.K12StudentId = rules.K12StudentId 
				and fact.MigrantStatusId = rules.DimMigrantStatusId'
		end
		else if @reportCode in ('082')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, cteStatus.DimCteStatusId, enrStatus.DimEnrollmentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimCteStatuses cteStatus 
					on fact.CteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimEnrollmentStatuses enrStatus 
					on fact.EnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteConcentratorCode <> ''MISSING'' 
				and enrStatus.ExitOrWithdrawalTypeCode in (''01921'',''01922'',''01923'',''01924'',''01925'',''01926'',''01927'',''01928'',''01930'',''01931'',''03502'',''03504'',''03505''
				,''03509'',''09999'',''73060'',''73601'')
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.CteStatusId = rules.DimCteStatusId 
				and fact.EnrollmentStatusId = rules.DimEnrollmentStatusId'
		end
		else if @reportCode in ('118')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId '
			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimGradeLevels dgl 
						on fact.GradeLevelId = dgl.DimGradeLevelId
					inner join rds.DimHomelessnessStatuses homeless 
						on homeless.DimHomelessnessStatusId = fact.HomelessnessStatusId
				'	
		end	
		else if @reportCode in ('160')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId,  studentStatus.DimK12EnrollmentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimK12EnrollmentStatuses studentStatus 
					on studentStatus.DimK12EnrollmentStatusId=fact.K12EnrollmentStatusId
				where studentStatus.PostSecondaryEnrollmentStatusEdFactsCode<>''MISSING''	
			) rules
				on fact.K12StudentId = rules.K12StudentId  
				and fact.K12EnrollmentStatusId = rules.DimK12EnrollmentStatusId'
		end
		else if @reportCode in ('204')
		begin
			if(@tableTypeAbbrv='T3ELNOTPROF')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, dimTitleIII.DimTitleIIIStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimTitleIIIStatuses dimTitleIII 
						on dimTitleIII.DimTitleIIIStatusId=fact.TitleIIIStatusId
					where dimTitleIII.FormerEnglishLearnerYearStatusCode=''5YEAR'' 
					and dimTitleIII.ProficiencyStatusEdFactsCode=''NOTPROFICIENT''  		
				) rules
					on fact.K12StudentId = rules.K12StudentId 
					and fact.TitleiiiStatusId = rules.DimTitleIIIStatusId'
			end
			else if (@tableTypeAbbrv='T3ELEXIT')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, dimTitleIII.DimTitleIIIStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimTitleIIIStatuses dimTitleIII 
						on dimTitleIII.DimTitleIIIStatusId=fact.TitleIIIStatusId
					where dimTitleIII.ProficiencyStatusEdFactsCode =''PROFICIENT''  		
				) rules
					on fact.K12StudentId = rules.K12StudentId 
					and fact.TitleiiiStatusId = rules.DimTitleIIIStatusId'
			end
		end
		else if @reportCode in ('150')
		begin
			-- calculated cohort length
			-- (Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength
			if(@tableTypeAbbrv='GRADRT4YRADJ')
			begin
				set @cohortYear = '4'
				set @cohortYearTotal = '4'
			end
			if(@tableTypeAbbrv='GRADRT5YRADJ')
			begin
				set @cohortYear = '4,5'
				set @cohortYearTotal = '5'
			end
			if(@tableTypeAbbrv='GRADRT6YRADJ')
			begin
				set @cohortYear = '4,5,6'
				set @cohortYearTotal = '6'
			end
			if(@tableTypeAbbrv='GRADRT7YRADJ')
			begin
				set @cohortYear = '4,5,6,7'
				set @cohortYearTotal = '7'
			end
			if(@tableTypeAbbrv='GRADRT8YRADJ')
			begin
				set @cohortYear = '4,5,6,7,8'
				set @cohortYearTotal = '8'
			end
			if(@tableTypeAbbrv='GRADRT9YRADJ')
			begin
				set @cohortYear = '4,5,6,7,8,9'
				set @cohortYearTotal = '9'
			end
			if(@tableTypeAbbrv='GRADRT10YRADJ')
			begin
				set @cohortYear = '4,5,6,7,8,9,10'
				set @cohortYearTotal = '10'
			end
			-- add cohort Total filter		-- used to calculate cohort total to the year
			set @sqlCountTotalJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, students.Cohort, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimPeople students 
						on students.DimPersonId = fact.K12StudentId
					where (Convert(int,SUBSTRING(students.Cohort,6,4)) - Convert(int,SUBSTRING(students.Cohort,1,4))) in (' + @cohortYearTotal + ')
					and students.Cohort is not null
				) rules
					on fact.K12StudentId = rules.K12StudentId
			'
			-- add cohort filter
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, students.Cohort, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimPeople students 
					on students.DimPersonId = fact.K12StudentId
				where (Convert(int,SUBSTRING(students.Cohort,6,4)) - Convert(int,SUBSTRING(students.Cohort,1,4))) in (' + @cohortYear + ')
				and students.Cohort is not null
			) rules
				on fact.K12StudentId = rules.K12StudentId
		'
			
		end
		else if @reportCode in ('151')
		begin
			-- calculated cohort length
			-- (Convert(int,SUBSTRING(Cohort,6,4)) - Convert(int,SUBSTRING(Cohort,1,4))) as CohortLength
			if(@tableTypeAbbrv='GRADCOHORT4YR')
			begin
				set @cohortYear = '4'
			end
			if(@tableTypeAbbrv='GRADCOHORT5YR')
			begin
				set @cohortYear = '5'
			end
			if(@tableTypeAbbrv='GRADCOHORT6YR')
			begin
				set @cohortYear = '6'
			end
			if(@tableTypeAbbrv='GRADCOHORT7YR')
			begin
				set @cohortYear = '7'
			end
			if(@tableTypeAbbrv='GRADCOHORT8YR')
			begin
				set @cohortYear = '8'
			end
			if(@tableTypeAbbrv='GRADCOHORT9YR')
			begin
				set @cohortYear = '9'
			end
			if(@tableTypeAbbrv='GRADCOHORT10YR')
			begin
				set @cohortYear = '10'
			end
			-- add cohort filter
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, students.Cohort, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimPeople students 
					on students.DimPersonId = fact.K12StudentId
				where (Convert(int,SUBSTRING(students.Cohort,6,4)) - Convert(int,SUBSTRING(students.Cohort,1,4))) = ' + @cohortYear + '
				and students.Cohort is not null
			) rules
				on fact.K12StudentId = rules.K12StudentId
		'
		end
		else if @reportCode in ('083')
		begin

			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, cteStatus.DimCteStatusId, enrStatus.DimEnrollmentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimCteStatuses cteStatus 
					on fact.CteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimEnrollmentStatuses enrStatus 
					on fact.EnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteConcentratorCode <> ''MISSING'' 
				and enrStatus.ExitOrWithdrawalTypeCode = ''01921''
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.CteStatusId = rules.DimCteStatusId 
				and fact.EnrollmentStatusId = rules.DimEnrollmentStatusId'

		end
		else if @reportCode in ('154')
		begin

			set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.K12StudentId, cteStatus.DimCteStatusId, enrStatus.DimK12EnrollmentStatusId, p.K12StudentStudentIdentifierState
				from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimCteStatuses cteStatus 
					on fact.CteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimK12EnrollmentStatuses enrStatus 
					on fact.K12EnrollmentStatusId = enrStatus.DimK12EnrollmentStatusId
				where cteStatus.CteConcentratorCode <> ''MISSING'' 
				and enrStatus.ExitOrWithdrawalTypeCode in (''01921'',''01922'',''01923'',''01924'',''01925'',''01926'',''01927'',''01928'',''01930'',''01931'',''03502'',''03504'',''03505''
				,''03509'',''09999'',''73060'',''73601'')
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.CteStatusId = rules.DimCteStatusId 
				and fact.K12EnrollmentStatusId = rules.DimK12EnrollmentStatusId'
		end
		else if @reportCode in ('155')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimCteStatuses dps on dps.DimCteStatusId=fact.CteStatusId
															and dps.CteParticipantCode <> ''MISSING''
			'
		end
		else if @reportCode in ('156')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, ss.DimCteStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				left join rds.DimCteStatuses ss 
					on fact.CteStatusId = ss.DimCteStatusId
				where ss.CteNontraditionalGenderStatusCode = ''NTE'' 
				and cteStatus.CteConcentratorCode <> ''MISSING''
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.CteStatusId = rules.DimCteStatusId'
		end
		else if @reportCode in ('158')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, cteStatus.DimCteStatusId, enrStatus.DimK12EnrollmentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimCteStatuses cteStatus 
					on fact.CteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimK12EnrollmentStatuses enrStatus 
					on fact.K12EnrollmentStatusId = enrStatus.DimK12EnrollmentStatusId
				where cteStatus.CteConcentratorCode <> ''MISSING''
				and enrStatus.ExitOrWithdrawalTypeCode = ''01921'' 
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.CteStatusId = rules.DimCteStatusId 
				and fact.K12EnrollmentStatusId = rules.DimK12EnrollmentStatusId'	

		end
		else if @reportCode in ('169')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, cteStatus.DimCteStatusId, enrStatus.DimK12EnrollmentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimCteStatuses cteStatus 
					on fact.CteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimK12EnrollmentStatuses enrStatus 
					on fact.K12EnrollmentStatusId = enrStatus.DimK12EnrollmentStatusId
				where cteStatus.CteConcentratorCode <> ''MISSING'' 
				and enrStatus.ExitOrWithdrawalTypeCode = ''01921'' 
			) rules
				on fact.K12StudentId = rules.K12StudentId  
				and fact.CteStatusId = rules.DimCteStatusId 
				and fact.K12EnrollmentStatusId = rules.DimK12EnrollmentStatusId'

		end
	    else if @reportCode in ('032')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, enrStatus.DimK12EnrollmentStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimK12EnrollmentStatuses enrStatus 
					on fact.K12EnrollmentStatusId = enrStatus.DimK12EnrollmentStatusId
				where enrStatus.ExitOrWithdrawalTypeCode = ''01927''
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.K12EnrollmentStatusId = rules.DimK12EnrollmentStatusId'
		end
		else if @reportCode in ('040')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')
				inner join #Grades grades on grades.OrganizationStateId = org.LeaIdentifierSea
				inner join #Membership membership on membership.OrganizationIdentifierSea = org.LeaIdentifierSea'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')
				inner join #Grades grades on grades.OrganizationStateId = org.SchoolIdentifierSea
				inner join #Membership membership on membership.OrganizationIdentifierSea = org.SchoolIdentifierSea'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
			) rules
				on fact.K12StudentId = rules.K12StudentId
				inner join RDS.DimK12AcademicAwardStatuses awardStatus 
					on fact.K12AcademicAwardStatusId = awardStatus.DimK12AcademicAwardStatusId
				AND awardStatus.HighSchoolDiplomaTypeEDFactsCode IN (''REGDIP'',''OTHCOM'')
			'
		end
		else if @reportCode in ('033')
		begin
			if @tableTypeAbbrv in ('LUNCHFREERED')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, p.K12StudentStudentIdentifierState
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')
					inner join #Membership membership 
						on membership.OrganizationIdentifierSea = org.SchoolIdentifierSea' 
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					) rules
						on fact.K12StudentId = rules.K12StudentId'

				--Check toggle to add a condition to exclude counts not used by the state
				if @toggleFreeLunch = 'Direct Certification Only'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
						and fact.SeaId = 999
						'
				end
			end
			else if @tableTypeAbbrv in ('DIRECTCERT')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.K12StudentId, fact.EconomicallyDisadvantagedStatusId, p.K12StudentStudentIdentifierState
						from rds.' + @factTable + ' fact '

				if @reportLevel = 'lea'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
				end 
				if @reportLevel = 'sch'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						AND org.ReportedFederally = 1
						AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')
					inner join #Membership membership 
						on membership.OrganizationIdentifierSea = org.SchoolIdentifierSea' 
				end

				set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimPeople p
						on fact.K12StudentId = p.DimPersonId
					inner join rds.DimK12Schools s 
						on fact.K12SchoolId = s.DimK12SchoolId
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
					inner join rds.DimEconomicallyDisadvantagedStatuses dss 
						on fact.EconomicallyDisadvantagedStatusId = dss.DimEconomicallyDisadvantagedStatusId
					where dss.NationalSchoolLunchProgramDirectCertificationIndicatorCode = ''YES''
					) rules
						on fact.K12StudentId = rules.K12StudentId 
						and fact.EconomicallyDisadvantagedStatusId = rules.EconomicallyDisadvantagedStatusId'

				--Check toggle to add a condition to exclude counts not used by the state
				if @toggleFreeLunch = 'Free and Reduced Only'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
						and fact.SeaId = 999
						'
				end
			end
		end
		else if @reportCode in ('141')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join #Students rules
					on fact.K12StudentId = rules.K12StudentId 
					and fact.EnglishLearnerStatusId =  rules.DimEnglishLearnerStatusId 
					and fact.GradelevelId =  rules.DimGradelevelId'
		end
		else if @reportCode in ('194')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, homelessStatus.DimHomelessnessStatusId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel in ('sea', 'lea')
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')
					AND org.McKinneyVentoSubgrantRecipient = ''1'''
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s 
					on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimHomelessnessStatuses homelessStatus 
					on homelessStatus.DimHomelessnessStatusId = fact.HomelessnessStatusId
				where homelessStatus.HomelessServicedIndicatorCode = ''Yes''
				and fact.GradeLevelId in (-1, 1)
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.HomelessnessStatusId =  rules.DimHomelessnessStatusId'
		end
		else if @reportCode in ('195')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.K12StudentId, m.DimAttendanceId, p.K12StudentStudentIdentifierState
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimPeople p
					on fact.K12StudentId = p.DimPersonId
				inner join rds.DimK12Schools s on fact.K12SchoolId = s.DimK12SchoolId
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1
				inner join rds.DimAttendances m on fact.AttendanceId = m.DimAttendanceId
				where m.AbsenteeismCode = ''CA''
			) rules
				on fact.K12StudentId = rules.K12StudentId 
				and fact.AttendanceId = rules.DimAttendanceId'
		end
		else if @reportCode ='052'
		begin
				set @queryFactFilter = ''	
		end
		else if @reportCode in ('070')
		begin
		
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					SELECT distinct fact.K12StaffId, s.DimK12StaffCategoryId
				from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimK12StaffCategories s 
						on fact.K12StaffCategoryId = s.DimK12StaffCategoryId				
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
					where s.K12StaffClassificationCode = ''SpecialEducationTeachers''
				) rules
				on fact.K12StaffId = rules.K12StaffId 
				and fact.K12StaffCategoryId = rules.DimK12StaffCategoryId'

		end
		else if @reportCode in ('112')
		begin
		
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					SELECT distinct fact.K12StaffId, s.DimK12StaffCategoryId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimK12StaffCategories s 
					on fact.K12StaffCategoryId = s.DimK12StaffCategoryId				
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
				where s.K12StaffClassificationCode = ''Paraprofessionals''
			) rules
				on fact.K12StaffId = rules.K12StaffId 
				and fact.K12StaffCategoryId = rules.DimK12StaffCategoryId'

		end
		else if @reportCode in ('067')
		begin

			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					SELECT distinct fact.K12StaffId, title3.DimTitleIIIStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimTitleIIIStatuses title3 
					on fact.TitleIIIStatusId = title3.DimTitleIIIStatusId				
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and fact.K12SchoolId <> -1
				where title3.TitleIIILanguageInstructionProgramTypeCode <> ''MISSING''
			) rules
				on fact.K12StaffId = rules.K12StaffId 
				and fact.TitleiiiStatusId = rules.DimTitleIIIStatusId'
		end

		else if @reportCode in ('203')
		begin

			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					SELECT distinct fact.K12StaffId, s.DimK12StaffStatusId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimLeas org 
					on fact.LeaId = org.DimLeaId
					AND org.ReportedFederally = 1
					AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.DimK12Schools org 
					on fact.K12SchoolId = org.DimK12SchoolId
					AND org.ReportedFederally = 1
					AND org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
				inner join rds.DimK12StaffStatuses s 
					on fact.K12StaffStatusId = s.DimK12StaffStatusId				
					and fact.SchoolYearId = @dimSchoolYearId
					and fact.FactTypeId = @dimFactTypeId
					and fact.LeaId <> -1
			) rules
				on fact.K12StaffId = rules.K12StaffId 
				and fact.K12StaffStatusId = rules.DimK12StaffStatusId'
		end

		else if @reportCode in ('059')
		begin

			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					SELECT distinct fact.K12StaffId, s.DimK12StaffCategoryId
					from rds.' + @factTable + ' fact '

			if @reportLevel = 'lea'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimLeas org 
						on fact.LeaId = org.DimLeaId
						AND org.ReportedFederally = 1
						AND org.LeaOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedBoundary'')'
			end 
			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.DimK12Schools org 
						on fact.K12SchoolId = org.DimK12SchoolId
						and org.ReportedFederally = 1
						and org.SchoolOperationalStatus in  (''New'', ''Added'', ''Open'', ''Reopened'', ''ChangedAgency'')'
			end

			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimK12StaffCategories s 
						on fact.K12StaffCategoryId = s.DimK12StaffCategoryId				
						and fact.SchoolYearId = @dimSchoolYearId
						and fact.FactTypeId = @dimFactTypeId
						and fact.LeaId <> -1'

			if @reportLevel = 'sch'
			begin
				set @sqlCountJoins = @sqlCountJoins + '
					where s.K12StaffClassificationCode in (''PrekindergartenTeachers'',''KindergartenTeachers'',''ElementaryTeachers'',''SecondaryTeachers'',''UngradedTeachers'')
				'
			end

			set @sqlCountJoins = @sqlCountJoins + '
			) rules
				on fact.K12StaffId = rules.K12StaffId 
				and fact.K12StaffCategoryId = rules.DimK12StaffCategoryId'

		end
		
		-- Insert actual count data
		if(@factReportTable = 'ReportEDFactsK12StaffCounts')
		begin
			if(@reportCode = '099')
			begin

				if @reportLevel = 'sea' 
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join ( select K12StaffId, K12StaffCategoryId, sum(round(StaffFullTimeEquivalency, 2)) as StaffFullTimeEquivalency
							from rds.FactK12StaffCounts fact 
							where fact.SchoolYearId = @dimSchoolYearId and fact.FactTypeId = @dimFactTypeId 
							and fact.SeaId <> -1
							group by K12StaffId, K12StaffCategoryId
						) K12StaffCount on K12StaffCount.K12StaffId = fact.K12StaffId 
							and K12StaffCount.K12StaffCategoryId = fact.K12StaffCategoryId' 
				end
				else
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join ( select K12StaffId, LeaId, K12StaffCategoryId, sum(round(StaffFullTimeEquivalency, 2)) as StaffFullTimeEquivalency
							from rds.FactK12StaffCounts fact 
							where fact.SchoolYearId = @dimSchoolYearId and fact.FactTypeId = @dimFactTypeId 
							and fact.LeaId <> -1
							group by K12StaffId, LeaId, K12StaffCategoryId
						) K12StaffCount on K12StaffCount.K12StaffId = fact.K12StaffId
							and K12StaffCount.LeaId = fact.LeaId
							and K12StaffCount.K12StaffCategoryId = fact.K12StaffCategoryId' 
				end
			
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimK12SchoolId int,'
					end + '			
					DimK12StaffId int, K12StudentStudentIdentifierState VARCHAR(60) ' + @sqlCategoryFieldDefs + ',
					StaffCount int,
					' + @factField + ' decimal(18,2)
				)

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimK12SchoolId,'
					end +
				'DimK12StaffId' + @sqlCategoryFields + ',StaffCount, ' + @factField + ')
				 select distinct ' + case   when @reportLevel = 'sea' then 'fact.SeaId,'
											when @reportLevel = 'lea' then 'fact.LeaId,' 
											else 'fact.K12SchoolId,'
					end +
				 'fact.K12StaffId' 
				+ @sqlCategoryQualifiedDimensionFields 
				+ ', isnull(fact.StaffCount, 0) as StaffCount,'
				+ 'isnull(K12StaffCount.StaffFullTimeEquivalency, 0.0) as StaffFullTimeEquivalency'
				+ ' from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							 else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
				'
			end
			else if(@reportCode in ('059','067','070','112','203'))
			begin
				set @sql = @sql + '
				----------------------------
				-- Insert actual count data 
				----------------------------
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimK12SchoolId int,'
					end + '			
					DimK12StaffId int' + @sqlCategoryFieldDefs + ',
					StaffCount int,
					' + @factField + ' decimal(18,2)
				)

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimK12SchoolId,'
					end +
				'DimK12StaffId' + @sqlCategoryFields + ',StaffCount, ' + @factField + ')
				 select distinct ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
										  when @reportLevel = 'lea' then 'fact.LeaId,' 
									      else 'fact.K12SchoolId,'
					end + 'fact.K12StaffId' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.StaffCount, 0)),
				sum(round(isnull(fact.' + @factField + ', 0.0), 2))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins + '
				where fact.SchoolYearId = @dimSchoolYearId 
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							 else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								   when @reportLevel = 'lea' then 'fact.LeaId,'
								   else 'fact.K12SchoolId,'
								 end +
				'fact.K12StaffId' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else
			begin
				set @sql = @sql + '
				----------------------------
				-- Insert actual count data 
				----------------------------
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int'
						   when @reportLevel = 'lea' then 'DimLeaId int' 
						   else 'DimK12SchoolId int'
					end + @sqlCategoryFieldDefs + ',
					StaffCount int,
					' + @factField + ' decimal(18,2)
				)

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId'
						  when @reportLevel = 'lea' then 'DimLeaId' 
						  else 'DimK12SchoolId'
					end + @sqlCategoryFields + ',StaffCount, ' + @factField + ')
				 select  ' + case when @reportLevel = 'sea' then 'fact.SeaId'
						when @reportLevel = 'lea' then 'fact.LeaId' 
						     else 'fact.K12SchoolId'
					end + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.StaffCount, 0)),
				sum(round(isnull(fact.' + @factField + ', 0.0), 2))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins + '
				where fact.SchoolYearId = @dimSchoolYearId 
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							 else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId'
								   when @reportLevel = 'lea' then 'fact.LeaId'
								   else 'fact.K12SchoolId'
								 end +
				@sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
		end		-- END @factReportTable = 'ReportEDFactsK12StaffCounts'
		else
		begin
			if(@reportCode = '009')
			begin
				set @sql = @sql + '
					----------------------------
					-- Insert actual count data 
					-- default ReportEDFactsK12StudentCounts
					----------------------------
		
					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
							when @reportLevel = 'lea' then 'DimLeaId int,' 
							else 'DimK12SchoolId int,'
					end + 'K12StudentStudentIdentifierState varchar(60) '  + @sqlCategoryFieldDefs + ',
					SpecialEducationServicesExitDate datetime,
					' + @factField + ' int,

					)

							' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

					truncate table #categorySet


					-- Actual Counts
					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
								when @reportLevel = 'lea' then 'DimLeaId,' 
								else 'DimK12SchoolId,'
						end + 'K12StudentStudentIdentifierState'  + @sqlCategoryFields + ', SpecialEducationServicesExitDate, ' + @factField + ')
					select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
										when @reportLevel = 'lea' then 'fact.LeaId,' 
										else 'fact.K12SchoolId,'
						end + 'rules.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
						exitDate.DateValue as SpecialEducationServicesExitDate,
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact  
						inner join rds.DimPeople p
							on fact.k12StudentId = p.DimPersonId '
					+ @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
									when @reportLevel = 'lea' then 'fact.LeaId <> -1'
									else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
					and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition +
					' group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
										when @reportLevel = 'lea' then 'fact.LeaId,'
										else 'fact.K12SchoolId,'
										end + 'rules.K12StudentStudentIdentifierState'  + @sqlCategoryQualifiedDimensionGroupFields + ',
										exitDate.DateValue
					' + @sqlHavingClause + '
					'
			end		-- END @factReportTable = 'ReportEDFactsK12StudentCounts'
			else if(@reportCode = '006')
			begin

				if CHARINDEX('DisciplineMethodOfChildrenWithDisabilities', @categorySetReportFieldList) = 0 
				begin
					set @reportFilterJoin = @reportFilterJoin + 'inner join rds.DimDisciplineStatuses di on fact.DisciplineStatusId = di.DimDisciplineStatusId'
					set @reportFilterCondition = @reportFilterCondition + ' and (di.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode <> ''MISSING'' or di.DisciplinaryactionTakenEdFactsCode in (''03086'',''03087'')) '
					set @reportFilterCondition = @reportFilterCondition + ' and di.IdeaInterimRemovalEDFactsCode NOT IN (''REMDW'', ''REMHO'') '
				end
				else
				begin
					set @reportFilterCondition = @reportFilterCondition + ' and (CAT_DisciplineMethodOfChildrenWithDisabilities.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode <> ''MISSING''  or CAT_DisciplineMethodOfChildrenWithDisabilities.DisciplinaryactionTakenEdFactsCode in (''03086'',''03087'')) '
					set @reportFilterCondition = @reportFilterCondition + ' and CAT_DisciplineMethodOfChildrenWithDisabilities.IdeaInterimRemovalEDFactsCode NOT IN (''REMDW'', ''REMHO'') '
				end

				if CHARINDEX('PrimaryDisabilityType', @categorySetReportFieldList) > 0 
				begin
					set @sqlCategoryQualifiedSubDimensionFields = @sqlCategoryQualifiedSubDimensionFields 
							+ ', CAT_PRIMARYDISABILITYTYPE.IdeaDisabilityTypeCode'
					set @sqlCategoryQualifiedSubGroupDimensionFields = @sqlCategoryQualifiedSubGroupDimensionFields + ',fact.IdeaDisabilityTypeCode'
				end

				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + '
				K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'
				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case	when @reportLevel = 'sea' then 'DimSeaId,'
							when @reportLevel = 'lea' then 'DimLeaId,' 
							else 'DimK12SchoolId,'
				end  + 'K12StudentStudentIdentifierState' 
				+ @sqlCategoryFields + ', ' + @factField + ')
				select ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,' 
								else 'fact.K12SchoolId,'
				end + 'fact.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedSubSelectDimensionFields + ',
				sum(isnull(fact.' + @factField + ', 0))
				from ( select ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,' 
								else 'fact.K12SchoolId,'
				end + 'stu.K12StudentStudentIdentifierState,sum(fact.DisciplineCount) as DisciplineCount, sum(fact.DurationOfDisciplinaryAction) as DurationOfDisciplinaryAction' 
				+ @sqlCategoryQualifiedSubDimensionFields + 
				' from rds.' + @factTable + ' fact '
				+ ' join rds.DimPeople stu on fact.K12StudentId = stu.DimPersonId '
				+ @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
								when @reportLevel = 'lea' then 'fact.LeaId <> -1'
								else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end   + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
									when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedSubDimensionFields +
				+ ' having SUM(fact.DurationOfDisciplinaryAction) >= 0.5 ) as fact
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'fact.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedSubGroupDimensionFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('088'))
			begin
							
				-- Add the filter for half day or more removals to handle cases 
				-- where a student doesn't meet the threshold at the LEA level. 
				-- RL 2/5/2025 ------------------------------------------------------
				if @reportLevel = 'lea' and @sqlHavingClause = ''
				begin
					set @sqlHavingClause = 'having SUM(fact.DurationOfDisciplinaryAction) >= 0.5 '
				end 

				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + '
				K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ', DurationOfDisciplinaryAction decimal(18, 2), 
					' + @factField + ' int
				)
				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'
				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'K12StudentStudentIdentifierState' 
				+ @sqlCategoryFields + ', DurationOfDisciplinaryAction, ' + @factField + ')
				select ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
					when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.DurationOfDisciplinaryAction, 0)),
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' 
				+ ' join rds.DimPeople stu on fact.K12StudentId = stu.DimPersonId '
				+ @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case   when @reportLevel = 'sea' then 'fact.SeaId,'
									when @reportLevel = 'lea' then 'fact.LeaId,'
									else 'fact.K12SchoolId,'
								end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('143'))
			begin
							
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + '
				K12StudentStudentIdentifierState varchar(50), DisciplinaryActionTaken varchar(100), IdeaInterimRemoval varchar(100)' + @sqlCategoryFieldDefs + 
				', DurationOfDisciplinaryAction decimal(18, 2), 
					' + @factField + ' int
				)
				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'
				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'K12StudentStudentIdentifierState, DisciplinaryActionTaken, IdeaInterimRemoval' 
				+ @sqlCategoryFields + ', DurationOfDisciplinaryAction, ' + @factField + ')
				select ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end  + 'stu.K12StudentStudentIdentifierState, CAT_DisciplinaryActionTaken.DisciplinaryActionTakenEdFactsCode, CAT_IdeaInterimRemoval.IdeaInterimRemovalEdFactsCode' 
				+ @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.DurationOfDisciplinaryAction, 0)),
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' 
				+ ' join rds.DimPeople stu on fact.K12StudentId = stu.DimPersonId '
				+ @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end  + 'stu.K12StudentStudentIdentifierState, CAT_DisciplinaryActionTaken.DisciplinaryActionTakenEdFactsCode, CAT_IdeaInterimRemoval.IdeaInterimRemovalEdFactsCode' 
								+ @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('007'))
			begin
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------

				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + 'K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
				DurationOfDisciplinaryAction decimal(18, 2),
				' + @factField + ' int
			)
		

				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'K12StudentStudentIdentifierState' + @sqlCategoryFields + ', DurationOfDisciplinaryAction, ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
					when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.DurationOfDisciplinaryAction, 0)),
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' 
				+ ' join rds.DimPeople stu on fact.K12StudentId = stu.DimPersonId '
				+ @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('005','144','disciplinaryremovals'))
			begin
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------

				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + 'K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
				DurationOfDisciplinaryAction decimal(18, 2),
				' + @factField + ' int
			)
		

				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'K12StudentStudentIdentifierState' + @sqlCategoryFields + ', DurationOfDisciplinaryAction, ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
					when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.DurationOfDisciplinaryAction, 0)),
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' 
				+ ' join rds.DimPeople stu on fact.K12StudentId = stu.DimPersonId '
				+ @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('086'))
			begin
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------

				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + 'K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
				IncidentIdentifier varchar(40),
				' + @factField + ' int
			)
		

				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'K12StudentStudentIdentifierState' + @sqlCategoryFields + ', IncidentIdentifier, ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
					when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end + 'stu.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
				fact.IncidentIdentifier,
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' 
				+ ' join rds.DimPeople stu on fact.K12StudentId = stu.DimPersonId '
				+ @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'stu.K12StudentStudentIdentifierState, fact.IncidentIdentifier' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('137') and @categorySetCode = 'CSB')
			begin
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------

				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + 'DimStudentId int, K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ', FirstAssessed varchar(50) ,
				' + @factField + ' int
			)
		

				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'DimStudentId, K12StudentStudentIdentifierState' + @sqlCategoryFields + ', FirstAssessed ,' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
					when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end + 'fact.K12StudentId, p.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ', 
				case when min(rules.AssessedFirstTime) is not null then ''FIRSTASSESS'' else ''MISSING'' end ,
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				inner join rds.DimPeople p on fact.K12StudentId = p.DimPersonId 
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'fact.K12StudentId, p.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('175', '178', '179', '185', '188', '189', '157', '137', '139'))
			begin
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------

				create table #categorySet (	' 
				+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						when @reportLevel = 'lea' then 'DimLeaId int,' 
						else 'DimK12SchoolId int,'
				end + 'DimStudentId int, K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
				' + @factField + ' int
			)
		

				' + case when @reportLevel = 'sea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
				'    when @reportLevel = 'lea' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
				' 	 when @reportLevel = 'sch' then '
				CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
				'    else ''
				end +
				'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						when @reportLevel = 'lea' then 'DimLeaId,' 
						else 'DimK12SchoolId,'
				end + 'DimStudentId, K12StudentStudentIdentifierState' + @sqlCategoryFields + ', ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
					when @reportLevel = 'lea' then 'fact.LeaId,' 
						    else 'fact.K12SchoolId,'
				end + 'fact.K12StudentId, p.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				inner join rds.DimPeople p on fact.K12StudentId = p.DimPersonId 
				where fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
								when @reportLevel = 'lea' then 'fact.LeaId,'
								else 'fact.K12SchoolId,'
								end + 'fact.K12StudentId, p.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode IN ('yeartoyearchildcount','yeartoyearenvironmentcount','yeartoyearexitcount','yeartoyearremovalcount'))
			begin
		
				set @sql = @sql + '
				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int'
						   when @reportLevel = 'lea' then 'DimLeaId int' 
						   else 'DimK12SchoolId int'
					end + ', K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId'
						  when @reportLevel = 'lea' then 'DimLeaId' 
						  else 'DimK12SchoolId'
					end + ', K12StudentStudentIdentifierState' + @sqlCategoryFields + ', ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId'
								 when @reportLevel = 'lea' then 'fact.LeaId' 
								 else 'fact.K12SchoolId'
					end + ', rules.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							 else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId'
								   when @reportLevel = 'lea' then 'fact.LeaId'
								   else 'fact.K12SchoolId'
								 end + 'rules.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode IN ('studentssummary'))
			begin
		
				set @sql = @sql + '
				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int'
						   when @reportLevel = 'lea' then 'DimLeaId int' 
						   else 'DimK12SchoolId int'
					end + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
			
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId'
						  when @reportLevel = 'lea' then 'DimLeaId' 
						  else 'DimK12SchoolId'
					end + @sqlCategoryFields + ', ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId'
								 when @reportLevel = 'lea' then 'fact.LeaId' 
								 else 'fact.K12SchoolId'
					end + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.LeaId <> -1'
							 else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId'
								   when @reportLevel = 'lea' then 'fact.LeaId'
								   else 'fact.K12SchoolId'
								 end + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('150'))
			begin
				set @sql = @sql + '
					----------------------------
					-- Insert actual count data 
					-- default ReportEDFactsK12StudentCounts
					----------------------------
		

					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int'
							when @reportLevel = 'lea' then 'DimLeaId int' 
							else 'DimK12SchoolId int'
					end + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

					truncate table #categorySet

					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId'
								when @reportLevel = 'lea' then 'DimLeaId' 
								else 'DimK12SchoolId'
						end + @sqlCategoryFields + ', ' + @factField + ')
					select  ' + case when @reportLevel = 'sea' then 'fact.SeaId'
										when @reportLevel = 'lea' then 'fact.LeaId' 
										else 'fact.K12SchoolId'
						end + @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
									when @reportLevel = 'lea' then 'fact.LeaId <> -1'
									else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
					and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
					group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId'
										when @reportLevel = 'lea' then 'fact.LeaId'
										else 'fact.K12SchoolId'
										end + @sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
					'
				-- add calculate total temp table
				set @sql = @sql + '
					---------------------------
					-- calculate cohort total
					---------------------------
					create table #categoryCohortSet ( '				
					+ case when @reportLevel = 'sea' then 'DimSeaId int'
							when @reportLevel = 'lea' then 'DimLeaId int' 
							else 'DimK12SchoolId int'
						end  + @sqlCategoryFieldDefs + ',
						' + @factField + ' int
					)
						
					' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategoryCohortSet ON #categoryCohortSet(DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategoryCohortSet ON #categoryCohortSet(DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategoryCohortSet ON #categoryCohortSet(DimK12SchoolId)
					'    else ''
					end +
					'
					truncate table #categoryCohortSet
					--------------------------------
					-- cohort total
					--------------------------------	
					declare @CohortTotal decimal(18,2)
					set @CohortTotal = 0

					
					-- Actual Total Counts
					insert into #categoryCohortSet
					(' + case when @reportLevel = 'sea' then 'DimSeaId'
								when @reportLevel = 'lea' then 'DimLeaId' 
								else 'DimK12SchoolId'
						end  + @sqlCategoryFields + ', ' + @factField + ')
					select  ' + case when @reportLevel = 'sea' then 'fact.SeaId'
								when @reportLevel = 'lea' then 'fact.LeaId' 
								else 'fact.K12SchoolId'
					end + @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + @sqlCountTotalJoins 
					+ ' ' + @reportFilterJoin + '
					where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
									when @reportLevel = 'lea' then 'fact.LeaId <> -1'
									else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
					and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
					and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId'
										when @reportLevel = 'lea' then 'fact.LeaId'
										else 'fact.K12SchoolId'
										end  + @sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
				'
				-- remove missing counts for this report c150
				if(@categorySetCode <> 'TOT')
				begin
				set @sql = @sql + '
					-- Remove MISSING counts - ' + @reportField + '
					if exists (select 1 from #categoryCohortSet
						where ' + @reportField + ' <> ''MISSING'' and ' + @factField + ' > 0)
					begin
						delete from #categoryCohortSet where ' + @reportField + ' = ''MISSING''
					end
					else
					begin
						delete from #categoryCohortSet where ' + @reportField + ' <> ''MISSING''					
					end
				'
				end
				-- calculate total

				if @reportLevel = 'sea'
				begin
					set @sql = @sql + '
					select @CohortTotal = sum(isnull(StudentCount, 0))
					from #categoryCohortSet cs
					inner join rds.DimSeas sch on cs.DimSeaId = sch.DimSeaId
					where cs.DimSeaId <> -1
					'
				end
					
			end
			else if(@reportCode in ('033') AND @categorySetCode = 'TOT')
			begin
				set @sql = @sql + '
					----------------------------
					-- Insert actual count data 
					-- default ReportEDFactsK12StudentCounts
					----------------------------
		
					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
							when @reportLevel = 'lea' then 'DimLeaId int,' 
							else 'DimK12SchoolId int,'
					end + 'DimStudentId int, K12StudentStudentIdentifierState varchar(50), TableTypeAbbrv varchar(25)' + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		
				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'

					truncate table #categorySet

					-- Actual Counts
					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
								when @reportLevel = 'lea' then 'DimLeaId,' 
								else 'DimK12SchoolId,'
						end + 'DimStudentId, K12StudentStudentIdentifierState, TableTypeAbbrv'  + @sqlCategoryFields + ', ' + @factField + ') 
					select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
										when @reportLevel = 'lea' then 'fact.LeaId,' 
										else 'fact.K12SchoolId,'
						end + 'fact.K12StudentId, rules.K12StudentStudentIdentifierState, 
						CASE WHEN dps.NationalSchoolLunchProgramDirectCertificationIndicatorCode = ''YES'' THEN ''DIRECTCERT''
							ELSE ''LUNCHFREERED''
						END' + @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + 
					' inner join rds.DimEconomicallyDisadvantagedStatuses dps on fact.EconomicallyDisadvantagedStatusId = dps.DimEconomicallyDisadvantagedStatusId ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
									when @reportLevel = 'lea' then 'fact.LeaId <> -1'
									else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
					and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition + '
					and dps.EligibilityStatusForSchoolFoodServiceProgramsCode in (''FREE'' ,''REDUCEDPRICE'' ) ' +
					' group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
										when @reportLevel = 'lea' then 'fact.LeaId,'
										else 'fact.K12SchoolId,'
										end + 'fact.K12StudentId, rules.K12StudentStudentIdentifierState, dps.NationalSchoolLunchProgramDirectCertificationIndicatorCode'  + @sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
					'
			end			
			else if(@reportCode in ('118'))
			begin
				--set the variables for Grades 13 and UG to be used in the exclusions
				declare @gradesExclude varchar(25)

				set @gradesExclude = '(''AE'''

				if (@toggleGrade13 = 0)
				begin 
					set @gradesExclude += ',''13'''
				end
				if (@toggleUngraded = 0)
				begin 
					set @gradesExclude += ',''UG'''
				end

				set @gradesExclude += ')'

				set @sql = @sql + '
					----------------------------
					-- Insert actual count data 
					-- default ReportEDFactsK12StudentCounts
					----------------------------
		
					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
							when @reportLevel = 'lea' then 'DimLeaId int,' 
							else 'DimK12SchoolId int,'
					end + 'K12StudentStudentIdentifierState varchar(50),' 
						+ 'EnrollmentEntryDateId int' + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
					) 

							' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
					'    else ''
					end +
					'
					truncate table #categorySet

							-- Actual Counts
							insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
								when @reportLevel = 'lea' then 'DimLeaId,' 
								else 'DimK12SchoolId,'

						end + 'K12StudentStudentIdentifierState, EnrollmentEntryDateId'  + @sqlCategoryFields + ', ' + @factField + ')
					select  ' + case @reportLevel
									when 'sea' then 'fact.SeaId,' + char(10)
									when 'lea' then '						fact.LeaId,' + char(10)
								else '						fact.K12SchoolId,' + char(10)
						end + '						p.K12StudentStudentIdentifierState,' + char(10)
						+ '						fact.EnrollmentEntryDateId' + char(10)
						+ @sqlCategoryQualifiedDimensionFields + char(10) +
						',	sum(isnull(fact.' + @factField + ', 0)) ' + char(10) +
					'from rds.' + @factTable + ' fact ' + char(10)
						
					select @sql = @sql + @sqlCountJoins + char(10)

					+ ' ' + @reportFilterJoin + '
					where ' + case when @reportLevel = 'sea' then 'fact.SeaId <>-1'
									when @reportLevel = 'lea' then 'fact.LeaId <> -1'
									else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '

					and homeless.HomelessnessStatusCode = ''Yes''
					and dgl.GradeLevelEdFactsCode NOT IN ' + @gradesExclude + '

					and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition +
					' group by ' + case @reportLevel 
										when 'sea' then 'fact.SeaId,' + char(10)
										when 'lea' then '						fact.LeaId,' + char(10)
									else '						fact.K12SchoolId,' + char(10)
									end + '						p.K12StudentStudentIdentifierState,' + char(10)
									+ '						fact.EnrollmentEntryDateId'  + char(10)
									+ 						@sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
					'

					if @categorySetCode = 'CSA'
					BEGIN
						set @sql = @sql + '  
							delete from #CategorySet 
							where GRADELEVEL = ''PK''
							'
					END

					if @reportLevel = 'sea'
					begin
							set @sql = @sql + '						
							;with cte as (
								select K12StudentStudentIdentifierState, ROW_NUMBER() OVER(PARTITION BY K12StudentStudentIdentifierState ORDER BY EnrollmentEntryDateId) as ''rownum'' 
								from #CategorySet
							)
							delete s from #CategorySet s
							inner join cte c on s.K12StudentStudentIdentifierState = c.K12StudentStudentIdentifierState
							where  rownum > 1
							'
					end 
					else if @reportLevel = 'lea'
					begin
							set @sql = @sql + '						
							;with cte as (
								select K12StudentStudentIdentifierState, DimLeaId, ROW_NUMBER() OVER(PARTITION BY K12StudentStudentIdentifierState, DimLeaId ORDER BY EnrollmentEntryDateId) as ''rownum'' 
								from #CategorySet
							)
							delete s from #CategorySet s
							inner join cte c on s.K12StudentStudentIdentifierState = c.K12StudentStudentIdentifierState and s.DimLeaId = c.DimLeaId
							where  rownum > 1
							'
					end 

			end
			else
			-- all other report codes
			begin
				if(@factReportTable = 'ReportEDFactsK12StudentCounts' and @factTypeCode <> 'datapopulation')
				begin
					set @sql = @sql + '
						----------------------------
						-- Insert actual count data 
						-- default ReportEDFactsK12StudentCounts
						----------------------------
		
						create table #categorySet (	' 
						+ case when @reportLevel = 'sea' then 'DimSeaId int,'
								when @reportLevel = 'lea' then 'DimLeaId int,' 
								else 'DimK12SchoolId int,'
						end + 'DimStudentId int,
						K12StudentStudentIdentifierState varchar(50)' + @sqlCategoryFieldDefs + ',
						' + @factField + ' int
						) 

								' + case when @reportLevel = 'sea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
						'    when @reportLevel = 'lea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
						' 	 when @reportLevel = 'sch' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
						'    else ''
						end +
						'

						truncate table #categorySet


						-- Actual Counts
						insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
							when @reportLevel = 'lea' then 'DimLeaId,' 
							else 'DimK12SchoolId,'

					end + 'DimStudentId, K12StudentStudentIdentifierState'  + @sqlCategoryFields + ', ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.SeaId,'
									when @reportLevel = 'lea' then 'fact.LeaId,' 
									else 'fact.K12SchoolId,'
					end + 'fact.K12StudentId, rules.K12StudentStudentIdentifierState' + @sqlCategoryQualifiedDimensionFields +
					case when @ReportCode = '116' then
					',	count(distinct K12StudentId) '
					else
					',	sum(isnull(fact.' + @factField + ', 0)) '
					end +
				'from rds.' + @factTable + ' fact ' + char(10)
					if @reportCode = '052'
						begin
							select @sql = @sql + char(10) +
							char(9) + char(9) + char(9) + char(9) + char(9) + char(9) +
							'inner join #Students rules
							on fact.K12StudentId = rules.K12StudentId' + char(10)					
							if @reportLevel = 'sch'
							begin
								select @sql = @sql + char(10) + 'and fact.K12SchoolId = rules.K12SchoolId'
							end
						end
						
				select @sql = @sql + @sqlCountJoins + char(10)

				+ ' ' + @reportFilterJoin + '
				where ' + case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
								when @reportLevel = 'lea' then 'fact.LeaId <> -1'
								else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' end  + '
				and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition +
				' group by ' + case  when @reportLevel = 'sea' then 'fact.SeaId,'
									when @reportLevel = 'lea' then 'fact.LeaId,'
									else 'fact.K12SchoolId,'
									end + 'fact.K12StudentId, rules.K12StudentStudentIdentifierState'  + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
				end		-- END @factReportTable = 'ReportEDFactsK12StudentCounts'
				else 
				begin
					set @sql = @sql + '
						----------------------------
						-- Insert actual count data 
						----------------------------
		
						create table #categorySet (	' 
						+ case when @reportLevel = 'sea' then 'DimSeaId int'
								when @reportLevel = 'lea' then 'DimLeaId int' 
								else 'DimK12SchoolId int'
						end 
							+ @sqlCategoryFieldDefs + ',
						' + @factField + ' int
						)

								' + case when @reportLevel = 'sea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
						'    when @reportLevel = 'lea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
						' 	 when @reportLevel = 'sch' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimK12SchoolId)
						'    else ''
						end +
						'

						truncate table #categorySet

						-- Actual Counts
						insert into #categorySet
						(' 
						+ case when @reportLevel = 'sea' then 'DimSeaId'
							when @reportLevel = 'lea' then 'DimLeaId' 
							else 'DimK12SchoolId' 
							end 
							+ @sqlCategoryFields + ', ' + @factField + ')
						select  ' 
						+ case when @reportLevel = 'sea' then 'fact.SeaId'
								when @reportLevel = 'lea' then 'fact.LeaId' 
									else 'fact.K12SchoolId'
							end 
						+ @sqlCategoryQualifiedDimensionFields + ',
						sum(isnull(fact.' + @factField + ', 0))
						from rds.' + @factTable + ' fact ' + @sqlCountJoins 
						+ ' ' + @reportFilterJoin + '
						where ' + 
						case when @reportLevel = 'sea' then 'fact.SeaId <> -1'
								when @reportLevel = 'lea' then 'fact.LeaId <> -1'
								else 'IIF(fact.K12SchoolId > 0, fact.K12SchoolId, fact.LeaId) <> -1' 
						end  
								+ ' and fact.SchoolYearId = @dimSchoolYearId ' + @reportFilterCondition 
								+ ' and fact.FactTypeId = @dimFactTypeId ' + @queryFactFilter 
								+ ' group by ' 
								+ case  when @reportLevel = 'sea' then 'fact.SeaId'
									when @reportLevel = 'lea' then 'fact.LeaId'
									else 'fact.K12SchoolId' 
								end 
								+ @sqlCategoryQualifiedDimensionGroupFields + '
						' + @sqlHavingClause + '
					'
				end			-- END @factReportTable - all other factReportTable
			end		-- END all other report codes
		end	    -- END @factReportTable - all other

		set @sql = @sql +  '
		----------------------------
		-- Remove Missing Counts
		----------------------------
		' + @sqlRemoveMissing

		-- Different Sum Operations
		declare @sumOperation as nvarchar(500)
		set @sumOperation = 'sum(isnull(' + @factField + ', 0))'

		if @reportCode in ('141','175', '178', '179', '185', '188', 
			'189', '121', '194', '082', '083', '154', '155', '156', '157', '158',
			'052') -- JW 6/30/2023 Added C052
		begin
			set @sumOperation = 'count(distinct cs.dimStudentId )'
		end
		else if @reportCode in ('002', '089', '009', '005','006','088','144', '116', '118')
		begin
			set @sumOperation = 'count(distinct cs.K12StudentStudentIdentifierState )'
		end
		else if @reportCode in ('086')
		begin
			set @sumOperation = 'count(distinct cs.IncidentIdentifier)'
		end
		else if @reportCode in ('059', '070', '099', '112', '203')
		begin
			set @sumOperation = 'sum(round(isnull(' + @factField + ', 0), 2))'
		end

	/***************************************
		Create Debugging Tables
	***************************************/
		--only create debug tables for the EDFacts reports
		if (len(@reportCode) = 3 and @reportCode not like '%[^0-9]%')
		begin

			set @sql += '

			----------------------------
			-- Create Debugging Tables
			----------------------------
			'

			--create the table name
			declare @debugTableName nvarchar(127) -- set max length here
			declare @categoryValues nvarchar(100)
			set @categoryValues = REPLACE(REPLACE(@categorySetCategoryList,'|,|','_'),'|','')
			set @debugTableName = concat(@reportCode, '_', @reportLevel, '_', @categorySetCode, '_', @reportYear, IIF(len(@categoryValues) = 0, '', concat('_', @categoryValues))) 

			--cleanup the table name for length, max allowable is 128 (just in case)
			-- if len(@debugTableName) > 128
			--	set @debugTableName = substring(@debugTableName, 0, 127)

			--drop the table if it exists 
			declare @dropTableSQL nvarchar(max)

			-- c033 creates the debug table, then adds to it so we have to conditionally drop that table
			if @reportCode in ('033') and @categorySetCode = 'TOT' and @tableTypeAbbrvs = 'DIRECTCERT'
			begin
				set @dropTableSQL = '       IF OBJECT_ID(N''[debug].' + QUOTENAME(@debugTableName) + ''',N''U'') IS NOT NULL DROP TABLE [debug].' + QUOTENAME(@debugTableName) + char(10) + char(10)
			end
			else if @reportCode in ('033') and @categorySetCode = 'TOT' and @tableTypeAbbrvs = 'LUNCHFREERED' -- if @dropdebugtable = 1 don't drop the table
			begin
				set @dropTableSQL = ' ' + char(10)
			end
			else
			begin -- drop the table for all other files
				set @dropTableSQL = '		IF OBJECT_ID(N''[debug].' + QUOTENAME(@debugTableName) + ''',N''U'') IS NOT NULL DROP TABLE [debug].' + QUOTENAME(@debugTableName) + char(10) + char(10)
			end
		
			set @sql += @dropTableSQL

			--create the table with the insert
			declare @debugTableCreate nvarchar(max)

			-- the debug c033 TOT table already exists, write the additional records into it
			if @reportCode IN ('033') and @categorySetCode = 'TOT' and @tableTypeAbbrvs = 'LUNCHFREERED'
			begin
				set @debugTableCreate = '		insert into '  + '[debug].' + QUOTENAME(@debugTableName) + char(10)	+	
				'(
					K12StudentStudentIdentifierState,
					schoolIdentifierSea,
					StudentCount,
					TableTypeAbbrv
				)
				select s.K12StudentStudentIdentifierState , sc.schoolIdentifierSea, c.StudentCount, c.TableTypeAbbrv				
				from #categorySet c 
				inner join rds.DimPeople s 
					on c.DimStudentId = s.DimPersonId 
				inner join rds.DimK12Schools sc 
					on c.DimK12SchoolId = sc.DimK12SchoolId 
				order by K12StudentStudentIdentifierState '				
			end 
			else 
			begin
				if @reportCode IN ('059', '067', '070', '099', '112', '203') 
				begin
					set @debugTableCreate = '					select s.K12StaffStaffMemberIdentifierState '
				end 
				else if @reportCode IN ('009','005','006','007','086','088','143','144','118') 
				begin
					set @debugTableCreate = '					select K12StudentStudentIdentifierState '   
				end 
				else  
				begin
					set @debugTableCreate = '					select s.K12StudentStudentIdentifierState ' 
				end 

				--set the LEA field in the select if necessary
				if @reportLevel	= 'LEA' 
				begin 
					set @debugTableCreate += ', l.leaIdentifierSea ' 
				end

				--set the School field in the select if necessary
				if @reportLevel = 'SCH' 
				begin
					set @debugTableCreate += ',  SC.leaIdentifierSea, sc.schoolIdentifierSea '  
				end

				--add the appropriate count column to the debug table
				if @reportCode IN ('005','006','007','086','088','143','144') 
				begin
					set @debugTableCreate += ', DisciplineCount '
				end
				else if @reportCode IN ('059', '067', '070', '099', '112', '203') 
				begin
					set @debugTableCreate += ', StaffCount '
				end 
				else if @reportCode IN ('050','113','125','126','137','138','139','175','178','179','185','188','189','224','225') 
				begin
					set @debugTableCreate += ', AssessmentCount '
				end 
				else
				begin
					set @debugTableCreate += ', StudentCount '
				end 

				--c033 - special condition to add TableTypeAbbrv to the select criteria 
				if @reportCode IN ('033') and @categorySetCode = 'TOT' and @tableTypeAbbrvs = 'DIRECTCERT'
				begin
					set @debugTableCreate += ', TableTypeAbbrv '  
				end
				--end of c033 code 

				set @debugTableCreate += @sqlCategoryFields + char(10) 
					+ '					into [debug].' + QUOTENAME(@debugTableName) + char(10)
			
				IF @reportCode IN ('059', '067', '070', '099', '112', '203')
				BEGIN
					set @debugTableCreate += '					from #categorySet c ' + char(10) +
					'					inner join rds.DimPeople s ' + char(10)
					+ '						on c.DimK12StaffId = s.DimPersonId ' + char(10)
				END 
				--these reports have been converted to use K12StudentStudentIdentifierState instead of K12StudentId
				--	in #Students and #categorySet so no need to join to DimPeople
				ELSE IF @reportCode IN ('009','005','006','007','086','088','143','144','118') 
				BEGIN
					set @debugTableCreate += '					from #categorySet c ' + char(10)
				END
				ELSE	
				BEGIN
					set @debugTableCreate += '					from #categorySet c ' + char(10) +
					'					inner join rds.DimPeople s ' + char(10)
					+ '						on c.DimStudentId = s.DimPersonId ' + char(10)
				END 

				--set the LEA join if necessary
				if @reportLevel = 'LEA' 
				begin
					set @debugTableCreate += '					inner join rds.DimLeas l ' + char(10)
						+ '						on c.DimLeaId = l.DimLeaId '  + char(10)
				end 

				--set the School join if necessary
				if @reportLevel = 'SCH' 
				begin
					set @debugTableCreate += '					inner join rds.DimK12Schools sc ' + char(10)
						+ '						on c.DimK12SchoolId = sc.DimK12SchoolId ' + char(10)
				end 

				if @reportCode in ('059', '067', '070', '099', '112', '203') 
				begin
					set @debugTableCreate += '					order by s.K12StaffStaffMemberIdentifierState ' + char(10)
				end
				else 
				begin
					set @debugTableCreate += '					order by K12StudentStudentIdentifierState ' + char(10)
				end
			end
			set @sql += @debugTableCreate 

		end

		---------------------------------
		-- Insert SQL into Fact Tables
		---------------------------------

		if @reportLevel = 'sea'
		-- SEA----
		begin
			set @sql = @sql + '
				-- insert sea sql
				insert into rds.' + @factReportTable + '
				(
					ReportCode,
					ReportYear,
					ReportLevel,
					CategorySetCode,
					Categories,
					StateANSICode,
					StateAbbreviationCode,
					StateAbbreviationDescription,
					OrganizationIdentifierNces,
					OrganizationIdentifierSea,
					OrganizationName,
					ParentOrganizationIdentifierSea,
					TableTypeAbbrv,
					TotalIndicator
					' + @sqlCategoryFields + ',
					' + @factField + '
				'
			if(@factReportTable = 'ReportEDFactsK12StaffCounts')
			begin
				set @sql = @sql + ',StaffCount'
			end
				
			if @reportCode in ('175', '178', '179', '185', '188', '189')
			begin
				set @sql = @sql + ',AssessmentAcademicSubject'
			end
			else if(@reportCode in ('150'))
			begin
				set @sql = @sql + ',ADJUSTEDCOHORTGRADUATIONRATE'
			end
			else if(@reportCode in ('137') and @categorySetCode = 'CSB')
			begin
				set @sql = @sql + ',ASSESSEDFIRSTTIME'
			end

			set @sql = @sql + '
				)
				select 
					''' + @reportCode + ''',
					''' + @reportYear + ''',
					''' + @reportLevel + ''',
					''' + @categorySetCode + ''',
					''' + @categorySetCategoryList + ''',
					sea.StateANSICode,
					sea.StateAbbreviationCode,
					sea.StateAbbreviationDescription,
					isnull(sea.StateANSICode,'''') as OrganizationIdentifierNces,
					sea.SeaOrganizationIdentifierSea as OrganizationIdentifierSea,
					sea.SeaOrganizationName as OrganizationName,
					null as ParentOrganizationIdentifierSea,
					''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
					''' + @totalIndicator + ''' as TotalIndicator' +
					@sqlCategoryFields + ', 
					' + @sumOperation + ' as ' + @factField + ''

			if(@factReportTable = 'ReportEDFactsK12StaffCounts')
			begin
				if @reportCode in ('067', '070', '112')
				begin
					set @sql = @sql + ',count(distinct dimK12StaffId )'
				end
				else
				begin
					set @sql = @sql + ',sum(isnull(StaffCount, 0))'
				end
			end

			if(@reportCode in ('137') and @categorySetCode = 'CSB')
			begin
				set @sql = @sql + ',FirstAssessed'
			end
				
			if @reportCode in ('175', '178', '179', '185', '188', '189')
			begin
				set @sql = @sql + ', case when ''' + @reportCode + ''' in (''175'',''185'') then ''MATH''
									when ''' + @reportCode + ''' in (''178'',''188'') then ''RLA''
									when ''' + @reportCode + ''' in (''179'',''189'') then ''SCIENCE''
									ELSE ''MISSING''
							end
					'
			end

			if(@reportCode in ('150'))
			begin
				set @sql = @sql + ', cast(' + @sumOperation + ' / @CohortTotal * 100 as Decimal(9,2)) as ADJUSTEDCOHORTGRADUATIONRATE '
			end

			set @sql = @sql + '
				from #categorySet cs
				inner join rds.DimSeas sea on cs.DimSeaId = sea.DimSeaId'

			if(@reportCode in ('009')) 
			begin
				if @categorySetCode = 'TOT' 
				begin
					set @sql = @sql + ' 
					left join (select K12StudentStudentIdentifierState, ' 
				end
				else
				begin
					set @sql = @sql + ' 
					inner join (select K12StudentStudentIdentifierState, ' 
				end

				SELECT @sql = @sql + 
					CASE @toggleCatchmentSea
						WHEN 'Districtwide (students moving out of district)' THEN
							' MIN(SpecialEducationServicesExitDate) AS SpecialEducationServicesExitDate'
						ELSE 
							' MAX(SpecialEducationServicesExitDate) AS SpecialEducationServicesExitDate'
					END

				SELECT @sql = @sql + ' from #categorySet group by K12StudentStudentIdentifierState) fs009 
										ON cs.K12StudentStudentIdentifierState = fs009.K12StudentStudentIdentifierState 
										AND cs.SpecialEducationServicesExitDate = fs009.SpecialEducationServicesExitDate'
			end 
				
			SET @sql = @sql + '
				Where sea.DimSeaId > 0
				group by 
					sea.StateANSICode,
					sea.StateAbbreviationCode,
					sea.StateAbbreviationDescription,
					sea.SeaOrganizationIdentifierSea,
					sea.SeaOrganizationName ' +
					@sqlCategoryFields
			
			if(@reportCode in ('137') and @categorySetCode = 'CSB')
			begin
				set @sql = @sql + ',FirstAssessed'
			end

			if @reportCode in ('086')
			begin
				set @sql = @sql + '
					having count(distinct cs.IncidentIdentifier) > 0'
			end
			else
			begin
				set @sql = @sql + '
					having sum(' + @factField + ') > 0'
			end

		end
		else if @reportLevel = 'lea'
		-- LEA ----
		begin
			set @sql = @sql + '
				-- insert lea sql '
			if(@factReportTable = 'ReportEDFactsK12StudentCounts' 
				OR @reportCode in ('088', '143', '006'))
			begin
				set @sql = @sql + '
					insert into rds.' + @factReportTable + '
					(
						ReportCode,
						ReportYear,
						ReportLevel,
						CategorySetCode,
						Categories,
						StateANSICode,
						StateAbbreviationCode,
						StateAbbreviationDescription,
						OrganizationIdentifierNces,
						OrganizationIdentifierSea,
						OrganizationName,
						ParentOrganizationIdentifierSea,
						TableTypeAbbrv,
						TotalIndicator
						' + @sqlCategoryFields + ',
						' + @factField + ''

				if(@factReportTable = 'ReportEDFactsK12StaffCounts')
				begin
					set @sql = @sql + ',StaffCount'
				end
							
				-- add StudentRate  field for c150
				if(@reportCode in ('150'))
				begin
					set @sql = @sql + ',ADJUSTEDCOHORTGRADUATIONRATE'
				end

			
				set @sql = @sql + '
					)
					select 
						''' + @reportCode + ''',
						''' + @reportYear + ''',
						''' + @reportLevel + ''',
						''' + @categorySetCode + ''',
						''' + @categorySetCategoryList + ''',
						lea.StateANSICode,
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription,
						isnull(lea.LeaIdentifierNces,'''') as OrganizationIdentifierNces,
						lea.LeaIdentifierSea as OrganizationIdentifierSea,
						lea.LeaOrganizationName as OrganizationName,
						lea.StateANSICode as ParentOrganizationIdentifierSea,
						''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
						''' + @totalIndicator + ''' as TotalIndicator' +
						@sqlCategoryFields + ', 
						' + @sumOperation + ' as ' + @factField

				if(@factReportTable = 'ReportEDFactsK12StaffCounts')
				begin
					if @reportCode in ('067', '070', '112')
					begin
						set @sql = @sql + ',count(distinct dimK12StaffId )'
					end
					else
					begin
						set @sql = @sql + ',sum(isnull(StaffCount, 0))'
					end
				end

				-- add calculation for StudentRate for c150
				if(@reportCode in ('150'))
				begin
					set @sql = @sql + ', cast(' + @sumOperation + ' / @CohortTotal * 100 as Decimal(9,2)) as ADJUSTEDCOHORTGRADUATIONRATE '
				end

				if @categorySetCode = 'TOT'
				begin
					if(@reportCode in ('002','089','052','033')) 
					begin	
 
						set @sql = @sql + '
							from #categorySet cs
							inner join rds.DimLeas lea on cs.DimLeaId = lea.DimLeaId
							and lea.LEAOperationalStatus not in (''Closed'', ''FutureAgency'', ''Inactive'', ''MISSING'')'
					end
					else
					begin
						set @sql = @sql + '
							from rds.DimLeas lea
							left outer join #categorySet cs on cs.DimLeaId = lea.DimLeaId'
					end
				end
				else
				begin
					set @sql = @sql + '
						from #categorySet cs
						inner join rds.DimLeas lea on cs.DimLeaId = lea.DimLeaId
						and lea.LEAOperationalStatus not in (''Closed'', ''FutureAgency'', ''Inactive'', ''MISSING'')'
				end

				-- if @categorySetCode = 'TOT'
				-- begin
				-- 	set @sql = @sql + '
				-- 		from rds.DimLeas lea
				-- 		left outer join #categorySet cs on cs.DimLeaId = lea.DimLeaId
				-- 		and lea.LEAOperationalStatus not in (''Closed'', ''FutureAgency'', ''Inactive'', ''MISSING'')'
				-- end
				-- else
				-- begin
				-- 	set @sql = @sql + '
				-- 		from #categorySet cs
				-- 		inner join rds.DimLeas lea on cs.DimLeaId = lea.DimLeaId'
				-- end

				if(@reportCode in ('009')) 
				begin
					if @categorySetCode = 'TOT' 
					begin
						set @sql = @sql + ' 
						left join (select K12StudentStudentIdentifierState, DimLeaId, ' 
					end
					else
					begin
						set @sql = @sql + ' 
						inner join (select K12StudentStudentIdentifierState, DimLeaId, '
					end
									
					SELECT @sql = @sql + 
						CASE @toggleCatchmentLea
							WHEN 'Districtwide (students moving out of district)' THEN
								' MIN(SpecialEducationServicesExitDate) AS SpecialEducationServicesExitDate'
							ELSE 
								' MAX(SpecialEducationServicesExitDate) AS SpecialEducationServicesExitDate'
						END

					SELECT @sql = @sql + ' from #categorySet group by K12StudentStudentIdentifierState, DimLeaId) fs009
											ON cs.K12StudentStudentIdentifierState = fs009.K12StudentStudentIdentifierState 
											AND cs.DimLeaId = fs009.DimLeaId 
											AND cs.SpecialEducationServicesExitDate = fs009.SpecialEducationServicesExitDate'
				end 

				set @sql = @sql + '
					where lea.DimLeaId <> -1 ' + char(10)
					set @sql = @sql + 'and lea.RecordStartDateTime >= ''' + @CalculatedSYStartDate + '''' + char(10)
					set @sql = @sql + 'and isnull(lea.RecordEndDateTime, ''' + @CalculatedSYEndDate + ''') <= ''' + @CalculatedSYEndDate + '''' + char(10)
					set @sql = @sql + 'and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963
					group by 
						lea.StateANSICode,
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription,
						lea.LeaIdentifierNces,
						lea.LeaIdentifierSea,
						lea.LeaOrganizationName ' +
						@sqlCategoryFields

			end		-- END @factReportTable = 'ReportEDFactsK12StudentCounts'
			else
			begin
				set @sql = @sql + '
					insert into rds.' + @factReportTable + '
					(
						ReportCode,
						ReportYear,
						ReportLevel,
						CategorySetCode,
						Categories,
						StateANSICode,
						StateAbbreviationCode,
						StateAbbreviationDescription,
						OrganizationIdentifierNces,
						OrganizationIdentifierSea,
						OrganizationName,
						ParentOrganizationIdentifierSea,
						TableTypeAbbrv,
						TotalIndicator
						' + @sqlCategoryFields + ',
						' + @factField + ''
			
				if(@factReportTable = 'ReportEDFactsK12StaffCounts')
				begin
					set @sql = @sql + ',StaffCount'
				end
							
				if @reportCode in ('175', '178', '179', '185', '188', '189')
				begin
					set @sql = @sql + ',AssessmentAcademicSubject'
				end
				else if(@reportCode in ('137') and @categorySetCode = 'CSB')
				begin
					set @sql = @sql + ',ASSESSEDFIRSTTIME'
				end

				set @sql = @sql + '
					)
					select 
						''' + @reportCode + ''',
						''' + @reportYear + ''',
						''' + @reportLevel + ''',
						''' + @categorySetCode + ''',
						''' + @categorySetCategoryList + ''',
						lea.StateANSICode,
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription,
						isnull(lea.LeaIdentifierNces,'''') as OrganizationIdentifierNces,
						lea.LeaIdentifierSea as OrganizationIdentifierSea,
						lea.LeaOrganizationName as OrganizationName,
						lea.StateANSICode as ParentOrganizationIdentifierSea,
						''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
						''' + @totalIndicator + ''' as TotalIndicator' +
						@sqlCategoryFields + ', 
						' + @sumOperation + ' as ' + @factField

				if(@factReportTable = 'ReportEDFactsK12StaffCounts')
				begin
					if @reportCode in ('067', '070', '112')
					begin
						set @sql = @sql + ',count(distinct dimK12StaffId )'
					end
					else
					begin
						set @sql = @sql + ',sum(isnull(StaffCount, 0))'
					end
				end

				if(@reportCode in ('137') and @categorySetCode = 'CSB')
				begin
					set @sql = @sql + ',FirstAssessed'
				end
							
				if @reportCode in ('175', '178', '179', '185', '188', '189')
				begin
					set @sql = @sql + ', case when ''' + @reportCode + ''' in (''175'',''185'') then ''MATH''
								when ''' + @reportCode + ''' in (''178'',''188'') then ''RLA''
								when ''' + @reportCode + ''' in (''179'',''189'') then ''SCIENCE''
								ELSE ''MISSING''
						end
					'
				end

				if @categorySetCode = 'TOT'
				begin
					set @sql = @sql + '
						from rds.DimLeas lea
						left outer join #categorySet cs on cs.DimLeaId = lea.DimLeaId'
				end
				else
				begin
					set @sql = @sql + '
						from #categorySet cs
						inner join rds.DimLeas lea on cs.DimLeaId = lea.DimLeaId'
				end

				set @sql = @sql + '
					where lea.DimLeaId <> -1 ' + char(10)
					set @sql = @sql + 'and lea.RecordStartDateTime >= ''' + @CalculatedSYStartDate + '''' + char(10)
					set @sql = @sql + 'and isnull(lea.RecordEndDateTime, ''' + @CalculatedSYEndDate + ''') <= ''' + @CalculatedSYEndDate + '''' + char(10)
					set @sql = @sql + 'and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963
					group by 
						lea.StateANSICode,
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription,
						lea.LeaIdentifierNces,
						lea.LeaIdentifierSea,
						lea.LeaOrganizationName ' +
						@sqlCategoryFields + '
					'

				if(@reportCode in ('137') and @categorySetCode = 'CSB')
				begin
					set @sql = @sql + ',FirstAssessed'
				end

				if @reportCode in ('086')
				begin
					set @sql = @sql + '
						having count(distinct cs.IncidentIdentifier) > 0'
				end
				else
				begin
					set @sql = @sql + '
						having sum(' + @factField + ') > 0'
				end

			end
		end		-- END @reportLevel = 'lea'
		else if @reportLevel = 'sch'
		begin
			set @sql = @sql + '
				-- insert sch sql '
			set @sql = @sql + '
				insert into rds.' + @factReportTable + '
				(
					ReportCode,
					ReportYear,
					ReportLevel,
					CategorySetCode,
					Categories,
					StateANSICode,
					StateAbbreviationCode,
					StateAbbreviationDescription,
					OrganizationIdentifierNces,
					OrganizationIdentifierSea,
					OrganizationName,
					ParentOrganizationIdentifierSea,
					TableTypeAbbrv,
					TotalIndicator
					' + @sqlCategoryFields + ',
					' + @factField + ''
			
			if(@factReportTable = 'ReportEDFactsK12StaffCounts')
			begin
				set @sql = @sql + ', StaffCount'
			end
			if @reportCode in ('175', '178', '179', '185', '188', '189')
			begin
				set @sql = @sql + ',AssessmentAcademicSubject'
			end
			else if(@reportCode in ('137') and @categorySetCode = 'CSB')
			begin
				set @sql = @sql + ',ASSESSEDFIRSTTIME'
			end
			
			-- add StudentRate  field for c150
			if(@reportCode in ('150'))
			begin
				set @sql = @sql + ', ADJUSTEDCOHORTGRADUATIONRATE'
			end

			set @sql = @sql + '
				)
				select 
					''' + @reportCode + ''',
					''' + @reportYear + ''',
					''' + @reportLevel + ''',
					''' + @categorySetCode + ''',
					''' + @categorySetCategoryList + ''',
					sch.StateANSICode,
					sch.StateAbbreviationCode,
					sch.StateAbbreviationDescription,
					isnull(sch.SchoolIdentifierNces,'''') as OrganizationIdentifierNces,
					sch.SchoolIdentifierSea as OrganizationIdentifierSea,
					sch.NameOfInstitution as OrganizationName,
					sch.LeaIdentifierSea as ParentOrganizationIdentifierSea,
					''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
					''' + @totalIndicator + ''' as TotalIndicator' +
					@sqlCategoryFields + ', 
					' + @sumOperation + ' as ' + @factField

			if(@factReportTable = 'ReportEDFactsK12StaffCounts')
			begin
				if @reportCode in ('067', '070', '112')
				begin
					set @sql = @sql + ',count(distinct dimK12StaffId )'
				end
				else
				begin
					set @sql = @sql + ',sum(isnull(StaffCount, 0))'
				end
			end

			if(@reportCode in ('137') and @categorySetCode = 'CSB')
			begin
				set @sql = @sql + ',FirstAssessed'
			end

			if @reportCode in ('175', '178', '179', '185', '188', '189')
			begin
				set @sql = @sql + ', case when ''' + @reportCode + ''' in (''175'',''185'') then ''MATH''
									when ''' + @reportCode + ''' in (''178'',''188'') then ''RLA''
									when ''' + @reportCode + ''' in (''179'',''189'') then ''SCIENCE''
									ELSE ''MISSING''
							end
				'
			end
			-- add calculation for StudentRate for c150
			if(@reportCode in ('150'))
			begin
				set @sql = @sql + ', cast(' + @sumOperation + ' / @CohortTotal * 100 as Decimal(9,2)) as ADJUSTEDCOHORTGRADUATIONRATE '
			end

			if(@factReportTable = 'ReportEDFactsK12StudentCounts')
			begin
				if @categorySetCode = 'TOT'
				begin
					set @sql = @sql + '
						from rds.DimK12Schools sch
						left outer join #categorySet cs on cs.DimK12SchoolId = sch.DimK12SchoolId'

					if @reportCode = '033'
					begin
						set @sql = @sql + '
							where sch.DimK12SchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963
							and cs.TableTypeAbbrv = ''' + @tableTypeAbbrv + ''''
					end
					else
					begin
						set @sql = @sql + '
							where sch.DimK12SchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963
							'
					end
				end
				else
				begin
					set @sql = @sql + '
						from #categorySet cs
						inner join rds.DimK12Schools sch on cs.DimK12SchoolId = sch.DimK12SchoolId'

					set @sql = @sql + '
							where sch.DimK12SchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963
							'
				end

				

				set @sql = @sql + '
					group by 
						sch.StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierSea,
						sch.NameOfInstitution ,
						sch.LeaIdentifierSea' +
						@sqlCategoryFields + '
					having sum(' + @factField + ') > 0'
			end
			else
			begin
				if @categorySetCode = 'TOT'
				begin
					set @sql = @sql + '
						from rds.DimK12Schools sch
						left outer join #categorySet cs on cs.DimK12SchoolId = sch.DimK12SchoolId'
				end
				else
				begin
					set @sql = @sql + '
						from #categorySet cs
						inner join rds.DimK12Schools sch on cs.DimK12SchoolId = sch.DimK12SchoolId'
				end

				set @sql = @sql + '
					where sch.DimK12SchoolId <> -1
					and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963
					group by 
						sch.StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierSea,
						sch.NameOfInstitution ,
						sch.LeaIdentifierSea ' +
						@sqlCategoryFields 

				if(@reportCode in ('137') and @categorySetCode = 'CSB')
				begin
					set @sql = @sql + ',FirstAssessed'
				end

				set @sql = @sql + '
						having sum(' + @factField + ') > 0'
			end
		end		-- END sch

		-- delete #categoryCohortSet used to calculate cohort total
		if(@reportCode in ('150'))
		begin
			set @sql = @sql + '
			drop table #categoryCohortSet'
		end
	end

	-----------------Contiguous Performance levels------------------------------------------------------------
	if @sqlType = 'performanceLevels'
	begin
		if @reportCode in ('175','178','179') and @reportLevel <> 'sea' and @year <= 2018
		begin

			declare @sqlSelectCategoryFields varchar(max)
			declare @sqlSelectCategoryFieldsExcludePerfLvl varchar(max)
			
			set @sqlCategoryFieldDefs = ''
			set @sqlCategoryFields = ''
			set @sqlPerformanceLevelJoins = ''
			set @sqlSelectCategoryFields = ''
			set @sqlSelectCategoryFieldsExcludePerfLvl = ''
	
			DECLARE categoryset_cursor CURSOR FOR 
			select upper(d.DimensionFieldName) as ReportField 
			from app.CategorySets cs
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels o 
				on cs.OrganizationLevelId = o.OrganizationLevelId
			inner join app.CategorySet_Categories csc 
				on cs.CategorySetId = csc.CategorySetId
			inner join app.Categories c 
				on csc.CategoryId = c.CategoryId
			inner join app.Category_Dimensions cd 
				on c.CategoryId = cd.CategoryId
			inner join app.Dimensions d 
				on cd.DimensionId = d.DimensionId
			inner join App.DimensionTables dt 
				on dt.DimensionTableId = d.DimensionTableId
			left outer join app.TableTypes tt 
				on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode
			and cs.CategorySetCode = @categorySetCode 
			and cs.SubmissionYear = @reportYear 
			and o.LevelCode = @reportLevel 

			OPEN categoryset_cursor
			FETCH NEXT FROM categoryset_cursor INTO @reportField

			WHILE @@FETCH_STATUS = 0
			BEGIN

				set @sqlCategoryFields = @sqlCategoryFields + ', ' + @reportField
		
				if(@reportField <> 'PERFORMANCELEVEL')
				begin
					set @sqlSelectCategoryFieldsExcludePerfLvl = @sqlSelectCategoryFieldsExcludePerfLvl + ', ' + @reportField
					if(LEN(@sqlPerformanceLevelJoins) > 0)
					begin
						set @sqlPerformanceLevelJoins = @sqlPerformanceLevelJoins + ' and a.' + @reportField + '= b.' + @reportField
					end
					else
					begin
						set @sqlPerformanceLevelJoins = @sqlPerformanceLevelJoins + ' a.' + @reportField + '= b.' + @reportField
					end
				end

				FETCH NEXT FROM categoryset_cursor INTO @reportField
			END

			CLOSE categoryset_cursor
			DEALLOCATE categoryset_cursor

			set @sql = @sql + ' 
			insert into #performanceData_' + @categorySetCode  + '(StateANSICode,
				StateAbbreviationCode,
				StateAbbreviationDescription,
				OrganizationIdentifierNces,
				OrganizationIdentifierSea,
				OrganizationName,
				ParentOrganizationIdentifierSea,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentAcademicSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl + ',AssessmentCount,PERFORMANCELEVEL)
			select StateANSICode,
				StateAbbreviationCode,
				StateAbbreviationDescription,
				OrganizationIdentifierNces,
				OrganizationIdentifierSea,
				OrganizationName,
				ParentOrganizationIdentifierSea,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentAcademicSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl + ',0 as AssessmentCount, b.Code as PERFORMANCELEVEL
			from ( select StateANSICode,
				StateAbbreviationCode,
				StateAbbreviationDescription,
				OrganizationIdentifierNces,
				OrganizationIdentifierSea,
				OrganizationName,
				ParentOrganizationIdentifierSea,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentAcademicSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl +
			' from  @reportData
			group by StateANSICode,
				StateAbbreviationCode,
				StateAbbreviationDescription,
				OrganizationIdentifierNces,
				OrganizationIdentifierSea,
				OrganizationName,
				ParentOrganizationIdentifierSea,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentAcademicSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl +
			' having  CategorySetCode =  ''' + @categorySetCode + ''') a
			cross join (select * from #CAT_PerformanceLevel) b
			'

			set @sql = @sql + '
			delete a from #performanceData_' + @categorySetCode + ' a
			inner join ( select OrganizationIdentifierSea' + @sqlCategoryFields + 
			' from @reportData
			group by OrganizationIdentifierSea,CategorySetCode' + @sqlCategoryFields +
			' having  CategorySetCode =  ''' + @categorySetCode + ''') b 
			on ' + @sqlPerformanceLevelJoins + ' and a.PERFORMANCELEVEL = b.PERFORMANCELEVEL and a.OrganizationIdentifierSea = b.OrganizationIdentifierSea
			'

			set @sql = @sql + '
			delete a from #performanceData_' + @categorySetCode + ' a
			inner join ( select  AssessmentTypeCode, Grade, PerformanceLevels, Subject
			from app.ToggleAssessments
			) b 
			on a.ASSESSMENTTYPE = b.AssessmentTypeCode and a.GradeLevel = b.Grade and a.AssessmentAcademicSubject = b.Subject
			and CAST(SUBSTRING(a.PERFORMANCELEVEL,2,1) as INT) > CAST(b.PerformanceLevels as INT)
			'

			set @sql = @sql + '

			insert into @reportData
			(
				StateANSICode,
				StateAbbreviationCode,
				StateAbbreviationDescription,
				OrganizationIdentifierNces,
				OrganizationIdentifierSea,
				OrganizationName,
				ParentOrganizationIdentifierSea,
				TableTypeAbbrv,
				TotalIndicator,
				ASSESSMENTAcademicSUBJECT,
				CategorySetCode
			' + @sqlCategoryFields + ', ' + @factField
		
		
			set @sql = @sql + ')
			select StateANSICode,
				StateAbbreviationCode,
				StateAbbreviationDescription,
				OrganizationIdentifierNces,
				OrganizationIdentifierSea,
				OrganizationName,
				ParentOrganizationIdentifierSea,
				TableTypeAbbrv,
				TotalIndicator,
				ASSESSMENTAcademicSUBJECT,
				CategorySetCode
			' + @sqlCategoryFields + ',AssessmentCount
			from #performanceData_' + @categorySetCode + '
			
			'
		end
	end
	
	if @sqlType = 'zero'
	begin

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		-- @sqlType = ''zero''
		----------------------------

		insert into @reportData
		(
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			TableTypeAbbrv,
			TotalIndicator,
			CategorySetCode
		' + @sqlCategoryFields + ', ' + @factField
		
		if(@factReportTable = 'ReportEDFactsK12StudentCounts')
		begin
			set @sql = @sql + ', ADJUSTEDCOHORTGRADUATIONRATE '
		end
		
		
		if(@factReportTable = 'ReportEDFactsK12StaffCounts')
		begin
			set @sql = @sql + ', StaffCount'
		end
		
		if @reportCode in ('175', '178', '179', '185', '188', '189')
		begin
			set @sql = @sql + ',AssessmentAcademicSubject'
		end
		
		set @sql = @sql + ')
			select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateAbbreviationCode,
			CAT_Organizations.StateAbbreviationDescription,
			CAT_Organizations.OrganizationIdentifierNces,
			CAT_Organizations.OrganizationIdentifierSea,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationIdentifierSea,
			' + case when @tableTypeAbbrv is null then '''''' else '''' + @tableTypeAbbrv + '''' end + ',
			''' + @totalIndicator + ''',
			''' + @categorySetCode + '''
			' + @sqlCategoryQualifiedFields + ','

			
		if(@factReportTable = 'ReportEDFactsK12StaffCounts')
		begin
			set @sql = @sql + ' 0.0 as ' + @factField + ', 0 as StaffCount'
		end
		else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
		begin
			set @sql = @sql + ' 0 as ' + @factField + ', 0.0 as ADJUSTEDCOHORTGRADUATIONRATE'
		end
		else
		begin
			set @sql = @sql + ' 0 as ' + @factField
		end
		
		if @reportCode in ('175', '178', '179', '185', '188', '189')
		begin
			set @sql = @sql + ', case when ''' + @reportCode + ''' in (''175'',''185'') then ''MATH''
										 when ''' + @reportCode + ''' in (''178'',''188'') then ''RLA''
										 when ''' + @reportCode + ''' in (''179'',''189'') then ''SCIENCE''
										 ELSE ''MISSING''
									end
				 '
		end

		/* JW 6/28/2023 Not sure this is even used
		if @reportCode in ('052') and @categorySetCode not in ('ST3','TOT') AND @reportLevel in ('lea', 'sch')
			begin
				set @sqlCategoryOptionJoins = @sqlCategoryOptionJoins + ' inner join (select distinct GRADELEVEL,OrganizationStateId
				from rds.ReportEDFactsOrganizationCounts where reportCode =''039'' AND reportLevel = ''' + @reportLevel +''' AND reportyear = ''' + @reportyear +''') b
				on CAT_GRADELEVEL.Code = b.GRADELEVEL and CAT_Organizations.OrganizationIdentifierSea = b.OrganizationStateId'
			end	
		*/
		if @reportCode in ('033')
		begin
			set @sqlZeroCountConditions = @sqlZeroCountConditions + ' AND TableTypeAbbrv = ''' + @tableTypeAbbrv + ''' '
		end
				
		--CIID-4862
		set @sqlZeroCountConditions = REPLACE(@sqlZeroCountConditions, 'and ', 'and rd.')
		set @sql = @sql + '
			from #CAT_Organizations CAT_Organizations' + @sqlCategoryOptionJoins + '
			LEFT JOIN (select * from @reportdata where CategorySetCode = ''' + @categorySetCode  + ''') rd
				ON rd.OrganizationIdentifierSea = CAT_Organizations.OrganizationIdentifierSea
				' + @sqlZeroCountConditions + '
		' + 'WHERE rd.OrganizationIdentifierSea IS NULL
		'
		set @sqlZeroCountConditions = REPLACE(@sqlZeroCountConditions, 'and rd.', 'and ')

		if @reportCode in ('002','089')
		BEGIN
		
		----------------Needed Just for SY 2019-20 -------------------------------------------------------------------------------------------------------------
			IF @reportYear = '2019-20'
			BEGIN
				set @sql = @sql + ' 
					IF NOT EXISTS(Select 1 from rds.ReportEDFactsK12StudentCounts a WHERE a.ReportCode in (''002'',''089'') 
					AND a.ReportYear = ''2019-20'' AND a.AGE IN (''AGE05K'', ''AGE05NOTK''))
					BEGIN
						delete from @reportData WHERE AGE IN (''AGE05K'', ''AGE05NOTK'')
					END

					IF EXISTS(Select 1 from rds.ReportEDFactsK12StudentCounts a WHERE a.ReportCode in (''002'',''089'') 
					AND a.ReportYear = ''2019-20'' AND a.AGE IN (''AGE05K'', ''AGE05NOTK''))
					BEGIN
						delete from @reportData WHERE AGE IN (''5'')
					END
					'
			END

			IF @year < 2023 AND @reportCode = '089' and @reportLevel ='LEA'
			BEGIN 
				SET @sql = @sql + ' 

				delete a from @reportData a
                where a.StudentCount = 0
                AND OrganizationIdentifierSea NOT IN
                (
					SELECT DISTINCT dl.LeaIdentifierSea
					FROM RDS.BridgeLeaGradeLevels blgl
					JOIN RDS.DimLeas dl
						ON blgl.LeaId = dl.DimLeaID
					JOIN RDS.DimGradeLevels dgl
						ON blgl.GradeLevelId = dgl.DimGradeLevelId
					WHERE GradeLevelCode IN (''KG'', ''PK'')
                )
				'
			END
			ELSE IF @year >= 2023 AND @reportCode = '089' and @reportLevel ='LEA'
			BEGIN
				SET @sql = @sql + ' 
					
				delete a from @reportData a
                where a.StudentCount = 0
                AND OrganizationIdentifierSea NOT IN
                (
					SELECT DISTINCT dl.LeaIdentifierSea
					FROM RDS.BridgeLeaGradeLevels blgl
					JOIN RDS.DimLeas dl
						ON blgl.LeaId = dl.DimLeaID
					JOIN RDS.FactK12StudentCounts rfsc
						ON dl.DimLeaId = rfsc.LeaId
						AND rfsc.FactTypeId = 3
						AND rfsc.SchoolYearId = @dimSchoolYearId
					JOIN RDS.DimGradeLevels dgl
						ON blgl.GradeLevelId = dgl.DimGradeLevelId
					WHERE GradeLevelCode IN (''PK'')
                )
				'
			END 
			ELSE IF @year >= 2023 AND @reportCode = '002' and @reportLevel = 'SCH'
			BEGIN
				SET @sql = @sql + ' 

				delete a from @reportData a
                where a.StudentCount = 0
                AND OrganizationIdentifierSea IN
                (
					select SchoolIdentifierSea from (
					(select K12SchoolId from rds.BridgeK12SchoolGradeLevels where GradeLevelId = 1) OffersPK
					inner join rds.DimK12Schools Schools
						on OffersPK.K12SchoolId = Schools.dimK12SchoolId
					inner join 
					(select K12SchoolId, count(*) CountOf from rds.BridgeK12SchoolGradeLevels group by K12SchoolId having count(*) = 1) OneGradeOnly
					on OffersPK.K12SchoolId = OneGradeOnly.K12SchoolId
					)                
				)
				'
			END 			
	
			IF @toggleDevDelayAges is not null
			BEGIN

				if @reportCode = '002' 
				begin
					if @toggleDevDelay6to9 is null
					begin
						set @sql = @sql + '  delete a from @reportData a
						where a.' +  @factField + ' = 0   
						AND IdeaDisabilityType = ''DD'' '
					end
					else
					begin
						set @sql = @sql + '  delete a from @reportData a
						where a.' +  @factField + ' = 0   
						AND IdeaDisabilityType = ''DD''
						AND AGE not in (' + @toggleDevDelay6to9 + ')'
					end
				end

				if @reportCode = '089' 
				begin
					if @toggleDevDelay3to5 is null
					begin
						set @sql = @sql + '  delete a from @reportData a
						where a.' +  @factField + ' = 0   
						AND IdeaDisabilityType = ''DD'' '
					end
					else
					begin
						set @sql = @sql + '  delete a from @reportData a
						where a.' +  @factField + ' = 0   
						AND IdeaDisabilityType = ''DD''
						AND AGE not in (' + @toggleDevDelay3to5 + ')'
					end
				end
			END
			ELSE
			BEGIN
				if @reportCode in ('002', '089')
				begin
					set @sql = @sql + '  delete a from @reportData a where IdeaDisabilityType = ''DD'' '
				end
			END

			DECLARE @IdeaEducationalEnvironmentField VARCHAR(100) = ''
			IF(@reportCode = '002') 
			BEGIN
				SET @IdeaEducationalEnvironmentField = 'IDEAEducationalEnvironmentForSchoolAge'
			END 
			ELSE
			BEGIN
				SET @IdeaEducationalEnvironmentField = 'IDEAEducationalEnvironmentForEarlyChildhood'
			END

			IF @istoggleExcludeCorrectionalAgeAll = 1
			BEGIN
				
				set @sql = @sql + '  delete a from @reportData a
					where ' + @IdeaEducationalEnvironmentField + ' = ''CF'' 
					'

			END
			ELSE IF @istoggleExcludeCorrectionalAge5to11 = 1
			BEGIN
				
				set @sql = @sql + '  delete a from @reportData a
					where AGE IN (''AGE05K'',''6'',''7'',''8'',''9'',''10'',''11'')
					AND ' + @IdeaEducationalEnvironmentField + ' = ''CF'' 
					'

			END
			ELSE IF @istoggleExcludeCorrectionalAge12to17 = 1 	
			BEGIN
				
				set @sql = @sql + '  delete a from @reportData a
					where AGE IN (''12'',''13'',''14'',''15'',''16'',''17'')
					AND ' + @IdeaEducationalEnvironmentField + ' = ''CF'' 
					'

			END
			ELSE IF @istoggleExcludeCorrectionalAge18to21 = 1 	
			BEGIN
				
				set @sql = @sql + '  delete a from @reportData a
					where AGE IN (''18'',''19'',''20'',''21'')
					AND ' + @IdeaEducationalEnvironmentField + ' = ''CF'' 
					'

			END
		END

		if(@reportCode = '009')
		BEGIN

			if(@toggleBasisOfExit = 0)
			begin
				set @sql = @sql + '  delete a from @reportData a
				where SpecialEducationExitReason = ''RC'''
			end

			if(@istoggleAlternateDiploma = 0)
			begin
				set @sql = @sql + '  delete a from @reportData a
				where SpecialEducationExitReason = ''GRADALTDPL'''
			end

			if(LEN(@toggleMaxAge) > 0)
			begin
				set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0
					AND AGE <> ''MISSING'' 
					AND CAST(AGE as INT) > CAST(' + @toggleMaxAge + ' as INT)'

				if(@istoggleMinAge = 1)
				begin
					
					if(LEN(@toggleMinAgeGrad) > 0)
					begin
						set @sql = @sql + '  delete a from @reportData a
						where a.' +  @factField + ' = 0 and a.CategorySetCode =''CSA''
						AND AGE <> ''MISSING'' AND SpecialEducationExitReason IN (''GHS'',''GRADALTDPL'',''RC'')
						AND CAST(AGE as INT) < CAST(' + @toggleMinAgeGrad + ' as INT)'
					end

				end

				set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0 and a.CategorySetCode =''CSA''
					AND AGE <> ''MISSING'' AND SpecialEducationExitReason IN (''RMA'')
					AND CAST(AGE as INT) <> CAST(' + @toggleMaxAge + ' as INT)'
			end
		END

		if @reportCode = '040'
		BEGIN
			IF @reportLevel <> 'sea'
			BEGIN
				set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0   
					AND a.CategorySetCode <> ''TOT''' 
			END

			IF @istoggleGradOther = 0
			BEGIN
				set @sql = @sql + '  delete a from @reportData a
				where a.' +  @factField + ' = 0   
				AND HIGHSCHOOLDIPLOMATYPE = ''OTHCOM''' 
			END
		END

		if @reportCode in ('175','178','179','185','188','189')
		begin
			if @istoggleRaceMap = 1
			begin
				set @sql = @sql + ' delete a from @reportData a
					where a.' +  @factField + ' = 0   
					and a.RACE in (''MA'',''MNP'',''MF'',''MHN'',''MPR'')
				'	
			end
			else
			begin
				set @sql = @sql + ' delete a from @reportData a
					where a.' +  @factField + ' = 0   
					and a.RACE in (''MAP'',''MF'',''MHN'',''MPR'')
				'	
			end
		end	

		if @reportCode in ('175','178','179')
		begin

			set @sql = @sql + ' delete a from @reportData a
				where a.' +  @factField + ' = 0 
				AND NOT EXISTS (Select 1 from app.ToggleAssessments b
									where a.ASSESSMENTTYPEADMINISTERED = b.AssessmentTypeCode
									and a.GradeLevel = b.Grade
									and a.AssessmentAcademicSubject = b.Subject)'

		end
		else if @reportCode in ('185', '188', '189')
        begin
			set @sql = @sql + ' 
				delete a from @reportData a
				where a.' + @factField + ' = 0
				AND RIGHT(a.TableTypeAbbrv, 2) = ''LG''
				AND a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR IN (''REGPARTWOACC'', ''REGPARTWACC'', ''ALTPARTALTACH'')
				AND NOT EXISTS (Select 1 from app.ToggleAssessments b
									where a.GradeLevel = b.Grade
									and a.AssessmentAcademicSubject = b.Subject
									and a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR = replace(b.AssessmentTypeCode, ''ASS'', ''PART''))'


			set @sql = @sql + ' 
				delete a from @reportData a
				where a.' + @factField + ' = 0
				AND RIGHT(a.TableTypeAbbrv, 2) = ''LG''
				AND a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR NOT IN (''REGPARTWOACC'', ''REGPARTWACC'', ''ALTPARTALTACH'')
				AND NOT EXISTS (Select 1 from app.ToggleAssessments b
									where a.GradeLevel = b.Grade
									and a.AssessmentAcademicSubject = b.Subject
									and a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR = (''P'' + replace(b.AssessmentTypeCode, ''ASMT'', ''ASM'')))'

			set @sql = @sql + ' 
				delete a from @reportData a
				where a.' + @factField + ' = 0
				AND RIGHT(a.TableTypeAbbrv, 2) = ''HS''
				AND a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR IN (''ALTPARTALTACH'')
				AND NOT EXISTS (Select 1 from app.ToggleAssessments b
									where a.GradeLevel = b.Grade
									and a.AssessmentAcademicSubject = b.Subject
									and a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR = replace(b.AssessmentTypeCode, ''ASS'', ''PART''))'


			set @sql = @sql + ' 
				delete a from @reportData a
				where a.' + @factField + ' = 0
				AND RIGHT(a.TableTypeAbbrv, 2) = ''HS''
				AND a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR NOT IN (''ALTPARTALTACH'')
				AND NOT EXISTS (Select 1 from app.ToggleAssessments b
									where a.GradeLevel = b.Grade
									and a.AssessmentAcademicSubject = b.Subject
									and a.ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR = (''P'' + replace(b.AssessmentTypeCode, ''ASMT'', ''ASM'')))'
		end
		/*Student count for displaced homemakers ?  If the state does not have displaced homemakers at the secondary level, leave that category set out of the file */
		else if @reportCode in ('082','083','142','154','155','156','157','158') and @toggleDisplacedHomemakers = '0'
		BEGIN
			set @sql = @sql + ' delete a from @reportData a
				where a.' +  @factField + ' = 0 and a.CategorySetCode =''CSG''
			'   
		END
		else if @reportCode in ('083')
		BEGIN
			set @sql = @sql + '  delete a from @reportData a
				where a.' +  @factField + ' = 0   
				AND HIGHSCHOOLDIPLOMATYPE NOT IN ( ' +  @toggleCteDiploma + ')'
		END

		set @sql = @sql + @sqlRemoveMissing
	end

	declare @dynamicCategorySelect as nvarchar(max)
	set @dynamicCategorySelect = ''
	declare @dynamicCategoryJoin as nvarchar(max)
	set @dynamicCategoryJoin = ''
	declare @dynamicCategoryCondition as nvarchar(max)
	set @dynamicCategoryCondition = ''

	if @sqlType = 'zero-performance' 
	begin

		IF(@categorySetCode = 'WODIS')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_SEX.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_SEX CAT_SEX'
			SET @dynamicCategoryCondition = 'and Category1 = CAT_SEX.Code'
		END
		ELSE
		BEGIN
			SET @dynamicCategorySelect = 'CAT_PrimaryDisabilityType.Code'
			SET @dynamicCategoryJoin = 'cross join  #cat_IdeaIndicator CAT_PrimaryDisabilityType'
			SET @dynamicCategoryCondition = 'and Category1 = CAT_PrimaryDisabilityType.Code'
		END

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		INSERT INTO #reportCounts
		(
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			PERFORMANCELEVEL,
			PARTICIPATIONSTATUS,
			ECODISSTATUS,
			RACE,
			Category1,
			AssessmentCount
		)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateAbbreviationCode,
			CAT_Organizations.StateAbbreviationDescription,
			CAT_Organizations.OrganizationIdentifierNces,
			CAT_Organizations.OrganizationIdentifierSea,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationIdentifierSea,
			CAT_PERFORMANCELEVEL.Code,
			CAT_PARTICIPATIONSTATUS.Code,
			CAT_ECODISSTATUS.Code,
			CAT_RACE.Code,
			' + @dynamicCategorySelect + ',
			0 as AssessmentCount
		from #CAT_Organizations CAT_Organizations
		cross join  #cat_PERFORMANCELEVEL CAT_PERFORMANCELEVEL
		cross join  #cat_PARTICIPATIONSTATUS CAT_PARTICIPATIONSTATUS
		cross join  #cat_ECODISSTATUS CAT_ECODISSTATUS
		cross join  #cat_RACE CAT_RACE
		' + @dynamicCategoryJoin + '
		where not exists (select 1 from #reportCounts
		where OrganizationIdentifierSea = CAT_Organizations.OrganizationIdentifierSea
		and PERFORMANCELEVEL = CAT_PERFORMANCELEVEL.Code 
		and PARTICIPATIONSTATUS = CAT_PARTICIPATIONSTATUS.Code 
		and ECODISSTATUS = CAT_ECODISSTATUS.Code 
		and RACE = CAT_RACE.Code 
		' + @dynamicCategoryCondition + '
		)
		
		'
	end
	
	if @sqlType = 'zero-discipline' 
	begin

		IF(@categorySetCode = 'disabilitytype')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_PrimaryDisabilityType.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_PrimaryDisabilityType CAT_PrimaryDisabilityType'
			SET @dynamicCategoryCondition = 'and Category = CAT_PrimaryDisabilityType.Code'
		END
		ELSE IF(@categorySetCode = 'gender' or @categorySetCode = 'sex')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_SEX.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_SEX CAT_SEX'
			SET @dynamicCategoryCondition = 'and Category = CAT_SEX.Code'
		END
		ELSE IF(@categorySetCode = 'raceethnicity')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_RACE.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_RACE CAT_RACE'
			SET @dynamicCategoryCondition = 'and Category = CAT_RACE.Code'
		END
		ELSE IF(@categorySetCode = 'cteparticipation')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_CTEPROGRAM.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_CTEPROGRAM CAT_CTEPROGRAM'
			SET @dynamicCategoryCondition = 'and Category = CAT_CTEPROGRAM.Code'
		END
		ELSE IF(@categorySetCode = 'exitingspeceducation')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_SpecialEducationExitReason.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_SpecialEducationExitReason CAT_SpecialEducationExitReason'
			SET @dynamicCategoryCondition = 'and Category = CAT_SpecialEducationExitReason.Code'
		END

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		insert into #reportCounts
		(
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea, 
			REMOVALLENGTH, 
			DisciplineMethodOfChildrenWithDisabilities, 
			IdeaInterimRemovalReason, 
			Category, 
			DisciplineCount)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateAbbreviationCode,
			CAT_Organizations.StateAbbreviationDescription,
			CAT_Organizations.OrganizationIdentifierNces,
			CAT_Organizations.OrganizationIdentifierSea,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationIdentifierSea, 
			CAT_REMOVALLENGTH.Code, 
			CAT_DisciplineMethodOfChildrenWithDisabilities.Code, 
			CAT_IdeaInterimRemovalReason.Code,
			' + @dynamicCategorySelect + ',
			0 as DisciplineCount
		from #CAT_Organizations CAT_Organizations
		cross join  #cat_REMOVALLENGTH CAT_REMOVALLENGTH
		cross join  #cat_DisciplineMethodOfChildrenWithDisabilities CAT_DisciplineMethodOfChildrenWithDisabilities
		cross join  #cat_IdeaInterimRemovalReason CAT_IdeaInterimRemovalReason
		' + @dynamicCategoryJoin + '
		where not exists (select 1 from #reportCounts
		where OrganizationIdentifierSea = CAT_Organizations.OrganizationIdentifierSea
		and REMOVALLENGTH = CAT_REMOVALLENGTH.Code 
		and DisciplineMethodOfChildrenWithDisabilities = CAT_DisciplineMethodOfChildrenWithDisabilities.Code 
		and IdeaInterimRemovalReason = CAT_IdeaInterimRemovalReason.Code 
		' + @dynamicCategoryCondition + '
		)
				
		'
	end

	if @sqlType = 'zero-educenv' 
	begin

		IF(@categorySetCode = 'disabilitytype')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_PrimaryDisabilityType.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_PrimaryDisabilityType CAT_PrimaryDisabilityType'
			SET @dynamicCategoryCondition = 'and Category = CAT_PrimaryDisabilityType.Code'
		END
		ELSE IF(@categorySetCode = 'gender' or @categorySetCode = 'sex')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_SEX.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_SEX CAT_SEX'
			SET @dynamicCategoryCondition = 'and Category = CAT_SEX.Code'
		END
		ELSE IF(@categorySetCode = 'raceethnicity')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_RACE.CODE'
			SET @dynamicCategoryJoin = 'cross join  #cat_RACE CAT_RACE'
			SET @dynamicCategoryCondition = 'and Category = CAT_RACE.Code'
		END

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		insert into #reportCounts
		(
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea, 
			IdeaEducationalEnvironment, 
			Category, 
			StudentCount)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateAbbreviationCode,
			CAT_Organizations.StateAbbreviationDescription,
			CAT_Organizations.OrganizationIdentifierNces,
			CAT_Organizations.OrganizationIdentifierSea,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationIdentifierSea, 
			CAT_IdeaEducationalEnvironment.Code, 
			' + @dynamicCategorySelect + ',
			0 as StudentCount
		from #CAT_Organizations CAT_Organizations
		cross join  #cat_IdeaEducationalEnvironment CAT_IdeaEducationalEnvironment
		' + @dynamicCategoryJoin + '
		where not exists (select 1 from #reportCounts
		where OrganizationIdentifierSea = CAT_Organizations.OrganizationIdentifierSea 
		and IdeaEducationalEnvironment = CAT_IdeaEducationalEnvironment.Code 
		' + @dynamicCategoryCondition + '
		)
				
		'
	end

	if @sqlType = 'zero-programs' 
	begin

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		insert into @reportCounts
		(
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			TitleISchoolStatus, 
			HOMELESSSTATUS, 
			MIGRANTSTATUS, 
			Section504Status, 
			LEPSTATUS, 
			CTEPROGRAM, 
			TitleIIIImmigrantParticipationStatus, 
			EligibilityStatusForSchoolFoodServiceProgram, 
			FOSTERCAREPROGRAM, 
			StudentCount)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateAbbreviationCode,
			CAT_Organizations.StateAbbreviationDescription,
			CAT_Organizations.OrganizationIdentifierNces,
			CAT_Organizations.OrganizationIdentifierSea,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationIdentifierSea,
			CAT_TitleISchoolStatus.Code, 
			CAT_HOMELESSSTATUS.Code, 
			CAT_MIGRANTSTATUS.Code, 
			CAT_Section504Status.Code, 
			CAT_LEPSTATUS.Code, 
			CAT_CTEPROGRAM.Code, 
			CAT_TitleIIIImmigrantParticipationStatus.Code, 
			CAT_EligibilityStatusForSchoolFoodServiceProgram.Code, 
			CAT_FOSTERCAREPROGRAM.Code,
			0 as StudentCount
		from #CAT_Organizations CAT_Organizations
		cross join  #cat_TitleISchoolStatus CAT_TitleISchoolStatus
		cross join  #cat_HOMELESSSTATUS CAT_HOMELESSSTATUS
		cross join  #cat_MIGRANTSTATUS CAT_MIGRANTSTATUS
		cross join  #cat_Section504Status CAT_Section504Status
		cross join  #cat_LEPSTATUS CAT_LEPSTATUS
		cross join  #cat_CTEPROGRAM CAT_CTEPROGRAM
		cross join  #cat_TitleIIIImmigrantParticipationStatus CAT_TitleIIIImmigrantParticipationStatus
		cross join  #cat_EligibilityStatusForSchoolFoodServiceProgram CAT_EligibilityStatusForSchoolFoodServiceProgram
		cross join  #cat_FOSTERCAREPROGRAM CAT_FOSTERCAREPROGRAM
		where not exists (select 1 from @reportCounts
		where OrganizationIdentifierSea = CAT_Organizations.OrganizationIdentifierSea 
		and TitleISchoolStatus = CAT_TitleISchoolStatus.Code 
		and HOMELESSSTATUS = CAT_HOMELESSSTATUS.Code 
		and MIGRANTSTATUS = CAT_MIGRANTSTATUS.Code 
		and Section504Status = CAT_Section504Status.Code 
		and LEPSTATUS = CAT_LEPSTATUS.Code 
		and CTEPROGRAM = CAT_CTEPROGRAM.Code 
		and TitleIIIImmigrantParticipationStatus = CAT_TitleIIIImmigrantParticipationStatus.Code 
		and EligibilityStatusForSchoolFoodServiceProgram = CAT_EligibilityStatusForSchoolFoodServiceProgram.Code 
		and FOSTERCAREPROGRAM = CAT_FOSTERCAREPROGRAM.Code 
		)
				
		'
	end
	return @sql
END
GO


