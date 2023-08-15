CREATE PROCEDURE [RDS].[Create_Reports]
	@factTypeCode as varchar(50),
	@runAsTest as bit,
	@reportType as varchar(50)
AS
BEGIN

begin try


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

	
	if(@reportType='studentcounts')
	begin
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

                if exists (select 'c' from app.GenerateReports where ReportCode = 'studentswdtitle1' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentswdtitle1')

				    exec [RDS].[Create_ReportData]	@reportCode = 'studentswdtitle1', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
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

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c002' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c002')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c002', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end


                if exists (select 'c' from app.GenerateReports where ReportCode = 'c089' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c089')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c089', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
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

			if @factTypeCode = 'specedexit'
			begin

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c009' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c009')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c009', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
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


            if exists (select 'c' from app.GenerateReports where ReportCode = 'c082' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c082')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c082', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c083' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c083')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c083', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

			if exists (select 'c' from app.GenerateReports where ReportCode = 'c154' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c154')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c154', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c155' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c155')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c155', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
	        end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c156' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c156')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c156', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end
		
            if exists (select 'c' from app.GenerateReports where ReportCode = 'c158' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c158')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c158', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end
				
            if exists (select 'c' from app.GenerateReports where ReportCode = 'c169' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c169')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c169', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c132' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history 
            
                -- This code is here because C132 uses FactStudentCounts and the table is not populated 
			    --				  when Migrate_OrganizationCounts run
			
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c132 - Section 1003 Funds')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c132', @runAsTest = @runAsTest
            end

		end

			if @factTypeCode = 'membership'
			begin
				if exists (select 'c' from app.GenerateReports where ReportCode = 'c033' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c033')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c033', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest

				end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c052' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    ---- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c052')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c052', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

			end

			if @factTypeCode = 'dropout'
			begin
				if exists (select 'c' from app.GenerateReports where ReportCode = 'c032' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c032')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c032', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

			end

			if @factTypeCode = 'grad'
			begin
				if exists (select 'c' from app.GenerateReports where ReportCode = 'c040' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c040')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c040', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c045' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
					-- Log history
					insert into app.DataMigrationHistories
					(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c045')

					exec [RDS].[Create_ReportData]	@reportCode = 'c045', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
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
				if exists (select 'c' from app.GenerateReports where ReportCode = 'c116' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c116')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c116', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c141' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c141')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c141',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			end

			if @factTypeCode = 'titleIIIELSY'
			begin

				   -- Uses new .Net ETL
                --if exists (select 'c' from app.GenerateReports where ReportCode = 'c045' and IsLocked = 1 and UseLegacyReportMigration = 1)
                --begin
				---- Log history
				--insert into app.DataMigrationHistories
				--(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c045')

				--exec [RDS].[Create_ReportData]	@reportCode = 'c045', @runAsTest = @runAsTest
                --end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c204' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c204')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c204', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			end

			if @factTypeCode = 'titleI'
			begin
				
                if exists (select 'c' from app.GenerateReports where ReportCode = 'c037' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c037')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c037', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c134' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c134')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c134', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			end

			if @factTypeCode = 'mep'
			begin
				 if exists (select 'c' from app.GenerateReports where ReportCode = 'c054' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c054')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c054', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			
            

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c121' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c121')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c121', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c122' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c122')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c122', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				 if exists (select 'c' from app.GenerateReports where ReportCode = 'c145' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c145')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c145', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			end

			
			if @factTypeCode = 'immigrant'
			begin
				if exists (select 'c' from app.GenerateReports where ReportCode = 'c165' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c165')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c165', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			end

			if @factTypeCode = 'nord'
			begin
			  

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c119' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c119')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c119', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c127' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c127')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c127', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c180' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c180')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c180', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c181' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c181')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c181', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

			end

			if @factTypeCode = 'homeless'
			begin

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c118' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c118')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c118', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				if exists (select 'c' from app.GenerateReports where ReportCode = 'c194' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c194')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c194', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
				
			end

			if @factTypeCode = 'chronic'
			begin
				 if exists (select 'c' from app.GenerateReports where ReportCode = 'c195' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c195')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c195', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest	
				end
			end

			if @factTypeCode = 'gradrate'
			begin
				 if exists (select 'c' from app.GenerateReports where ReportCode = 'c150' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c150')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c150', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c151' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c151')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c151', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			end

			if @factTypeCode = 'hsgradenroll'
			begin
				if exists (select 'c' from app.GenerateReports where ReportCode = 'c160' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c160')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c160',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
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


	end

	else if(@reportType='disciplinecounts')
	begin
			if @factTypeCode = 'datapopulation' 
				begin

								
                if exists (select 'c' from app.GenerateReports where ReportCode = 'studentdiscipline' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
                    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Data Population Summary - studentdiscipline')

				    exec [RDS].[Create_ReportData]	@reportCode = 'studentdiscipline', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

				end
			if @factTypeCode = 'submission'
			begin


                if exists (select 'c' from app.GenerateReports where ReportCode = 'c005' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c005')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c005',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c006' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c006')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c006', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end
			
                if exists (select 'c' from app.GenerateReports where ReportCode = 'c007' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c007')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c007', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c086' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c086')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c086', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c088' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c088')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c088', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c143' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c143')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c143', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
                end

                if exists (select 'c' from app.GenerateReports where ReportCode = 'c144' and IsLocked = 1 and UseLegacyReportMigration = 1)
                begin			
				    -- Log history
				    insert into app.DataMigrationHistories
				    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c144')

				    exec [RDS].[Create_ReportData]	@reportCode = 'c144', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
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
	end

	else if(@reportType='studentassessments')
	begin
			
		if @factTypeCode = 'submission'
		begin

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c113' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c113')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c113', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c125' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c125')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c125', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c126' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c126')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c126', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c139' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c139')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c139', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c175' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c175')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c175', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c178' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c178')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c178', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c179' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c179')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c179', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c185' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c185')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c185', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c188' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c188')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c188', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c189' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c189')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c189',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c138' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c138')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c138',@dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c137' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c137')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c137', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c050' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c050')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c050', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c142' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c142')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c142', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c157' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c157')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c157', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'stateassessmentsperformance' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'State Reports - stateassessmentsperformance')

			    exec [RDS].[Create_ReportData]	@reportCode = 'stateassessmentsperformance', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

		end
	end

	else if(@reportType='personnelcounts')
	begin
		if @factTypeCode = 'submission'
		begin

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c070' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c070')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c070', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c099' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c099')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c099', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
			end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c112' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c112')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c112', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c059' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c059')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c059', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c067' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c067')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c067', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c203' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'Submission Reports - c203')

			    exec [RDS].[Create_ReportData]	@reportCode = 'c203', @dimFactTypeCode = @factTypeCode, @runAsTest = @runAsTest
            end

		end
	end

	else if(@reportType='organizationcounts')
	begin
		if @factTypeCode = 'directory'
		begin
		
            if exists (select 'c' from app.GenerateReports where ReportCode = 'c029' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c029 - Organization data')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c029', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c039' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c039 - Organization Grade level data')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c039', @runAsTest = @runAsTest
		    end


            if exists (select 'c' from app.GenerateReports where ReportCode = 'c129' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c129 - CCD School data')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c129', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c130' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c130 - ESEA Status')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c130', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c193' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c193 - Title I Allocations')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c193', @runAsTest = @runAsTest
		    end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c190' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c190 - Charter Authorizer Directory')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c190', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c196' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c196 - Management Organizations Directory')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c196', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c197' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    --	Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c197 - Crosswalk of Charter School to Management')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c197', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c198' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    --	Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c198 - Charter Contracts')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c198', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c103' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
                insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c103 - Accountability')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c103', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c131' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c131 -LEA REAP-Flex Alternative Uses Indicator')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c131', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c205' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c205 - Progress Achieving English Language')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c205', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c206' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c206 - Progress Achieving English Language')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c206', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c163' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c163 -GFSA Reporting Status')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c163', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c170' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c170 - LEA Subgrant')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c170', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c035' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c035 - Federal Funds')

			    exec [RDS].[Create_OrganizationReportData]	@reportCode = 'c035', @runAsTest = @runAsTest
            end

		end
	end

	else if(@reportType='organizationstatuscounts')
	begin
		if @factTypeCode = 'organizationstatus'
		begin
		
            if exists (select 'c' from app.GenerateReports where ReportCode = 'c199' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c199 - Organization Status data')

			    exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c199', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c200' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c200 - Organization Status data')

			    exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c200', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c201' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c201 - Organization Status data')

			    exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c201', @runAsTest = @runAsTest
            end

            if exists (select 'c' from app.GenerateReports where ReportCode = 'c202' and IsLocked = 1 and UseLegacyReportMigration = 1)
            begin			
			    -- Log history
			    insert into app.DataMigrationHistories
			    (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			    values	(getutcdate(), @dataMigrationTypeId, 'c202 - Organization Status data')

			    exec [RDS].[Create_OrganizationStatusReportData]	@reportCode = 'c202', @runAsTest = @runAsTest
            end

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