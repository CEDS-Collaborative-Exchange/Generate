-- =============================================
-- Author: AEM
-- Create date: 2022-07-08
-- Description:	This proc will execute a series of App metadata rollovers. 
--		All GenerateReports will be rolled over from their earliest 
--		instance into the next year and so on through the year specified as @targetSubmissionYear 
-- =============================================
CREATE PROCEDURE [App].[Rollover_All_Metadata_up_to_SchoolYear]
	@targetSubmissionYear int
AS
BEGIN

	set nocount on
	BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @schoolYear int
			,@schoolYear2 int
			,@strSchoolYear varchar(5)
			,@strSchoolYear2 varchar(5)
			,@reportCode varchar(50)

		IF @targetSubmissionYear IS NULL
			SELECT @targetSubmissionYear = GenerateConfigurationValue
			FROM App.GenerateConfigurations
			WHERE GenerateConfigurationKey = 'SchoolYear'

		/*Find last valid version of each file spec*/
		--use existence of CategorySet in SubmissionYear as indicator of metadata existence

		--#mdExists contains a list of SubmissionYears for which a ReportCode has existing metadata
		SELECT DISTINCT acs.SubmissionYear,agr.ReportCode
		INTO #mdExists
		FROM App.GenerateReports agr
			INNER JOIN [App].[CategorySets] acs 
			ON agr.GenerateReportId = acs.GenerateReportId

		;WITH syRange AS (
			--syRange lists every ReportCode in Generate with every year since 2014
			SELECT sy.SchoolYear,x.ReportCode
			FROM rds.DimSchoolYears sy
			CROSS JOIN (SELECT DISTINCT ReportCode FROM App.GenerateReports) x
			WHERE sy.SchoolYear BETWEEN 2014 AND @targetSubmissionYear
		)
		--#absentMetadata contains the SchoolYears in which each ReportCode is not implemented
		SELECT syRange.SchoolYear,syRange.ReportCode
		INTO #absentMetadata
		FROM syRange
		LEFT JOIN #mdExists mdExists
			ON syRange.SchoolYear = mdExists.SubmissionYear
			AND syRange.ReportCode = mdExists.ReportCode
		WHERE mdExists.SubmissionYear IS NULL
		ORDER BY syRange.ReportCode,syRange.SchoolYear


		--We only want to rollover data from one year into the next. If a report was added in 2019, we don't need to roll metadata into 2015
		--So, I'm only going to rollover reports that are already implemented in an earlier year

		DECLARE csy CURSOR FOR
			SELECT distinct am.ReportCode,am.SchoolYear - 1, am.SchoolYear
			FROM #absentMetadata am
			INNER JOIN #mdExists me
				ON am.ReportCode = me.ReportCode
			WHERE me.SubmissionYear < am.SchoolYear
			ORDER BY am.ReportCode,am.SchoolYear

		SET @reportCode = NULL

		OPEN csy

		FETCH NEXT FROM csy INTO @reportCode,@schoolYear,@schoolYear2

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @strSchoolYear = cast(@schoolYear as varchar(5)) 

			SET @strSchoolYear2 = cast(@schoolYear2 as varchar(5))

			print '@reportCode = ' + @reportCode + '; @schoolYear = ' + @strSchoolYear + '; @schoolYear2 = ' + @strSchoolYear2
	
			EXEC App.Rollover_Previous_Year_Metadata @reportCode , @strSchoolYear , @strSchoolYear2
		
			FETCH NEXT FROM csy INTO @reportCode,@schoolYear,@schoolYear2

		END

		CLOSE csy
		DEALLOCATE csy

		DROP TABLE #absentMetadata
		DROP TABLE #mdExists

	COMMIT TRANSACTION

	END TRY
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
set nocount off
END


