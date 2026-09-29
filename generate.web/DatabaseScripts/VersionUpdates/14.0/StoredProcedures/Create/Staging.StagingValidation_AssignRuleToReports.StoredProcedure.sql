create PROCEDURE [Staging].[StagingValidation_AssignRuleToReports]
	@StagingValidationRuleId int,
	@FactTypeOrReportCode varchar(200), 
	@CreatedBy varchar(50),
	@Enabled bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- SPLIT @ReportGroupOrCode into table rows -------------------------------------
	IF OBJECT_ID(N'tempdb..#ReportCodes') IS NOT NULL DROP TABLE #ReportCodes
	select * into #ReportCodes from dbo.fnSplit(@FactTypeOrReportCode, ',')


	IF OBJECT_ID(N'tempdb..#StagingRelationships') IS NOT NULL DROP TABLE #StagingRelationships
	create table #StagingRelationships (
		GenerateReportId int,
		ReportCode varchar(10)
		)


	-- INSERT INTO #StagingRelationships FOR MATCHING REPORT GROUPS OR REPORT CODES
		if @FactTypeOrReportCode = 'ALL'
			begin
				insert into #StagingRelationships
				select DISTINCT
					GenerateReportId,
					ReportCode
				from app.vwStagingRelationships
			end
		else
			begin
				insert into #StagingRelationships
				select DISTINCT
					GenerateReportId,
					ReportCode
				from app.vwStagingRelationships sr
				inner join #ReportCodes rc
					on sr.ReportCode = rc.item
					or sr.FactTypeCode = rc.item
			end

	-- INSERT RULES --------------------------------------------------------

	BEGIN TRY
		insert into Staging.StagingValidationRules_ReportsXREF
		select DISTINCT
			@StagingValidationRuleId,
			case 
				when @FactTypeOrReportCode = 'ALL' then -1 
				else sr.GenerateReportId
			end,
			@Enabled,
			@CreatedBy
		from #StagingRelationships sr
		left join Staging.StagingValidationRules_ReportsXREF x
			on x.StagingValidationRuleId = @StagingValidationRuleId
			and x.GenerateReportId = sr.GenerateReportId
		where x.StagingValidationRuleId is null
	END TRY
	BEGIN CATCH
		print 'INSERT OF RULE FAILED.  ' + ERROR_MESSAGE()
	END CATCH

END