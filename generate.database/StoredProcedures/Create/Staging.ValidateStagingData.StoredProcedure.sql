CREATE PROCEDURE Staging.ValidateStagingData
	@SchoolYear int,
	@ReportGroupOrCodeParm varchar(50)
AS
BEGIN

	set NOCOUNT ON

	-- Verify @ReportGroupOrCodeParm is Valid
	if not exists (
		select top 1 * from App.vwReportCode_StagingTables 
		where ReportCode = @ReportGroupOrCodeParm or ReportGroup = @ReportGroupOrCodeParm)
		begin
			select '*** INVALID VALUE FOR @ReportGroupOrCodeParm.  VALID OPTIONS ARE:','' VALID_VALUES
			union
			select distinct 'Report Group', ReportGroup from App.vwReportCode_StagingTables
			union
			select distinct 'Report Code', ReportCode from App.vwReportCode_StagingTables
			order by 1

			return
		end


	declare 
		@Id int,
		@InsertDate datetime = getdate(), 
		@RecordCount int,
		@RuleCount int,
		@TableName varchar(100),
		@ColumnName varchar(100),
		@RefTableName varchar(100),
		@TableFilter varchar(10),
		@SQL varchar(max) = '',
		@ValidationType varchar(500),
		@Condition varchar(500),
		@ValidationMessage varchar(500),
		@Severity varchar(20),
		@LogMessage nvarchar(max),
		@ShowRecordsSQL varchar(max),
		@ReportGroup varchar(50),
		@ReportCode varchar(10),

		@NullValue varchar(20) = 'Null Value',
		@NoRecords varchar(20) = 'No Records',
		@BadValue varchar(20) = 'Bad Value',
		@OptionNotMapped varchar(25) = 'Option Not Mapped',
		@CEDSOptionMismatch varchar(25) = 'CEDS Option Mismatch',

		@TryCatchError tinyint = 0,
		@MigrationType int = (select DataMigrationTypeId from App.DataMigrationTypes where DataMigrationTypeCode = 'StagingValidation')

	-- INSERT INTO APP.DATAMIGRATIONHISTORIES
	select @LogMessage = 'Executing Staging Validation for ' 
	select @LogMessage = @LogMessage +  @ReportGroupOrCodeParm + ' - ' + convert(varchar, @SchoolYear)
	insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType




	-- This may be changed to retain history ------------------------
	--truncate table Staging.StagingValidationResults
	-----------------------------------------------------------------
		IF OBJECT_ID(N'tempdb..#Rules') IS NOT NULL DROP TABLE #Rules
	
		-- Get list of rules that apply to the ReportGroup or ReportCode passed in
		-- If the parameter passed in is a ReportCode, then also get rules for the associated ReportGroup
		-- Example: if 'C039' is passed in as a parameter, get all rules for C039 as well as all Directory rules for the tables used by C039
		select distinct ssvr.* 
		into #Rules
		from Staging.StagingValidationRules ssvr
		inner join App.vwReportCode_StagingTables v
			on ssvr.StagingTableName = v.StagingTableName
		where ssvr.ReportGroupOrCodes like '%' + @ReportGroupOrCodeParm + '%' 
		or (ssvr.ReportGroupOrCodes like '%' + (select distinct ReportGroup from App.vwReportCode_StagingTables where ReportCode = @ReportGroupOrCodeParm)  + '%'
		and v.ReportCode like '%' + @ReportGroupOrCodeParm + '%')
		or (ssvr.ReportGroupOrCodes in (select distinct ReportCode from App.vwReportCode_StagingTables where ReportGroup = @ReportGroupOrCodeParm)  )

		select @RuleCount = @@ROWCOUNT
		--select * from #Rules
		--return

	while exists (select top 1 * from #Rules)
	begin
		select @Id = (select top 1 StagingValidationRuleId from #Rules)
		select 
			@TableName = StagingTableName,
			@ColumnName = ColumnName,
			@ValidationType = ValidationType,
			@RefTableName = RefTableName,
			@TableFilter = TableFilter,
			@Condition = Condition,
			@ValidationMessage = ValidationMessage,
			@Severity = Severity,
			@ReportGroup = ReportGroupOrCodes
		from #Rules
		where StagingValidationRuleId = @Id
		-- Build and execute dynamic SQL
		if @ColumnName is null and @ValidationType <> @BadValue -- TABLE LEVEL VALIDATION
			begin
				select @SQL = 'if not exists(select top 1 * from staging.' + @TableName + ')' + char(10)
				select @SQL = @SQL + '	begin' + char(10)
				select @SQL = @SQL + '		insert into Staging.StagingValidationResults' + char(10)
				select @SQL = @SQL + '		select ''' + convert(varchar, @SchoolYear) + ''',''' 
				select @SQL = @SQL + isnull(@ReportGroupOrCodeParm, isnull(@ReportGroup,'')) + ''', ''' 
				select @SQL = @SQL + @TableName + ''', NULL, ''' + isnull(@Severity,'') + ''', ''' 
				select @SQL = @SQL + @NoRecords + case when @ValidationMessage is not null then  ' - ' else '' end 
				select @SQL = @SQL + isnull(@ValidationMessage,'') + ''', 0, NULL, ''' 
				select @SQL = @SQL + convert(varchar, @InsertDate, 121) + '''' + char(10)
				select @SQL = @SQL + ', ' + convert(varchar, @Id)
				select @SQL = @SQL + '	end'

				begin try
					exec (@SQL)
				end try
				begin catch
					select @TryCatchError = @TryCatchError + 1
					select @LogMessage = '*** STAGING VALIDATION TRY/CATCH ERROR ***' + char(10)
					select @LogMessage = @LogMessage + ERROR_MESSAGE()	+ char(10)
					select @LogMessage = @LogMessage + 'StagingValidateRuleId: ' + convert(varchar, @Id) + char(10)
					select @LogMessage = @LogMessage + 'SQL: ' + char(10) + @SQL

					insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType
				end catch
			end
		else -- COLUMN-LEVEL VALIDATION
			begin
				select @SQL = ''

				-- NULL VALUES ---------------------------------------------------------------------
				if @ValidationType = @NullValue
						begin
							select @ShowRecordsSQL = 'select * from Staging.' + @TableName + ' where ' + @ColumnName + ' is null' + char(10)

							select @SQL = 'declare @RecordCount int' + char(10)
							select @SQL = @SQL + 'select @RecordCount = (select count(*) from Staging.' + @TableName + ' where ' + @ColumnName + ' is null)' + char(10)
							select @SQL = @SQL + 'if @RecordCount > 0' + char(10)
							select @SQL = @SQL + '	begin' + char(10)
							select @SQL = @SQL + '		insert into Staging.StagingValidationResults' + char(10)
							select @SQL = @SQL + '		select ''' + convert(varchar, @SchoolYear) + ''',''' + isnull(@ReportGroupOrCodeParm, isnull(@ReportGroup,'')) + ''', ''' + @TableName + ''', ''' + @ColumnName + ''', ''' + isnull(@Severity,'') + ''', ''' + @NullValue + case when @ValidationMessage is not null then  ' - ' else '' end + isnull(@ValidationMessage,'') + ''', @RecordCount, ''' + isnull(@ShowRecordsSQL,'') + ''', ''' + convert(varchar, @InsertDate, 121) + ''',' + convert(varchar, @Id) + char(10)
							select @SQL = @SQL + '	end' + char(10)


							begin try
								exec (@SQL)
							end try
							begin catch
								select @TryCatchError = @TryCatchError + 1
								select @LogMessage = '*** STAGING VALIDATION TRY/CATCH ERROR ***' + char(10)
								select @LogMessage = @LogMessage + ERROR_MESSAGE()	+ char(10)
								select @LogMessage = @LogMessage + 'StagingValidateRuleId: ' + convert(varchar, @Id) + char(10)
								select @LogMessage = @LogMessage + 'SQL: ' + char(10) + @SQL

								insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType
							end catch
								end

				-- CONDITIONAL CHECKING FOR A BAD VALUE ---------------------------------------------------------------
				if @ValidationType = @BadValue 
					begin

						select @ShowRecordsSQL = 'select * from Staging.' + @TableName + char(10) + @Condition + char(10)
							
						select @SQL = 'declare @RecordCount int' + char(10)
						select @SQL = @SQL + 'select @RecordCount = (select count(*) from Staging.' + @TableName + ' ' + @Condition + ')' + char(10)
						select @SQL = @SQL + 'if @RecordCount > 0' + char(10)
						select @SQL = @SQL + '	begin' + char(10)
						select @SQL = @SQL + '		insert into Staging.StagingValidationResults' + char(10)
						select @SQL = @SQL + '		select ''' + convert(varchar, @SchoolYear) + ''',''' + isnull(@ReportGroupOrCodeParm, isnull(@ReportGroup,'')) + ''', ''' + @TableName + ''', ''' + isnull(@ColumnName,'') + ''', ''' + isnull(@Severity,'') + ''', ''' + @BadValue + case when @ValidationMessage is not null then  ' - ' else '' end + isnull(@ValidationMessage,'') + ''', @RecordCount, ''' + replace(isnull(@ShowRecordsSQL,''),'''','''''') + ''', ''' + convert(varchar, @InsertDate, 121) + ''',' + convert(varchar, @Id) + char(10)
						select @SQL = @SQL + '	end' + char(10)

						begin try
							exec (@SQL)
						end try
						begin catch
							select @TryCatchError = @TryCatchError + 1
							select @LogMessage = '*** STAGING VALIDATION TRY/CATCH ERROR ***' + char(10)
							select @LogMessage = @LogMessage + ERROR_MESSAGE()	+ char(10)
							select @LogMessage = @LogMessage + 'StagingValidateRuleId: ' + convert(varchar, @Id) + char(10)
							select @LogMessage = @LogMessage + 'SQL: ' + char(10) + @SQL

							insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType
						end catch
					end

				-- OPTION NOT MAPPED -------------------------------------------------------------------------------------------
				if @ValidationType = @OptionNotMapped
					begin	
					-- 1. Show counts of records where the column value doesn't match the defined InputCode in SourceSystemReferenceData
						select @ShowRecordsSQL = 'select ''''' + convert(varchar, @SchoolYear) + ''''' SchoolYear, ''''' 
						select @ShowRecordsSQL = @ShowRecordsSQL + @TableName + ''''' TableName,' + char(10) 
						select @ShowRecordsSQL = @ShowRecordsSQL + '	E.' + @ColumnName + ', ''''' 
						select @ShowRecordsSQL = @ShowRecordsSQL + @RefTableName + ''''' RefTableName, ''''' + isnull(@TableFilter,'NULL') + '''''' +  ' TableFilter, SSRD.InputCode, ' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'count(*) RecordCount' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'from Staging.' + @TableName + ' E' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'left join Staging.SourceSystemReferenceData SSRD' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	on SSRD.TableName = ''''' + @RefTableName +  '''''' + char(10)
						if @TableFilter is not null
							begin
								select @ShowRecordsSQL = @ShowRecordsSQL + '	and SSRD.TableFilter = ''''' + isnull(@TableFilter,'') + '''''' + char(10)
							end
						select @ShowRecordsSQL = @ShowRecordsSQL + '	and E.' + @ColumnName + ' = SSRD.InputCode' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	and SSRD.SchoolYear = ' + convert(varchar, @SchoolYear) + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'where E.' + @ColumnName + ' is not null' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	and SSRD.SourceSystemReferenceDataId is null and E.SchoolYear = ' + convert(varchar, @SchoolYear) + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'group by TableName,' + @ColumnName + ', TableName, TableFilter, InputCode' + char(10)

						select @SQL = 'declare @RecordCount int' + char(10)
						select @SQL = @SQL + 'select @RecordCount = (select count(*) from Staging.' + @TableName + ' E' + char(10)
						select @SQL = @SQL + 'left join Staging.SourceSystemReferenceData SSRD' + char(10)
						select @SQL = @SQL + '	on SSRD.TableName = ''' + @RefTableName + '''' + char(10)
						if @TableFilter is not null
							begin
								select @SQL = @SQL + '	and SSRD.TableFilter = ''' + isnull(@TableFilter,'') + '''' + char(10)
							end
						select @SQL = @SQL + '	and E.' + @ColumnName + ' = SSRD.InputCode' + char(10)
						select @SQL = @SQL + '	and SSRD.SchoolYear = ' + convert(varchar, @SchoolYear) + char(10)
						select @SQL = @SQL + 'where E.' + @ColumnName + ' is not null' + char(10)
						select @SQL = @SQL + '	and SSRD.SourceSystemReferenceDataId is null and E.SchoolYear = ' + convert(varchar, @SchoolYear) + ')' + char(10)

						select @SQL = @SQL + 'if @RecordCount > 0' + char(10)
						select @SQL = @SQL + '	begin' + char(10)
						select @SQL = @SQL + '		insert into Staging.StagingValidationResults' + char(10)
						select @SQL = @SQL + '		select ''' + convert(varchar, @SchoolYear) + ''',''' + isnull(@ReportGroupOrCodeParm, isnull(@ReportGroup,'')) + ''', ''' + @TableName + ''', ''' + @ColumnName + ''', ''' + isnull(@Severity,'') + ''', ''' + @OptionNotMapped + case when @ValidationMessage is not null then  ' - ' else '' end + isnull(@ValidationMessage,'') + ''', @RecordCount, ''' + isnull(@ShowRecordsSQL,'') + ''', ''' + convert(varchar, @InsertDate, 121) + ''',' + convert(varchar, @Id) + char(10)
						select @SQL = @SQL + '	end'

						begin try
							exec (@SQL)
						end try
						begin catch
							select @TryCatchError = @TryCatchError + 1
							select @LogMessage = '*** STAGING VALIDATION TRY/CATCH ERROR ***' + char(10)
							select @LogMessage = @LogMessage + ERROR_MESSAGE()	+ char(10)
							select @LogMessage = @LogMessage + 'StagingValidateRuleId: ' + convert(varchar, @Id) + char(10)
							select @LogMessage = @LogMessage + 'SQL: ' + char(10) + @SQL

							insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType
						end catch
				
					-- 2. Show which columns have a missing or undefined CEDS value as the Output code in SourceSystemReferenceData
					-- NEED TO ADD BETTER HANDLING FOR TABLE FILTER VALUES (GRADE LEVEL, OPERATIONAL STATUS) BECAUSE NOT ALL VALUES APPLY BASED ON TABLE FILTER
						select @ShowRecordsSQL = 'select R.' + @RefTableName + 'Id, R.Description CEDSDescription, R.Code CEDSCode, R.Definition CEDSDefinition,' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	SSRD.SourceSystemReferenceDataId, SSRD.SchoolYear, SSRD.TableName, SSRD.TableFilter,' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	SSRD.InputCode, SSRD.OutputCode IncorrectOrMissingCEDSValueInSourceSystemReferenceData' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'from dbo.' + @RefTableName + ' R' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'left join Staging.SourceSystemReferenceData SSRD' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	on R.Code = SSRD.OutputCode' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	and SSRD.TableName = ' + '''''' + @RefTableName + '''''' + char(10)
						if @TableFilter is not null
							begin
								select @ShowRecordsSQL = @ShowRecordsSQL + '	and SSRD.TableFilter = ''''' + isnull(@TableFilter,'') + '''''' + char(10)
							end
						select @ShowRecordsSQL = @ShowRecordsSQL + 'WHERE SSRD.OutputCode is NULL' + char(10)

						select @ShowRecordsSQL = @ShowRecordsSQL + 'UNION' + char(10)

						select @ShowRecordsSQL = @ShowRecordsSQL + 'SELECT R.' + @RefTableName + 'Id, R.Description CEDSDescription, R.Code CEDSCode, R.Definition CEDSDefinition,' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	SSRD.SourceSystemReferenceDataId, SSRD.SchoolYear, SSRD.TableName, SSRD.TableFilter,' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	SSRD.InputCode, SSRD.OutputCode IncorrectOrMissingCEDSValueInSourceSystemReferenceData' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'FROM Staging.SourceSystemReferenceData SSRD' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'LEFT JOIN dbo.' + @RefTableName + ' R' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + '	ON R.Code = SSRD.OutputCode' + char(10)
						select @ShowRecordsSQL = @ShowRecordsSQL + 'WHERE SSRD.TableName = ' + '''''' + @RefTableName + '''''' + char(10)
						if @TableFilter is not null
							begin
								select @ShowRecordsSQL = @ShowRecordsSQL + '	and SSRD.TableFilter = ''''' + isnull(@TableFilter,'') + '''''' + char(10)
							end
						select @ShowRecordsSQL = @ShowRecordsSQL + '	and R.Code is NULL' + char(10)


						select @SQL = 'declare @RecordCount int' + char(10)
						select @SQL = @SQL + 'select @RecordCount = (select count(*) from (' + char(10)

						--select @SQL = @SQL + @ShowRecordsSQL + char(10)
						------------------------------------------------------------------------------------------------------------------------------------------------------------------
										select @SQL = @SQL + 'select R.' + @RefTableName + 'Id, R.Description CEDSDescription, R.Code CEDSCode, R.Definition CEDSDefinition,' + char(10)
										select @SQL = @SQL + '	SSRD.SourceSystemReferenceDataId, SSRD.SchoolYear, SSRD.TableName, SSRD.TableFilter,' + char(10)
										select @SQL = @SQL + '	SSRD.InputCode, SSRD.OutputCode IncorrectOrMissingCEDSValueInSourceSystemReferenceData' + char(10)
										select @SQL = @SQL + 'from dbo.' + @RefTableName + ' R' + char(10)
										select @SQL = @SQL + 'left join Staging.SourceSystemReferenceData SSRD' + char(10)
										select @SQL = @SQL + '	on R.Code = SSRD.OutputCode' + char(10)
										select @SQL = @SQL + '	and SSRD.TableName = ' + '''' + @RefTableName + '''' + char(10) -- This line is different from @ShowRecordsSQL
										if @TableFilter is not null
											begin
												select @SQL = @SQL + '	and SSRD.TableFilter = ''' + isnull(@TableFilter,'') + '''' + char(10)
											end
										select @SQL = @SQL + 'WHERE SSRD.OutputCode is NULL' + char(10)

										select @SQL = @SQL + 'UNION' + char(10)

										select @SQL = @SQL + 'SELECT R.' + @RefTableName + 'Id, R.Description CEDSDescription, R.Code CEDSCode, R.Definition CEDSDefinition,' + char(10)
										select @SQL = @SQL + '	SSRD.SourceSystemReferenceDataId, SSRD.SchoolYear, SSRD.TableName, SSRD.TableFilter,' + char(10)
										select @SQL = @SQL + '	SSRD.InputCode, SSRD.OutputCode IncorrectOrMissingCEDSValueInSourceSystemReferenceData' + char(10)
										select @SQL = @SQL + 'FROM Staging.SourceSystemReferenceData SSRD' + char(10)
										select @SQL = @SQL + 'LEFT JOIN dbo.' + @RefTableName + ' R' + char(10)
										select @SQL = @SQL + '	ON R.Code = SSRD.OutputCode' + char(10)
										select @SQL = @SQL + 'WHERE SSRD.TableName = ' + '''' + @RefTableName + '''' + char(10) -- This line is different from @ShowRecordsSQL
										if @TableFilter is not null
											begin
												select @SQL = @SQL + '	and SSRD.TableFilter = ''' + isnull(@TableFilter,'') + '''' + char(10)
											end
										select @SQL = @SQL + '	and R.Code is NULL' + char(10)
						------------------------------------------------------------------------------------------------------------------------------------------------------------------
					
						select @SQL = @SQL + ') Z )' + char(10)

						select @SQL = @SQL + 'if @RecordCount > 0' + char(10)
						select @SQL = @SQL + '	begin' + char(10)
						select @SQL = @SQL + '		insert into Staging.StagingValidationResults' + char(10)
						select @SQL = @SQL + '		select ''' + convert(varchar, @SchoolYear) + ''',''' + isnull(@ReportGroupOrCodeParm, isnull(@ReportGroup,'')) + ''', ''' + @TableName + ''', ''' + @ColumnName + ''', '''
						select @SQL = @SQL +		isnull(@Severity,'') + ''', ''' + @CEDSOptionMismatch + case when @ValidationMessage is not null then  ' - ' else '' end + isnull(@ValidationMessage,'') + ''', @RecordCount, ' + char(10)
						select @SQL = @SQL +		+ '''' + isnull(@ShowRecordsSQL,'') + ''', ' + char(10) -- Need to do something to add extra quotes around RefTableName value 

						select @SQL = @SQL +		'''' + convert(varchar, @InsertDate, 121) + '''' + char(10)
						select @SQL = @SQL + ', ' + convert(varchar, @Id)
						select @SQL = @SQL + '	end'

						begin try
							exec (@SQL)
						end try
						begin catch
							select @TryCatchError = @TryCatchError + 1
							select @LogMessage = '*** STAGING VALIDATION TRY/CATCH ERROR ***' + char(10)
							select @LogMessage = @LogMessage + ERROR_MESSAGE()	+ char(10)
							select @LogMessage = @LogMessage + 'StagingValidateRuleId: ' + convert(varchar, @Id) + char(10)
							select @LogMessage = @LogMessage + 'SQL: ' + char(10) + @SQL

							insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType
						end catch
					end
			end

		delete from #Rules 
		where StagingValidationRuleId = @Id
	end

	-- INSERT INTO APP.DATAMIGRATIONHISTORIES
	select @LogMessage = convert(varchar, @RuleCount - @TryCatchError) + ' of ' + convert(varchar, @RuleCount) + ' staging validation rules executed for ' 
	select @LogMessage = @LogMessage + @ReportGroupOrCodeParm + ' - ' + convert(varchar, @SchoolYear)
	insert into App.DataMigrationHistories select getdate(), @LogMessage, @MigrationType


	if @TryCatchError <> 0
		begin
			PRINT 'Staging validation completed, but ' + convert(varchar, @TryCatchError) +
				case when @TryCatchError = 1 then ' error ' else 'errors ' end +
			'did not execute due to errors in the rules.'
			PRINT 'Please query table App.DataMigrationHistories where DataMigrationTypeId= ' + convert(varchar, @MigrationType) + ' for more information'
		end

END
