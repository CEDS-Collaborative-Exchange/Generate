CREATE PROCEDURE [Staging].[StagingValidation_InsertRule]
	@FactTypeOrReportCode varchar(200), 
	@StagingTableName varchar(200),
	@StagingColumnName varchar (200),
	@RuleDscr varchar(max),
	@Condition varchar(max),
	@ValidationMessage varchar(2000) = NULL,
	--@Severity varchar(50),
	@CreatedBy varchar(50),
	@Enabled bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @StagingValidationRuleId int

	-- Set the Severity Level
	-- If a column is REQUIRED to contain a value, then set severity to ERROR for this rule.
	-- For any other conditions, set the severity to INFORMATIONAL
	declare @Severity varchar(50)
	if @Condition = 'Required' set @Severity = 'Error' else set @Severity = 'Informational'




-- SPLIT @ReportGroupOrCode into table rows -------------------------------------
	IF OBJECT_ID(N'tempdb..#ReportCodes') IS NOT NULL DROP TABLE #ReportCodes
	select * into #ReportCodes from dbo.fnSplit(@FactTypeOrReportCode, ',')
	update #ReportCodes set item = replace(item,'FS','C') -- do this in case they pass in 'FS' for report code rather than 'C'


	IF OBJECT_ID(N'tempdb..#StagingRelationships') IS NOT NULL DROP TABLE #StagingRelationships
	create table #StagingRelationships (
		GenerateReportId int,
		ReportCode varchar(10),
		ReportGroup varchar(50),
		StagingTableId int,
		StagingTableName varchar(100),
		StagingColumnId int,
		StagingColumnName varchar(100)
		)


	-- INSERT INTO #StagingRelationships FOR MATCHING REPORT GROUPS OR REPORT CODES
		if @FactTypeOrReportCode = 'ALL'
			begin
				insert into #StagingRelationships
				select DISTINCT
					GenerateReportId,
					ReportCode,
					FactTypeCode,
					StagingTableId,6
					StagingTableName,
					StagingColumnId,
					StagingColumnName
				from app.vwStagingRelationships
				where 
					StagingTableName = @StagingTableName
					and StagingColumnName = @StagingColumnName
			end
		else
			begin
				insert into #StagingRelationships
				select DISTINCT
					GenerateReportId,
					ReportCode,
					FactTypeCode,
					StagingTableId,
					StagingTableName,
					StagingColumnId,
					StagingColumnName
				from app.vwStagingRelationships sr
				inner join #ReportCodes rc
					on sr.ReportCode = rc.item
					or sr.FactTypeCode = rc.item
				where 
					StagingTableName = @StagingTableName
					and StagingColumnName = @StagingColumnName
			end

	-- INSERT RULES --------------------------------------------------------

	BEGIN TRY
		insert into Staging.StagingValidationRules
		select DISTINCT
			sr.StagingTableId,
			sr.StagingColumnId,
			@RuleDscr,
			@Condition,
			@ValidationMessage,
			@Severity,
			@CreatedBy
		from #StagingRelationships sr
		left join Staging.StagingValidationRules svr
			on sr.StagingTableId = svr.StagingTableId
			and sr.StagingColumnId = svr.StagingColumnId
			and @Condition = svr.Condition
		where svr.StagingValidationRuleId is null

		select @StagingValidationRuleId = @@IDENTITY

		if @StagingValidationRuleId is not NULL
			begin
				insert into Staging.StagingValidationRules_ReportsXREF
				select DISTINCT
					@StagingValidationRuleId,
					case 
						when @FactTypeOrReportCode = 'ALL' then -1 
						else GenerateReportId
					end,
					@Enabled,
					@CreatedBy
				from #StagingRelationships
			end
	END TRY
	BEGIN CATCH
		print 'INSERT OF RULE FAILED.  ' + ERROR_MESSAGE()
	END CATCH

END
