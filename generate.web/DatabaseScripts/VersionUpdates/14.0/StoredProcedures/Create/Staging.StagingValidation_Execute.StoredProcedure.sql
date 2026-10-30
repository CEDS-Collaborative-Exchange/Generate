create PROCEDURE [Staging].[StagingValidation_Execute]
	@SchoolYear int,
	@FactTypeOrReportCode varchar(50),
	@RemoveHistory bit = 0, --1
	@PrintSQL bit = 0  -- 1
AS

--declare
--	@SchoolYear int = 2023,
--	@FactTypeOrReportCode varchar(50) = 'Exiting',
--	@TruncateResultsTable bit = 0, -- 1
--	@PrintSQL bit = 0

BEGIN

	set NOCOUNT ON


	-- Verify @FactTypeOrReportCode is Valid
	if not exists (
		select top 1 * from App.vwStagingRelationships 
		where ReportCode = @FactTypeOrReportCode or FactTypeCode = @FactTypeOrReportCode)
		begin
			select '*** INVALID VALUE FOR @FactTypeOrReportCode.  VALID OPTIONS ARE:','' VALID_VALUES
			union
			select distinct 'Fact Type', FactTypeCode from App.vwReportCode_StagingTables
			union
			select distinct 'Report Code', ReportCode from App.vwReportCode_StagingTables
			order by 1

			return
		end

		-- Load temp table with values from vwStagingValidation that match parameter
		IF OBJECT_ID(N'tempdb..#vwStagingRelationships') IS NOT NULL DROP TABLE #vwStagingRelationships

		select * 
		into #vwStagingRelationships
		from app.vwStagingRelationships
		where (FactTypeCode = @FactTypeOrReportCode 
		or ReportCode = @FactTypeOrReportCode)
		 and StagingTableName is not null

		--select * from #vwStagingValidation


	-- This may be changed to retain history ------------------------
	if @RemoveHistory = 1
		begin
			delete from Staging.StagingValidationResults
			where SchoolYear = @SchoolYear and FactTypeOrReportCode = @FactTypeOrReportCode
		end
	-----------------------------------------------------------------


	declare 
		@StagingValidationRuleId int,
		@StagingColumnId int,
		@InsertDate datetime = getdate(), 
		@RecordCount int,
		@TableName varchar(100),
		@ColumnName varchar(100),
		@RefTableName varchar(100),
		@TableFilter varchar(10),
		@SQL varchar(max) = '',
		@ValidationType varchar(500),
		@Condition varchar(max),
		@ValidationMessage varchar(2000),
		@Severity varchar(20),
		@ErrorMessage varchar(500),
		@ShowRecordsSQL varchar(max),
		@SQL_Part varchar(max),
		@FactType varchar(50),
		@ReportCode varchar(10),

		@NullValue varchar(100) = 'A value in this column cannot be NULL or empty.  A valid value must exist.',
		@NoRecords varchar(100) = 'The table cannot be empty',
		@BadValue varchar(100) = 'Column contains an invalid value',
		@StagingValueNotMappedInSSRD varchar(500) = 'Staging Value Not Mapped in Staging.SourceSystemReferenceData',

		@Severity_CRITICAL varchar(20) = 'Critical',
		@Severity_ERROR varchar(20) = 'Error',
		@Severity_INFORMATIONAL varchar(20) = 'Informational'



		-----------------------------------------------------------------------------------------------
		-- VALIDATION TYPE: NO RECORDS (Table cannot be empty).  NO RULE NEEDS TO BE DEFINED FOR THIS
		-----------------------------------------------------------------------------------------------
		select @StagingValidationRuleId = -1 -- This is a global value for all rules related to "no records in a table"

		IF OBJECT_ID(N'tempdb..#Tables') IS NOT NULL DROP TABLE #Tables

		select distinct StagingTableName into #Tables from #vwStagingRelationships

		while exists (select top 1 * from #Tables)
		begin
			select @TableName = (select top 1 StagingTableName from #Tables)

			select @SQL = 'if not exists(select top 1 * from staging.' + @TableName + ')' + char(10)
			select @SQL += '	begin' + char(10)
			select @SQL += '		insert into Staging.StagingValidationResults' + char(10)
			select @SQL += '		select ' + char(10)
			select @SQL += '		''' + convert(varchar, @StagingValidationRuleId) + ''', '
			select @SQL += '''' + convert(varchar, @SchoolYear) + ''','''
			select @SQL += isnull(@FactTypeOrReportCode, isnull(@FactType,'')) + ''', ' 
			select @SQL += '''' + @TableName + ''', '
			select @SQL += 'NULL, ' 
			select @SQL += '''' + @Severity_CRITICAL + ''', ' 
			select @SQL += '''' + @NoRecords  + ''', '
			select @SQL += ' 0, '
			select @SQL += '''select count(*) from Staging.' + @TableName + ''',' 
			select @SQL += '''' + convert(varchar, @InsertDate, 121) + '''' + char(10)
			select @SQL += '	end' + char(10)

			begin try
				if @PrintSQL = 1 
					begin
						select @StagingValidationRuleId RuleId, @SQL 'SQL'
					end
				else exec (@SQL)
			end try
			begin catch
				-- If a SQL ERROR happens due to bad @SQL formatting, log this and continue processing remaining rules
				select @ErrorMessage = ERROR_MESSAGE()	

				insert into Staging.StagingValidationResults
					select 
						-9					StagingValidationRuleId,
						@SchoolYear			SchoolYear,
						@FactTypeOrReportCode	FactTypeOrReportCode,
						@TableName			StagingTableName,
						@ColumnName			ColumnName,
						'Rule_Error'		Severity,
						@ErrorMessage		ValidationMessage,
						0					RecordCount,
						@SQL				ShowRecordsSQL,
						@InsertDate			InsertDate
			end catch

			delete from #Tables where StagingTableName = @TableName

		end

		-----------------------------------------------------------------------------------------------
		-- VALIDATION TYPE: STAGING VALUE NOT MAPPED IN SSRD.  NO RULE NEEDS TO BE DEFINED FOR THIS
		-----------------------------------------------------------------------------------------------
		select @SQL = ''
		select @StagingValidationRuleId = -2 -- This is a global value for all rules related to "staging value not mapped in SSRD"

		IF OBJECT_ID(N'tempdb..#SSRDMappings') IS NOT NULL DROP TABLE #SSRDMappings

		select distinct vw.StagingColumnId, vw.StagingTableName, vw.StagingColumnName, vw.SSRDRefTableName, vw.SSRDTableFilter
		into #SSRDMappings 
		from #vwStagingRelationships vw
		where vw.SSRDRefTableName is not NULL

		while exists (select top 1 * from #SSRDMappings)
		begin

			select @StagingColumnId = (select top 1 StagingColumnId from #SSRDMappings)

			select 
				@TableName = StagingTableName,
				@ColumnName = StagingColumnName,
				@RefTableName = SSRDRefTableName,
				@TableFilter = SSRDTableFilter
			from #SSRDMappings
			where StagingColumnId = @StagingColumnId



			select @SQL_Part = 'FROM Staging.' + @TableName + ' T' + char(10)
			select @SQL_Part += 'LEFT JOIN Staging.SourceSystemReferenceData SSRD' + char(10)
			select @SQL_Part += '	ON SSRD.SchoolYear = ' + convert(varchar, @SchoolYear) + char(10) --T.SchoolYear' + char(10)
			select @SQL_Part += '		AND SSRD.InputCode = T.' + @ColumnName + char(10)		
			select @SQL_Part += '		AND SSRD.TableName = ''' + @RefTableName + '''' + char(10)
			if @TableFilter is not null
				begin
					select @SQL_Part += 	'		AND SSRD.TableFilter = ''' + @TableFilter + '''' + char(10)
				end
			select @SQL_Part += 'WHERE T.' + @ColumnName + ' is not null' + char(10)
			select @SQL_Part += 'AND SSRD.InputCode is null' + char(10)


			select @ShowRecordsSQL = 'SELECT *' + char(10)
			select @ShowRecordsSQL += @SQL_Part + char(10)



						select @SQL = 'declare @RecordCount int' + char(10)
						select @SQL += 'select @RecordCount = (select count(*) ' + char(10)
						select @SQL += @SQL_Part + char(10)
						select @SQL += ')' + char(10)

						select @SQL += 'if @RecordCount > 0' + char(10)
						select @SQL += '	begin' + char(10)
						select @SQL += '		insert into Staging.StagingValidationResults' + char(10)
						select @SQL += '		select ' + char(10)
						select @SQL += '		''' + convert(varchar, @StagingValidationRuleId) + ''', '
						select @SQL += '''' + convert(varchar, @SchoolYear) + ''','''
						select @SQL +=	isnull(@FactTypeOrReportCode, isnull(@FactType,'')) + ''', '
						select @SQL += '''' + @TableName + ''', '
						select @SQL += '''' + @ColumnName + ''', ' 
						select @SQL += '''' + @Severity_ERROR + ''', '
						select @SQL += '''' + @StagingValueNotMappedInSSRD + ''', '
						select @SQL += '@RecordCount, '
						select @SQL += '''' + replace(isnull(@ShowRecordsSQL,''),'''','''''') + ''', '
						select @SQL += '''' + convert(varchar, @InsertDate, 121) + '''' + char(10)
						select @SQL += '	end' + char(10)

			begin try
				if @PrintSQL = 1 
					begin
						select @StagingValidationRuleId RuleId, @SQL 'SQL'
					end
				else exec (@SQL)
			end try
			begin catch
				-- If a SQL ERROR happens due to bad @SQL formatting, log this and continue processing remaining rules
				select @ErrorMessage = ERROR_MESSAGE()	

				insert into Staging.StagingValidationResults
					select 
						-9					StagingValidationRuleId,
						@SchoolYear			SchoolYear,
						@FactTypeOrReportCode	FactTypeOrReportCode,
						@TableName			StagingTableName,
						@ColumnName			ColumnName,
						'Rule_Error'		Severity,
						@ErrorMessage		ValidationMessage,
						0					RecordCount,
						@SQL				ShowRecordsSQL,
						@InsertDate			InsertDate
			end catch

			delete from #SSRDMappings where StagingColumnId = @StagingColumnId

		end


		-----------------------------------------------------------------------------------------------
		-- VALIDATION TYPE: NULL VALUE (Column is required and cannot contain NULL value)
		-----------------------------------------------------------------------------------------------
		select @SQL = ''

		IF OBJECT_ID(N'tempdb..#RequiredColumns') IS NOT NULL DROP TABLE #RequiredColumns

		select distinct vsr.StagingValidationRuleId, vw.StagingTableName, vw.StagingColumnName 
		into #RequiredColumns 
		from #vwStagingRelationships vw
		inner join staging.vwStagingValidationRules vsr
			on (vw.GenerateReportId = vsr.GenerateReportId
			or vsr.GenerateReportId = -1) -- -1 means this rule applies to all reports
			and (vw.StagingTableId = vsr.StagingTableId or vsr.GenerateReportId = -1) -- -1 means this rule applies to all reports
			and	vw.StagingColumnId = vsr.StagingColumnId
		where vsr.Condition = 'Required' and vsr.Enabled_XREF = 1
		order by vsr.StagingValidationRuleId

	
		--select * from #RequiredColumns
		--return

		while exists (select top 1 * from #RequiredColumns)
		begin

			select @StagingValidationRuleId = (select top 1 StagingValidationRuleId from #RequiredColumns)

			select 
				@TableName = StagingTableName,
				@ColumnName = StagingColumnName
			from #RequiredColumns
			where StagingValidationRuleId = @StagingValidationRuleId

			select @ShowRecordsSQL = 'select * from Staging.' + @TableName + ' where ' + @ColumnName + ' is null or len(ltrim(rtrim(' + @ColumnName + '))) =  0' 

			select @SQL = 'declare @RecordCount int' + char(10)
			select @SQL += 'select @RecordCount = (select count(*) from Staging.' + @TableName + ' where ' + @ColumnName + ' is null or len(ltrim(rtrim(' + @ColumnName + '))) = 0)' + char(10)
			select @SQL += 'if @RecordCount > 0' + char(10)
			select @SQL += '	begin' + char(10)
			select @SQL += '		insert into Staging.StagingValidationResults' + char(10)
			select @SQL += '		select ' + char(10)
			select @SQL += '		''' + convert(varchar, @StagingValidationRuleId) + ''', '
			select @SQL += '''' + convert(varchar, @SchoolYear) + ''','''
			select @SQL +=	isnull(@FactTypeOrReportCode, isnull(@FactType,'')) + ''', '
			select @SQL += '''' + @TableName + ''', '
			select @SQL += '''' + @ColumnName + ''', ' 
			select @SQL += '''' + @Severity_Error + ''', '
			select @SQL += '''' + @NullValue  + ''', '
			select @SQL += '@RecordCount, '
			select @SQL += '''' + isnull(@ShowRecordsSQL,'') + ''', '
			select @SQL += '''' + convert(varchar, @InsertDate, 121) + '''' + char(10)
			select @SQL += '	end' + char(10)

			begin try
				if @PrintSQL = 1 
					begin
						select @StagingValidationRuleId RuleId, @SQL 'SQL'
					end
				else exec (@SQL)
			end try
			begin catch
				-- If a SQL ERROR happens due to bad @SQL formatting, log this and continue processing remaining rules
				select @ErrorMessage = ERROR_MESSAGE()	

				insert into Staging.StagingValidationResults
					select 
						-9					StagingValidationRuleId,
						@SchoolYear			SchoolYear,
						@FactTypeOrReportCode	FactTypeOrReportCode,
						@TableName			StagingTableName,
						@ColumnName			ColumnName,
						'Rule_Error'		Severity,
						@ErrorMessage		ValidationMessage,
						0					RecordCount,
						@SQL				ShowRecordsSQL,
						@InsertDate			InsertDate
			end catch

			delete from #RequiredColumns where StagingValidationRuleId = @StagingValidationRuleId

		end



		-----------------------------------------------------------------------------------------------
		-- VALIDATION TYPE: BAD VALUE (A defined condition in the Rules table is not met)
		-- BASED ON A PARTICULAR TABLE AND COLUMN
		-- For this rule type, the condition should start with "WHERE" because this rule could apply to 
		-- multiple tables.  Example: Requiring LEAIdentifierSeaAccountability crosses multiple tables.
		-----------------------------------------------------------------------------------------------
		select @SQL = ''

		IF OBJECT_ID(N'tempdb..#ConditionalRules') IS NOT NULL DROP TABLE #ConditionalRules
		select distinct vsr.StagingValidationRuleId, vw.StagingTableName, vw.StagingColumnName,
		vsr.RuleDscr, vsr.Condition, vsr.ValidationMessage, vsr.Severity
		into #ConditionalRules
		from #vwStagingRelationships vw
		inner join staging.vwStagingValidationRules vsr
			on (vw.GenerateReportId = vsr.GenerateReportId
			or vsr.GenerateReportId = -1) -- -1 means this rule applies to all reports
			and (vw.StagingTableId = vsr.StagingTableId or vsr.GenerateReportId = -1) -- -1 means this rule applies to all reports
			and	vw.StagingColumnId = vsr.StagingColumnId
		where vsr.Condition <> 'Required' and vsr.Enabled_XREF = 1 and vsr.Condition like 'where %'
		order by vsr.StagingValidationRuleId

		while exists (select top 1 * from #ConditionalRules)
		begin

			select @StagingValidationRuleId = (select top 1 StagingValidationRuleId from #ConditionalRules)

			select 
				@TableName = StagingTableName,
				@ColumnName = StagingColumnName,
				@Condition = Condition,
				@ValidationMessage = ValidationMessage,
				@Severity = Severity
			from #ConditionalRules
			where StagingValidationRuleId = @StagingValidationRuleId

			select @ShowRecordsSQL = 'select * from Staging.' + @TableName + char(10) + @Condition + char(10)

			select @SQL = 'declare @RecordCount int' + char(10)
			select @SQL = @SQL + 'select @RecordCount = (select count(*) from Staging.' + @TableName + ' ' + @Condition + ')' + char(10)
			select @SQL += 'if @RecordCount > 0' + char(10)
			select @SQL += '	begin' + char(10)
			select @SQL += '		insert into Staging.StagingValidationResults' + char(10)
			select @SQL += '		select ' + char(10)
			select @SQL += '		''' + convert(varchar, @StagingValidationRuleId) + ''', '
			select @SQL += '''' + convert(varchar, @SchoolYear) + ''','''
			select @SQL +=	isnull(@FactTypeOrReportCode, isnull(@FactType,'')) + ''', '
			select @SQL += '''' + @TableName + ''', '
			select @SQL += '''' + @ColumnName + ''', ' 
			select @SQL += '''' + @Severity_INFORMATIONAL + ''', '
			select @SQL += '''' + @BadValue + case when @ValidationMessage is not null then  ' - ' else '' end + isnull(@ValidationMessage,'')  + ''', '
			select @SQL += '@RecordCount, '
			select @SQL += '''' + replace(isnull(@ShowRecordsSQL,''),'''','''''') + ''', '
			select @SQL += '''' + convert(varchar, @InsertDate, 121) + '''' + char(10)
			select @SQL += '	end' + char(10)

			begin try
				if @PrintSQL = 1 
					begin
						select @StagingValidationRuleId RuleId, @SQL 'SQL'
					end
				else exec (@SQL)
			end try
			begin catch
				-- If a SQL ERROR happens due to bad @SQL formatting, log this and continue processing remaining rules
				select @ErrorMessage = ERROR_MESSAGE()	

				insert into Staging.StagingValidationResults
					select 
						-9					StagingValidationRuleId,
						@SchoolYear			SchoolYear,
						@FactTypeOrReportCode	FactTypeOrReportCode,
						@TableName			StagingTableName,
						@ColumnName			ColumnName,
						'Rule_Error'		Severity,
						@ErrorMessage		ValidationMessage,
						0					RecordCount,
						@SQL				ShowRecordsSQL,
						@InsertDate			InsertDate
			end catch

			delete from #ConditionalRules where StagingValidationRuleId = @StagingValidationRuleId

		end


		-----------------------------------------------------------------------------------------------
		-- VALIDATION TYPE: BAD VALUE (A defined condition in the Rules table is not met)
		-- COMPLEX CONDITION
		-- BASED ON A COMBINATION OF VALUES AND DEPENDENCIES
		-- For this rule type, the condition should start with "SELECT" to identify exact logic to be used
		-----------------------------------------------------------------------------------------------
		select @SQL = ''

		IF OBJECT_ID(N'tempdb..#ComplexConditionalRules') IS NOT NULL DROP TABLE #ComplexConditionalRules
		select distinct vsr.StagingValidationRuleId, vw.StagingTableName, vw.StagingColumnName,
		vsr.RuleDscr, vsr.Condition, vsr.ValidationMessage, vsr.Severity
		into #ComplexConditionalRules
		from #vwStagingRelationships vw
		inner join staging.vwStagingValidationRules vsr
			on (vw.GenerateReportId = vsr.GenerateReportId
			or vsr.GenerateReportId = -1) -- -1 means this rule applies to all reports
			and (vw.StagingTableId = vsr.StagingTableId or vsr.GenerateReportId = -1) -- -1 means this rule applies to all reports
			and	vw.StagingColumnId = vsr.StagingColumnId
		where vsr.Condition <> 'Required' and vsr.Enabled_XREF = 1 and vsr.Condition like ('select %')
		order by vsr.StagingValidationRuleId

		--select * from #vwstagingrelationships
		--select * from #ComplexConditionalRules
		--return

		while exists (select top 1 * from #ComplexConditionalRules)
		begin

			select @StagingValidationRuleId = (select top 1 StagingValidationRuleId from #ComplexConditionalRules)

			select 
				@TableName = StagingTableName,
				@ColumnName = StagingColumnName,
				@Condition = Condition,
				@ValidationMessage = ValidationMessage,
				@Severity = Severity
			from #ComplexConditionalRules
			where StagingValidationRuleId = @StagingValidationRuleId

			select @ShowRecordsSQL = 'select * from (' + @Condition + ') A' + char(10)

			select @SQL = 'declare @RecordCount int' + char(10)
			select @SQL = @SQL + 'select @RecordCount = (select count(*) from (' + @Condition + ') CONDITION )' + char(10)
			select @SQL += 'if @RecordCount > 0' + char(10)
			select @SQL += '	begin' + char(10)
			select @SQL += '		insert into Staging.StagingValidationResults' + char(10)
			select @SQL += '		select ' + char(10)
			select @SQL += '		''' + convert(varchar, @StagingValidationRuleId) + ''', '
			select @SQL += '''' + convert(varchar, @SchoolYear) + ''','''
			select @SQL +=	isnull(@FactTypeOrReportCode, isnull(@FactType,'')) + ''', '
			select @SQL += '''' + @TableName + ''', '
			select @SQL += '''' + @ColumnName + ''', ' 
			select @SQL += '''' + @Severity_INFORMATIONAL + ''', '
			select @SQL += '''' + @BadValue + case when @ValidationMessage is not null then  ' - ' else '' end + isnull(@ValidationMessage,'')  + ''', '
			select @SQL += '@RecordCount, '
			select @SQL += '''' + replace(isnull(@ShowRecordsSQL,''),'''','''''') + ''', '
			select @SQL += '''' + convert(varchar, @InsertDate, 121) + '''' + char(10)
			select @SQL += '	end' + char(10)

			begin try
				if @PrintSQL = 1 
					begin
						select @StagingValidationRuleId RuleId, @SQL 'SQL'
					end
				else exec (@SQL)
			end try
			begin catch
				-- If a SQL ERROR happens due to bad @SQL formatting, log this and continue processing remaining rules
				select @ErrorMessage = ERROR_MESSAGE()	

				insert into Staging.StagingValidationResults
					select 
						-9					StagingValidationRuleId,
						@SchoolYear			SchoolYear,
						@FactTypeOrReportCode	FactTypeOrReportCode,
						@TableName			StagingTableName,
						@ColumnName			ColumnName,
						'Rule_Error'		Severity,
						@ErrorMessage		ValidationMessage,
						0					RecordCount,
						@SQL				ShowRecordsSQL,
						@InsertDate			InsertDate
			end catch

			delete from #ComplexConditionalRules where StagingValidationRuleId = @StagingValidationRuleId

		end



END

