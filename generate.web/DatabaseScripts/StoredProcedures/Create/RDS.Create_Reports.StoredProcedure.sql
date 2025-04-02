CREATE PROCEDURE [RDS].[Create_Reports]
	@factTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

begin try

	declare @dataMigrationTypeId as int, @factTypeId as int

	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'report'

	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	--Get the SchoolYear
	declare @SchoolYear as int
	select @Schoolyear = (
		select max(SchoolYear)
		from rds.DimSchoolYears d 
		inner join rds.DimSchoolYearDataMigrationTypes dd 
			on dd.DimSchoolYearId = d.DimSchoolYearId 
			and dd.IsSelected = 1 
			and dd.DataMigrationTypeId = 3
	)

	-- Refresh all directory data
	--exec Staging.[Staging-to-DimSeas] NULL, NULL, 0
	--exec Staging.[Staging-to-DimLeas] NULL, NULL, 0
	--exec Staging.[Staging-to-DimK12Schools] NULL, 0

	if @factTypeCode = 'datapopulation' 
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentcount' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentcount')			

				exec [RDS].[Create_ReportData]	@reportCode = 'studentcount', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentsex' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentsex')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentsex', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentdisability' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentdisability')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentdisability',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentrace' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentrace')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentrace', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentsubpopulation' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentsubpopulation')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentsubpopulation', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'childcount'
		begin

			--exec Staging.[Staging-to-DimK12Students] NULL
			--exec Staging.[Staging-to-FactK12StudentCounts_ChildCount]

			if exists (select 'c' from app.GenerateReports where ReportCode = '002' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 002')

				exec [RDS].[Create_ReportData]	@reportCode = '002', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '089' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 089')

				exec [RDS].[Create_ReportData]	@reportCode = '089', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'yeartoyearenvironmentcount' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Reports - Year To Year Environment Count Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearenvironmentcount', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'yeartoyearchildcount' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - Year To Year Child Count Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearchildcount', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'yeartoyearremovalcount' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - Year To Year Students Removal Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearremovalcount', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentssummary' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - LEA Students Summary Profile')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentssummary', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
	
		end
		if @factTypeCode = 'exiting'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '009' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 009')

				exec [RDS].[Create_ReportData]	@reportCode = '009', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'exitspecialeducation' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - exitspecialeducation')

				exec [RDS].[Create_ReportData]	@reportCode = 'exitspecialeducation', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'yeartoyearexitcount' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - Year To Year Exit Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearexitcount', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'cte'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '082' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 082')

				exec [RDS].[Create_ReportData]	@reportCode = '082', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '083' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 083')

				exec [RDS].[Create_ReportData]	@reportCode = '083', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '154' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 154')

				exec [RDS].[Create_ReportData]	@reportCode = '154', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '155' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 155')

				exec [RDS].[Create_ReportData]	@reportCode = '155', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '156' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 156')

				exec [RDS].[Create_ReportData]	@reportCode = '156', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
	
			if exists (select 'c' from app.GenerateReports where ReportCode = '158' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 158')

				exec [RDS].[Create_ReportData]	@reportCode = '158', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
			
			if exists (select 'c' from app.GenerateReports where ReportCode = '169' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 169')

				exec [RDS].[Create_ReportData]	@reportCode = '169', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '132' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history 
		
				-- This code is here because 132 uses FactStudentCounts and the table is not populated 
				--				  when Migrate_OrganizationCounts run
		
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '132 - Section 1003 Funds')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '132', @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'membership'
		begin
			
			if exists (select 'c' from app.GenerateReports where ReportCode = '052' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				---- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 052')

				exec [RDS].[Create_ReportData]	@reportCode = '052', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '033' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 033')

				exec [RDS].[Create_ReportData]	@reportCode = '033', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest

			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '226' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 226')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '226',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'dropout'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = '032' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 032')

				exec [RDS].[Create_ReportData]	@reportCode = '032', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'graduatescompleters'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = '040' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 040')

				exec [RDS].[Create_ReportData]	@reportCode = '040', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '045' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 045')

				exec [RDS].[Create_ReportData]	@reportCode = '045', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'cohortgraduationrate' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				---- Log history

				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - cohortgraduationrate')

				exec [RDS].[Create_CustomReportData]	@reportCode = 'cohortgraduationrate', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'sppapr'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = 'indicator9' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator9')

				exec [RDS].[Create_ReportData]	@reportCode = 'indicator9', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'indicator10' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator10')

				exec [RDS].[Create_ReportData]	@reportCode = 'indicator10', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'titleIIIELOct'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = '141' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 141')

				exec [RDS].[Create_ReportData]	@reportCode = '141',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'titleIIIELSY'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '116' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 116')

				exec [RDS].[Create_ReportData]	@reportCode = '116', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '045' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 045')

				exec [RDS].[Create_ReportData]	@reportCode = '045', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			-- This report is retired --
			--if exists (select 'c' from app.GenerateReports where ReportCode = '204' and IsLocked = 1 and UseLegacyReportMigration = 1)
--            begin			
			--    -- Log history
			--    insert into app.DataMigrationHistories
			--    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 204')

			--    exec [RDS].[Create_ReportData]	@reportCode = '204', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
--            end
		end
		if @factTypeCode = 'titleI'
		begin
		
			if exists (select 'c' from app.GenerateReports where ReportCode = '037' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 037')

				exec [RDS].[Create_ReportData]	@reportCode = '037', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '134' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 134')

				exec [RDS].[Create_ReportData]	@reportCode = '134', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '222' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 222')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '222',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentswdtitle1' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentswdtitle1')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentswdtitle1', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'migranteducationprogram'
		begin
				if exists (select 'c' from app.GenerateReports where ReportCode = '054' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 054')

				exec [RDS].[Create_ReportData]	@reportCode = '054', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '121' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 121')

				exec [RDS].[Create_ReportData]	@reportCode = '121', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '122' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 122')

				exec [RDS].[Create_ReportData]	@reportCode = '122', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

				if exists (select 'c' from app.GenerateReports where ReportCode = '145' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 145')

				exec [RDS].[Create_ReportData]	@reportCode = '145', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'immigrant'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = '165' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 165')

				exec [RDS].[Create_ReportData]	@reportCode = '165', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'neglectedordelinquent'
		begin
		
			if exists (select 'c' from app.GenerateReports where ReportCode = '119' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 119')

				exec [RDS].[Create_ReportData]	@reportCode = '119', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '127' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 127')

				exec [RDS].[Create_ReportData]	@reportCode = '127', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '218' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 218')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '218',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '219' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 219')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '219',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '220' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 220')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '220',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '221' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 221')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '221',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'homeless'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '118' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 118')

				exec [RDS].[Create_ReportData]	@reportCode = '118', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '194' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 194')

				exec [RDS].[Create_ReportData]	@reportCode = '194', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		
		end
		if @factTypeCode = 'chronic'
		begin
				if exists (select 'c' from app.GenerateReports where ReportCode = '195' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 195')

				exec [RDS].[Create_ReportData]	@reportCode = '195', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest	
			end
		end
		if @factTypeCode = 'graduationrate'
		begin
				if exists (select 'c' from app.GenerateReports where ReportCode = '150' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 150')

				exec [RDS].[Create_ReportData]	@reportCode = '150', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '151' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 151')

				exec [RDS].[Create_ReportData]	@reportCode = '151', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'hsgradpsenroll'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = '160' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 160')

				exec [RDS].[Create_ReportData]	@reportCode = '160',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'other'
		begin
				if exists (select 'c' from app.GenerateReports where ReportCode = 'studentfederalprogramsparticipation' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - studentfederalprogramsparticipation')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentfederalprogramsparticipation',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest

				exec RDS.Create_StudentFederalProgramsReportData @reportCode = 'studentfederalprogramsparticipation',@factTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentmultifedprogsparticipation' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - studentmultifedprogsparticipation')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentmultifedprogsparticipation', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest

				exec RDS.Create_StudentFederalProgramsReportData @reportCode = 'studentmultifedprogsparticipation',@factTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end


			if exists (select 'c' from app.GenerateReports where ReportCode = 'edenvironmentdisabilitiesage3-5' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - edenvironmentdisabilitiesage3-5')

				exec [RDS].[Create_ReportData]	@reportCode = 'edenvironmentdisabilitiesage3-5', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'edenvironmentdisabilitiesage6-21' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - edenvironmentdisabilitiesage6-21')

				exec [RDS].[Create_ReportData]	@reportCode = 'edenvironmentdisabilitiesage6-21', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end


		
		end
		if @factTypeCode = 'discipline' 
		begin

						
			if exists (select 'c' from app.GenerateReports where ReportCode = 'studentdiscipline' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentdiscipline')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentdiscipline', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '005' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 005')

				exec [RDS].[Create_ReportData]	@reportCode = '005',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '006' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 006')

				exec [RDS].[Create_ReportData]	@reportCode = '006', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
	
			if exists (select 'c' from app.GenerateReports where ReportCode = '007' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 007')

				exec [RDS].[Create_ReportData]	@reportCode = '007', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '086' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 086')

				exec [RDS].[Create_ReportData]	@reportCode = '086', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '088' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 088')

				exec [RDS].[Create_ReportData]	@reportCode = '088', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '143' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 143')

				exec [RDS].[Create_ReportData]	@reportCode = '143', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '144' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 144')

				exec [RDS].[Create_ReportData]	@reportCode = '144', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'indicator4a' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator4a')

				exec [RDS].[Create_CustomReportData] @reportCode = 'indicator4a', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'indicator4b' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator4b')

				exec [RDS].[Create_CustomReportData] @reportCode = 'indicator4b', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'disciplinaryremovals' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Reports - Disciplinary Removals')

				exec [RDS].[Create_ReportData] @reportCode = 'disciplinaryremovals', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'assessment'
		begin
			if exists (select 'c' from app.GenerateReports where ReportCode = '113' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 113')

				exec [RDS].[Create_ReportData]	@reportCode = '113', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '125' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 125')

				exec [RDS].[Create_ReportData]	@reportCode = '125', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '126' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 126')

				exec [RDS].[Create_ReportData]	@reportCode = '126', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '139' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 139')

				exec [RDS].[Create_ReportData]	@reportCode = '139', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '175' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 175')

				exec [RDS].[Create_ReportData]	@reportCode = '175', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '178' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 178')

				exec [RDS].[Create_ReportData]	@reportCode = '178', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '179' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 179')

				exec [RDS].[Create_ReportData]	@reportCode = '179', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '185' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 185')

				exec [RDS].[Create_ReportData]	@reportCode = '185', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '188' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 188')

				exec [RDS].[Create_ReportData]	@reportCode = '188', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '189' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 189')

				exec [RDS].[Create_ReportData]	@reportCode = '189',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '138' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 138')

				exec [RDS].[Create_ReportData]	@reportCode = '138',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '137' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 137')

				exec [RDS].[Create_ReportData]	@reportCode = '137', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '050' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 050')

				exec [RDS].[Create_ReportData]	@reportCode = '050', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '142' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 142')

				exec [RDS].[Create_ReportData]	@reportCode = '142', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '157' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 157')

				exec [RDS].[Create_ReportData]	@reportCode = '157', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '224' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 224')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '224',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '225' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 225')

				exec [RDS].[Insert_CountsIntoReportTable]
						@ReportCode  = '225',
						@SubmissionYear = @SchoolYear, 
						@IdentifierToCount = 'K12StudentStudentIdentifierState',
						@IsDistinctCount  = 1,
						@RunAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'stateassessmentsperformance' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Reports - stateassessmentsperformance')

				exec [RDS].[Create_ReportData]	@reportCode = 'stateassessmentsperformance', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'yeartoyearprogress' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Reports - yeartoyearprogress')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearprogress', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'yeartoyearattendance' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Reports - yeartoyearattendance')

				exec [RDS].[Create_YeartoYearAttendanceReportData]	@reportCode = 'yeartoyearattendance', @factTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end
		end
		if @factTypeCode = 'staff'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '070' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 070')

				exec [RDS].[Create_ReportData]	@reportCode = '070', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '099' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 099')

				exec [RDS].[Create_ReportData]	@reportCode = '099', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '112' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 112')

				exec [RDS].[Create_ReportData]	@reportCode = '112', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '059' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 059')

				exec [RDS].[Create_ReportData]	@reportCode = '059', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '067' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 067')

				exec [RDS].[Create_ReportData]	@reportCode = '067', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '203' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - 203')

				exec [RDS].[Create_ReportData]	@reportCode = '203', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'directory'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '029' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '029 - Organization data')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '029', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '039' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '039 - Organization Grade level data')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '039', @runAsTest = @runAsTest
			end


			if exists (select 'c' from app.GenerateReports where ReportCode = '129' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '129 - CCD School data')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '129', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '130' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '130 - ESEA Status')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '130', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '193' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '193 - Title I Allocations')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '193', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '190' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '190 - Charter Authorizer Directory')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '190', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '196' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '196 - Management Organizations Directory')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '196', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '197' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				--	Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '197 - Crosswalk of Charter School to Management')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '197', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '198' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				--	Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '198 - Charter Contracts')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '198', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '103' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '103 - Accountability')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '103', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '131' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '131 -LEA REAP-Flex Alternative Uses Indicator')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '131', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '205' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '205 - Progress Achieving English Language')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '205', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '206' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '206 - Progress Achieving English Language')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '206', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '163' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '163 -GFSA Reporting Status')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '163', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '170' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '170 - LEA Subgrant')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '170', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '035' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '035 - Federal Funds')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '035', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '207' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '207 - State Appropriations for Charter Schools')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '207', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '223' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '223 - State Appropriations for Charter Schools')

				exec [RDS].[Create_OrganizationReportData]	@reportCode = '223', @runAsTest = @runAsTest
			end

		end
		if @factTypeCode = 'organizationstatus'
		begin

			if exists (select 'c' from app.GenerateReports where ReportCode = '199' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '199 - Organization Status data')

				exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = '199', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '200' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '200 - Organization Status data')

				exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = '200', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '201' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '201 - Organization Status data')

				exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = '201', @runAsTest = @runAsTest
			end

			if exists (select 'c' from app.GenerateReports where ReportCode = '202' and IsLocked = 1 and UseLegacyReportMigration = 1)
			begin			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, '202 - Organization Status data')

				exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = '202', @runAsTest = @runAsTest
			end

		end
	
	end try

	begin catch

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	end catch



End