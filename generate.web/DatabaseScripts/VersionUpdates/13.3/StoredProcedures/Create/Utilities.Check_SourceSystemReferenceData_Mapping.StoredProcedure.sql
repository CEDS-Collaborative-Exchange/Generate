CREATE PROCEDURE [Utilities].[Check_SourceSystemReferenceData_Mapping]
	@FactTypeCode varchar(50) = null,
	@schoolYear smallint,
	@showUnmappedOnly bit = 0
AS 
BEGIN
	/*
	Sample Execution: exec [Utilities].[Check_SourceSystemReferenceData_Mapping] 'childcount', 2022, 1	
		-- RUN the Child Count Group (002/089) and only show the reference values that do not have a mapping
	Sample Execution: exec [Utilities].[Check_SourceSystemReferenceData_Mapping] 'childcount', 2022, 0	
		-- RUN the Child Count Group (002/089) and only show all mappings

	There are 3 parameters
		@generateReportGroup - This is the Generate Report Group Name (listed below with the associated File Specs for reference)
		@schoolYear - The School Year to check for in Staging.SourceSystemReferenceData
		@showUnmappedOnly - Set this if you only want to view the CEDS options that do not have a corresponding state mapping

		Generate Report Groups		File Specs
			Assessment					175,178,179,185,188,189, 113,125,126,137,138,139,142
			ChildCount					002,089
			ChronicAbsenteeism			195
			Directory					029,039,190,196,035,103,129,130,131,163,170,193,197,198,205,206
			Discipline					005,006,007,086,088,143,144
			Dropout						032
			Exiting						009
			GraduatesCompleters			040
			GraduationRate				150,151
			Homeless					118,194
			HSGraduatePSEnrollment		160
			Personnel					070,099,112,059,065,067,203
			Immigrant					165
			Membership					033,052
			MigrantEducationProgram		054,121,145
			NeglectedOrDelinquent		119,127
			TitleI						037,134
			titleIIIELOct				116,141
			TitleIIIELSY				045,204
	*/

	-------------------------------------------------	
	--Setup
	-------------------------------------------------	

	--check that report group was provided
	if isnull(@FactTypeCode, '') = ''
	begin 
		select '*** No value provided for FactTypeCode. Valid options are:' ValidValues
		UNION
		SELECT DISTINCT FactTypeCode FROM rds.DimFactTypes
		return
	end

	--check that the report group is valid
	if isnull(@FactTypeCode, '') <> '' 
	begin
		if (select count(*) from rds.DimFactTypes where FactTypeCode = @FactTypeCode) < 1
		begin
			select '*** Invalid value provided for Generate Report Group. Valid options are:' ValidValues
			UNION
			SELECT DISTINCT FactTypeCode FROM rds.DimFactTypes
			return
		end 
	end

	--check that a school year was provided
	if isnull(@schoolYear, '') = ''
	begin 
		print '*** No school year provided, please execute the script with a valid School Year'
		return
	end


	-------------------------------------------------	
	--Execute the scripts
	-------------------------------------------------	

	--Get the Report IDs that make up the Generate Report Group
	begin try

		--populate the temp table for use in the joins later
		if OBJECT_ID('tempdb..#fileSpecByReportGroup') is not null
			drop table #fileSpecByReportGroup

		create table #fileSpecByReportGroup (
			FileGroupName varchar(50)
			, FileNumber varchar(3)
		)
	
		declare @tempSql nvarchar(max)
		set @tempSql = 
		'insert into #fileSpecByReportGroup ( ' + char(10) +
		'	FileGroupName ' + char(10) +
		'	, FileNumber ' + char(10) +
		')' + char(10) +
		'select agrg.FactTypeCode, agr.GenerateReportId ' + char(10) +	 
		'from app.GenerateReport_FactType x ' + char(10) +
		'	inner join rds.dimFactTypes agrg ' + char(10) +
		'		on x.FactTypeId = agrg.dimFactTypeId ' + char(10) +
		'	inner join app.GenerateReports agr ' + char(10) +
		'		on x.GenerateReportId = agr.GenerateReportId ' + char(10) +
		'where agrg.FactTypeCode = ''' + @FactTypeCode + '''
		'	
--		print (@tempSql)
		exec sp_executesql @tempSql

	end try
	begin catch
		select 'Failed to get the report IDs from the Report Group provided', ERROR_MESSAGE()
	end catch

	begin try

		declare @getSQL nvarchar(max)
		set @getSQL = 

		'select distinct ''' + @FactTypeCode + '''' + char(10) +
		'	, agst.StagingTableName ' + char(10) +
		'	, x.CEDSReferenceTable ' + char(10) +
		'	, x.SSRDTableFilter ' + char(10) +
		'	, sssrd.InputCode ' + char(10) +
		'	, sssrd.OutputCode ' + char(10) +
		'from app.SourceSystemReferenceMapping_DomainFile_XREF x ' + char(10) +
		'	inner join app.GenerateReports agr ' + char(10) +
		'		on agr.GenerateReportId in (select distinct FileNumber from #fileSpecByReportGroup) ' + char(10) +
		'	inner join app.GenerateStagingTables agst ' + char(10) +
		'		on x.StagingTableId = agst.StagingTableId ' + char(10) +
		'	inner join staging.SourceSystemReferenceData sssrd ' + char(10) +
		'		on x.CEDSReferenceTable = sssrd.TableName ' + char(10) +
		'		and isnull(x.SSRDTableFilter, ''N/A'') = ISNULL(sssrd.TableFilter, ''N/A'') ' + char(10) +
		'where x.GenerateReportGroup like (''%' + @FactTypeCode + '%'')' + char(10) +
		'and sssrd.SchoolYear = ' + convert(varchar, @SchoolYear) + '' + char(10)

		if @showUnmappedOnly = 1
		begin 
			set @getSQL += 'and sssrd.InputCode is null ' + char(10)  		
		end 

		set @getSQL += 
		'order by StagingTableName, CEDSReferenceTable '
		
--		print (@getSql)
		exec sp_executesql @getSql

	end try
	begin catch
		select 'Failed to get the report IDs from the Fact Type provided', ERROR_MESSAGE()
	end catch

END
