CREATE PROCEDURE [Staging].[StagingValidation_GetResults]
	@SchoolYear int,
	@FactTypeOrReportCode varchar(50),
	@IncludeHistory bit = NULL
AS
BEGIN

	-- Verify @ReportGroupOrCodeParm is Valid
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

	if isnull(@IncludeHistory,0) = 1
		begin
			-- Return All Results for @ReportGroupOrCodeParm -----------------
			select * from Staging.StagingValidationResults 
			where SchoolYear = @SchoolYear and FactTypeOrReportCode  = @FactTypeOrReportCode 
			order by InsertDate, StagingTableName, ColumnName
		end
		else
		begin
			-- Return Latest Results for @ReportGroupOrCodeParm ---------------------------
			declare @LatestDate datetime = (select max(InsertDate) from Staging.StagingValidationResults where SchoolYear = @SchoolYear and FactTypeOrReportCode = @FactTypeOrReportCode)

			select * from Staging.StagingValidationResults 
			where SchoolYear = @SchoolYear and FactTypeOrReportCode  = @FactTypeOrReportCode and InsertDate = @LatestDate
			order by StagingTableName, ColumnName
			------------------------------------------------------------------------------
		end
END
