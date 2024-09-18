CREATE FUNCTION [RDS].[Get_CountSQL]
(
	@reportCode as nvarchar(150),
	@reportLevel as nvarchar(10),
	@reportYear as nvarchar(10),
	@categorySetCode as nvarchar(150),	
	@sqlType as nvarchar(50),
	@includeOrganizations as bit,
	@isFileGenerator as bit,
	@tableTypeAbbrvs as nvarchar(150)='',
	@totalIndicators as Nvarchar(1)='',
	@factTypeCode as varchar(50)
	
)
RETURNS nvarchar(MAX)
AS
BEGIN
		
	declare @sql as nvarchar(max)
	set @sql = ''

	declare @cohortYear varchar(10), @cohortYearTotal varchar(10), @dimFactTypeId as int, @year int, @calculatedMemberDate varchar(10), @calculatedSYStartDate varchar(10), @calculatedSYEndDate varchar(10)

	-- Get GenerateReportTypeCode
	declare @generateReportTypeCode as varchar(50)
	select @generateReportTypeCode = t.ReportTypeCode
	from app.GenerateReports r
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where r.ReportCode = @reportCode


	-- @dimFactTypeId
	select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode
	
	-- Get DimDateId
	declare @dimDateId as int
	select @dimDateId = DimDateId, @year = [Year] from rds.DimDates where SubmissionYear = @reportYear

	
	set @calculatedSYStartDate = '07/01/' + CAST(@year as varchar(4))
	set @calculatedSYEndDate = '06/30/' + CAST(@year + 1 as varchar(4))

	-- Get TableTypeAbbrv and TotalIndicator
	declare @tableTypeAbbrv as nvarchar(150)
	declare @totalIndicator as nvarchar(1)

	IF(@reportCode in ('c204', 'c150', 'c151','c033','c116'))
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
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
		left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
		where r.ReportCode = @reportCode
		and cs.CategorySetCode = @categorySetCode
		and cs.SubmissionYear = @reportYear 
		and o.LevelCode = @reportLevel 
	end

	declare @toggleGrade13 as bit
 	declare @toggleUngraded as bit
	declare @toggleAdultEd as bit
	declare @toggleGradCompltrResponse as varchar(200)
	declare @toggleEnglishLearnerProf as bit
	declare @toggleEnglishLearnerTitleIII as bit
	declare @toggleDisplacedHomemakers as bit
	declare @toggleCteDiploma as varchar(100)
	declare @toggleCtePerkDisab as varchar(50)
	declare @toggleMaxAge as varchar(50)
	declare @istoggleMinAge as bit
	declare @toggleMinAgeGrad as varchar(50)
	declare @toggleBasisOfExit as bit
	declare @toggleChildCountDate as varchar(10)


	-- Get Custom Child Count Date (if available)
	select @toggleChildCountDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	IF LEN(ISNULL(@toggleChildCountDate,'')) <= 0
	BEGIN
		set @toggleChildCountDate = '11/01/' + CAST(@year as varchar(4))
	END

	select @calculatedMemberDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'MEMBERDTE'

	IF LEN(ISNULL(@calculatedMemberDate,'')) <= 0
	BEGIN
		set @calculatedMemberDate = '10/01/' + CAST(@year as varchar(4))
	END

	select @toggleUngraded = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CCDUNGRADED'

	select @toggleGrade13 = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CCDGRADE13'

	select @toggleAdultEd = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ADULTEDU'

	select @toggleEnglishLearnerProf = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ASSESSENGLEARNPROF'

	select @toggleEnglishLearnerTitleIII = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'ASSESSENGLEARNPROFTTLEIII'

	select @toggleDisplacedHomemakers = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CTEDISPLCDHMMKRATSECDLVL'

	select @toggleCtePerkDisab = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CTEPERKDISAB'

	select @toggleMaxAge = replace(ResponseValue, ' Years', '')
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXMAXAGE' and ISNULL(ResponseValue,'None') not in ('None')
	
	select @istoggleMinAge = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXMINAGEIF'

	if(@istoggleMinAge = 1)
	begin
		select @toggleMinAgeGrad = replace(ResponseValue, ' Years', '')
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'DEFEXMINAGENUM'
	end

	select @toggleBasisOfExit = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end,0) 
	from app.ToggleQuestions q 
	left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXCERTIF'

	-- Get Toggle Values
 	---------------------------------------------
	-- Developmental Delay Ages
	declare @toggleDevDelayAges as varchar(1000)
	declare @toggleDevDelay3to5 as varchar(1000)
	declare @toggleDevDelay6to9 as varchar(1000)

	select @toggleDevDelayAges = COALESCE(@toggleDevDelayAges + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'

	select @toggleDevDelay3to5 = COALESCE(@toggleDevDelay3to5 + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
	and ResponseValue in ('3 Years', '4 Years', '5 Years')

	select @toggleDevDelay6to9 = COALESCE(@toggleDevDelay6to9 + ', ''', '''') + replace(ResponseValue, ' Years', '') + ''''
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
	and ResponseValue in ('6 Years', '7 Years', '8 Years', '9 Years')

	Select @toggleGradCompltrResponse = COALESCE(@toggleGradCompltrResponse + ', ' +
		case 
			when ResponseValue = 'Regular diploma that indicates a student meets or exceeds the requirements of a regular diploma.' THEN '''REGDIP'''
			When ResponseValue ='Other high school completion credentials for meeting criteria other than the requirements for a regular diploma(i.e. certificate of completion, certificate of attendance).' 
				THEN '''OTHCOM''' 
		end,
		case when ResponseValue = 'Regular diploma that indicates a student meets or exceeds the requirements of a regular diploma.' THEN '''REGDIP'''
			When ResponseValue ='Other high school completion credentials for meeting criteria other than the requirements for a regular diploma(i.e. certificate of completion, certificate of attendance).' 
				THEN '''OTHCOM''' 
		end)
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
	where q.EmapsQuestionAbbrv = 'GRADRPT'
		
	Set @toggleGradCompltrResponse = ISNULL(@toggleGradCompltrResponse,'''REGDIP'', ''OTHCOM''')

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

	-- Determine Fact/Report Tables
	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

	-- TODO - make this metadata-driven
	declare @personField as nvarchar(50)
	set @personField = 'DimStudentId'
	if @factTable = 'FactPersonnelCounts'
	  begin
		set @personField = 'DimPersonnelId'
	  end

	declare @idFieldsSQL as nvarchar(max)
	set @idFieldsSQL = ''

	if @reportLevel = 'sea'
	  begin
		set @idFieldsSQL = '
		s.StateANSICode as OrganizationNcesId,
		s.SeaStateIdentifier as OrganizationStateId,
		s.SeaName as OrganizationName,
		null as ParentOrganizationStateId'
	end
	else if @reportLevel = 'lea'
	  begin
		set @idFieldsSQL = '
		s.LeaNcesIdentifier as OrganizationNcesId,
		s.LeaStateIdentifier as OrganizationStateId,
		s.LeaName as OrganizationName,
		s.StateANSICode as ParentOrganizationStateId'
	end
	else if @reportLevel = 'sch'
	  begin
		set @idFieldsSQL = '
			s.SchoolNcesIdentifier as OrganizationNcesId,
			s.SchoolStateIdentifier as OrganizationStateId,
			s.SchoolName as OrganizationName,
			s.LeaStateIdentifier as ParentOrganizationStateId'
	end

	-- not Actual sql types
	if @sqlType = 'zero' or @sqlType = 'zero-performance' or @sqlType = 'zero-discipline' or @sqlType = 'zero-educenv' or @sqlType = 'zero-programs' 
	  begin
		if(@includeOrganizations = 1)
		  begin
			set @sql  = '
			declare @dimDateId as int
			set @dimDateId = ' + convert(varchar(20), @dimDateId) + ' 
			declare @dimFactTypeId as int
			set @dimFactTypeId = ' + convert(varchar(20), @dimFactTypeId) + '

			----------------------------
			-- Category Options
			----------------------------
			-- Organizations
			---------------------------
			create table #CAT_Organizations
			(
				[StateANSICode] [nvarchar](100) NULL,
				[StateCode] [nvarchar](100) NULL,
				[StateName] [nvarchar](500) NULL,
				[OrganizationNcesId] [nvarchar](100) NULL,
				[OrganizationStateId] [nvarchar](100) NULL,
				[OrganizationName] [nvarchar](1000) NULL,
				[ParentOrganizationStateId] [nvarchar](100) NULL
			)
			CREATE INDEX IDX_CAT_Organizations ON #CAT_Organizations (OrganizationStateId)

			truncate table #CAT_Organizations

			-- temp Category organizations table
			insert into #CAT_Organizations
			select distinct 
				s.StateANSICode,
				s.StateCode,
				s.StateName, ' +
			@idFieldsSQL + '
			from ' 
			+ case when @reportLevel = 'lea' then 'rds.DimLeas s'
				   else 'rds.DimSchools s' end  +  
			' inner join (
			select ' +  case when @reportLevel = 'lea' then 'LEAStateIdentifier'  else 'SchoolStateIdentifier' end  +  
			' as stateIdentifier, max(OperationalStatusEffectiveDate) as OperationalStatusEffectiveDate
			from rds.FactOrganizationCounts f inner join ' + case when @reportLevel = 'lea' then 'rds.DimLeas l'  else 'rds.DimSchools l' end  +  
			' on ' +  case when @reportLevel = 'lea' then 'f.DimLeaId = l.DimLeaId '  else 'f.DimSchoolId = l.DimSchoolId ' end  +
			' where f.DimCountDateId = ' + CAST(@dimDateId as varchar(10)) +
			' group by ' +  case when @reportLevel = 'lea' then 'LEAStateIdentifier'  else 'SchoolStateIdentifier' end + 
			') status on status.OperationalStatusEffectiveDate = s.OperationalStatusEffectiveDate
			AND status.stateIdentifier = s.' +  case when @reportLevel = 'lea' then 'LEAStateIdentifier'  else 'SchoolStateIdentifier' end
			+ ' where s.ReportedFederally = 1 and ' + case when @reportLevel = 'lea' then 's.DimLeaId <> -1 
			and s.LEAOperationalStatus not in (''Closed'', ''Future'', ''Inactive'', ''MISSING'')'
			else 's.DimSchoolId <> -1 
			and s.SchoolOperationalStatus	not in (''Closed'', ''Future'', ''Inactive'', ''MISSING'')
			' end  

			IF(@reportCode in ('c052'))
			begin
				set @sql  = @sql + ' AND CONVERT(date,s.operationalstatuseffectivedate,101) between CONVERT(date, ''' + @calculatedSYStartDate + ''',101) AND CONVERT(date, ''' + @calculatedMemberDate + ''',101)'
			
			end
			else if(@reportCode in ('c002','c089'))
			begin
				set @sql  = @sql + ' AND CONVERT(date,s.operationalstatuseffectivedate,101) between CONVERT(date, ''' + @calculatedSYStartDate + ''',101) AND CONVERT(date, ''' + @toggleChildCountDate + ''',101)'
			end
			else
			begin
				set @sql  = @sql + ' AND CONVERT(date,s.operationalstatuseffectivedate,101) between CONVERT(date, ''' + @calculatedSYStartDate + ''',101) AND CONVERT(date, ''' + @calculatedSYEndDate + ''',101)'
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
		

		IF(@factReportTable = 'FactPersonnelCountReports')
		BEGIN
			
				set @sql  = '

			----------------------------
			-- Category Options
			----------------------------
			-- Schools
			---------------------------
			create table #CAT_Schools
			(
				DimSchoolId int
			)
			CREATE INDEX IDX_CAT_Schools ON #CAT_Schools (DimSchoolId)

			truncate table #CAT_Schools
			-- temp Category schools table							
			insert into #CAT_Schools
			select distinct fact.DimSchoolId
			from rds.' + @factTable + ' fact
			where fact.DimCountDateId = @dimDateId  
			and fact.DimFactTypeId = @dimFactTypeId
			and fact.DimSchoolId <> -1
			' 

		END
		ELSE
		BEGIN

				set @sql  = '

			----------------------------
			-- Category Options
			----------------------------
			-- Schools
			---------------------------
			create table #CAT_Schools
			(
				DimSchoolId int
			)
			CREATE INDEX IDX_CAT_Schools ON #CAT_Schools (DimSchoolId)

			truncate table #CAT_Schools
			-- temp Category schools table							
			insert into #CAT_Schools
			select distinct fact.DimSchoolId
			from rds.' + @factTable + ' fact
			where fact.DimCountDateId = @dimDateId  
			and fact.DimFactTypeId = @dimFactTypeId
			and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
			' 

		END

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
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
			inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
			inner join app.Categories c on csc.CategoryId = c.CategoryId
			inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
			inner join app.Dimensions d on cd.DimensionId = d.DimensionId
			inner join App.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
			left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
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
				declare @CAT_' + @dimension + ' as table (
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

	DECLARE categoryset_cursor CURSOR FOR 
	select cs.CategorySetId, 
	upper(d.DimensionFieldName) as ReportField, 
	case
		when d.IsOrganizationLevelSpecific = 1 then @reportLevel + 
			case
				when d.DimensionFieldName = 'YEAR' then d.DimensionFieldName
				when @reportCode = 'yeartoyearexitcount' and @categorySetCode in ('exitOnly','exitWithSex','exitWithDisabilityType','exitWithLEPStatus','exitWithRaceEthnic','exitWithAge') and d.DimensionFieldName <>'BASISOFEXIT' then d.DimensionFieldName + 'Description'
				when @reportCode = 'yeartoyearremovalcount' and @categorySetCode in ('removaltype','removaltypewithgender','removaltypewithdisabilitytype','removaltypewithlepstatus','removaltypewithraceethnic','removaltypewithage') and d.DimensionFieldName <>'REMOVALTYPE' then d.DimensionFieldName + 'Description'
				when @generateReportTypeCode = 'datapopulation' then d.DimensionFieldName + 'Code'
				else d.DimensionFieldName + 'EdFactsCode'
			end
		else case
				when d.DimensionFieldName = 'YEAR' then d.DimensionFieldName
				when @reportCode = 'yeartoyearexitcount' and @categorySetCode in ('exitOnly','exitWithSex','exitWithDisabilityType','exitWithLEPStatus','exitWithRaceEthnic','exitWithAge') and d.DimensionFieldName <>'BASISOFEXIT' then d.DimensionFieldName + 'Description'
				when @reportCode = 'yeartoyearremovalcount' and @categorySetCode in ('removaltype','removaltypewithgender','removaltypewithdisabilitytype','removaltypewithlepstatus','removaltypewithraceethnic','removaltypewithage') and d.DimensionFieldName <>'REMOVALTYPE' then d.DimensionFieldName + 'Description'
				when @generateReportTypeCode = 'datapopulation' then d.DimensionFieldName + 'Code'
				else d.DimensionFieldName + 'EdFactsCode'
			end
	end as DimensionField,
	c.CategoryCode, 
	dt.DimensionTableName as DimensionTable
	from app.CategorySets cs
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
	inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
	inner join app.Categories c on csc.CategoryId = c.CategoryId
	inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
	inner join app.Dimensions d on cd.DimensionId = d.DimensionId
	inner join App.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
	left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
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
		cross join  @CAT_' + @reportField + ' CAT_' + @reportField
		
		-- TODO: Add this to RDS.DimensionTables
		set @dimensionPrimaryKey = ''

		if @dimensionTable = 'DimAges'
		begin
			set @dimensionPrimaryKey = 'DimAgeId'
		end

		if @dimensionTable = 'DimDates'
		begin
			set @dimensionPrimaryKey = 'DimDateId'
		end

			if @dimensionTable = 'DimEnrollment'
		begin
			set @dimensionPrimaryKey = 'DimEnrollmentId'
		end

		else if @dimensionTable = 'DimAssessments'
		begin
			set @dimensionPrimaryKey = 'DimAssessmentId'
		end
		else if @dimensionTable = 'DimDemographics'
		begin
			set @dimensionPrimaryKey = 'DimDemographicId'
		end
		else if @dimensionTable = 'DimDisciplines'
		begin
			set @dimensionPrimaryKey = 'DimDisciplineId'
		end
		else if @dimensionTable = 'DimGradeLevels'
		begin
			set @dimensionPrimaryKey = 'DimGradeLevelId'
		end
		else if @dimensionTable = 'DimIdeaStatuses'
		begin
			set @dimensionPrimaryKey = 'DimIdeaStatusId'
		end
		else if @dimensionTable = 'DimPersonnelStatuses'
		begin
			set @dimensionPrimaryKey = 'DimPersonnelStatusId'
		end
		else if @dimensionTable = 'DimPersonnelCategories'
		begin
			set @dimensionPrimaryKey = 'DimPersonnelCategoryId'
		end
		else if @dimensionTable = 'DimRaces'
		begin
			set @dimensionPrimaryKey = 'DimRaceId'
		end
		else if @dimensionTable = 'DimProgramStatuses'
		begin
			set @dimensionPrimaryKey = 'DimProgramStatusId'
		end
		else if @dimensionTable = 'DimTitle1Statuses'
		begin
			set @dimensionPrimaryKey = 'DimTitle1StatusId'
		end
		else if @dimensionTable = 'DimTitleiiiStatuses'
		begin
			set @dimensionPrimaryKey = 'DimTitleiiiStatusId'
		end
		else if @dimensionTable = 'DimLanguages'
		begin
			set @dimensionPrimaryKey = 'DimLanguageId'
		end
		else if @dimensionTable = 'DimStudentStatuses'
		begin
			set @dimensionPrimaryKey = 'DimStudentStatusId'
		end
		else if @dimensionTable = 'DimMigrants'
		begin
			set @dimensionPrimaryKey = 'DimMigrantId'
		end
		else if @dimensionTable = 'DimTitleiiiStatuses'
		begin
			set @dimensionPrimaryKey = 'DimTitleiiiStatusId'
		end
		else if @dimensionTable = 'DimAssessmentStatuses'
		begin
			set @dimensionPrimaryKey = 'DimAssessmentStatusId'
		end
		else if @dimensionTable = 'DimFirearms'
		begin
			set @dimensionPrimaryKey = 'DimFirearmsId'
		end
		else if @dimensionTable = 'DimFirearmsDiscipline'
		begin
			set @dimensionPrimaryKey = 'DimFirearmsDisciplineId'
		end
		else if @dimensionTable = 'DimCohortStatuses'
		begin
			set @dimensionPrimaryKey = 'DimCohortStatusId'
		end
		else if @dimensionTable ='DimNorDProgramStatuses'
		begin
			set @dimensionPrimaryKey = 'DimNorDProgramStatusId'
		end
		else if @dimensionTable ='DimCteStatuses'
		begin
			set @dimensionPrimaryKey = 'DimCteStatusId'
		end
		else if @dimensionTable ='DimEnrollmentStatuses'
		begin
			set @dimensionPrimaryKey = 'DimEnrollmentStatusId'
		end

		if(@includeOrganizations = 1)
		  begin
			if(@isFileGenerator = 0)
			  begin
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					-- ' + @reportField + '
					---------------------------
					declare @CAT_' + @reportField + ' as table (
						Code varchar(100)
					)
					'
			end
		end

		set @sqlCategoryOptions = @sqlCategoryOptions + ' 
			DELETE FROM @CAT_' + @reportField + '
			'						

		-- Get Category Option Values
		-------------------------------------
		if @generateReportTypeCode = 'datapopulation'
		begin

			-- Create CAT table based on category code in category set

			if @categoryCode = 'SEX'
			begin

				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into @CAT_' + @reportField + '
			select distinct Code
			from ods.RefSex

			insert into @CAT_' + @reportField + '
			select ''MISSING''
				'

			end
			else if @categoryCode = 'RACEETHNIC'
			begin
						
				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into @CAT_' + @reportField + '
			select distinct Code
			from ods.RefRace

			insert into @CAT_' + @reportField + '
			select ''MISSING''

			insert into @CAT_' + @reportField + '
			select ''HI''
			'

			end
			else if @categoryCode = 'ECODIS'
			begin

				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into @CAT_' + @reportField + '
			select ''MISSING''

			insert into @CAT_' + @reportField + '
			select ''EconomicDisadvantage''
			'

			end
			else if @categoryCode = 'HOMELSENRLSTAT'
			begin

				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into @CAT_' + @reportField + '
			select ''MISSING''

			insert into @CAT_' + @reportField + '
			select ''HomelessUnaccompaniedYouth''
			'
			end
			else if @categoryCode = 'MIGRNTSTATUS'
			begin

				set @sqlCategoryOptions = @sqlCategoryOptions + '
			insert into @CAT_' + @reportField + '
			select ''MISSING''

			insert into @CAT_' + @reportField + '
			select ''Migrant''
			'

			end

		
			else
			begin
				if @reportCode = 'studentswdtitle1'
				begin
					-- (no category sets ARE available)
					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into @CAT_' + @reportField + '
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
						insert into @CAT_' + @reportField + '
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
				insert into @CAT_' + @reportField + '
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
					insert into @CAT_' + @reportField + '
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

				IF(@categoryCode = 'GRADELVBASICW13')
				BEGIN
					set @gradeList = '''KG'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'''
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
					insert into @CAT_' + @reportField + '
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
				set @gradeList = '''KG'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'''

				IF(@toggleGrade13 = 1)
				BEGIN
					set @gradeList = @gradeList + ',''13'''
				END

				IF(@toggleUngraded = 1)
				BEGIN
					set @gradeList = @gradeList + ',''UG'''
				END

				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into @CAT_' + @reportField + '
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
					insert into @CAT_' + @reportField + '
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
						insert into @CAT_' + @reportField + '
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
						insert into @CAT_' + @reportField + '
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
				-- Check Toggle settings
				if exists (select 1 from app.ToggleResponses r
							inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
							where q.EmapsQuestionAbbrv = 'GRADRPT')
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into @CAT_' + @reportField + '
						SELECT distinct o.CategoryOptionCode
						from app.CategoryOptions o
						inner join app.Categories c on o.CategoryId = c.CategoryId
						and c.CategoryCode = ''' +  @categoryCode + '''
						and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
						inner join app.ToggleResponses r on o.CategoryOptionCode = 
								case
									when o.CategoryOptionCode = ''MISSING'' then o.CategoryOptionCode
									else
										case when r.ResponseValue =''Regular diploma that indicates a student meets or exceeds the requirements of a regular diploma.'' Then ''REGDIP''
										else  ''OTHCOM'' end
								end
						inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
						where q.EmapsQuestionAbbrv = ''GRADRPT''
						'
				end
				else
				begin

					set @sqlCategoryOptions = @sqlCategoryOptions + '
						insert into @CAT_' + @reportField + '
						SELECT distinct o.CategoryOptionCode
						from app.CategoryOptions o
						inner join app.Categories c on o.CategoryId = c.CategoryId
						and c.CategoryCode = ''' +  @categoryCode + '''
						and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
						where 1 = 1
						'
				end
			end
			else if @categoryCode in ('DISCIPLINEACTION', 'ASSESSMENTSUBJECT', 'PERSONNELTYPE')
			begin
				-- No category sets available
				set @sqlCategoryOptions = @sqlCategoryOptions + '
					insert into @CAT_' + @reportField + '
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
					insert into @CAT_' + @reportField + '
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
				insert into @CAT_' + @reportField + '
				SELECT distinct o.CategoryOptionCode
				from app.CategoryOptions o
				inner join app.Categories c on o.CategoryId = c.CategoryId
				and c.CategoryCode = ''' +  @categoryCode + '''
				and o.CategorySetId = ' + convert(varchar(20), @categorySetId) + '
				where 1 = 1
				'
		end

		-- Remove options based on report
		if @reportCode in ('c002')
			begin
				if @categoryCode = 'EDUCENV' and @reportLevel = 'sch'
				begin 
					set @sqlCategoryOptions = @sqlCategoryOptions + '
					and o.CategoryOptionCode NOT IN (''PPPS'', ''HH'') '
				end
			end
		else if @reportCode in ('c005')
			begin
				if @categoryCode = 'EDUCENV'
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
					and o.CategoryOptionCode NOT IN (''PPPS'') '
				end
							
			end
		else if @reportCode in ('c007')
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
		else if @reportCode in ('c006', 'c088', 'c143')
			begin
				if @categoryCode = 'EDUCENV'
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
					and o.CategoryOptionCode NOT IN (''PPPS'') '
				end
			end 

		else if @reportCode in ('c137')
			begin
				if @categoryCode = 'PARTSTATUS' AND @toggleEnglishLearnerProf = 0
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
					and o.CategoryOptionCode NOT IN (''MEDICAL'') '
				end
			end 

		else if @reportCode in ('c138')
			begin
				if @categoryCode = 'PARTSTATUS' AND @toggleEnglishLearnerTitleIII = 0
				begin
					set @sqlCategoryOptions = @sqlCategoryOptions + '
					and o.CategoryOptionCode NOT IN (''MEDICAL'') '
					set @sqlCategoryOptions = @sqlCategoryOptions + '
					and o.CategoryOptionCode NOT IN (''MEDEXEMPT'') '
				end
			end 

		else if @reportCode in ('c144')
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
				end
			end


		if @sqlType = 'actual'
			begin
				-- Determine Return Values for option values based on category and/or report
				declare @categoryReturnFieldIsAggregate as bit
				set @categoryReturnFieldIsAggregate = 0

				-- TODO - make use of IsCalculated field to drive this via metadata
				IF @categoryCode = 'REMOVALLENSUS'
					begin
						set @sqlCategoryReturnField = '
						case 
							when sum(isnull(fact.DisciplineDuration, 0)) <= 0 then ''MISSING''
							when sum(isnull(fact.DisciplineDuration, 0)) <= 10.0 then ''LTOREQ10''
							else ''GREATER10''
						end'
						set @categoryReturnFieldIsAggregate = 1
					end
				else if @categoryCode = 'REMOVALLENIDEA'
					begin
						set @sqlCategoryReturnField = '
						case 
							when sum(isnull(fact.DisciplineDuration, 0)) >= 0.5 AND sum(isnull(fact.DisciplineDuration, 0)) < 1.5 then ''LTOREQ1''
							when sum(isnull(fact.DisciplineDuration, 0)) <= 10.0 then ''2TO10''
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
					else
					begin
						set @sqlCategoryReturnField = 'CAT_' + @reportField + '.RaceCode'
					end
					end
				else if @categoryCode = 'MAJORREG'
					begin
						set @sqlCategoryReturnField = '
						case 
							when CAT_' + @reportField + '.RaceCode = ''AM7'' then ''MAN''
							when CAT_' + @reportField + '.RaceCode = ''AS7'' then ''MA''
							when CAT_' + @reportField + '.RaceCode = ''BL7'' then ''MB''
							when CAT_' + @reportField + '.RaceCode = ''HI7'' then ''MHL''
							when CAT_' + @reportField + '.RaceCode = ''MU7'' then ''MM''
							when CAT_' + @reportField + '.RaceCode = ''PI7'' then ''MNP''
							when CAT_' + @reportField + '.RaceCode = ''WH7'' then ''MW''
							else ''MISSING''
						end'
					end
				else if @categoryCode in ('DISABSTATIDEA', 'DISABSTATUS', 'DISABIDEASTATUS')
					begin
						if @reportCode = 'c175'
							begin
								set @sqlCategoryReturnField = ' 
								case 
									when CAT_' + @reportField + '.IDEAIndicatorCode = ''MISSING'' then ''MISSING''
									else ''WDIS''
								end'
							end
						else
							begin
								set @sqlCategoryReturnField = '
								case 
									when CAT_' + @reportField + '.IDEAIndicatorCode = ''MISSING'' then ''WODIS''
									else ''WDIS''
								end'
							end
					end
				else if @categoryCode in ('DISABCATIDEA') and @year < 2020
				begin
					
					set @sqlCategoryReturnField = ' 
								case 
									when CAT_' + @reportField + '.DisabilityCode = ''ID'' then ''MR''
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
					ELSE If @reportCode in ( 'C138', 'C137')
						BEGIN
							set @sqlCategoryReturnField = ' 
							case 
								when CAT_' + @reportField + '.ParticipationStatusCode = ''MISSING'' then ''MISSING''						
								when CAT_' + @reportField + '.ParticipationStatusCode = ''NPART'' then ''NPART''
								when CAT_' + @reportField + '.ParticipationStatusCode = ''MEDEXEMPT'' then ''MEDICAL''
								else ''PART''
							end'
						END
					end
				else if @categoryCode = 'LUNCHPROG'
					begin
						set @sqlCategoryReturnField = ' 
							case 
								when CAT_' + @reportField + '.FoodServiceEligibilityCode = ''FREE'' then ''FL''
								when CAT_' + @reportField + '.FoodServiceEligibilityCode = ''REDUCEDPRICE'' then ''RPL''
								else CAT_' + @reportField + '.' + @dimensionField + '
							end'
					end

				else if @categoryCode = 'HOMELESS'
					begin
						set @sqlCategoryReturnField = ' 
							case 
								when CAT_' + @reportField + '.HomelessStatusCode = ''Homeless'' then ''H''					
								else CAT_' + @reportField + '.' + @dimensionField + '
							end'
					end
				else if @categoryCode = 'DISABSTATUS504'
					begin
						set @sqlCategoryReturnField = ' 
							case 
								when CAT_' + @reportField + '.Section504ProgramCode = ''SECTION504'' then ''DISAB504STAT''					
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

				---Begin New Code for c118

				else if @categoryCode = 'AGE3TOGRADE13'
					begin
						set @sqlCategoryReturnField = ' 
							case 
								when isnull(da.AgeCode, ''99'') IN (''3'', ''4'', ''5'')
										and isnull(CAT_GRADELEVEL.GradeLevelEdFactsCode, ''xx'') <> ''KG'' THEN ''AGE3TO5NOTK''
								else CAT_GRADELEVEL.GradeLevelEdFactsCode END'
					end

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
							when CAT_' + @reportField + '.FosterCareProgramCode = ''FOSTERCARE'' then ''FCS''					
							else CAT_' + @reportField + '.' + @dimensionField + '
						end'
				end
				else if (@categoryCode = 'PROFSTATUS' and @reportCode  IN ('yeartoyearprogress','c175','c178','c179'))
					begin
						set @sqlCategoryReturnField = ' 
							case 
								WHEN assmnt.PerformanceLevelEdFactsCode =''MISSING'' THEN ''MISSING''
								when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''PROFICIENT''		
								when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)  THEN  ''NOTPROFICIENT''
								else ''MISSING''
							end'
					end
				else if @categoryCode = 'PROFSTATUS' and @reportCode='c142'
					begin
						set @sqlCategoryReturnField = ' 
							case 
							WHEN assmnt.PerformanceLevelEdFactsCode =''MISSING'' THEN ''NODETERM''
							when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  ''PROFICIENT''		
							when CAST(SUBSTRING( assmnt.PerformanceLevelEdFactsCode, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)  THEN  ''NOTPROFICIENT''	
							else ''MISSING''
							end'
					end

				else if @categoryCode = 'TESRES' and @reportCode='c157'
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
									when CAT_' + @reportField + '.DisabilityCode = ''MISSING'' then ''MISSING''
									else ''DISADA''
								end'
							end
						else
							begin
								set @sqlCategoryReturnField = '
								case 
									when CAT_' + @reportField + '.DisabilityCode = ''MISSING'' then ''MISSING''
									else ''WDIS''
								end'
							end
					end
				else if @categoryCode in ('ACADSUBASSESNOSCI','ACADSUBASSES')
				begin
					set @sqlCategoryReturnField = ' 
						case 
							when CAT_' + @reportField + '.AssessmentSubjectEdFactsCode = ''MATH'' then ''M''	
							when CAT_' + @reportField + '.AssessmentSubjectEdFactsCode = ''SCIENCE'' then ''S''				
							else CAT_' + @reportField + '.' + @dimensionField + '
						end'
				end
				else if @categoryCode IN ('AGESA','AGEEC') and @reportCode in ('c002', 'c089') and @year > 2018
				begin
					set @sqlCategoryReturnField = 'CAT_' + @reportField + '_temp.Code'
				end
				else
				begin
					-- Default
					set @sqlCategoryReturnField = 'CAT_' + @reportField + '.' + @dimensionField
				end

				-- Add return value for this category to the list of fields
				IF(@reportCode = 'c006')
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
				if(@reportCode = 'c006' AND @dimensionField <> 'RemovalLengthEdFactsCode')
				begin
					if @categoryCode = 'RACEETHNIC'
					begin
						set @sqlCategoryQualifiedSubDimensionFields = @sqlCategoryQualifiedSubDimensionFields + ', RaceCode'
						set @sqlCategoryQualifiedSubGroupDimensionFields = @sqlCategoryQualifiedSubGroupDimensionFields + ', RaceCode'
					end
					else
					begin
						set @sqlCategoryQualifiedSubDimensionFields = @sqlCategoryQualifiedSubDimensionFields + ', ' + 'CAT_' + @reportField + '.' + @dimensionField
						set @sqlCategoryQualifiedSubGroupDimensionFields = @sqlCategoryQualifiedSubGroupDimensionFields + ', ' +  'fact.' + @dimensionField 
					end
				end

				----Begin New Code for c118

				if(@reportCode = 'c118')
				begin
					if @categoryCode = 'AGE3TOGRADE13'
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
						set @sqlHavingClause = @sqlHavingClause + ' and ' + @sqlCategoryReturnField + ' in (select Code from @CAT_' + @reportField + ')'
					end

			-- Build join conditions for actual counts
				if @reportField = 'RACE' and @reportCode in ('yeartoyearremovalcount','yeartoyearexitcount') and @categorySetCode not in ('raceethnicity','raceethnic')
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimRaces CAT_' + @reportField + ' on fact.DimRaceId = CAT_' + @reportField + '.DimRaceId 
					and isnull(CAT_' + @reportField + '.dimFactTypeId, @dimFactTypeId) = @dimFactTypeId
					inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
						on CAT_RACE.RaceCode = CAT_' + @reportField + '_temp.Code'
				end
				else if @reportField = 'RACE'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimRaces CAT_' + @reportField + ' on fact.DimRaceId = CAT_' + @reportField + '.DimRaceId 
					and isnull(CAT_' + @reportField + '.dimFactTypeId, @dimFactTypeId) = @dimFactTypeId
					inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
				end
			else if (@reportField = 'PROFICIENCYSTATUS' and @reportCode in ('yeartoyearprogress','c175','c178','c179'))
			BEGIN
					set @sqlCountJoins = @sqlCountJoins + '		
						inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
						inner join RDS.DimAssessments assmnt on fact.DimAssessmentId = assmnt.DimAssessmentId 
						inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = CAT_GradeLevel.GradeLevelCode and tgglAssmnt.Subject = assmnt.AssessmentSubjectEdFactsCode	
															AND tgglAssmnt.AssessmentTypeCode = assmnt.AssessmentTypeEdFactsCode			
						inner join @CAT_' + + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
						'
			END	
			---Begin New Code for c118

			else if(@reportField = 'GRADELEVEL' and @reportCode in ('c118'))
			BEGIN
					set @sqlCountJoins = @sqlCountJoins + '		
						left join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
						left join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
							on ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode = CAT_' + @reportField + '_temp.Code
							and ' + 'CAT_' + @reportField + '.GradeLevelEdFactsCode NOT IN (''AE'')
						left join RDS.DimAges da ON fact.DimAgeId = da.DimAgeId
							and da.AgeCode IN (''3'', ''4'', ''5'')
						'
			END

			---End New Code


			else if(@reportField = 'PROFICIENCYSTATUS' and @reportCode in ('C142'))
			BEGIN
					set @sqlCountJoins = @sqlCountJoins + '		
						inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
						inner join RDS.DimGradeLevels grdlevel on fact.DimGradeLevelId = grdlevel.DimGradeLevelId
						inner join RDS.DimAssessments assmnt on fact.DimAssessmentId = assmnt.DimAssessmentId 
						inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = grdlevel.GradeLevelCode and tgglAssmnt.Subject = assmnt.AssessmentSubjectEdFactsCode				
						inner join @CAT_' + + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
						inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId			
							 and cteStatus.CteProgramCode =''CTECONC'''
			END				
			else if(@reportField = 'TESTRESULT' and  @reportCode in ('C157'))
			BEGIN
				set @sqlCountJoins = @sqlCountJoins + '		
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '	
					inner join RDS.DimGradeLevels grdlevel on fact.DimGradeLevelId = grdlevel.DimGradeLevelId
					inner join RDS.DimAssessments assmnt on fact.DimAssessmentId = assmnt.DimAssessmentId 
					inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = grdlevel.GradeLevelCode and tgglAssmnt.Subject = assmnt.AssessmentSubjectEdFactsCode	
					inner join @CAT_' + + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code
					inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId			
							and cteStatus.CteProgramCode =''CTECONC'''
			END	
			else if(@reportCode in ('c002','c089') and @year > 2018 and @reportField IN ('AGE'))
			begin
				set @sqlCountJoins = @sqlCountJoins + '
				inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
				inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
					on CAT_' + @reportField + '.' + @reportField + 'EdfactsCode' + ' = IIF(CAT_' + @reportField + '_temp.Code ' + 'in (''AGE05K'',''AGE05NOTK''), ''5'',' + ' CAT_' + @reportField + '_temp.Code)'
			end
			else if(@reportCode in ('yeartoyearchildcount', 'yeartoyearenvironmentcount','yeartoyearexitcount','yeartoyearremovalcount','studentssummary'))
			BEGIN
				if @dimensionTable='DimDates'
				begin
					set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.DimCountDateId = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
					inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
				end
				else
				begin
				if(@reportCode in ('yeartoyearexitcount') and @categorySetCode in ('exitOnly','exitWithSex','exitWithDisabilityType','exitWithLEPStatus','exitWithRaceEthnic','exitWithAge')
				and @reportField IN ('SEX','DISABILITY','RACE','LEPSTATUS','AGE'))
				begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
					inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + LEFT(@sqlCategoryReturnField ,(len(@sqlCategoryReturnField)- 11)) + 'EdfactsCode = CAT_' + @reportField + '_temp.Code'
				end
				else if(@reportCode in ('yeartoyearremovalcount') and @categorySetCode in ('removaltype','removaltypewithgender','removaltypewithdisabilitytype','removaltypewithlepstatus','removaltypewithraceethnic','removaltypewithage') and @reportField IN ('SEX','DISABILITY','RACE','LEPSTATUS','AGE'))
				begin
				set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
					inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + LEFT(@sqlCategoryReturnField ,(len(@sqlCategoryReturnField)- 11)) + 'EdfactsCode = CAT_' + @reportField + '_temp.Code'
				end
				else
					begin
						set @sqlCountJoins = @sqlCountJoins + '
					inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
					inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
						on ' + @sqlCategoryReturnField + ' = CAT_' + @reportField + '_temp.Code'
					end
				end

				
		END		
				else
				begin
					if @categoryReturnFieldIsAggregate = 0
					begin
						set @sqlCountJoins = @sqlCountJoins + '
						inner join RDS.' + @dimensionTable + ' CAT_' + @reportField + ' on fact.' + @dimensionPrimaryKey + ' = CAT_' + @reportField + '.' + @dimensionPrimaryKey + '
						inner join @CAT_' + @reportField + ' CAT_' + @reportField + '_temp
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
								
		if @reportCode in ('c002','edenvironmentdisabilitiesage6-21','c089','disciplinaryremovals','c006','c005')
		begin

			IF CHARINDEX('DISABILITY', @categorySetReportFieldList) = 0 
			begin
				set @reportFilterJoin = 'inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId'
				set @reportFilterCondition = 'and idea.DisabilityEdFactsCode <> ''MISSING'''

			IF @reportLevel = 'sch' and @reportCode = 'c002'
			begin
				set @reportFilterCondition = @reportFilterCondition + ' and idea.EducEnvEdFactsCode not in (''HH'', ''PPPS'')'
			end
			end
			ELSE IF @reportLevel = 'sch' AND CHARINDEX('DISABILITY', @categorySetReportFieldList) > 0 and @reportCode = 'c002'
			begin
				set @reportFilterJoin = 'inner join rds.DimIdeaStatuses educenv on fact.DimIdeaStatusId = educenv.DimIdeaStatusId'
				set @reportFilterCondition = 'and educenv.EducEnvEdFactsCode not in (''HH'', ''PPPS'')'
			end

			IF @year > 2018 AND @reportCode = 'c002' AND CHARINDEX('AGE', @categorySetReportFieldList) > 0 
			begin
				set @reportFilterJoin = @reportFilterJoin + '
				inner join rds.DimGradeLevels g on fact.DimGradeLevelId = g.DimGradeLevelId 
				and g.GradeLevelEdFactsCode = IIF(CAT_AGE_temp.Code = ''AGE05K'', ''KG'', g.GradeLevelEdFactsCode)'
			end
			ELSE IF @year > 2018 AND @reportCode = 'c089' AND CHARINDEX('AGE', @categorySetReportFieldList) > 0 
			begin
				set @reportFilterJoin = @reportFilterJoin + '
				inner join rds.DimGradeLevels g on fact.DimGradeLevelId = g.DimGradeLevelId 
				and g.GradeLevelEdFactsCode = IIF(CAT_AGE_temp.Code = ''AGE05NOTK'', ''PK'', g.GradeLevelEdFactsCode)'
			end
			
		end
		else if @reportCode in ('c116')
		begin
				set @reportFilterJoin = 'inner join rds.DimTitleiiiStatuses titleIII on fact.DimTitleiiiStatusId = titleIII.DimTitleiiiStatusId'
				set @reportFilterCondition = 'and titleIII.TitleiiiLanguageInstructionCode <> ''MISSING'''
		end

		else if @reportCode in ('c157')
		begin
				set @reportFilterJoin = '
								inner join RDS.DimAssessments assmntSubject on fact.DimAssessmentId = assmntSubject.DimAssessmentId'
				set @reportFilterCondition = '
				and assmntSubject.AssessmentSubjectCode = ''73065'''
		end
		else if @reportCode in ('c143')
		begin
				set @reportFilterJoin = 'inner join RDS.DimDisciplines CAT_DISCIPLINEACTION 
				on fact.DimDisciplineId = CAT_DISCIPLINEACTION.DimDisciplineId
				inner join RDS.DimDisciplines CAT_REMOVALTYPE on fact.DimDisciplineId = CAT_REMOVALTYPE.DimDisciplineId
				inner join RDS.DimIdeaStatuses CAT_EDUCENV on fact.DimIdeaStatusId = CAT_EDUCENV.DimIdeaStatusId																									
				'
				set @reportFilterCondition = ' 
				and (CAT_DISCIPLINEACTION.DisciplineActionEdFactsCode IN (''03086'', ''03087'', ''03100'', ''03101'', ''03102'', ''03154'', ''03155'') 
				or CAT_REMOVALTYPE.RemovalTypeEdFactsCode <> ''MISSING'')
				and CAT_EDUCENV.EducEnvCode <> ''PPPS''
				and CAT_EDUCENV.IDEAIndicatorCode = ''IDEA'''
		end
		else if @reportCode in ('c144')
		begin
				set @reportFilterJoin = 'inner join RDS.DimDisciplines CAT_DISCIPLINEACTION 
				on fact.DimDisciplineId = CAT_DISCIPLINEACTION.DimDisciplineId
				inner join RDS.DimIdeaStatuses CAT_EDUCENV on fact.DimIdeaStatusId = CAT_EDUCENV.DimIdeaStatusId
				'
				set @reportFilterCondition = ' 
				and (CAT_DISCIPLINEACTION.DisciplineActionEdFactsCode IN (''03086'', ''03087''))
				and CAT_EDUCENV.EducEnvCode <> ''PPPS'''
		end
	

		-- Filter facts based on report
		----------------------------------
		declare @queryFactFilter as nvarchar(max)
		set @queryFactFilter = ''
								
		if @reportCode in ('c002','edenvironmentdisabilitiesage6-21')
		begin
			-- Ages 6-21, Has Disability
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.DimStudentId, idea.DimIdeaStatusId' 
					+ CASE WHEN (@year > 2018 AND @reportCode = 'c002') THEN ' ,grades.DimGradeLevelId' ELSE '' END +
					'
					from rds.' + @factTable + ' fact
					inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
						and age.AgeValue >= ' + CAST(IIF(@year > 2018 AND @reportCode = 'c002',5,6) as varchar(10)) + ' and age.AgeValue <= 21
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId'
					+ CASE WHEN (@year > 2018 AND @reportCode = 'c002') THEN  '
					inner join rds.DimGradeLevels grades on fact.DimGradeLevelId = grades.DimGradeLevelId
					and grades.GradeLevelEdFactsCode = IIF(age.AgeValue = 5, ''KG'', grades.GradeLevelEdFactsCode)' ELSE '' END + ' 
					 where idea.DisabilityEdFactsCode <> ''MISSING''
				)  rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
				+ CASE WHEN (@year > 2018 AND @reportCode = 'c002') THEN ' and fact.DimGradeLevelId = rules.DimGradeLevelId' ELSE '' END + '
				'
	
			if not @toggleDevDelayAges is null
			begin
				-- Exclude DD from counts for invalid ages

				set @sqlCountJoins = @sqlCountJoins + '
					left join (
						select distinct fact.DimStudentId
						from rds.' + @factTable + ' fact
						inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
							and not age.AgeCode in (' + @toggleDevDelayAges + ')
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
						where idea.DisabilityEdFactsCode = ''DD''
					) exclude
						on fact.DimStudentId = exclude.DimStudentId'
						
				set @queryFactFilter = @queryFactFilter + '
				and exclude.DimStudentId IS NULL'

				if @toggleDevDelay6to9 is null and CHARINDEX('DISABILITY', @categorySetReportFieldList) > 0
				begin
					set @sqlRemoveMissing = @sqlRemoveMissing + '

					-- Remove DD counts for invalid ages
					delete from #categorySet where DISABILITY = ''DD''
					'
				end

			end

		end 
	else if @reportCode in ('c005', 'c007', 'disciplinaryremovals')
		begin
		-- Ages 3-21, Has Disability
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, idea.DimIdeaStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 3 and age.AgeValue <= 21
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
				where idea.EducEnvCode <> ''PPPS''
					and idea.IDEAIndicatorCode = ''IDEA''
			)  rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId
			and fact.DimStudentId NOT IN (SELECT DimStudentId FROM RDS.FactStudentDisciplines sd GROUP BY DimStudentId HAVING SUM(sd.DisciplineDuration) > 45)'
			
		end
	else if @reportCode = 'c009'
		begin
		-- Ages 14-21, Has Disability
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, idea.DimIdeaStatusId
				from rds.FactStudentCounts fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 14 and age.AgeValue <= 21
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
				where idea.BasisOfExitEdFactsCode <> ''MISSING'' and idea.EducEnvEdFactsCode <> ''PPPS''
			) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId '
		end
	else if @reportCode in ('c089','edenvironmentdisabilitiesage3-5')
		begin
			-- Ages 3-5, Has Disability
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.DimStudentId, idea.DimIdeaStatusId
					from rds.' + @factTable + ' fact
					inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
						and age.AgeValue >= 3 and age.AgeValue <= 5
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
					where idea.DisabilityEdFactsCode <> ''MISSING''
				) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId '
		
			if not @toggleDevDelayAges is null
				begin
					set @queryFactFilter = @queryFactFilter + '
						and not fact.DimStudentId  in (
							select distinct fact.DimStudentId
							from rds.' + @factTable + ' fact
							inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
								and not age.AgeCode in (' + @toggleDevDelayAges + ')
							inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
							and fact.DimCountDateId = @dimDateId
							and fact.DimFactTypeId = @dimFactTypeId
							and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
							inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
							where idea.DisabilityEdFactsCode = ''DD''
						)'
						
					if @toggleDevDelay3to5 is null and CHARINDEX('DISABILITY', @categorySetReportFieldList) > 0
						begin
							set @sqlRemoveMissing = @sqlRemoveMissing + '
								-- Remove DD counts for invalid ages
								delete from #categorySet where DISABILITY = ''DD''
							'
						end
				end
		end
	else if @reportCode in ('c006')
		begin
		-- Ages 3-21, Has Disability, Duration >= 0.5 
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, idea.DimIdeaStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 3 and age.AgeValue <= 21
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
				where idea.EducEnvCode <> ''PPPS''
					and idea.IDEAIndicatorCode = ''IDEA''
			) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId 
			'

		end
	else if @reportCode in ('c088', 'c143')
		begin
		-- Ages 3-21, Has Disability, Duration >= 0.5 
			set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, idea.DimIdeaStatusId, dis.DimDisciplineId
				from rds.' + @factTable + ' fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 3 and age.AgeValue <= 21
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
				inner join rds.DimDisciplines dis on fact.DimDisciplineId = dis.DimDisciplineId
				where idea.EducEnvCode <> ''PPPS''
					and idea.IDEAIndicatorCode = ''IDEA''
					and (dis.DisciplineMethodCode <> ''MISSING''
						or dis.DisciplineActionCode IN (''03086'', ''03087'', ''03158'')
						or dis.RemovalReasonCode <> ''MISSING''
						or dis.RemovalTypeCode <> ''MISSING'')


			) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId and fact.DimDisciplineId = rules.DimDisciplineId 
			and fact.DimStudentId IN (
					SELECT DimStudentId 
					FROM RDS.FactStudentDisciplines sd 
					inner join rds.DimIdeaStatuses idea on sd.DimIdeaStatusId = idea.DimIdeaStatusId
					inner join rds.DimDisciplines dis on sd.DimDisciplineId = dis.DimDisciplineId
					where idea.EducEnvCode <> ''PPPS''
						and idea.IDEAIndicatorCode = ''IDEA''
						and (dis.DisciplineMethodCode <> ''MISSING''
							or dis.DisciplineActionCode IN (''03086'', ''03087'', ''03158'')
							or dis.RemovalReasonCode <> ''MISSING''
							or dis.RemovalTypeCode <> ''MISSING'')
					GROUP BY DimStudentId HAVING SUM(sd.DisciplineDuration) >= 0.5)
			'

			if CHARINDEX('DISCIPLINEACTION', @categorySetReportFieldList) > 0 and CHARINDEX('REMOVALTYPE', @categorySetReportFieldList) > 0
			begin
				set @sqlCountJoins = @sqlCountJoins + ' 
				and (CAT_DISCIPLINEACTION.DisciplineActionEdFactsCode IN (''03086'', ''03087'', ''03100'', ''03101'', ''03102'', ''03154'', ''03155'') 
				or CAT_REMOVALTYPE.RemovalTypeEdFactsCode <> ''MISSING'')
				'
			end

		end
	else if @reportCode in ('c134')
	BEGIN
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
					select distinct fact.DimStudentID,  titleI.DimTitle1StatusId	
					from rds.' + @factTable + ' fact
					inner join rds.DimTitle1Statuses titleI on fact.DimTitle1StatusId = titleI.DimTitle1StatusId
					and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				where titleI.Title1ProgramTypeCode <> ''MISSING''
			) rules on fact.DimStudentId = rules.DimStudentId and fact.DimTitle1StatusId = rules.DimTitle1StatusId'	
	END
	else if @reportCode in('c138' , 'C137', 'C139')
		BEGIN
			-- Assessment type = ELPASS
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
					select distinct fact.DimStudentID,  assessment.DimAssessmentID	
					from rds.' + @factTable + ' fact
					inner join rds.DimAssessments assessment on fact.DimAssessmentID = assessment.DimAssessmentID
					and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				where assessment.AssessmentTypeEdFactsCode = ''ELPASS''
			) rules on fact.DimStudentId = rules.DimStudentId and fact.DimAssessmentID = rules.DimAssessmentID'	
			
			if(@reportCode = 'C138')
			BEGIN
				set @sqlCountJoins = @sqlCountJoins +  '
										and fact.DimTitleiiiStatusId <> -1'
			END
		END
		else if @reportCode in ('c144')
        begin
             -- Ages 3-21 (if has disability), Grads K-12 (if no disability)
             set @sqlCountJoins = @sqlCountJoins + '
                    inner join (
                                                       select distinct fact.DimStudentId, fact.DimIdeaStatusId, fact.DimGradeLevelId, fact.dimschoolid
                                                       from rds.' + @factTable + ' fact
                                                       inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
                                                       and age.AgeValue >= 3 and age.AgeValue <= 21
                                                       inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
                                                       and fact.DimCountDateId = @dimDateId
                                                       and fact.DimFactTypeId = @dimFactTypeId
                                                       and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
                                                       inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
													   inner join rds.DimGradeLevels grades on fact.DimGradeLevelId = grades.DimGradeLevelId
                                                       where idea.DisabilityEdFactsCode <> ''MISSING''
                                                       union
                                                       select distinct fact.DimStudentId, fact.DimIdeaStatusId, fact.DimGradeLevelId, fact.dimschoolid
                                                       from rds.' + @factTable + ' fact
                                                       inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
                                                       inner join rds.DimGradeLevels grades on fact.DimGradeLevelId = grades.DimGradeLevelId
                                                       where fact.DimCountDateId = @dimDateId
                                                       and fact.DimFactTypeId = @dimFactTypeId
                                                       and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
                                                       and idea.DisabilityEdFactsCode = ''MISSING''
													   and idea.EducEnvCode <> ''PPPS''
                                                       and grades.GradeLevelCode in (''KG'', ''01'', ''02'', ''03'', ''04'', ''05'', ''06'', ''07'', ''08'', ''09'', ''10'', ''11'', ''12'')
                           ) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId
						   and fact.DimGradeLevelId = rules.DimGradeLevelId and fact.dimschoolid = rules.dimschoolid
                    '
		end
		else if @reportCode in ('c175', 'c178', 'c179')
		begin
		set @queryFactFilter = 'and CAT_ASSESSMENTTYPE.AssessmentSubjectEdFactsCode = '
			if(@reportCode = 'c175')
			begin
				set @queryFactFilter = @queryFactFilter + '''MATH'''
			end
			else if(@reportCode = 'c178')
			begin
				set @queryFactFilter = @queryFactFilter + '''RLA'''
			end
			else if(@reportCode = 'c179')
			begin
				set @queryFactFilter = @queryFactFilter + '''SCIENCE'''
			end
		end
		else if @reportCode in ('c185', 'c188', 'c189')
		begin
			set @queryFactFilter = 'and CAT_PARTICIPATIONSTATUS.AssessmentSubjectEdFactsCode = '
			if(@reportCode = 'c185')
			begin
				set @queryFactFilter = @queryFactFilter + '''MATH'''
			end
			else if(@reportCode = 'c188')
			begin
				set @queryFactFilter = @queryFactFilter + '''RLA'''
			end
			else if(@reportCode = 'c189')
			begin
				set @queryFactFilter = @queryFactFilter + '''SCIENCE'''
			end
		end
	else if @reportCode in ('studentswdtitle1','c037')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimSchoolId, titleI.DimTitle1StatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimTitle1Statuses titleI on fact.DimTitle1StatusId = titleI.DimTitle1StatusId
				where titleI.Title1SchoolStatusEdFactsCode <> ''MISSING'' and titleI.Title1SchoolStatusEdFactsCode <> ''NOTTITLE1ELIG''
				) rules on fact.DimSchoolId = rules.DimSchoolId and fact.DimTitle1StatusId = rules.DimTitle1StatusId'
		end

		else if @reportCode in ('yeartoyearenvironmentcount')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						select distinct fact.DimStudentId, ideaStatus.DimIdeaStatusId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimIdeaStatuses ideaStatus on fact.DimIdeaStatusId = ideaStatus.DimIdeaStatusId
					where ideaStatus.EducEnvCode <> ''MISSING''
					) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
		end
		else if @reportCode in ('yeartoyearexitcount')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
					select distinct fact.DimStudentId, ideaStatus.DimIdeaStatusId
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimIdeaStatuses ideaStatus on fact.DimIdeaStatusId = ideaStatus.DimIdeaStatusId
					where ideaStatus.BasisOfExitCode <> ''MISSING''
					) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
		end
		else if @reportCode in ('yeartoyearremovalcount')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
					select distinct fact.DimStudentId, disc.DimDisciplineId
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimDisciplines disc on fact.DimDisciplineId = disc.DimDisciplineId
					where disc.RemovalTypeCode <> ''MISSING''
					) rules on fact.DimStudentId = rules.DimStudentId and fact.DimDisciplineId = rules.DimDisciplineId'
		end
			else if @reportCode in ('studentssummary')
		begin
				if @categorySetCode like ('disability%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId, ideaStatus.DimIdeaStatusId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId					
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimIdeaStatuses ideaStatus on fact.DimIdeaStatusId = ideaStatus.DimIdeaStatusId
						where ideaStatus.DisabilityEdFactsCode <> ''MISSING''
						) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
					end
				else if @categorySetCode like ('gender%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId, demo.DimDemographicId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimDemographics demo on fact.DimDemographicId = demo.DimDemographicId
						where demo.SexEdFactsCode <> ''MISSING''
						) rules on fact.DimStudentId = rules.DimStudentId and fact.DimDemographicId = rules.DimDemographicId'
					end
				else if @categorySetCode like ('age%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId, age.DimAgeId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
						where age.AgeEdFactsCode <> ''MISSING''
						) rules on fact.DimStudentId = rules.DimStudentId and fact.DimAgeId = rules.DimAgeId'
					end
				else if @categorySetCode like ('lepstatus%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId, demo.DimDemographicId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimDemographics demo on fact.DimDemographicId = demo.DimDemographicId
						where demo.LepStatusEdFactsCode <> ''MISSING''
						) rules on fact.DimStudentId = rules.DimStudentId and fact.DimDemographicId = rules.DimDemographicId'
					end
				else if @categorySetCode like ('earlychildhood%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId, ideaStatus.DimIdeaStatusId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimIdeaStatuses ideaStatus on fact.DimIdeaStatusId = ideaStatus.DimIdeaStatusId
						where ideaStatus.EducEnvEdFactsCode <> ''MISSING''
						) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
					end
					else if @categorySetCode like ('schoolage%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId, ideaStatus.DimIdeaStatusId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimIdeaStatuses ideaStatus on fact.DimIdeaStatusId = ideaStatus.DimIdeaStatusId
						where ideaStatus.EducEnvEdFactsCode <> ''MISSING''
						) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
					end
				else if @categorySetCode like ('raceethnic%')
					begin
					set @sqlCountJoins = @sqlCountJoins + '
						inner join (
						select distinct fact.DimStudentId
						from rds.' + @factTable + ' fact
						inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
						inner join rds.DimRaces race on fact.DimRaceId = race.DimRaceId
						) rules on fact.DimStudentId = rules.DimStudentId'
					end
		end
	else if @reportCode in ('indicator9', 'indicator10')
		begin
		-- Ages 6-21
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select  distinct fact.DimStudentId
				from rds.' + @factTable + ' fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 6 and age.AgeValue <= 21
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
			) rules on fact.DimStudentId = rules.DimStudentId'
		end
	else if @reportCode in ('c045')
		begin
		-- Ages 3-21
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId
				from rds.' + @factTable + ' fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 3 and age.AgeValue <= 21
				inner join rds.DimProgramStatuses ps on fact.DimProgramStatusId = ps.DimProgramStatusId
					and ps.ImmigrantTitleIIIProgramEdFactsCode = ''IMMIGNTTTLIII''
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
			) rules on fact.DimStudentId = rules.DimStudentId'
		end
	else if @reportCode in ('indicator4a', 'indicator4b')
		begin
		-- Ages 3-21
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId
				from rds.' + @factTable + ' fact
				inner join rds.DimAges age on fact.DimAgeId = age.DimAgeId
					and age.AgeValue >= 3 and age.AgeValue <= 21
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
			) rules on fact.DimStudentId = rules.DimStudentId'
		end
	else if @reportCode in ('exitspecialeducation')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, idea.DimIdeaStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimIdeaStatuses idea on fact.DimIdeaStatusId = idea.DimIdeaStatusId
				where idea.BasisOfExitCode <> ''MISSING''
				) rules on fact.DimStudentId = rules.DimStudentId and fact.DimIdeaStatusId = rules.DimIdeaStatusId'
		end
		else if @reportCode in ('c121')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, ss.DimStudentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimStudentStatuses ss on fact.DimStudentStatusId = ss.DimStudentStatusId
				where ss.MobilityStatus36moCode = ''QAD36''
				) rules on fact.DimStudentId = rules.DimStudentId and fact.DimStudentStatusId = rules.DimStudentStatusId'
		end
	else if @reportCode in ('c122')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, m.DimMigrantId, studentStatuses.DimStudentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimMigrants m on fact.DimMigrantId = m.DimMigrantId
				inner join rds.DimStudentStatuses studentStatuses on fact.DimStudentStatusId = studentStatuses.DimStudentStatusId
				where m.MepEnrollmentTypeCode = ''MEPSUM'' and studentStatuses.MobilityStatus36moCode <> ''MISSING''
				) rules on fact.DimStudentId = rules.DimStudentId and fact.DimMigrantId = rules.DimMigrantId and fact.DimStudentStatusId = rules.DimStudentStatusId'
		end
	else if @reportCode in ('c127', 'c119')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, n.DimNorDProgramStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimNorDProgramStatuses n on fact.DimNorDProgramStatusId = n.DimNorDProgramStatusId
				where n.NeglectedProgramTypeCode <> ''MISSING''
				) rules on fact.DimStudentId = rules.DimStudentId and fact.DimNorDProgramStatusId = rules.DimNorDProgramStatusId'
		end
	else if @reportCode in ('c054','c165')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, m.DimDemographicId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimDemographics m on fact.DimDemographicId = m.DimDemographicId
				where m.MigrantStatusCode <> ''MISSING''
				) rules on fact.DimStudentId = rules.DimStudentId and fact.DimDemographicId = rules.DimDemographicId'
		end
	else if @reportCode in ('c082')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, cteStatus.DimCteStatusId, enrStatus.DimEnrollmentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimEnrollmentStatuses enrStatus on fact.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteProgramCode =''CTECONC'' and enrStatus.ExitOrWithdrawalCode in		(''01921'',''01922'',''01923'',''01924'',''01925'',''01926'',''01927'',''01928'',''01930'',''01931'',''03502'',''03504'',''03505''
				,''03509'',''09999'',''73060'',''73601'')
			) rules
			on fact.DimStudentId = rules.DimStudentId and fact.DimCteStatusId = rules.DimCteStatusId and fact.DimEnrollmentStatusId = rules.DimEnrollmentStatusId'
		end
	else if @reportCode in ('c118')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId,  demo.DimDemographicId, dgl.DimGradeLevelId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				inner join rds.DimGradeLevels dgl on fact.DimGradeLevelId = dgl.DimGradeLevelId
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimDemographics demo on demo.DimDemographicId=fact.DimDemographicId
				where demo.HomelessStatusCode=''Homeless''
				and dgl.GradeLevelEdFactsCode NOT IN (''AE'')			
			) rules
			on fact.DimStudentId = rules.DimStudentId  and fact.DimDemographicId = rules.DimDemographicId and fact.DimGradeLevelId = rules.DimGradeLevelId' 
		end
	else if @reportCode in ('c160')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId,  studentStatus.DimEnrollmentId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimEnrollment studentStatus on studentStatus.DimEnrollmentId=fact.DimEnrollmentId
				where studentStatus.PostSecondaryEnrollmentStatusEdFactsCode<>''MISSING''	
						
			) rules
			on fact.DimStudentId = rules.DimStudentId  and fact.DimEnrollmentId = rules.DimEnrollmentId'
		end

	else if @reportCode in ('c204')
		begin
		if(@tableTypeAbbrv='T3ELNOTPROF')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, dimTitleIII.DimTitleiiiStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimTitleiiiStatuses dimTitleIII on dimTitleIII.DimTitleiiiStatusId=fact.DimTitleiiiStatusId
				where dimTitleIII.FormerEnglishLearnerYearStatusCode=''5YEAR'' AND dimTitleIII.ProficiencyStatusEdFactsCode=''NOTPROFICIENT''  		
			) rules
			on fact.DimStudentId = rules.DimStudentId and fact.DimTitleiiiStatusId = rules.DimTitleiiiStatusId'
		end
	else if (@tableTypeAbbrv='T3ELEXIT')
		begin
		  set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, dimTitleIII.DimTitleiiiStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimTitleiiiStatuses dimTitleIII on dimTitleIII.DimTitleiiiStatusId=fact.DimTitleiiiStatusId
				where dimTitleIII.ProficiencyStatusEdFactsCode=''PROFICIENT''  		
			) rules
			on fact.DimStudentId = rules.DimStudentId and fact.DimTitleiiiStatusId = rules.DimTitleiiiStatusId'
		end
		end
	else if @reportCode in ('c150')
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
			-- add cohort Total filter		-- used to calculate cohort total to the year
			set @sqlCountTotalJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.DimStudentId, students.Cohort
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimStudents students on students.DimStudentId = fact.DimStudentId
					where (Convert(int,SUBSTRING(students.Cohort,6,4)) - Convert(int,SUBSTRING(students.Cohort,1,4))) in (' + @cohortYearTotal + ')
					and students.Cohort is not null
				) rules
				on fact.DimStudentId = rules.DimStudentId
			'
			-- add cohort filter
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.DimStudentId, students.Cohort
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimStudents students on students.DimStudentId = fact.DimStudentId
					where (Convert(int,SUBSTRING(students.Cohort,6,4)) - Convert(int,SUBSTRING(students.Cohort,1,4))) in (' + @cohortYear + ')
					and students.Cohort is not null
				) rules
				on fact.DimStudentId = rules.DimStudentId
			'
			
		end
	else if @reportCode in ('c151')
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
		-- add cohort filter
		set @sqlCountJoins = @sqlCountJoins + '
		inner join (
				select distinct fact.DimStudentId, students.Cohort
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimStudents students on students.DimStudentId = fact.DimStudentId
				where (Convert(int,SUBSTRING(students.Cohort,6,4)) - Convert(int,SUBSTRING(students.Cohort,1,4))) = ' + @cohortYear + '
				and students.Cohort is not null
			) rules
			on fact.DimStudentId = rules.DimStudentId
		'
	end
	else if @reportCode in ('c083')
		begin

		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, cteStatus.DimCteStatusId, enrStatus.DimEnrollmentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimEnrollmentStatuses enrStatus on fact.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteProgramCode =''CTECONC'' and enrStatus.ExitOrWithdrawalCode = ''01921''
			) rules
			on fact.DimStudentId = rules.DimStudentId and fact.DimCteStatusId = rules.DimCteStatusId and fact.DimEnrollmentStatusId = rules.DimEnrollmentStatusId'

		end

	else if @reportCode in ('c154')
		begin

					set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, cteStatus.DimCteStatusId, enrStatus.DimEnrollmentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimEnrollmentStatuses enrStatus on fact.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteProgramCode =''CTECONC'' 
				and enrStatus.ExitOrWithdrawalCode in (''01921'',''01922'',''01923'',''01924'',''01925'',''01926'',''01927'',''01928'',''01930'',''01931'',''03502'',''03504'',''03505''
				,''03509'',''09999'',''73060'',''73601'')
			) rules
				on fact.DimStudentId = rules.DimStudentId and fact.DimCteStatusId = rules.DimCteStatusId and fact.DimEnrollmentStatusId = rules.DimEnrollmentStatusId'
		end

	else if @reportCode in ('C155')
		Begin
			set @sqlCountJoins = @sqlCountJoins + '
					inner join rds.DimCteStatuses dps on dps.DimCteStatusId=fact.DimCteStatusId
															and dps.CteProgramCode = ''CTEPART''
			'
		End

	else if @reportCode in ('c156')
		begin
					set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, ss.DimCteStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				left join rds.DimCteStatuses ss on fact.DimCteStatusId = ss.DimCteStatusId
				where ss.CteNontraditionalGenderStatusCode = ''NTE'' and ss.CteProgramCode =''CTECONC''
			) rules
				on fact.DimStudentId = rules.DimStudentId and fact.DimCteStatusId = rules.DimCteStatusId'
		end

	else if @reportCode in ('c158')
		begin

		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, cteStatus.DimCteStatusId, studentStatus.DimStudentStatusId, enrStatus.DimEnrollmentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimStudentStatuses studentStatus on fact.DimStudentStatusId = studentStatus.DimStudentStatusId
				inner join rds.DimEnrollmentStatuses enrStatus on fact.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteProgramCode =''CTECONC'' and enrStatus.ExitOrWithdrawalCode = ''01921'' and studentStatus.PlacementStatusCode <> ''MISSING''
			) rules
			on fact.DimStudentId = rules.DimStudentId and fact.DimCteStatusId = rules.DimCteStatusId and fact.DimStudentStatusId = rules.DimStudentStatusId 
			and fact.DimEnrollmentStatusId = rules.DimEnrollmentStatusId'

		end

	else if @reportCode in ('c169')
		begin

		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, cteStatus.DimCteStatusId, studentStatus.DimStudentStatusId, enrStatus.DimEnrollmentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimCteStatuses cteStatus on fact.DimCteStatusId = cteStatus.DimCteStatusId
				inner join rds.DimStudentStatuses studentStatus on fact.DimStudentStatusId = studentStatus.DimStudentStatusId
				inner join rds.DimEnrollmentStatuses enrStatus on fact.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where cteStatus.CteProgramCode =''CTECONC'' and enrStatus.ExitOrWithdrawalCode = ''01921'' and studentStatus.PlacementTypeCode <> ''MISSING''
			) rules
			on fact.DimStudentId = rules.DimStudentId  and fact.DimCteStatusId = rules.DimCteStatusId and fact.DimStudentStatusId = rules.DimStudentStatusId 
			and fact.DimEnrollmentStatusId = rules.DimEnrollmentStatusId'

		end
    else if @reportCode in ('c032')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, enrStatus.DimEnrollmentStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimEnrollmentStatuses enrStatus on fact.DimEnrollmentStatusId = enrStatus.DimEnrollmentStatusId
				where enrStatus.ExitOrWithdrawalCode = ''01927''
				) rules
			on fact.DimStudentId = rules.DimStudentId and fact.DimEnrollmentStatusId = rules.DimEnrollmentStatusId'
		end
	else if @reportCode in ('c040')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				) rules
			on fact.DimStudentId = rules.DimStudentId'
		end
	else if @reportCode in ('c033')
		begin
		if @tableTypeAbbrv in ('LUNCHFREERED')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.DimStudentId
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimStudentStatuses dss on fact.DimStudentStatusId = dss.DimStudentStatusId					
					) rules
				on fact.DimStudentId = rules.DimStudentId'
			end
		else if @tableTypeAbbrv in ('DIRECTCERT')
		begin
			set @sqlCountJoins = @sqlCountJoins + '
				inner join (
					select distinct fact.DimStudentId
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimStudentStatuses dss on fact.DimStudentStatusId = dss.DimStudentStatusId
					where dss.NSLPDirectCertificationIndicatorCode = ''YES''
					) rules
				on fact.DimStudentId = rules.DimStudentId'
			end
		end
		
	else if @reportCode in ('c141')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId,  m.DimDemographicId, g.DimGradelevelId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimDemographics m on fact.DimDemographicId = m.DimDemographicId
				inner join rds.DimGradeLevels g on fact.DimGradelevelId = g.DimGradelevelId
				where m.LepStatusCode = ''LEP'' and g.GradeLevelEdFactsCode not in (''PK'',''AE'')
			) rules
				on fact.DimStudentId = rules.DimStudentId and fact.DimDemographicId =  rules.DimDemographicId and fact.DimGradelevelId =  rules.DimGradelevelId'
		end
	else if @reportCode in ('c194')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, progStatus.DimProgramStatusId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimProgramStatuses progStatus on progStatus.DimProgramStatusId = fact.DimProgramStatusId
				where progStatus.HomelessServicedIndicatorCode = ''YES''
			) rules
				on fact.DimStudentId = rules.DimStudentId and fact.DimProgramStatusId =  rules.DimProgramStatusId'
		end
	else if @reportCode in ('c195')
		begin
		set @sqlCountJoins = @sqlCountJoins + '
			inner join (
				select distinct fact.DimStudentId, m.DimAttendanceId
				from rds.' + @factTable + ' fact
				inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
				and fact.DimCountDateId = @dimDateId
				and fact.DimFactTypeId = @dimFactTypeId
				and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
				inner join rds.DimAttendance m on fact.DimAttendanceId = m.DimAttendanceId
				where m.AbsenteeismCode = ''CA''
			) rules
				on fact.DimStudentId = rules.DimStudentId and fact.DimAttendanceId = rules.DimAttendanceId'
		end

	else if (@reportCode ='c052' and   @categorySetCode NOT in ('TOT', 'ST3'))
		begin
		if @reportLevel = 'sea'
			BEGIN

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
				set @queryFactFilter = '			 
					and 
					fact.DimStudentId in (
					select distinct fact.DimStudentId
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimGradeLevels gl on fact.DimGradeLevelId = gl.DimGradeLevelId
												and gl.GradeLevelEdFactsCode in (' + 	@MembershipgradeList + '					
											
												))'

			END 
		ELSE 
			BEGIN 
				set @queryFactFilter = '
					and 
					fact.DimStudentId in (
					select distinct fact.DimStudentId
					from rds.' + @factTable + ' fact
					inner join rds.DimSchools s on fact.dimschoolid = s.dimschoolid
					and fact.DimCountDateId = @dimDateId
					and fact.DimFactTypeId = @dimFactTypeId
					and IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1
					inner join rds.DimGradeLevels gl on fact.DimGradeLevelId = gl.DimGradeLevelId
							and gl.GradeLevelEdFactsCode in (
								SELECT GRADELEVEL From rds.FactOrganizationCountReports c39 where c39.ReportCode = ''C039''
									and c39.reportLevel = ''' + @reportLevel +
									''' and c39.reportyear = ''' + @reportyear +
									''' and c39.OrganizationStateId = 
									(case when ''' + @reportLevel + ''' = ''lea'' then s.LeaStateIdentifier
										when '''	   +@reportlevel+ '''=  ''sch'' then s.SchoolStateIdentifier
									else c39.OrganizationStateId end )											
							))'
			END
		end
		else if @reportCode in ('c070')
			begin
		
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						SELECT distinct fact.DimPersonnelId, s.DimPersonnelCategoryId
						from rds.' + @factTable + ' fact
						inner join rds.DimPersonnelCategories s on fact.DimPersonnelCategoryId = s.DimPersonnelCategoryId				
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and fact.DimSchoolId <> -1
						where s.StaffCategoryCCDCode = ''SpecialEducationTeachers''
						) rules
					on fact.DimPersonnelId = rules.DimPersonnelId and fact.DimPersonnelCategoryId = rules.DimPersonnelCategoryId'

			end
			else if @reportCode in ('c112')
			begin
		
				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						SELECT distinct fact.DimPersonnelId, s.DimPersonnelCategoryId
						from rds.' + @factTable + ' fact
						inner join rds.DimPersonnelCategories s on fact.DimPersonnelCategoryId = s.DimPersonnelCategoryId				
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and fact.DimSchoolId <> -1
						where s.StaffCategoryCCDCode = ''Paraprofessionals''
						) rules
					on fact.DimPersonnelId = rules.DimPersonnelId and fact.DimPersonnelCategoryId = rules.DimPersonnelCategoryId'

			end
		else if @reportCode in ('c067')
		BEGIN

				set @sqlCountJoins = @sqlCountJoins + '
					inner join (
						SELECT distinct fact.DimPersonnelId, title3.DimTitleiiiStatusId
						from rds.' + @factTable + ' fact
						inner join rds.DimTitleiiiStatuses title3 on fact.DimTitleiiiStatusId = title3.DimTitleiiiStatusId				
						and fact.DimCountDateId = @dimDateId
						and fact.DimFactTypeId = @dimFactTypeId
						and fact.DimSchoolId <> -1
						where title3.TitleiiiLanguageInstructionCode <> ''MISSING''
						) rules
					on fact.DimPersonnelId = rules.DimPersonnelId and fact.DimTitleiiiStatusId = rules.DimTitleiiiStatusId'
		END

		
	-- Insert actual count data
	if(@factReportTable = 'FactPersonnelCountReports')
		begin
			if(@reportCode = 'c099')
			begin

				set @sqlCountJoins = @sqlCountJoins + '
				inner join ( select DimPersonnelId, sum(round(PersonnelFTE, 2)) as PersonnelFTE
						from rds.FactPersonnelCounts fact 
						where fact.DimCountDateId = @dimDateId and fact.DimFactTypeId = @dimFactTypeId 
						and fact.DimSchoolId <> -1
						group by DimPersonnelId
					) personnelCount on personnelCount.DimPersonnelId = fact.DimPersonnelId'
				
			
				set @sql = @sql + '

				----------------------------
				-- Insert actual count data 
				----------------------------
		
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + '			
					DimPersonnelId int' + @sqlCategoryFieldDefs + ',
					PersonnelCount int,
					' + @factField + ' decimal(18,2)
				)

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimSchoolId,'
					end +
				'DimPersonnelId' + @sqlCategoryFields + ',PersonnelCount, ' + @factField + ')
				 select distinct ' + case   when @reportLevel = 'sea' then 'fact.DimSeaId,'
											when @reportLevel = 'lea' then 'fact.DimLeaId,' 
											else 'fact.DimSchoolId,'
					end +
				 'fact.DimPersonnelId' 
				+ @sqlCategoryQualifiedDimensionFields 
				+ ', isnull(fact.PersonnelCount, 0) as PersonnelCount,'
				+ 'isnull(personnelCount.PersonnelFTE, 0.0) as PersonnelFTE'
				+ ' from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
				and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
				'
			end
			else if(@reportCode in ('c067','c070','c112'))
			begin
				set @sql = @sql + '
				----------------------------
				-- Insert actual count data 
				----------------------------
				create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + '			
					DimPersonnelId int' + @sqlCategoryFieldDefs + ',
					PersonnelCount int,
					' + @factField + ' decimal(18,2)
				)

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimSchoolId,'
					end +
				'DimPersonnelId' + @sqlCategoryFields + ',PersonnelCount, ' + @factField + ')
				 select distinct ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
										  when @reportLevel = 'lea' then 'fact.DimLeaId,' 
									      else 'fact.DimSchoolId,'
					end + 'fact.DimPersonnelId' + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.PersonnelCount, 0)),
				sum(round(isnull(fact.' + @factField + ', 0.0), 2))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins + '
				where fact.DimCountDateId = @dimDateId 
				and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
								   when @reportLevel = 'lea' then 'fact.DimLeaId,'
								   else 'fact.DimSchoolId,'
								 end +
				'fact.DimPersonnelId' + @sqlCategoryQualifiedDimensionGroupFields + '
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
						   else 'DimSchoolId int'
					end + @sqlCategoryFieldDefs + ',
					PersonnelCount int,
					' + @factField + ' decimal(18,2)
				)

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId'
						  when @reportLevel = 'lea' then 'DimLeaId' 
						  else 'DimSchoolId'
					end + @sqlCategoryFields + ',PersonnelCount, ' + @factField + ')
				 select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId'
						when @reportLevel = 'lea' then 'fact.DimLeaId' 
						     else 'fact.DimSchoolId'
					end + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.PersonnelCount, 0)),
				sum(round(isnull(fact.' + @factField + ', 0.0), 2))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins + '
				where fact.DimCountDateId = @dimDateId 
				and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1'	 end  + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId'
								   when @reportLevel = 'lea' then 'fact.DimLeaId'
								   else 'fact.DimSchoolId'
								 end +
				@sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
		end		-- END @factReportTable = 'FactPersonnelCountReports'
	else
		begin
			if(@reportCode = 'c006')
				begin

					IF CHARINDEX('DISCIPLINEMETHOD', @categorySetReportFieldList) = 0 
					begin
						set @reportFilterJoin = @reportFilterJoin + 'inner join rds.DimDisciplines di on fact.DimDisciplineId = di.DimDisciplineId'
						set @reportFilterCondition = @reportFilterCondition + 'and di.DisciplineMethodEdFactsCode <> ''MISSING'''
					end
					else
					begin
						set @reportFilterCondition = @reportFilterCondition + 'and CAT_DISCIPLINEMETHOD.DisciplineMethodEdFactsCode <> ''MISSING'''
					end

					set @sql = @sql + '

					----------------------------
					-- Insert actual count data 
					----------------------------
		
					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + '
					DimStudentId int' + @sqlCategoryFieldDefs + ',
						' + @factField + ' int
					)
					' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'
					truncate table #categorySet

					-- Actual Counts
					insert into #categorySet
					(' + case	when @reportLevel = 'sea' then 'DimSeaId,'
								when @reportLevel = 'lea' then 'DimLeaId,' 
								else 'DimSchoolId,'
					end  + 'DimStudentId' 
					+ @sqlCategoryFields + ', ' + @factField + ')
					select ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
									when @reportLevel = 'lea' then 'fact.DimLeaId,' 
									else 'fact.DimSchoolId,'
					end + 'fact.DimStudentId' + @sqlCategoryQualifiedSubSelectDimensionFields + ',
					sum(isnull(fact.' + @factField + ', 0))
					from ( select ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
									when @reportLevel = 'lea' then 'fact.DimLeaId,' 
									else 'fact.DimSchoolId,'
					end + 'fact.DimStudentId,sum(fact.DisciplineCount) as DisciplineCount, sum(fact.DisciplineDuration) as DisciplineDuration' 
					+ @sqlCategoryQualifiedSubDimensionFields +
					' from rds.' + @factTable + ' fact ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
					and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
								 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
								 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end   + '
					group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
										when @reportLevel = 'lea' then 'fact.DimLeaId,'
								   else 'fact.DimSchoolId,'
								 end + 'fact.DimStudentId' + @sqlCategoryQualifiedSubDimensionFields 
					+ ' having SUM(fact.DisciplineDuration) >= 0.5 ) as fact
					group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
								   when @reportLevel = 'lea' then 'fact.DimLeaId,'
								   else 'fact.DimSchoolId,'
								 end + 'fact.DimStudentId' + @sqlCategoryQualifiedSubGroupDimensionFields + '
					' + @sqlHavingClause + '
					'
				end
				else if(@reportCode in ('c088'))
				begin
							
					set @sql = @sql + '

					----------------------------
					-- Insert actual count data 
					----------------------------
		
					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + '
					DimStudentId int' + @sqlCategoryFieldDefs + ', DisciplineDuration decimal(18, 2), 
						' + @factField + ' int
					)
					' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'
					truncate table #categorySet

					-- Actual Counts
					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimSchoolId,'
					end + 'DimStudentId' 
					+ @sqlCategoryFields + ', DisciplineDuration, ' + @factField + ')
					select ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
						when @reportLevel = 'lea' then 'fact.DimLeaId,' 
						     else 'fact.DimSchoolId,'
					end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.DisciplineDuration, 0)),
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
					and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1'	 end  + '
					group by ' + case   when @reportLevel = 'sea' then 'fact.DimSeaId,'
										when @reportLevel = 'lea' then 'fact.DimLeaId,'
										else 'fact.DimSchoolId,'
								 end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
					'
				end
			else if(@reportCode in ('c143'))
				begin
							
					set @sql = @sql + '

					----------------------------
					-- Insert actual count data 
					----------------------------
		
					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + '
					DimStudentId int, DISCIPLINEACTION varchar(100), REMOVALTYPE varchar(100)' + @sqlCategoryFieldDefs + 
					', DisciplineDuration decimal(18, 2), 
						' + @factField + ' int
					)
					' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'
					truncate table #categorySet

					-- Actual Counts
					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimSchoolId,'
					end + 'DimStudentId, DISCIPLINEACTION, REMOVALTYPE' 
					+ @sqlCategoryFields + ', DisciplineDuration, ' + @factField + ')
					select ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
									when @reportLevel = 'lea' then 'fact.DimLeaId,' 
						     else 'fact.DimSchoolId,'
					end  + 'fact.DimStudentId, CAT_DISCIPLINEACTION.DisciplineActionEdFactsCode, CAT_REMOVALTYPE.RemovalTypeEdFactsCode' 
					+ @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.DisciplineDuration, 0)),
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
					and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1'	 end  + '
					group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
								   when @reportLevel = 'lea' then 'fact.DimLeaId,'
								   else 'fact.DimSchoolId,'
								 end  + 'fact.DimStudentId, CAT_DISCIPLINEACTION.DisciplineActionEdFactsCode, CAT_REMOVALTYPE.RemovalTypeEdFactsCode' 
								 + @sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
					'
				end
			else if(@reportCode in ('c005','c086','c144','c007'))
				begin
					set @sql = @sql + '

					----------------------------
					-- Insert actual count data 
					----------------------------

					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + 'DimStudentId int' + @sqlCategoryFieldDefs + ',
					DisciplineDuration decimal(18, 2),
					' + @factField + ' int
				)
		

					' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

					truncate table #categorySet

					-- Actual Counts
					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimSchoolId,'
					end + 'DimStudentId' + @sqlCategoryFields + ', DisciplineDuration, ' + @factField + ')
					select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
						when @reportLevel = 'lea' then 'fact.DimLeaId,' 
						     else 'fact.DimSchoolId,'
					end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.DisciplineDuration, 0)),
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
					and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1'	 end  + '
					group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
								   when @reportLevel = 'lea' then 'fact.DimLeaId,'
								   else 'fact.DimSchoolId,'
								 end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionGroupFields + '
					' + @sqlHavingClause + '
					'
				end
			else if(@reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189', 'c157'))
			begin
					set @sql = @sql + '

					----------------------------
					-- Insert actual count data 
					----------------------------

					create table #categorySet (	' 
					+ case when @reportLevel = 'sea' then 'DimSeaId int,'
						   when @reportLevel = 'lea' then 'DimLeaId int,' 
						   else 'DimSchoolId int,'
					end + 'DimStudentId int' + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		

					' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

					truncate table #categorySet

					-- Actual Counts
					insert into #categorySet
					(' + case when @reportLevel = 'sea' then 'DimSeaId,'
						  when @reportLevel = 'lea' then 'DimLeaId,' 
						  else 'DimSchoolId,'
					end + 'DimStudentId' + @sqlCategoryFields + ', ' + @factField + ')
					select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
						when @reportLevel = 'lea' then 'fact.DimLeaId,' 
						     else 'fact.DimSchoolId,'
					end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionFields + ',
					sum(isnull(fact.' + @factField + ', 0))
					from rds.' + @factTable + ' fact ' + @sqlCountJoins 
					+ ' ' + @reportFilterJoin + '
					where fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
					and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
					and ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1'	 end  + '
					group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
								   when @reportLevel = 'lea' then 'fact.DimLeaId,'
								   else 'fact.DimSchoolId,'
								 end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionGroupFields + '
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
						   else 'DimSchoolId int'
					end + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId'
						  when @reportLevel = 'lea' then 'DimLeaId' 
						  else 'DimSchoolId'
					end + @sqlCategoryFields + ', ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId'
								 when @reportLevel = 'lea' then 'fact.DimLeaId' 
								 else 'fact.DimSchoolId'
					end + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
				and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId'
								   when @reportLevel = 'lea' then 'fact.DimLeaId'
								   else 'fact.DimSchoolId'
								 end + @sqlCategoryQualifiedDimensionGroupFields + '
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
						   else 'DimSchoolId int'
					end + @sqlCategoryFieldDefs + ',
					' + @factField + ' int
				)
		

				' + case when @reportLevel = 'sea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
					'    when @reportLevel = 'lea' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
					' 	 when @reportLevel = 'sch' then '
					CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
					'    else ''
					end +
					'

				truncate table #categorySet

				-- Actual Counts
			
				insert into #categorySet
				(' + case when @reportLevel = 'sea' then 'DimSeaId'
						  when @reportLevel = 'lea' then 'DimLeaId' 
						  else 'DimSchoolId'
					end + @sqlCategoryFields + ', ' + @factField + ')
				select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId'
								 when @reportLevel = 'lea' then 'fact.DimLeaId' 
								 else 'fact.DimSchoolId'
					end + @sqlCategoryQualifiedDimensionFields + ',
				sum(isnull(fact.' + @factField + ', 0))
				from rds.' + @factTable + ' fact ' + @sqlCountJoins 
				+ ' ' + @reportFilterJoin + '
				where ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
							 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
							 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
				and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
				and fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
				group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId'
								   when @reportLevel = 'lea' then 'fact.DimLeaId'
								   else 'fact.DimSchoolId'
								 end + @sqlCategoryQualifiedDimensionGroupFields + '
				' + @sqlHavingClause + '
				'
			end
			else if(@reportCode in ('c150'))
				begin
					set @sql = @sql + '
						----------------------------
						-- Insert actual count data 
						-- default FactStudentCountReports
						----------------------------
		

						create table #categorySet (	' 
						+ case when @reportLevel = 'sea' then 'DimSeaId int'
							   when @reportLevel = 'lea' then 'DimLeaId int' 
							   else 'DimSchoolId int'
						end + @sqlCategoryFieldDefs + ',
						' + @factField + ' int
					)
		

					' + case when @reportLevel = 'sea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
						'    when @reportLevel = 'lea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
						' 	 when @reportLevel = 'sch' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
						'    else ''
						end +
						'

						truncate table #categorySet

						insert into #categorySet
						(' + case when @reportLevel = 'sea' then 'DimSeaId'
								  when @reportLevel = 'lea' then 'DimLeaId' 
								  else 'DimSchoolId'
							end + @sqlCategoryFields + ', ' + @factField + ')
						select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId'
										 when @reportLevel = 'lea' then 'fact.DimLeaId' 
										 else 'fact.DimSchoolId'
							end + @sqlCategoryQualifiedDimensionFields + ',
						sum(isnull(fact.' + @factField + ', 0))
						from rds.' + @factTable + ' fact ' + @sqlCountJoins 
						+ ' ' + @reportFilterJoin + '
						where ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
									 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
									 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
						and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
						and fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
						group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId'
										   when @reportLevel = 'lea' then 'fact.DimLeaId'
										   else 'fact.DimSchoolId'
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
							   else 'DimSchoolId int'
							end  + @sqlCategoryFieldDefs + ',
							' + @factField + ' int
						)
						
						' + case when @reportLevel = 'sea' then '
						CREATE INDEX IDX_CategoryCohortSet ON #categoryCohortSet(DimSeaId)
						'    when @reportLevel = 'lea' then '
						CREATE INDEX IDX_CategoryCohortSet ON #categoryCohortSet(DimLeaId)
						' 	 when @reportLevel = 'sch' then '
						CREATE INDEX IDX_CategoryCohortSet ON #categoryCohortSet(DimSchoolId)
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
								  else 'DimSchoolId'
							end  + @sqlCategoryFields + ', ' + @factField + ')
						select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId'
								 when @reportLevel = 'lea' then 'fact.DimLeaId' 
								 else 'fact.DimSchoolId'
						end + @sqlCategoryQualifiedDimensionFields + ',
						sum(isnull(fact.' + @factField + ', 0))
						from rds.' + @factTable + ' fact ' + @sqlCountTotalJoins 
						+ ' ' + @reportFilterJoin + '
						where ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
									 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
									 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
						and fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
						and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
						group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId'
										   when @reportLevel = 'lea' then 'fact.DimLeaId'
										   else 'fact.DimSchoolId'
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
			else if(@reportCode in ('c033') AND @categorySetCode = 'TOT')
				begin
					set @sql = @sql + '
						----------------------------
						-- Insert actual count data 
						-- default FactStudentCountReports
						----------------------------
		

						create table #categorySet (	' 
						+ case when @reportLevel = 'sea' then 'DimSeaId int,'
							   when @reportLevel = 'lea' then 'DimLeaId int,' 
							   else 'DimSchoolId int,'
						end + 'DimStudentId int' + @sqlCategoryFieldDefs + ',
						' + @factField + ' int
					)
		

					' + case when @reportLevel = 'sea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
						'    when @reportLevel = 'lea' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
						' 	 when @reportLevel = 'sch' then '
						CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
						'    else ''
						end +
						'

						truncate table #categorySet

						-- Actual Counts
						insert into #categorySet
						(' + case when @reportLevel = 'sea' then 'DimSeaId,'
								  when @reportLevel = 'lea' then 'DimLeaId,' 
								  else 'DimSchoolId,'
							end + 'DimStudentId'  + @sqlCategoryFields + ', ' + @factField + ')
						select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
										 when @reportLevel = 'lea' then 'fact.DimLeaId,' 
										 else 'fact.DimSchoolId,'
							end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionFields + ',
						sum(isnull(fact.' + @factField + ', 0))
						from rds.' + @factTable + ' fact ' + 
						' inner join rds.DimProgramStatuses dps on fact.DimProgramStatusId = dps.DimProgramStatusId ' + @sqlCountJoins 
						+ ' ' + @reportFilterJoin + '
						where ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
									 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
									 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
						and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
						and fact.DimCountDateId = @dimDateId ' + @reportFilterCondition + '
						and dps.FoodServiceEligibilityCode in (''FREE'' ,''REDUCEDPRICE'' ) ' +
						' group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
										   when @reportLevel = 'lea' then 'fact.DimLeaId,'
										   else 'fact.DimSchoolId,'
										 end + 'fact.DimStudentId'  + @sqlCategoryQualifiedDimensionGroupFields + '
						' + @sqlHavingClause + '
						'
				end			
			else
				-- all other report codes
				begin
					if(@factReportTable = 'FactStudentCountReports')
						begin
							set @sql = @sql + '
								----------------------------
								-- Insert actual count data 
								-- default FactStudentCountReports
								----------------------------
		
								create table #categorySet (	' 
								+ case when @reportLevel = 'sea' then 'DimSeaId int,'
									   when @reportLevel = 'lea' then 'DimLeaId int,' 
									   else 'DimSchoolId int,'
								end + 'DimStudentId int'  + @sqlCategoryFieldDefs + ',
								' + @factField + ' int
								)

										' + case when @reportLevel = 'sea' then '
								CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
								'    when @reportLevel = 'lea' then '
								CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
								' 	 when @reportLevel = 'sch' then '
								CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
								'    else ''
								end +
								'

								truncate table #categorySet


								-- Actual Counts
								insert into #categorySet
						(' + case when @reportLevel = 'sea' then 'DimSeaId,'
								  when @reportLevel = 'lea' then 'DimLeaId,' 
								  else 'DimSchoolId,'
							end + 'DimStudentId'  + @sqlCategoryFields + ', ' + @factField + ')
						select  ' + case when @reportLevel = 'sea' then 'fact.DimSeaId,'
										 when @reportLevel = 'lea' then 'fact.DimLeaId,' 
										 else 'fact.DimSchoolId,'
							end + 'fact.DimStudentId' + @sqlCategoryQualifiedDimensionFields + ',
						sum(isnull(fact.' + @factField + ', 0))
						from rds.' + @factTable + ' fact ' + @sqlCountJoins 
						+ ' ' + @reportFilterJoin + '
						where ' + case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
									 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
									 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' end  + '
						and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter + '
						and fact.DimCountDateId = @dimDateId ' + @reportFilterCondition +
						' group by ' + case  when @reportLevel = 'sea' then 'fact.DimSeaId,'
										   when @reportLevel = 'lea' then 'fact.DimLeaId,'
										   else 'fact.DimSchoolId,'
										 end + 'fact.DimStudentId'  + @sqlCategoryQualifiedDimensionGroupFields + '
						' + @sqlHavingClause + '
						'
						end		-- END @factReportTable = 'FactStudentCountReports'
					else
						begin
							set @sql = @sql + '
								----------------------------
								-- Insert actual count data 
								----------------------------
		
								create table #categorySet (	' 
								+ case when @reportLevel = 'sea' then 'DimSeaId int'
									   when @reportLevel = 'lea' then 'DimLeaId int' 
									   else 'DimSchoolId int'
								end 
								  + @sqlCategoryFieldDefs + ',
								' + @factField + ' int
								)

										' + case when @reportLevel = 'sea' then '
								CREATE INDEX IDX_CategorySet ON #CategorySet (DimSeaId)
								'    when @reportLevel = 'lea' then '
								CREATE INDEX IDX_CategorySet ON #CategorySet (DimLeaId)
								' 	 when @reportLevel = 'sch' then '
								CREATE INDEX IDX_CategorySet ON #CategorySet (DimSchoolId)
								'    else ''
								end +
								'

								truncate table #categorySet

								-- Actual Counts
								insert into #categorySet
								(' 
								+ case when @reportLevel = 'sea' then 'DimSeaId'
								  when @reportLevel = 'lea' then 'DimLeaId' 
								  else 'DimSchoolId' 
								  end 
								  + @sqlCategoryFields + ', ' + @factField + ')
								select  ' 
								+ case when @reportLevel = 'sea' then 'fact.DimSeaId'
										when @reportLevel = 'lea' then 'fact.DimLeaId' 
										 else 'fact.DimSchoolId'
								  end 
								+ @sqlCategoryQualifiedDimensionFields + ',
								sum(isnull(fact.' + @factField + ', 0))
								from rds.' + @factTable + ' fact ' + @sqlCountJoins 
								+ ' ' + @reportFilterJoin + '
								where ' + 
								case when @reportLevel = 'sea' then 'fact.DimSeaId <> -1'
									 when @reportLevel = 'lea' then 'fact.DimLeaId <> -1'
									 else 'IIF(fact.DimSchoolId > 0, fact.DimSchoolId, fact.DimLeaId) <> -1' 
								end  
									 + ' and fact.DimCountDateId = @dimDateId ' + @reportFilterCondition 
									 + ' and fact.DimFactTypeId = @dimFactTypeId ' + @queryFactFilter 
									 + ' group by ' 
									 + case  when @reportLevel = 'sea' then 'fact.DimSeaId'
										   when @reportLevel = 'lea' then 'fact.DimLeaId'
										   else 'fact.DimSchoolId' 
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


		if @reportCode in ('c005','c006','c086','c088','c144','c009','c175', 'c178', 'c179', 'c185', 'c188', 'c189', 'c121', 'c194', 'c082', 'c083', 'c154', 'c155', 'c156', 'c157', 'c158')
		begin
			set @sumOperation = 'count(distinct dimStudentId )'
		end
		else if @reportCode in ('c059', 'c070', 'c099', 'c112', 'c203')
		begin
			set @sumOperation = 'sum(round(isnull(' + @factField + ', 0), 2))'
		end


		
		-- Insert SQL
		---------------------------

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
						StateCode,
						StateName,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						TableTypeAbbrv,
						TotalIndicator
						' + @sqlCategoryFields + ',
						' + @factField + '
					'
				if(@factReportTable = 'FactPersonnelCountReports')
					begin
						set @sql = @sql + ',PersonnelCount'
					end
				
				if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
				begin
					set @sql = @sql + ',AssessmentSubject'
				end
				else if(@reportCode in ('c150'))
				begin
					set @sql = @sql + ',StudentRate'
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
						sea.StateCode,
						sea.StateName,
						isnull(sea.StateANSICode,'''') as OrganizationNcesId,
						sea.SeaStateIdentifier as OrganizationStateId,
						sea.SeaName as OrganizationName,
						null as ParentOrganizationStateId,
						''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
						''' + @totalIndicator + ''' as TotalIndicator' +
						@sqlCategoryFields + ', 
						' + @sumOperation + ' as ' + @factField + ''

				if(@factReportTable = 'FactPersonnelCountReports')
					begin
						if @reportCode in ('c067', 'c070', 'c112')
						begin
							set @sql = @sql + ',count(distinct dimPersonnelId )'
						end
						else
						begin
							set @sql = @sql + ',sum(isnull(PersonnelCount, 0))'
						end
					end
				
				if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
					begin
						set @sql = @sql + ', case when ''' + @reportCode + ''' in (''c175'',''c185'') then ''MATH''
										 when ''' + @reportCode + ''' in (''c178'',''c188'') then ''RLA''
										 when ''' + @reportCode + ''' in (''c179'',''c189'') then ''SCIENCE''
										 ELSE ''MISSING''
									end
						 '
					end

				if(@reportCode in ('c150'))
					begin
						set @sql = @sql + ', cast(' + @sumOperation + ' / @CohortTotal * 100 as Decimal(9,2)) as StudentRate '
					end

				set @sql = @sql + '
					from #categorySet cs
					inner join rds.DimSeas sea on cs.DimSeaId = sea.DimSeaId
					Where sea.DimSeaId > 0
					group by 
						sea.StateANSICode,
						sea.StateCode,
						sea.StateName,
						sea.SeaStateIdentifier,
						sea.SeaName ' +
						@sqlCategoryFields + '
					having sum(' + @factField + ') > 0'

				end
		else if @reportLevel = 'lea'
			-- LEA ----
			begin
				set @sql = @sql + '
					-- insert lea sql '
				if(@factReportTable = 'FactStudentCountReports' 
					OR @reportCode in ('c088', 'c143', 'c006'))
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
								StateCode,
								StateName,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								TableTypeAbbrv,
								TotalIndicator
								' + @sqlCategoryFields + ',
								' + @factField + ''

						if(@factReportTable = 'FactPersonnelCountReports')
							begin
								set @sql = @sql + ',PersonnelCount'
							end
							

						-- add StudentRate  field for c150
						if(@reportCode in ('c150'))
							begin
								set @sql = @sql + ',StudentRate'
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
								lea.StateCode,
								lea.StateName,
								isnull(lea.LeaNcesIdentifier,'''') as OrganizationNcesId,
								lea.LeaStateIdentifier as OrganizationStateId,
								lea.LeaName as OrganizationName,
								lea.StateANSICode as ParentOrganizationStateId,
								''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
								''' + @totalIndicator + ''' as TotalIndicator' +
								@sqlCategoryFields + ', 
								' + @sumOperation + ' as ' + @factField

						if(@factReportTable = 'FactPersonnelCountReports')
						begin
							if @reportCode in ('c067', 'c070', 'c112')
							begin
								set @sql = @sql + ',count(distinct dimPersonnelId )'
							end
							else
							begin
								set @sql = @sql + ',sum(isnull(PersonnelCount, 0))'
							end
						end


						-- add calculation for StudentRate for c150
						if(@reportCode in ('c150'))
							begin
								set @sql = @sql + ', cast(' + @sumOperation + ' / @CohortTotal * 100 as Decimal(9,2)) as StudentRate '
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
							where lea.DimLeaId <> -1
							and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963
							group by 
								lea.StateANSICode,
								lea.StateCode,
								lea.StateName,
								lea.LeaNcesIdentifier,
								lea.LeaStateIdentifier,
								lea.LeaName ' +
								@sqlCategoryFields + '
							having sum(' + @factField + ') > 0'


					end		-- END @factReportTable = 'FactStudentCountReports'
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
								StateCode,
								StateName,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								TableTypeAbbrv,
								TotalIndicator
								' + @sqlCategoryFields + ',
								' + @factField + ''
			
							if(@factReportTable = 'FactPersonnelCountReports')
								begin
									set @sql = @sql + ',PersonnelCount'
								end
							
							if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
							begin
								set @sql = @sql + ',AssessmentSubject'
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
									lea.StateCode,
									lea.StateName,
									isnull(lea.LeaNcesIdentifier,'''') as OrganizationNcesId,
									lea.LeaStateIdentifier as OrganizationStateId,
									lea.LeaName as OrganizationName,
									lea.StateANSICode as ParentOrganizationStateId,
									''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
									''' + @totalIndicator + ''' as TotalIndicator' +
									@sqlCategoryFields + ', 
									' + @sumOperation + ' as ' + @factField

							if(@factReportTable = 'FactPersonnelCountReports')
							begin
								if @reportCode in ('c067', 'c070', 'c112')
								begin
									set @sql = @sql + ',count(distinct dimPersonnelId )'
								end
								else
								begin
									set @sql = @sql + ',sum(isnull(PersonnelCount, 0))'
								end
							end
							
							if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
							begin
								set @sql = @sql + ', case when ''' + @reportCode + ''' in (''c175'',''c185'') then ''MATH''
										 when ''' + @reportCode + ''' in (''c178'',''c188'') then ''RLA''
										 when ''' + @reportCode + ''' in (''c179'',''c189'') then ''SCIENCE''
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
								where lea.DimLeaId <> -1
								and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963
								group by 
									lea.StateANSICode,
									lea.StateCode,
									lea.StateName,
									lea.LeaNcesIdentifier,
									lea.LeaStateIdentifier,
									lea.LeaName ' +
									@sqlCategoryFields + '
								having sum(' + @factField + ') > 0'

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
						StateCode,
						StateName,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						TableTypeAbbrv,
						TotalIndicator
						' + @sqlCategoryFields + ',
						' + @factField + ''
			
				if(@factReportTable = 'FactPersonnelCountReports')
					begin
						set @sql = @sql + ', PersonnelCount'
					end
				if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
					begin
						set @sql = @sql + ',AssessmentSubject'
					end
			
				-- add StudentRate  field for c150
				if(@reportCode in ('c150'))
					begin
						set @sql = @sql + ', StudentRate'
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
						sch.StateCode,
						sch.StateName,
						isnull(sch.SchoolNcesIdentifier,'''') as OrganizationNcesId,
						sch.SchoolStateIdentifier as OrganizationStateId,
						sch.SchoolName as OrganizationName,
						sch.LeaStateIdentifier as ParentOrganizationStateId,
						''' + @tableTypeAbbrv + ''' as TableTypeAbbrv,
						''' + @totalIndicator + ''' as TotalIndicator' +
						@sqlCategoryFields + ', 
						' + @sumOperation + ' as ' + @factField

				if(@factReportTable = 'FactPersonnelCountReports')
					begin
						if @reportCode in ('c067', 'c070', 'c112')
						begin
							set @sql = @sql + ',count(distinct dimPersonnelId )'
						end
						else
						begin
							set @sql = @sql + ',sum(isnull(PersonnelCount, 0))'
						end
					end
				if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
				begin
						set @sql = @sql + ', case when ''' + @reportCode + ''' in (''c175'',''c185'') then ''MATH''
										 when ''' + @reportCode + ''' in (''c178'',''c188'') then ''RLA''
										 when ''' + @reportCode + ''' in (''c179'',''c189'') then ''SCIENCE''
										 ELSE ''MISSING''
									end
				 '
				end
				-- add calculation for StudentRate for c150
				if(@reportCode in ('c150'))
					begin
						set @sql = @sql + ', cast(' + @sumOperation + ' / @CohortTotal * 100 as Decimal(9,2)) as StudentRate '
					end


				if(@factReportTable = 'FactStudentCountReports')
					begin
						if @categorySetCode = 'TOT'
							begin
								set @sql = @sql + '
									from rds.DimSchools sch
									left outer join #categorySet cs on cs.DimSchoolId = sch.DimSchoolId'
							end
						else
							begin
								set @sql = @sql + '
									from #categorySet cs
									inner join rds.DimSchools sch on cs.DimSchoolId = sch.DimSchoolId'
							end

						set @sql = @sql + '
							where sch.DimSchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963
							group by 
								sch.StateANSICode,
								sch.StateCode,
								sch.StateName,
								sch.SchoolNcesIdentifier,
								sch.SchoolStateIdentifier,
								sch.SchoolName ,
								sch.LeaStateIdentifier' +
								@sqlCategoryFields + '
							having sum(' + @factField + ') > 0'
					end
				else
					begin
						if @categorySetCode = 'TOT'
							begin
								set @sql = @sql + '
									from rds.DimSchools sch
									left outer join #categorySet cs on cs.DimSchoolId = sch.DimSchoolId'
							end
						else
							begin
								set @sql = @sql + '
									from #categorySet cs
									inner join rds.DimSchools sch on cs.DimSchoolId = sch.DimSchoolId'
							end

						set @sql = @sql + '
							where sch.DimSchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963
							group by 
								sch.StateANSICode,
								sch.StateCode,
								sch.StateName,
								sch.SchoolNcesIdentifier,
								sch.SchoolStateIdentifier,
								sch.SchoolName ,
								sch.LeaStateIdentifier ' +
								@sqlCategoryFields + '
							having sum(' + @factField + ') > 0'
					end
			end		-- END sch

		set @sql = @sql + '
		drop table #categorySet
		drop table #CAT_Schools
	'
	-- delete #categoryCohortSet used to calculate cohort total
	if(@reportCode in ('c150'))
	  begin
		set @sql = @sql + '
		drop table #categoryCohortSet'
	  end

	end

	-----------------Contiguous Performance levels------------------------------------------------------------
	if @sqlType = 'performanceLevels'
	begin
		if @reportCode in ('c175','c178','c179') and @reportLevel <> 'sea' and @year <= 2018
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
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
			inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
			inner join app.Categories c on csc.CategoryId = c.CategoryId
			inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
			inner join app.Dimensions d on cd.DimensionId = d.DimensionId
			inner join App.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
			left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
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
				StateCode,
				StateName,
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl + ',AssessmentCount,PERFORMANCELEVEL)
			select StateANSICode,
				StateCode,
				StateName,
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl + ',0 as AssessmentCount, b.Code as PERFORMANCELEVEL
			from ( select StateANSICode,
				StateCode,
				StateName,
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl +
			' from  @reportData
			group by StateANSICode,
				StateCode,
				StateName,
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				TableTypeAbbrv,
				TotalIndicator,
				AssessmentSubject,
				CategorySetCode
			' + @sqlSelectCategoryFieldsExcludePerfLvl +
			' having  CategorySetCode =  ''' + @categorySetCode + ''') a
			cross join (select * from #CAT_PerformanceLevel) b
			'

			set @sql = @sql + '
			delete a from #performanceData_' + @categorySetCode + ' a
			inner join ( select OrganizationStateId' + @sqlCategoryFields + 
			' from @reportData
			group by OrganizationStateId,CategorySetCode' + @sqlCategoryFields +
			' having  CategorySetCode =  ''' + @categorySetCode + ''') b 
			on ' + @sqlPerformanceLevelJoins + ' and a.PERFORMANCELEVEL = b.PERFORMANCELEVEL and a.OrganizationStateId = b.OrganizationStateId
			'

			set @sql = @sql + '
			delete a from #performanceData_' + @categorySetCode + ' a
			inner join ( select  AssessmentTypeCode, Grade, PerformanceLevels, Subject
			from app.ToggleAssessments
			) b 
			on a.ASSESSMENTTYPE = b.AssessmentTypeCode and a.GradeLevel = b.Grade and a.AssessmentSubject = b.Subject
			and CAST(SUBSTRING(a.PERFORMANCELEVEL,2,1) as INT) > CAST(b.PerformanceLevels as INT)
			'

			set @sql = @sql + '

			insert into @reportData
			(
				StateANSICode,
				StateCode,
				StateName,
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				TableTypeAbbrv,
				TotalIndicator,
				ASSESSMENTSUBJECT,
				CategorySetCode
			' + @sqlCategoryFields + ', ' + @factField
		
		
			set @sql = @sql + ')
			select StateANSICode,
				StateCode,
				StateName,
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				TableTypeAbbrv,
				TotalIndicator,
				ASSESSMENTSUBJECT,
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
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			TableTypeAbbrv,
			TotalIndicator,
			CategorySetCode
		' + @sqlCategoryFields + ', ' + @factField
		
		if(@factReportTable = 'FactStudentCountReports')
			begin
				set @sql = @sql + ', StudentRate '
			end
		
		
		if(@factReportTable = 'FactPersonnelCountReports')
			begin
				set @sql = @sql + ', PersonnelCount'
			end
		
		if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
			begin
				set @sql = @sql + ',AssessmentSubject'
			end
		
		set @sql = @sql + ')
			select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateCode,
			CAT_Organizations.StateName,
			CAT_Organizations.OrganizationNcesId,
			CAT_Organizations.OrganizationStateId,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationStateId,
			' + case when @tableTypeAbbrv is null then '''''' else '''' + @tableTypeAbbrv + '''' end + ',
			''' + @totalIndicator + ''',
			''' + @categorySetCode + '''
			' + @sqlCategoryQualifiedFields + ','

			
		if(@factReportTable = 'FactPersonnelCountReports')
			begin
				set @sql = @sql + ' 0.0 as ' + @factField + ', 0 as PersonnelCount'
			end
		else if(@factReportTable = 'FactStudentCountReports')
			begin
				set @sql = @sql + ' 0 as ' + @factField + ', 0.0 as StudentRate'
			end
		else
			begin
				set @sql = @sql + ' 0 as ' + @factField
			end
		
		if @reportCode in ('c175', 'c178', 'c179', 'c185', 'c188', 'c189')
		begin
			set @sql = @sql + ', case when ''' + @reportCode + ''' in (''c175'',''c185'') then ''MATH''
										 when ''' + @reportCode + ''' in (''c178'',''c188'') then ''RLA''
										 when ''' + @reportCode + ''' in (''c179'',''c189'') then ''SCIENCE''
										 ELSE ''MISSING''
									end
				 '
		end

		if @reportCode in ('c052') and @categorySetCode not in ('ST3','TOT')
			begin
				set @sqlCategoryOptionJoins = @sqlCategoryOptionJoins + ' inner join (select distinct GRADELEVEL,OrganizationStateId
				from rds.FactOrganizationCountReports where reportCode =''C039'' AND reportLevel = ''' + @reportLevel +''' AND reportyear = ''' + @reportyear +''') b
				on CAT_GRADELEVEL.Code = b.GRADELEVEL and CAT_Organizations.OrganizationStateId = b.OrganizationStateId'
			end	
				
		set @sql = @sql + '
			from #CAT_Organizations CAT_Organizations' + @sqlCategoryOptionJoins + '
			where not exists (select 1 from @reportData
			where OrganizationStateId = CAT_Organizations.OrganizationStateId
			' + @sqlZeroCountConditions + '
			and ' + @factField + ' > 0 
			)
		'

		if @reportCode in ('c002','c089')
		BEGIN
		
		----------------Needed Just for SY 2019-20 -------------------------------------------------------------------------------------------------------------
			IF @reportYear = '2019-20'
			BEGIN
				set @sql = @sql + ' 
					IF NOT EXISTS(Select 1 from rds.FactStudentCountReports a WHERE a.ReportCode in (''c002'',''c089'') 
					AND a.ReportYear = ''2019-20'' AND a.AGE IN (''AGE05K'', ''AGE05NOTK''))
					BEGIN
						delete from @reportData WHERE AGE IN (''AGE05K'', ''AGE05NOTK'')
					END

					IF EXISTS(Select 1 from rds.FactStudentCountReports a WHERE a.ReportCode in (''c002'',''c089'') 
					AND a.ReportYear = ''2019-20'' AND a.AGE IN (''AGE05K'', ''AGE05NOTK''))
					BEGIN
						delete from @reportData WHERE AGE IN (''5'')
					END
					'
			END

			IF @reportCode = 'c089' and @reportLevel ='LEA' BEGIN
				SET @sql = @sql + ' 
					
				delete a from @reportData a
                where a.StudentCount = 0
                AND OrganizationStateId NOT IN
                (
                SELECT DISTINCT dl.LeaStateIdentifier
                FROM RDS.BridgeLeaGradeLevels blgl
                JOIN RDS.DimLeas dl
                    ON blgl.DimLeaId = dl.DimLeaID
                JOIN RDS.DimGradeLevels dgl
                    ON blgl.DimGradeLevelId = dgl.DimGradeLevelId
                WHERE GradeLevelCode IN (''KG'', ''PK'')
                )
				'
			END 

			IF @toggleDevDelayAges is not null
			BEGIN

				set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0   
					AND AGE NOT IN ( ' +  @toggleDevDelayAges + ')
					AND DISABILITY = ''DD'' '

				if @reportCode = 'c002' AND @toggleDevDelay6to9 is null
				begin
					set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0   
					AND DISABILITY = ''DD'' '
				end

				if @reportCode = 'c089' AND @toggleDevDelay3to5 is null
				begin
					set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0   
					AND DISABILITY = ''DD'' '
				end
			END
		END

		if(@reportCode = 'c009')
		BEGIN

				if(@toggleBasisOfExit = 0)
				begin
					set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0
					AND BASISOFEXIT IN (''GHS'',''GRADALTDPL'',''RC'')'
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
							AND AGE <> ''MISSING'' AND BASISOFEXIT IN (''GHS'',''GRADALTDPL'',''RC'')
							AND CAST(AGE as INT) < CAST(' + @toggleMinAgeGrad + ' as INT)'
						end

					end

					set @sql = @sql + '  delete a from @reportData a
						where a.' +  @factField + ' = 0 and a.CategorySetCode =''CSA''
						AND AGE <> ''MISSING'' AND BASISOFEXIT IN (''RMA'')
						AND CAST(AGE as INT) <> CAST(' + @toggleMaxAge + ' as INT)'
				end
		END

		if(@reportCode = 'C040')
			BEGIN
				set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0   
					AND DIPLOMACREDENTIALTYPE NOT IN ( ' +  @toggleGradCompltrResponse + ')' 
			END

		if @reportCode in ('c175','c178','c179')
			begin

				set @sql = @sql + ' delete a from @reportData a
					where a.' +  @factField + ' = 0 
					AND NOT EXISTS (Select 1 from app.ToggleAssessments b
									  where a.AssessmentType = b.AssessmentTypeCode
									  and a.GradeLevel = b.Grade
									  and a.AssessmentSubject = b.Subject
									  and LEN(a.PerformanceLevel) = 2
									  and CAST(SUBSTRING(a.PerformanceLevel,2,1) as INT) <= CAST(b.PerformanceLevels as INT))'

			end
		else if @reportCode in ('c185','c189')
			begin
				set @sql = @sql + ' delete a from @reportData a
					where a.' +  @factField + ' = 0 
					AND a.PARTICIPATIONSTATUS not in (''MEDEXEMPT'',''NPART'')
				'
			end

		else if @reportCode in ('c188')
			begin
				set @sql = @sql + ' delete a from @reportData a
					where a.' +  @factField + ' = 0 
					AND a.PARTICIPATIONSTATUS not in (''MEDEXEMPT'',''NPART'',''PARTLEP'')
				'
			end

		--Student count for displaced homemakers ? If the state does not have displaced homemakers at the secondary level, leave that category set out of the file
		else if @reportCode in ('c082','c083','c142','c154','c155','c156','c157','c158') and @toggleDisplacedHomemakers = '0'
			BEGIN
				set @sql = @sql + ' delete a from @reportData a
					where a.' +  @factField + ' = 0 and a.CategorySetCode =''CSG''
				'   
			END
		else if @reportCode in ('c083')
			BEGIN
				set @sql = @sql + '  delete a from @reportData a
					where a.' +  @factField + ' = 0   
					AND DIPLOMACREDENTIALTYPE NOT IN ( ' +  @toggleCteDiploma + ')'
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
				SET @dynamicCategoryJoin = 'cross join  @CAT_SEX CAT_SEX'
				SET @dynamicCategoryCondition = 'and Category1 = CAT_SEX.Code'
			END
		ELSE
			BEGIN
				SET @dynamicCategorySelect = 'CAT_DISABILITY.Code'
				SET @dynamicCategoryJoin = 'cross join  @CAT_IDEAINDICATOR CAT_DISABILITY'
				SET @dynamicCategoryCondition = 'and Category1 = CAT_DISABILITY.Code'
			END

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		INSERT INTO #reportCounts
		(
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			PERFORMANCELEVEL,
			PARTICIPATIONSTATUS,
			ECODISSTATUS,
			RACE,
			Category1,
			AssessmentCount
		)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateCode,
			CAT_Organizations.StateName,
			CAT_Organizations.OrganizationNcesId,
			CAT_Organizations.OrganizationStateId,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationStateId,
			CAT_PERFORMANCELEVEL.Code,
			CAT_PARTICIPATIONSTATUS.Code,
			CAT_ECODISSTATUS.Code,
			CAT_RACE.Code,
			' + @dynamicCategorySelect + ',
			0 as AssessmentCount
		from #CAT_Organizations CAT_Organizations
		cross join  @CAT_PERFORMANCELEVEL CAT_PERFORMANCELEVEL
		cross join  @CAT_PARTICIPATIONSTATUS CAT_PARTICIPATIONSTATUS
		cross join  @CAT_ECODISSTATUS CAT_ECODISSTATUS
		cross join  @CAT_RACE CAT_RACE
		' + @dynamicCategoryJoin + '
		where not exists (select 1 from #reportCounts
		where OrganizationStateId = CAT_Organizations.OrganizationStateId
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
			SET @dynamicCategorySelect = 'CAT_DISABILITY.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_DISABILITY CAT_DISABILITY'
			SET @dynamicCategoryCondition = 'and Category = CAT_DISABILITY.Code'
		END
		ELSE IF(@categorySetCode = 'gender' or @categorySetCode = 'sex')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_SEX.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_SEX CAT_SEX'
			SET @dynamicCategoryCondition = 'and Category = CAT_SEX.Code'
		END
		ELSE IF(@categorySetCode = 'raceethnicity')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_RACE.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_RACE CAT_RACE'
			SET @dynamicCategoryCondition = 'and Category = CAT_RACE.Code'
		END
		ELSE IF(@categorySetCode = 'cteparticipation')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_CTEPROGRAM.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_CTEPROGRAM CAT_CTEPROGRAM'
			SET @dynamicCategoryCondition = 'and Category = CAT_CTEPROGRAM.Code'
		END
		ELSE IF(@categorySetCode = 'exitingspeceducation')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_BASISOFEXIT.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_BASISOFEXIT CAT_BASISOFEXIT'
			SET @dynamicCategoryCondition = 'and Category = CAT_BASISOFEXIT.Code'
		END

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		insert into #reportCounts
		(
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, 
			REMOVALLENGTH, 
			DISCIPLINEMETHOD, 
			REMOVALREASON, 
			Category, 
			DisciplineCount)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateCode,
			CAT_Organizations.StateName,
			CAT_Organizations.OrganizationNcesId,
			CAT_Organizations.OrganizationStateId,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationStateId, 
			CAT_REMOVALLENGTH.Code, 
			CAT_DISCIPLINEMETHOD.Code, 
			CAT_REMOVALREASON.Code,
			' + @dynamicCategorySelect + ',
			0 as DisciplineCount
		from #CAT_Organizations CAT_Organizations
		cross join  @CAT_REMOVALLENGTH CAT_REMOVALLENGTH
		cross join  @CAT_DISCIPLINEMETHOD CAT_DISCIPLINEMETHOD
		cross join  @CAT_REMOVALREASON CAT_REMOVALREASON
		' + @dynamicCategoryJoin + '
		where not exists (select 1 from #reportCounts
		where OrganizationStateId = CAT_Organizations.OrganizationStateId
		and REMOVALLENGTH = CAT_REMOVALLENGTH.Code 
		and DISCIPLINEMETHOD = CAT_DISCIPLINEMETHOD.Code 
		and REMOVALREASON = CAT_REMOVALREASON.Code 
		' + @dynamicCategoryCondition + '
		)
				
		'
	end


	if @sqlType = 'zero-educenv' 
	begin

		IF(@categorySetCode = 'disabilitytype')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_DISABILITY.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_DISABILITY CAT_DISABILITY'
			SET @dynamicCategoryCondition = 'and Category = CAT_DISABILITY.Code'
		END
		ELSE IF(@categorySetCode = 'gender' or @categorySetCode = 'sex')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_SEX.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_SEX CAT_SEX'
			SET @dynamicCategoryCondition = 'and Category = CAT_SEX.Code'
		END
		ELSE IF(@categorySetCode = 'raceethnicity')
		BEGIN
			SET @dynamicCategorySelect = 'CAT_RACE.CODE'
			SET @dynamicCategoryJoin = 'cross join  @CAT_RACE CAT_RACE'
			SET @dynamicCategoryCondition = 'and Category = CAT_RACE.Code'
		END

		set @sql = @sql + '
		----------------------------
		-- Insert zero count data 
		----------------------------

		insert into #reportCounts
		(
			StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId, 
			EDUCENV, 
			Category, 
			StudentCount)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateCode,
			CAT_Organizations.StateName,
			CAT_Organizations.OrganizationNcesId,
			CAT_Organizations.OrganizationStateId,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationStateId, 
			CAT_EDUCENV.Code, 
			' + @dynamicCategorySelect + ',
			0 as StudentCount
		from #CAT_Organizations CAT_Organizations
		cross join  @CAT_EDUCENV CAT_EDUCENV
		' + @dynamicCategoryJoin + '
		where not exists (select 1 from #reportCounts
		where OrganizationStateId = CAT_Organizations.OrganizationStateId 
		and EDUCENV = CAT_EDUCENV.Code 
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
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			TITLE1SCHOOLSTATUS, 
			HOMELESSSTATUS, 
			MIGRANTSTATUS, 
			SECTION504PROGRAM, 
			LEPSTATUS, 
			CTEPROGRAM, 
			IMMIGRANTTITLEIIIPROGRAM, 
			FOODSERVICEELIGIBILITY, 
			FOSTERCAREPROGRAM, 
			StudentCount)
		select CAT_Organizations.StateANSICode,
			CAT_Organizations.StateCode,
			CAT_Organizations.StateName,
			CAT_Organizations.OrganizationNcesId,
			CAT_Organizations.OrganizationStateId,
			CAT_Organizations.OrganizationName,
			CAT_Organizations.ParentOrganizationStateId,
			CAT_TITLE1SCHOOLSTATUS.Code, 
			CAT_HOMELESSSTATUS.Code, 
			CAT_MIGRANTSTATUS.Code, 
			CAT_SECTION504PROGRAM.Code, 
			CAT_LEPSTATUS.Code, 
			CAT_CTEPROGRAM.Code, 
			CAT_IMMIGRANTTITLEIIIPROGRAM.Code, 
			CAT_FOODSERVICEELIGIBILITY.Code, 
			CAT_FOSTERCAREPROGRAM.Code,
			0 as StudentCount
		from #CAT_Organizations CAT_Organizations
		cross join  @CAT_TITLE1SCHOOLSTATUS CAT_TITLE1SCHOOLSTATUS
		cross join  @CAT_HOMELESSSTATUS CAT_HOMELESSSTATUS
		cross join  @CAT_MIGRANTSTATUS CAT_MIGRANTSTATUS
		cross join  @CAT_SECTION504PROGRAM CAT_SECTION504PROGRAM
		cross join  @CAT_LEPSTATUS CAT_LEPSTATUS
		cross join  @CAT_CTEPROGRAM CAT_CTEPROGRAM
		cross join  @CAT_IMMIGRANTTITLEIIIPROGRAM CAT_IMMIGRANTTITLEIIIPROGRAM
		cross join  @CAT_FOODSERVICEELIGIBILITY CAT_FOODSERVICEELIGIBILITY
		cross join  @CAT_FOSTERCAREPROGRAM CAT_FOSTERCAREPROGRAM
		where not exists (select 1 from @reportCounts
		where OrganizationStateId = CAT_Organizations.OrganizationStateId 
		and TITLE1SCHOOLSTATUS = CAT_TITLE1SCHOOLSTATUS.Code 
		and HOMELESSSTATUS = CAT_HOMELESSSTATUS.Code 
		and MIGRANTSTATUS = CAT_MIGRANTSTATUS.Code 
		and SECTION504PROGRAM = CAT_SECTION504PROGRAM.Code 
		and LEPSTATUS = CAT_LEPSTATUS.Code 
		and CTEPROGRAM = CAT_CTEPROGRAM.Code 
		and IMMIGRANTTITLEIIIPROGRAM = CAT_IMMIGRANTTITLEIIIPROGRAM.Code 
		and FOODSERVICEELIGIBILITY = CAT_FOODSERVICEELIGIBILITY.Code 
		and FOSTERCAREPROGRAM = CAT_FOSTERCAREPROGRAM.Code 
		)
				
		'
	end
	return @sql
END