CREATE PROCEDURE [Staging].[StagingValidation_GetResults]
	@SchoolYear int,
	@ReportGroupOrCode varchar(50),
	@IncludeHistory bit = NULL
AS
BEGIN

	-- Verify @ReportGroupOrCodeParm is Valid
	if not exists (
		select top 1 * from App.vwReportCode_StagingTables 
		where ReportCode = @ReportGroupOrCode or ReportGroup = @ReportGroupOrCode)
		begin
			select '*** INVALID VALUE FOR @ReportGroupOrCode.  VALID OPTIONS ARE:','' VALID_VALUES
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
			where SchoolYear = @SchoolYear and ReportGroupOrCode = @ReportGroupOrCode 
			order by InsertDate, StagingTableName, ColumnName
		end
		else
		begin
			-- Return Latest Results for @ReportGroupOrCodeParm ---------------------------
			declare @LatestDate datetime = (select max(InsertDate) from Staging.StagingValidationResults where SchoolYear = @SchoolYear and ReportGroupOrCode = @ReportGroupOrCode)

			select * from Staging.StagingValidationResults 
			where SchoolYear = @SchoolYear and ReportGroupOrCode = @ReportGroupOrCode and InsertDate = @LatestDate
			order by StagingTableName, ColumnName
			------------------------------------------------------------------------------
		end
END
