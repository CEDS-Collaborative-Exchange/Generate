/*******************************************************************************
Jeff Wheaton MSF&W
May 5, 2026

This procedure returns data formatted for an EdFacts Submission Report based on
the provided parameters.

The resulting dataset will be ordered by CategorySetCode and Organization Identifier
*******************************************************************************/
CREATE PROCEDURE [Utilities].[GetEdFactsReportSubmissionData]
	@ReportYear int, 
	@ReportCode varchar(10), 
	@ReportLevel varchar(3), 
	@FilterOrganizationIds varchar(200) = NULL,	-- Results will be filtered to this OrganizationId if included
	@FilterTotalsOnly bit = 0,					-- 1=Filter to only "TotalIndicator='Y'"
	@FilterCategorySets varchar(100) = NULL,	-- include a comma delimited list of category sets to include in the results
	@AdditionalFilterSQL varchar(2000) = NULL,  -- Add additional criteria to the "WHERE" clause.  Example: 'and IdeaDisabilityType = ''OHI'' and Age=''20'''
	@ShowCategorySetColumnInResults bit = 0,	-- 1=Include CategorySet in the results. *** THIS DOES NOT CONFORM TO EDFACTS FILE SPECS ***
	@ShowOrganizationNameInResults bit = 0,		-- 1=Include OrganizationIdentfierSEA and OrganizationName in the results. *** THIS DOES NOT CONFORM TO EDFACTS FILE SPECS ***  
	@HideFillerColumns bit = 0,					-- 1=Hide Filler Columns in Results
	@ShowSQL bit = 0							-- 1=Show dynamic SQL that produces dataset rather than data.  Useful when debugging

	---- TESTING ------------------------------------------------
	-- DECLARE
	-- @ReportYear int = 2026,
	-- @ReportCode varchar(10) = '002',
	-- @ReportLevel varchar(3) = 'sch',

	-- @FilterOrganizationIds varchar(200) = NULL,
	-- @FilterTotalsOnly bit = 0,					-- 1=Filter to only "TotalIndicator='Y'"
	-- @FilterCategorySets varchar(100) = NULL,	-- include a comma delimited list of category sets to include in the results
	-- @AdditionalFilterSQL varchar(2000) = NULL,  -- Add additional criteria to the "WHERE" clause.  Example: 'and IdeaDisabilityType = ''OHI'' and Age=''20'''
	-- @ShowCategorySetColumnInResults bit = 0,	-- 1=Include CategorySet in the results. *** THIS DOES NOT CONFORM TO EDFACTS FILE SPECS ***
	-- @ShowOrganizationNameInResults bit = 0,		-- 1=Include OrganizationIdentfierSEA and OrganizationName in the results. *** THIS DOES NOT CONFORM TO EDFACTS FILE SPECS ***  
	-- @HideFillerColumns bit = 0,					-- 1=Hide Filler Columns in Results
	-- @ShowSQL bit = 0							-- 1=Show dynamic SQL that produces dataset rather than data.  Useful when debugging

	-------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON
	drop table if exists #Metadata
	drop table if exists ##RecordCount

	if @ReportCode in ('029', '039')
		begin
			select @ShowOrganizationNameInResults = 0
		end

	create table #Metadata (
		SubmissionYear int,
		FileSubmissionDescription varchar(200),
		ReportCode varchar(200),
		FactReportTableName varchar(400),
		FactFieldName varchar(200),
		TableTypeAbbrv varchar(200),
		LevelCode varchar(100),
		SequenceNumber int,
		StartPosition int,
		EndPosition int,
		ColumnName varchar(400),
		ReportColumn varchar(400)
	)
	insert into #Metadata
	select 
		FS.SubmissionYear,
		FS.FileSubmissionDescription,
		R.ReportCode,
		FT.FactReportTableName,
		FT.FactFieldName,
		TT.TableTypeAbbrv,
		OL.LevelCode,
		FSFC.SequenceNumber,
		FSFC.StartPosition,
		FSFC.EndPosition,
		FC.ColumnName,
		FC.ReportColumn
	from app.GenerateReports R
	left join app.FactTables FT
		on R.FactTableId = FT.FactTableId
	left join app.GenerateReport_TableType GRTT
		on r.GenerateReportId = GRTT.GenerateReportId
	left join app.TableTypes TT
		on GRTT.TableTypeId = TT.TableTypeId
	left join app.FileSubmissions FS
		on R.GenerateReportId = FS.GenerateReportId
	left join app.OrganizationLevels OL
		on fs.OrganizationLevelId = OL.OrganizationLevelId
	left join app.FileSubmission_FileColumns FSFC
		on FS.FileSubmissionId = FSFC.FileSubmissionId
	left join app.FileColumns FC
		on fsfc.FileColumnId = fc.FileColumnId

	where 1=1
	and FC.ColumnName not in ('CarriageReturn/LineFeed', 'FileRecordNumber')
	and FS.SubmissionYear = @ReportYear 
		and ReportCode = @ReportCode
		and OL.LevelCode = @ReportLevel
		-- Need to handle instances where there are multiple TableTypeAbbrv for a file type
		and isnull(TableTypeAbbrv,'') = 
			case 
				when @ReportCode = '059' then 'FTEStaff' 
				else isnull(TableTypeAbbrv, '')
			end

if not exists (select top 1 * from #Metadata)
	begin
		print 'Invalid Parameters or no data exists for the combined parameters.'
		return
	end

		-----------------------------------------------------------------------------------
	declare 
		@SQL varchar(max) = '',
		@SelectColumns varchar(max) = '',
		@SequenceNumber smallint = 2,
		@ColumnName varchar(200) = '',
		@ReportColumnName varchar(200) = '',
		@ReportTableName varchar(200) = '',
		@TableTypeAbbrv varchar(200) = '',
		@CountColumnName varchar(200) = '',
		@FileSubmissionDescription varchar(200) = '',
		@OrderBy varchar(200) = '',
		@StateCode varchar(2) = '',
		@OrganizationFilterColumnName varchar(25) = ''

		-- No OrganizationID filter if ReportLevel = SEA or ReportCode in Directory Files
		if @ReportLevel = 'SEA' select @FilterOrganizationIds = NULL

		-- No OrganizationID filter for any Directory reports
		if @ReportCode in (
			select ReportCode from app.GenerateReports R
			inner join app.GenerateReport_FactType FT
				on R.GenerateReportId = FT.GenerateReportId
			where FT.FactTypeId = 21 -- Directory
			)
			begin
				select @FilterOrganizationIds = NULL
			end

		-- FORMAT COMMA LIST PARAMETERS FOR USE IN THE IN CLAUSE ------------------------------------------
		declare @item varchar(100) = ''

		-- Format @FilterCategorySets
		if @FilterCategorySets is not null
			begin
				drop table if exists #CategorySets
				declare @CategorySetList varchar(500) = ''
				select * into #CategorySets from app.Split(@FilterCategorySets, ',')
				while exists (select top 1 item from #CategorySets)
					begin
						select @item = (select top 1 item from #CategorySets)
						select @CategorySetList += quotename(@item, '''')
						delete from #CategorySets where item = @item
						if exists (select top 1 item from #CategorySets)
							begin
								select @CategorySetList += ', '
							end
					end
				--print @CategorySetList
				--return
				
			end
			else
				begin
					select @CategorySetList = ''''
				end

		-- Format @FilterOrganizationIds
		if @FilterOrganizationIds is not null
			begin
				drop table if exists #Organizations
				declare @OrganizationList varchar(500) = ''
				select * into #Organizations from app.Split(@FilterOrganizationIds, ',')
				while exists (select top 1 item from #Organizations)
					begin
						select @item = (select top 1 item from #Organizations)
						select @OrganizationList += quotename(@item, '''')
						delete from #Organizations where item = @item
						if exists (select top 1 item from #Organizations)
							begin
								select @OrganizationList += ', '
							end
					end			
			end
			-------------------------------------------------------------------------------------------

		select @ReportTableName = (select top 1 FactReportTableName from #Metadata)
		select @CountColumnName = (select top 1 FactFieldName from #Metadata)
		select @FileSubmissionDescription = (select top 1 FileSubmissionDescription from #Metadata)
		select @StateCode = (select top 1 ISNULL(StateCode,'') from RDS.ReportEDFactsOrganizationCounts)

		
		-- If a file spec has multiple table types, we need to handle this by
		-- filtering to just one table type when constructing the dynamic sql to
		-- avoid problems with duplicate sequence numbers.  The assumption is that
		-- each table type for a file spec will have identical columns.
			drop table if exists #TableTypes
			select distinct isnull(TableTypeAbbrv,'') TableTypeAbbrv into #TableTypes from #Metadata
			select @TableTypeAbbrv = isnull((select top 1 TableTypeAbbrv from #Metadata), '')


		while exists (select top 1 SequenceNumber from #Metadata where isnull(TableTypeAbbrv, '') = @TableTypeAbbrv)
			begin
				select @ReportColumnName = (select ReportColumn from #Metadata where SequenceNumber = @SequenceNumber and isnull(TableTypeAbbrv, '') = @TableTypeAbbrv)
				select @ColumnName = (select ColumnName from #Metadata where SequenceNumber = @SequenceNumber and isnull(TableTypeAbbrv, '') = @TableTypeAbbrv)
				if @ColumnName is not null
					begin
						if @ReportColumnName in ('OrganizationIdentifierSea', 'OrganizationStateId')
							begin
								select @OrderBy += @ColumnName -- @ReportColumnName
							end

							-----------------------------------------------------------------------------------------------------
							if @ColumnName = 'StateAgencyNumber'
								begin
									select @ReportColumnName = '''01''' + ' ' + @ColumnName
								end

							else if @ColumnName = 'NCESLEAIDNumber' and @ReportLevel = 'SCH'
								begin
									select @ReportColumnName = 'ISNULL(ParentOrganizationNCESId,'''') ' + @ColumnName
								end
							else if @ColumnName = 'NCESLEAIDNumber' and @ReportLevel = 'LEA'
								begin
									select @ReportColumnName = 'ISNULL(OrganizationNCESId,'''') ' + @ColumnName
								end
							else if @ColumnName = 'NCESSchoolIDNumber' and @ReportLevel = 'SCH'
								begin
									select @ReportColumnName = 'ISNULL(OrganizationNCESId,'''') ' + @ColumnName
								end

							else if @ColumnName = 'StateLEAIDNumber' and @ReportLevel = 'LEA'
								begin
									if @ReportCode in ('029', '039', '129') 
										begin
											select @ReportColumnName = 'ISNULL(OrganizationStateId, '''') ' + @ColumnName
										end
									else
										begin
											select @ReportColumnName = 'ISNULL(OrganizationIdentifierSea, '''') ' + @ColumnName
										end
								end

							else if @ColumnName = 'StateLEAIDNumber' and @ReportLevel = 'SCH'
								begin
									if @ReportCode in ('029', '039', '129') 
										begin
											select @ReportColumnName = 'ISNULL(ParentOrganizationStateId, '''') ' + @ColumnName
										end
									else
										begin
											select @ReportColumnName = 'ISNULL(ParentOrganizationIdentifierSea, '''') ' + @ColumnName
										end
								end

							else if @ColumnName = 'StateSchoolIDNumber' and @ReportLevel = 'SCH'
								begin
									if @ReportCode in ('029', '039', '129') 
										begin
											select @ReportColumnName = 'ISNULL(OrganizationStateId, '''') ' + @ColumnName
										end
									else
										begin
											select @ReportColumnName = 'ISNULL(OrganizationIdentifierSea, '''') ' + @ColumnName
										end
								end

							-- SPECIAL HANDLING FOR 029 ZIP CODES -----------------
							else if @ReportColumnName = 'MailingAddressPostalCode'
								begin
									select @ReportColumnName = 'ISNULL(left(MailingAddressPostalCode, 5),'''') ' + @ReportColumnName
								end
							else if @ReportColumnName = 'PhysicalAddressPostalCode'
								begin
									select @ReportColumnName = 'ISNULL(left(PhysicalAddressPostalCode, 5),'''') ' + @ReportColumnName
								end
							else if @ColumnName = 'MailingZipcodePlus4'
								begin
									select @ReportColumnName = 'case when len(isnull(MailingAddressPostalCode,'''')) >= 9 then right(MailingAddressPostalCode,4) else '''' end ' + @ColumnName
								end
							else if @ColumnName = 'LocationZipcodePlus4'
								begin
									select @ReportColumnName = 'case when len(isnull(PhysicalAddressPostalCode,'''')) >= 9 then right(PhysicalAddressPostalCode,4) else '''' end ' + @ColumnName
								end


							-- Add Count Column
							else if @ColumnName = 'Amount' and @CountColumnName <> ''
								begin
									select @ReportColumnName =  'ISNULL(' + @CountColumnName + ', '''') ' + @CountColumnName	 + char(10)
								end

							--  StatusEffectiveDate Column
							else if @ColumnName = 'StatusEffectiveDate' and isnull(@ReportColumnName,'') = ''
								begin
									select @ReportColumnName =  'ISNULL(' + 'EffectiveDate' + ', '''') ' + @ColumnName	 + char(10)
								end


							-- When there is a ReportColumn in the Metadata for a ColumnName
							else if isnull(@ReportColumnName, '') <> '' 
								begin
									select @ReportColumnName = 'ISNULL(' + @ReportColumnName + ', '''') ' + @ReportColumnName + char(10)
								end

							-- All other cases where no ReportColumn exists in the metadata and hasn't been accounted for above (Filler, etc.)
							else if isnull(@ReportColumnName, '') = '' 
								begin
									if @ColumnName like 'Filler%' or @ColumnName = 'Explanation' or @ColumnName = 'MailingAddress3' or @ColumnName = 'LocationAddress3'
										begin
											if @HideFillerColumns = 0
												begin
													select @ReportColumnName = '''''' + ' ' + @ColumnName
												end
											else 
												begin
													select @ReportColumnName = ' '
												end
										end
									else
										begin
											-- No ReportColumn defined in metadata because ColumnName will be the ReportColumn
											select @ReportColumnName = 'ISNULL(' + @ColumnName + ', '''') ' + @ColumnName + char(10)
										end
								end

							if @SequenceNumber > 2
								begin
									-- Determine if comma is needed
									if @HideFillerColumns = 1
										begin
											if @ColumnName like 'Filler%' or (@ColumnName = 'Explanation' or @ColumnName = 'MailingAddress3' or @ColumnName = 'LocationAddress3')
												begin
													select @SelectColumns += ''
												end
										else
											begin
												select @SelectColumns += ', ' 
											end
										end
									else
										begin
											select @SelectColumns += ', ' 
										end
									end
							select @SelectColumns += @ReportColumnName --+ char(10)
						end
				delete from #Metadata where SequenceNumber = @SequenceNumber and isnull(TableTypeAbbrv, '') = @TableTypeAbbrv
				select @SequenceNumber += 1

			end

	if @ShowOrganizationNameInResults = 1 
		begin
			select @SelectColumns = 'OrganizationName, ' + char(10) + @SelectColumns
		end

	if @ShowCategorySetColumnInResults = 1
		begin
			select @SelectColumns = 'CategorySetCode, ' + char(10) + @SelectColumns
		end


	select @SQL = 
		'DROP TABLE IF EXISTS #REPORT' + char(10) + char(10)
		+ 'SELECT ' +
		+ @SelectColumns + char(10)
		+ 'INTO #REPORT' + char(10)
		+ 'FROM RDS.' + @ReportTableName + char(10)
		+ 'WHERE ReportYear = ' + convert(varchar, @ReportYear) + char(10)
		+ char(9) + 'AND ReportCode = ' + quotename(@ReportCode,'''') + char(10)
		+ char(9) + 'AND ReportLevel = ' + quotename(@ReportLevel,'''') + char(10) 

	-- Additional Filter SQL
		if @AdditionalFilterSQL is not null
			begin
				if left(ltrim(rtrim(@AdditionalFilterSQL)),4) <> 'AND '
					begin
						select @AdditionalFilterSQL = 'AND ' + @AdditionalFilterSQL
					end
				select @SQL += char(9) + @AdditionalFilterSQL + char(10)
			end	



	-- ADDITIONAL FILTERING BASED ON PARAMETERS -------------------------------------------------------
	if @FilterOrganizationIds is not null
		begin
			select @OrganizationFilterColumnName = 'OrganizationIdentifierSEA'
			select @SQL += char(9) + 'AND ' + @OrganizationFilterColumnName + ' in (' + @OrganizationList + ')' + char(10)
		end

	if @FilterTotalsOnly = 1
		begin
			select @SQL += char(9) + 'AND TotalIndicator = ''Y'' ' + char(10)
		end

	if @FilterCategorySets is not null
		begin
			select @SQL += char(9) + 'AND CategorySetCode in (' + @CategorySetList + ')' + char(10)
		end



	if @OrderBy = '' and @ShowCategorySetColumnInResults = 1
		begin
			select @OrderBy = 'CategorySetCode'
		end
	else if @OrderBy <> '' and @ShowCategorySetColumnInResults = 1
		begin
			select @OrderBy += ', CategorySetCode'
		end


	if @OrderBy = ''
		begin
			select @SQL += char(10) + 'Select ROW_NUMBER() OVER (ORDER BY StateANSICode) AS FileRecordNumber,* from #REPORT ' + char(10)
		end
	else
		begin
			select @SQL += char(10) + 'Select ROW_NUMBER() OVER (ORDER BY ' + @OrderBy + ') AS FileRecordNumber,* from #REPORT ' + char(10)
			select @SQL += 'ORDER BY ' + @OrderBy + char(10) + char(10)
		end


	----------------------------------------------------------------------
	select @SQL += 'drop table if exists ##RecordCount' + char(10)
	select @SQL += 'select count(*) RecordCount into ##RecordCount from #REPORT; ' + char(10) 

	----------------------------------------------------------------------
	-- Only run query if data exists in the report table for the parameters supplied
	declare 
		@ResultValue int,
		@VerifySQL nvarchar(max) = ''

	select @VerifySQL = 'SELECT @Out = count(*) FROM RDS.' + @ReportTableName + ' WHERE ReportYear = ' + convert(varchar, @ReportYear) + ' AND ReportCode = ' + quotename(@ReportCode,'''') + ' AND ReportLevel = ' + quotename(@ReportLevel,'''')

	exec sp_executesql
		@Statement = @VerifySQL,
		@params = N'@Out INT OUTPUT',
		@Out = @ResultValue OUTPUT


	--if ISNULL(@ResultValue,0) > 0
		begin

			if @ShowSQL = 1
				begin
					print @SQL
				end
			else
				begin
					declare @ConformsToEdFacts bit = 1

					if @ShowCategorySetColumnInResults = 1 
						or @ShowOrganizationNameInResults = 1 
						or @FilterOrganizationIds is not NULL 
						or @FilterTotalsOnly = 1 
						or @FilterCategorySets is not null
						or @HideFillerColumns = 1 
						or @AdditionalFilterSQL is not null
						begin
							select @ConformsToEdFacts = 0
							select 'NOTE: This dataset does not conform to EdFacts file specifications and cannot be uploaded to EdPass'
						end

					exec (@SQL)

					if @ConformsToEdFacts = 1
						begin
							-- CREATE HEADER RECORD ---------------------------------------------------------------------------------------------
							if exists (select top 1 * from ##RecordCount)
								begin
									select 
										@FileSubmissionDescription 'FileType',
										convert(varchar, (select RecordCount from ##RecordCount)) 'TotalRecords',
										left(@StateCode + '_' + upper(@ReportLevel) + '_' + @ReportCode + '_' + convert(varchar, year(getdate())) + convert(varchar, month(getdate())) + convert(varchar, day(getdate())), 21) + '.TAB' 'FileName', -- replace(replace(convert(varchar, getdate(), 101),' ',''), '/',''), 21) + '.TAB' 'FileName',
										@StateCode + '_' + upper(@ReportLevel) + '_' + @ReportCode 'FileIdentifier' ,
										convert(varchar, @ReportYear-1) + '-' + convert(varchar, @ReportYear) 'ReportingPeriod'
									end
							---------------------------------------------------------------------------------------------------------------
						end

				end
		end
	--else
	--	begin
	--		print 'NO DATA EXISTS FOR THIS COMBINATION OF PARAMETERS!'
	--	end

	drop table if exists ##RecordCount

END
