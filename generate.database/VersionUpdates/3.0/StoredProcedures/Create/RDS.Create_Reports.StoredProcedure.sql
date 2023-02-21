
CREATE PROCEDURE [RDS].[Create_Reports]
	@factTypeCode as varchar(50),
	@runAsTest as bit,
	@reportType as varchar(50)
AS
BEGIN

begin try

begin transaction	

	declare @factTable as varchar(50)
	if(@reportType='studentcounts')
		begin
			set @factTable = 'FactStudentCounts'
	end
	else if(@reportType='organizationcounts')
	begin
		set @factTable = 'FactOrganizationCounts'
	end
	else if(@reportType='disciplinecounts')
	begin
			set @factTable = 'FactStudentDisciplines'
	end
	else if(@reportType='studentassessments')
	begin
			set @factTable = 'FactStudentAssessments'
	end
	else if(@reportType='personnelcounts')
	begin
			set @factTable = 'FactPersonnelCounts'
	end
	else if(@reportType='customcounts')
	begin
			set @factTable = 'FactCustomCounts'
	end

	declare @dataMigrationTypeId as int

	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'report'


	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

	declare @useChildCountDate as bit
	set @useChildCountDate = 0

	IF @factTypeCode = 'childcount'
	BEGIN
		set @useChildCountDate = 1
	END
	
	if(@reportType='studentcounts')
	begin
			if @factTypeCode = 'datapopulation' 
			begin
				delete from rds.FactStudentCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('studentcount','studentsex','studentdisability','studentrace','studentswdtitle1') and r.IsLocked=1) and ReportYear in (
				select distinct SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	)
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentcount')			

				exec [RDS].[Create_ReportData]	@reportCode = 'studentcount', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentsex')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentsex', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentdisability')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentdisability', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentrace')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentrace', @runAsTest = @runAsTest

				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentswdtitle1')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentswdtitle1', @runAsTest = @runAsTest

			end


			if @factTypeCode = 'childcount'
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c002')

				exec [RDS].[Create_ReportData]	@reportCode = 'c002', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c089')

				exec [RDS].[Create_ReportData]	@reportCode = 'c089', @runAsTest = @runAsTest

								-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Reports - Year To Year Environment Count Report')


				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearenvironmentcount', @runAsTest = @runAsTest
					
					-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - Year To Year Child Count Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearchildcount', @runAsTest = @runAsTest

					-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - Year To Year Exit Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearexitcount', @runAsTest = @runAsTest


					-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - Year To Year Students Removal Report')

				exec [RDS].[Create_ReportData]	@reportCode = 'yeartoyearremovalcount', @runAsTest = @runAsTest

					-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Quality Report - LEA Students Summary Profile')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentssummary', @runAsTest = @runAsTest

			
			end

			if @factTypeCode = 'specedexit'
			begin
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'bmissionbmission Reports - c009')

				exec [RDS].[Create_ReportData]	@reportCode = 'c009', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - exitspecialeducation')

				exec [RDS].[Create_ReportData]	@reportCode = 'exitspecialeducation', @runAsTest = @runAsTest
			end

			if @factTypeCode = 'submission'
			begin	
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c032')

				exec [RDS].[Create_ReportData]	@reportCode = 'c032', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c033')

				exec [RDS].[Create_ReportData]	@reportCode = 'c033', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c037')

				exec [RDS].[Create_ReportData]	@reportCode = 'c037', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c040')

				exec [RDS].[Create_ReportData]	@reportCode = 'c040', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c045')

				exec [RDS].[Create_ReportData]	@reportCode = 'c045', @runAsTest = @runAsTest


			
				---- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c052')

				exec [RDS].[Create_ReportData]	@reportCode = 'c052', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c054')

				exec [RDS].[Create_ReportData]	@reportCode = 'c054', @runAsTest = @runAsTest

			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c116')

				exec [RDS].[Create_ReportData]	@reportCode = 'c116', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c119')

				exec [RDS].[Create_ReportData]	@reportCode = 'c119', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c121')

				exec [RDS].[Create_ReportData]	@reportCode = 'c121', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c122')

				exec [RDS].[Create_ReportData]	@reportCode = 'c122', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c127')

				exec [RDS].[Create_ReportData]	@reportCode = 'c127', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c134')

				exec [RDS].[Create_ReportData]	@reportCode = 'c134', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c141')

				exec [RDS].[Create_ReportData]	@reportCode = 'c141', @runAsTest = @runAsTest

				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c145')

				exec [RDS].[Create_ReportData]	@reportCode = 'c145', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c165')

				exec [RDS].[Create_ReportData]	@reportCode = 'c165', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c180')

				exec [RDS].[Create_ReportData]	@reportCode = 'c180', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c181')

				exec [RDS].[Create_ReportData]	@reportCode = 'c181', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c194')

				exec [RDS].[Create_ReportData]	@reportCode = 'c194', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c195')

				exec [RDS].[Create_ReportData]	@reportCode = 'c195', @runAsTest = @runAsTest	
				
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator9')

				exec [RDS].[Create_ReportData]	@reportCode = 'indicator9', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator10')
	
				exec [RDS].[Create_ReportData]	@reportCode = 'indicator10', @runAsTest = @runAsTest

			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - cohortgraduationrate')

				exec [RDS].[Create_CustomReportData]	@reportCode = 'cohortgraduationrate', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - studentfederalprogramsparticipation')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentfederalprogramsparticipation', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - studentmultifedprogsparticipation')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentmultifedprogsparticipation', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - edenvironmentdisabilitiesage3-5')

				exec [RDS].[Create_ReportData]	@reportCode = 'edenvironmentdisabilitiesage3-5', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Defined Reports - edenvironmentdisabilitiesage6-21')

				exec [RDS].[Create_ReportData]	@reportCode = 'edenvironmentdisabilitiesage6-21', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c118')

				exec [RDS].[Create_ReportData]	@reportCode = 'c118', @runAsTest = @runAsTest

							-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c204')

				exec [RDS].[Create_ReportData]	@reportCode = 'c204', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c160')

				exec [RDS].[Create_ReportData]	@reportCode = 'c160', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c150')

				exec [RDS].[Create_ReportData]	@reportCode = 'c150', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c151')

				exec [RDS].[Create_ReportData]	@reportCode = 'c151', @runAsTest = @runAsTest

			end
				
			if @factTypeCode = 'cte'
			begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c082')

			exec [RDS].[Create_ReportData]	@reportCode = 'c082', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c083')

			exec [RDS].[Create_ReportData]	@reportCode = 'c083', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c154')

			exec [RDS].[Create_ReportData]	@reportCode = 'c154', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c155')

			exec [RDS].[Create_ReportData]	@reportCode = 'c155', @runAsTest = @runAsTest
	
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c156')

			exec [RDS].[Create_ReportData]	@reportCode = 'c156', @runAsTest = @runAsTest

		
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c158')

			exec [RDS].[Create_ReportData]	@reportCode = 'c158', @runAsTest = @runAsTest

				
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c169')

			exec [RDS].[Create_ReportData]	@reportCode = 'c169', @runAsTest = @runAsTest


				-- Log history -- This code is here because C132 uses FactStudentCounts and the table is not populated 
			--				  when Migrate_OrganizationCounts run
			
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c132 - Section 1003 Funds')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c132', @runAsTest = @runAsTest
			end
	end

	else if(@reportType='disciplinecounts')
	begin
			if @factTypeCode = 'datapopulation' 
				begin

				delete from rds.FactStudentDisciplineReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('studentdiscipline') and r.IsLocked=1) and ReportYear in (
				select distinct SubmissionYear from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	)

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentdiscipline')

				exec [RDS].[Create_ReportData]	@reportCode = 'studentdiscipline', @runAsTest = @runAsTest

				end
			if @factTypeCode = 'submission'
			begin

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c005')

				exec [RDS].[Create_ReportData]	@reportCode = 'c005', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c006')

				exec [RDS].[Create_ReportData]	@reportCode = 'c006', @runAsTest = @runAsTest

			
				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c007')

				exec [RDS].[Create_ReportData]	@reportCode = 'c007', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c086')

				exec [RDS].[Create_ReportData]	@reportCode = 'c086', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c088')

				exec [RDS].[Create_ReportData]	@reportCode = 'c088', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c143')

				exec [RDS].[Create_ReportData]	@reportCode = 'c143', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c144')

				exec [RDS].[Create_ReportData]	@reportCode = 'c144', @runAsTest = @runAsTest


				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator4a')

				exec [RDS].[Create_CustomReportData] @reportCode = 'indicator4a', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - indicator4b')

				exec [RDS].[Create_CustomReportData] @reportCode = 'indicator4b', @runAsTest = @runAsTest

				-- Log history
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'State Reports - Disciplinary Removals')

				exec [RDS].[Create_ReportData] @reportCode = 'disciplinaryremovals', @runAsTest = @runAsTest
		end
	end

	else if(@reportType='studentassessments')
	begin
			if @factTypeCode = 'datapopulation'
		begin

		delete from rds.FactStudentAssessmentReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('studentsubpopulation') and r.IsLocked=1) and ReportYear in (
				select distinct SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	)
			--truncate table rds.FactStudentAssessmentReports

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentsubpopulation')

			exec [RDS].[Create_ReportData]	@reportCode = 'studentsubpopulation', @runAsTest = @runAsTest
		end

		if @factTypeCode = 'submission'
		begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c113')

			exec [RDS].[Create_ReportData]	@reportCode = 'c113', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c125')

			exec [RDS].[Create_ReportData]	@reportCode = 'c125', @runAsTest = @runAsTest


			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c126')

			exec [RDS].[Create_ReportData]	@reportCode = 'c126', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c139')

			exec [RDS].[Create_ReportData]	@reportCode = 'c139', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c175')

			exec [RDS].[Create_ReportData]	@reportCode = 'c175', @runAsTest = @runAsTest


			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c178')

			exec [RDS].[Create_ReportData]	@reportCode = 'c178', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c179')

			exec [RDS].[Create_ReportData]	@reportCode = 'c179', @runAsTest = @runAsTest
			
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c185')

			exec [RDS].[Create_ReportData]	@reportCode = 'c185', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c188')

			exec [RDS].[Create_ReportData]	@reportCode = 'c188', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c189')

			exec [RDS].[Create_ReportData]	@reportCode = 'c189', @runAsTest = @runAsTest


			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c138')

			exec [RDS].[Create_ReportData]	@reportCode = 'c138', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c137')

			exec [RDS].[Create_ReportData]	@reportCode = 'c137', @runAsTest = @runAsTest

				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c050')

			exec [RDS].[Create_ReportData]	@reportCode = 'c050', @runAsTest = @runAsTest

				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c142')

			exec [RDS].[Create_ReportData]	@reportCode = 'c142', @runAsTest = @runAsTest


				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c157')

			exec [RDS].[Create_ReportData]	@reportCode = 'c157', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'State Reports - stateassessmentsperformance')

			exec [RDS].[Create_ReportData]	@reportCode = 'stateassessmentsperformance', @runAsTest = @runAsTest

		end
	end

	else if(@reportType='personnelcounts')
	begin
		if @factTypeCode = 'submission'
		begin
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c070')

			exec [RDS].[Create_ReportData]	@reportCode = 'c070', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c099')

			exec [RDS].[Create_ReportData]	@reportCode = 'c099', @runAsTest = @runAsTest
			
			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c112')

			exec [RDS].[Create_ReportData]	@reportCode = 'c112', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c059')

			exec [RDS].[Create_ReportData]	@reportCode = 'c059', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c067')

			exec [RDS].[Create_ReportData]	@reportCode = 'c067', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c203')

			exec [RDS].[Create_ReportData]	@reportCode = 'c203', @runAsTest = @runAsTest

		end
	end

	else if(@reportType='organizationcounts')
	begin
		if @factTypeCode = 'datapopulation' --or @factTypeCode = 'submission'
		begin
		delete from rds.FactOrganizationCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c029','c039','c129','c130','c193','c190','c196','c197','c198','c103','c131','c205','c206','c163', 'c170', 'c035') and r.IsLocked=1
				and ReportYear in (
				select distinct SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'))

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c029 - Organization data')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c029', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c039 - Organization Grade level data')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c039', @runAsTest = @runAsTest
		
				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c129 - CCD School data')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c129', @runAsTest = @runAsTest


				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c130 - ESEA Status')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c130', @runAsTest = @runAsTest

					-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c193 - Title I Allocations')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c193', @runAsTest = @runAsTest
		
				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c190 - Charter Authorizer Directory')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c190', @runAsTest = @runAsTest

				-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c196 - Management Organizations Directory')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c196', @runAsTest = @runAsTest

			--	-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c197 - Crosswalk of Charter School to Management')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c197', @runAsTest = @runAsTest

			--	-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c198 - Charter Contracts')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c198', @runAsTest = @runAsTest

				insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c103 - Accountability')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c103', @runAsTest = @runAsTest

				insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c131 -LEA REAP-Flex Alternative Uses Indicator')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c131', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c205 - Progress Achieving English Language')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c205', @runAsTest = @runAsTest


			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c206 - Progress Achieving English Language')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c206', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c163 -GFSA Reporting Status')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c163', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c170 - LEA Subgrant')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c170', @runAsTest = @runAsTest

			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c035 - Federal Funds')

			exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c035', @runAsTest = @runAsTest


		end
	end

	else if(@reportType='organizationstatuscounts')
	begin
		if @factTypeCode = 'datapopulation' --or @factTypeCode = 'submission'
		begin
		delete from rds.FactOrganizationStatusCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c199', 'c201', 'c200', 'c202') and r.IsLocked=1) and ReportYear in (
				select distinct SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	)

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c199 - Organization Status data')

			exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c199', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c200 - Organization Status data')

			exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c200', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c201 - Organization Status data')

			exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c201', @runAsTest = @runAsTest

			-- Log history
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, 'c202 - Organization Status data')

			exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c202', @runAsTest = @runAsTest
		end
	end

	commit transaction

	end try

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



End