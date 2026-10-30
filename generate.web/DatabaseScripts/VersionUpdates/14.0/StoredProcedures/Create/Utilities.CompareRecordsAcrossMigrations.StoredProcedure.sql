CREATE PROCEDURE [Utilities].[CompareRecordsAcrossMigrations]
    @reportCode			nvarchar(3),
    @reportLevel		nvarchar(3) = null,
    @schoolYear			int = null,
    @categorySetCode	nvarchar(3) = null,
	@stagingFilter		nvarchar(max) = null,
	@showSql			bit = 0
AS
BEGIN

	set nocount on;

	--for debugging
	--declare
	--	@reportCode			nvarchar(3) = '002',
	--	@reportLevel		nvarchar(3) = 'sea',	-- 'sea', 'lea', 'sch'
	--	@schoolYear			int = 2026,
	--	@categorySetCode	nvarchar(3) = 'csa',	-- example 'csa', 'csb', 'st1', 'tot'
	--	@stagingFilter		nvarchar(200) = null,	-- example 'LeaIdentifierSeaAccountability = ''123'' and SchoolIdentifierSea = ''456'' '
	--												-- example 'IdeaIndicator = 1 '
	--	@showSql			bit = 1					-- this will either output the dynamic sql code for review or execute the dynamic sql code and display the results

	-----
	--clear the temp tables used by this process
	-----
	drop table if exists #staging_records
	drop table if exists #fact_records
	drop table if exists #debug_records
	drop table if exists #staging_not_fact
	drop table if exists #fact_not_tot

	-----
	--report code must be valid
	-----
	if not exists (
		select 1
		from app.GenerateReports gr
		where gr.ReportCode = @ReportCode
	)
	begin
		print concat('Invalid ReportCode: ', @ReportCode, ' not found in app.GenerateReports.')
		return;
	end

	-----
	--report code must be in a valid fact type and not Directory
	-----
	declare @factType varchar(25)

	select @factType = upper(isnull(RDS.Get_FactTypeByReport(@ReportCode), ''))
	
	if isnull(@factType, '') = '' or @factType = 'DIRECTORY'
	begin
		print 'Invalid ReportCode: Provided report code is missing or not for a student/staff fact type.'
		return
	end;

	-----
	--default SchoolYear if not provided
	-----
	if @SchoolYear IS NULL
	begin
		select @SchoolYear = sy.SchoolYear
		from rds.DimSchoolYearDataMigrationTypes dm
		inner join rds.DimSchoolYears sy
			on dm.DimSchoolYearId = sy.DimSchoolYearId
		where dm.IsSelected = 1
		  and dm.DataMigrationTypeId = 3;
	end;

	if @SchoolYear IS NULL
	begin
		print 'SchoolYear was not provided and no selected migration SchoolYear was found.'
		return;
	end;

	-----
	--validate the provided reportlevel and default if necessary
	-----
	;with ValidReportLevels AS (
		select distinct
			cs.CategorySetCode
			, ol.LevelCode AS ReportLevelCode
			, ol.OrganizationLevelId
		from app.CategorySets cs
		inner join app.GenerateReports gr
			on gr.GenerateReportId = cs.GenerateReportId
		inner join app.OrganizationLevels ol
			on cs.OrganizationLevelId = ol.OrganizationLevelId
		where gr.ReportCode = @ReportCode
		  and cs.SubmissionYear = @SchoolYear
	)

	select 
		@ReportLevel = COALESCE(
			(select top(1) v.ReportLevelCode
			 from ValidReportLevels v
			 where v.ReportLevelCode = @ReportLevel),
			(select top(1) v.ReportLevelCode
			 from ValidReportLevels v
			 order by v.OrganizationLevelId ASC, v.ReportLevelCode)
		);

	-----
	--validate the provided category set and default if necessary
	-----
	;with ValidCategorySets AS (
		select distinct
			cs.CategorySetCode
			, ol.LevelCode AS ReportLevelCode
			, ol.OrganizationLevelId
		from app.CategorySets cs
		inner join app.GenerateReports gr
			on gr.GenerateReportId = cs.GenerateReportId
		inner join app.OrganizationLevels ol
			on cs.OrganizationLevelId = ol.OrganizationLevelId
		where gr.ReportCode = @ReportCode
		  and cs.SubmissionYear = @SchoolYear
		  and ol.LevelCode = @ReportLevel
	)

	select
		@CategorySetCode = COALESCE(
			(select top(1) v.CategorySetCode
			 from ValidCategorySets v
			 where v.CategorySetCode = @CategorySetCode),
			(select top(1) v.CategorySetCode
			 from ValidCategorySets v
			 order by v.OrganizationLevelId desc, v.CategorySetCode)
		);

	-----
	--exit the SP if no valid metadata rows exist at all
	-----
	if @CategorySetCode is null or @ReportLevel is null
	begin
		print 'No valid category set/report level found for the report code and school year.'
		return;
	end;

	-----
	--set the appropriate debug table based on the provided criteria
	-----
	--create the variable for the existance of the debug table
	declare @debugExists bit = 1

	--assemble the partial debug table to use for comparison
	declare @partialDebugTable varchar(16) = concat(@reportCode, '_', @reportLevel, '_', @categorySetCode, '_', @schoolYear)

	--validate that the debug table exists 
	declare @debugSearchValue varchar(17) = @partialDebugTable + '%'
	declare @debugTable varchar(75)	

	set @debugTable = (
		select '[' + t.name  + ']'
		from sys.tables t
		where schema_name(t.schema_id) = 'debug'
		and t.name like @debugSearchValue
	)

	if isnull(@debugTable, '') = ''
	begin
		print 'There is no debug table to match the partial value' + @debugTable + ' for the query.'
		set @debugExists = 0
	end;	

	-----
	--set the variables to handle staff and student
	-----
	declare @personIdentifier varchar(40), @domain varchar(10)
	if @factType = 'staff'
	begin
		set @personIdentifier = 'StaffMemberIdentifierState'
		set @domain = 'K12Staff'
	end
	else 
	begin
		set @personIdentifier = 'StudentIdentifierState'
		set @domain = 'K12Student'
	end

	-----
	--set the sql variable to hold the dynamic code
	-----
	declare @sql nvarchar(max) = ''

	------------------------------------
	--do the work
	------------------------------------

	--get the records from the staging debug view
	set @sql = ''
	set @sql = @sql + '
	select distinct 
		NULLIF(LTRIM(RTRIM(' + @personIdentifier + ')), '''')			AS StagingPersonIdentifier
		, NULLIF(LTRIM(RTRIM(LeaIdentifierSeaAccountability)), '''')	AS StagingLeaIdentifier
		, NULLIF(LTRIM(RTRIM(SchoolIdentifierSea)), '''')				AS StagingSchoolIdentifier
	into #staging_records
	from [debug].[vw' + @factType + '_StagingTables]
	where nullif(ltrim(rtrim(' + @personIdentifier + ')), '''') is not null 
	'
	--add any additional filtering that was provided
	if isnull(@stagingFilter, '') <> ''
	begin
		set @sql = @sql + '
		and ' + @stagingFilter + char(10) + '' 
	end

	--get the records from the fact debug view
	set @sql = @sql + '
	select distinct
		NULLIF(LTRIM(RTRIM(' + @domain + @personIdentifier + ')), '''')	AS FactPersonIdentifier
		, NULLIF(LTRIM(RTRIM(LeaIdentifierSea)), '''')					AS FactLeaIdentifier
		, NULLIF(LTRIM(RTRIM(SchoolIdentifierSea)), '''')				AS FactSchoolIdentifier
	into #fact_records
	from [debug].[vw' + @factType + '_FactTable]
	where NULLIF(LTRIM(RTRIM(' + @domain + @personIdentifier + ')), '''') IS NOT NULL
	'

	--if the debug table was found, get the records from the debug table
	if @debugExists = 1
	begin
		set @sql  = @sql + '
		select distinct 
			NULLIF(LTRIM(RTRIM(' + @domain + @personIdentifier + ')), '''')	AS DebugPersonIdentifier '
		if @reportLevel = 'lea'
		begin
			set @sql  = @sql + '
			, NULLIF(LTRIM(RTRIM(LeaIdentifierSea)), '''')					AS DebugLeaIdentifier '
		end
		else if @reportLevel = 'sch'
		begin
			set @sql  = @sql + '
			, NULLIF(LTRIM(RTRIM(SchoolIdentifierSea)), '''')				AS DebugSchoolIdentifier '
		end

		set @sql  = @sql + '
		into #debug_records
		from [debug].' + @debugTable + '
		where NULLIF(LTRIM(RTRIM(' + @domain + @personIdentifier + ')), '''') IS NOT NULL
		'
	end

	--combine the staging and fact temp tables to identify records that did not migrate
	set @sql  = @sql + '
	select s.StagingPersonIdentifier
	into #staging_not_fact
	from #staging_records s
	left join #fact_records f 
		on f.FactPersonIdentifier = s.StagingPersonIdentifier
	where f.FactPersonIdentifier IS NULL
	'

	--combine the fact and debug temp tables to identify records that did not migrate
	if @debugExists = 1
	begin
		set @sql  = @sql + '
		select f.FactPersonIdentifier
		into #fact_not_tot
		from #fact_records f '

		--add the additional query filtering if it was provided 
		if isnull(@stagingFilter, '') <> ''
		begin
			set @sql = @sql + '
			inner join #staging_records s
				on f.FactPersonIdentifier = s.StagingPersonIdentifier '
		end

		set @sql  = @sql + '
		left join #debug_records t 
			on t.DebugPersonIdentifier = f.FactPersonIdentifier
		where t.DebugPersonIdentifier IS NULL
		'
	end

	-----
	--display the results
	-----
	set @sql  = @sql + '
	select 
		''InStaging_NotInFact'' AS DifferenceType,
		count(*) as RecordCount
	from #staging_not_fact

	select *
	from [debug].[vw' + @factType + '_StagingTables]
	where ' + @personIdentifier + ' in (
		select StagingPersonIdentifier
		from #staging_not_fact
	)
	'

	if @debugExists = 1
	begin
		set @sql  = @sql + '
		select 
			''InFact_NotInDebugTables'' AS DifferenceType,
			count(*) as RecordCount
		from #fact_not_tot;

		select *
		from [debug].[vw' + @factType + '_FactTable]
		where ' + @domain + @personIdentifier + ' in (
			select FactPersonIdentifier
			from #fact_not_tot
		)
		'
	end

	--if you want to see the sql code that is being executed
	if @showSql = 1
		print @sql;
	else 
		execute sp_executesql @sql;

END
