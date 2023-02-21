CREATE PROCEDURE [RDS].[Empty_Reports]
	@factTypeCode as varchar(50),
	@reportType as varchar(50)=null
AS
BEGIN

begin try
	begin transaction


	declare @dimFactTypeId as int
	select @dimFactTypeId = DimFactTypeId
	from rds.DimFactTypes where factTypeCode = @factTypeCode

	declare @dataMigrationTypeId as int, @selectedYear as int
	declare @selectedReportYear as varchar(100)

	select @dataMigrationTypeId = DataMigrationTypeId
	from app.DataMigrationTypes where DataMigrationTypeCode = 'report'

	select @selectedYear = d.SchoolYear, @selectedReportYear = d.SchoolYear
	from rds.DimSchoolYears d		
	inner join rds.DimSchoolYearDataMigrationTypes dd on dd.DimSchoolYearId = d.DimSchoolYearId and dd.IsSelected=1
	inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode = 'report'

	 insert into app.DataMigrationHistories
	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
	values	(getutcdate(), @dataMigrationTypeId, 'Empty Selected Reports: ' + @factTypeCode + ' Report Type ' + ISNULL(@reportType, ''))			

		if @factTypeCode = 'datapopulation'
		begin	
				if(@reportType='studentcounts')
				begin
					delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
					select ReportCode
					from app.GenerateReports r
					where r.ReportCode in ('studentcount','studentsex','studentdisability','studentrace','studentswdtitle1','studentsubpopulation')
					 and r.IsLocked=1) 
					and ReportYear = @selectedReportYear
				end
				else if(@reportType='disciplinecounts')
				begin
					delete from rds.ReportEDFactsK12StudentDisciplines where ReportCode in (
					select ReportCode
					from app.GenerateReports r
					where r.ReportCode in ('studentdiscipline') and r.IsLocked=1) and ReportYear = @selectedReportYear
								
				end
		end	
		else if @factTypeCode = 'directory'
		begin
			delete from rds.FactOrganizationCountReports where ReportCode in (
					select ReportCode from app.GenerateReports r
					where r.ReportCode in ('c029','c039','c129','c130','c193','c190','c196','c197','c198','c103','c131','c205','c206','c163', 'c170', 'c035', 'c207') and r.IsLocked=1)
					and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'organizationstatus'
		begin
			delete from rds.FactOrganizationStatusCountReports where ReportCode in (
					select ReportCode from app.GenerateReports r
					where r.ReportCode in ('c199', 'c201', 'c200', 'c202') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'childcount'
		begin	
				delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
					select ReportCode
					from app.GenerateReports r
					where r.ReportCode in ('c002', 'c089', 'yeartoyearenvironmentcount', 'yeartoyearchildcount', 'studentssummary') 
					and r.IsLocked=1) 
					and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'specedexit'
		begin

				delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c009','exitspecialeducation','yeartoyearexitcount') and r.IsLocked=1)  
				and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'cte'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c082','c083','c132','c154','c155','c156','c158','c169') and r.IsLocked=1) 
				and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'membership'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c033','c052') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'dropout'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c032') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'grad'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c040') and r.IsLocked=1) and ReportYear = @selectedReportYear

			delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('cohortgraduationrate')and r.IsLocked=1)  and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'sppapr'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('indicator9','indicator10') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'titleIIIELOct'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c116','c141') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'titleIIIELSY'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c045','c204') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'titleI'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c037','c134') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'mep'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c054','c121','c122','c145') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'immigrant'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c165') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'nord'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c119','c127','c180','c181') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'homeless'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c118','c194') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'chronic'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c195') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'gradrate'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c150','c151') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'hsgradenroll'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c160') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'other'
		begin	
				
				delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('studentfederalprogramsparticipation', 'studentmultifedprogsparticipation', 
				'edenvironmentdisabilitiesage3-5','edenvironmentdisabilitiesage6-21') and r.IsLocked=1) 
				and ReportYear = @selectedReportYear

				delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('studentfederalprogramsparticipation', 'studentmultifedprogsparticipation') and r.IsLocked=1) 
				and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'submission'
		begin
			if(@reportType='disciplinecounts')
			begin
				delete from rds.ReportEDFactsK12StudentDisciplines where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('c005', 'c006', 'c007','c086','c088','c143','c144','disciplinaryremovals','yeartoyearremoval') 
				and r.IsLocked=1) and  ReportYear = @selectedReportYear

				delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('indicator4a','indicator4b') and r.IsLocked=1) and  ReportYear = @selectedReportYear
			end
			else if(@reportType='studentassessments')
			begin
				delete from rds.FactK12StudentAssessmentReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				where r.ReportCode in ('c126', 'c139','c175','c178','c179','c185','c188','c189','c138','c137','c050','c142','c157','stateassessmentsperformance') and r.IsLocked=1) 
				and  ReportYear = @selectedReportYear
								

				delete from rds.FactK12StudentAssessmentReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				where r.ReportCode in ('yeartoyearprogress') and r.IsLocked=1) and  ReportYear in (
				select SchoolYear	from rds.DimSchoolYears
				where Year in (@selectedYear, @selectedYear - 1, @selectedYear - 2, @selectedYear - 3)) 

				delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				where r.ReportCode in ('yeartoyearattendance') and r.IsLocked=1) and  ReportYear = @selectedReportYear

			end
			else if(@reportType='personnelcounts')
			begin
				delete from rds.ReportEDFactsK12StaffCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('c070', 'c099','c112','c059','c067') and r.IsLocked=1)  and  ReportYear = @selectedReportYear
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

	END CATCH; 


END