CREATE PROCEDURE [Staging].[ValidateStagingData_GetResults]
	@SchoolYear int,
	@ReportGroupOrCodeParm varchar(50),
	@IncludeHistory bit = NULL
AS
BEGIN

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

	if isnull(@IncludeHistory,0) = 1
		begin
			-- Return All Results for @ReportGroupOrCodeParm -----------------
			select * from Staging.StagingValidationResults 
			where SchoolYear = @SchoolYear and ReportGroupOrCode = @ReportGroupOrCodeParm 
			order by InsertDate, StagingTableName, ColumnName
		end
		else
		begin
			-- Return Latest Results for @ReportGroupOrCodeParm ---------------------------
			declare @LatestDate datetime = (select max(InsertDate) from Staging.StagingValidationResults where SchoolYear = @SchoolYear and ReportGroupOrCode = @ReportGroupOrCodeParm)

			select * from Staging.StagingValidationResults 
			where SchoolYear = @SchoolYear and ReportGroupOrCode = @ReportGroupOrCodeParm and InsertDate = @LatestDate
			order by StagingTableName, ColumnName
			------------------------------------------------------------------------------
		end
END
