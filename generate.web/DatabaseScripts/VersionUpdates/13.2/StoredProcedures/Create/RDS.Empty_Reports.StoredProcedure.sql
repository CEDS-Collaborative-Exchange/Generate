CREATE PROCEDURE [RDS].[Empty_Reports]
	@factTypeCode as varchar(50)
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
	values	(getutcdate(), @dataMigrationTypeId, 'Empty Selected Reports: ' + @factTypeCode)			

		if @factTypeCode = 'datapopulation'
		begin	
					delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
					select ReportCode
					from app.GenerateReports r
					where r.ReportCode in ('studentcount','studentsex','studentdisability','studentrace','studentsubpopulation')
					 and r.IsLocked=1) 
					and ReportYear = @selectedReportYear
		end	
		else if @factTypeCode = 'directory'
		begin
			delete from rds.ReportEDFactsOrganizationCounts where ReportCode in (
					select ReportCode from app.GenerateReports r
					where r.ReportCode in ('029','039','129','130','193','190','196','197','198','103','131','205','206','163', '170', '035', '207') and r.IsLocked=1)
					and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'organizationstatus'
		begin
			delete from rds.ReportEDFactsOrganizationStatusCounts where ReportCode in (
					select ReportCode from app.GenerateReports r
					where r.ReportCode in ('199', '201', '200', '202') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'childcount'
		begin	
				delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
					select ReportCode
					from app.GenerateReports r
					where r.ReportCode in ('002', '089', 'yeartoyearenvironmentcount', 'yeartoyearchildcount', 'studentssummary') 
					and r.IsLocked=1) 
					and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'exiting'
		begin

				delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('009','exitspecialeducation','yeartoyearexitcount') and r.IsLocked=1)  
				and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'cte'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('082','083','132','154','155','156','158','169') and r.IsLocked=1) 
				and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'membership'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('033','052') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'dropout'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('032') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'graduatescompleters'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('040') and r.IsLocked=1) and ReportYear = @selectedReportYear

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
				where r.ReportCode in ('141') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'titleIIIELSY'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('045','204', '116') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'titleI'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('037','134','studentswdtitle1') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'migranteducationprogram'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('054','121','122','145') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'immigrant'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('165') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'neglectedordelinquent'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('119','127','180','181') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'homeless'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('118','194') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'chronicabsenteeism'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('195') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'graduationrate'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('150','151') and r.IsLocked=1) and ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'hsgradpsenroll'
		begin	
				
			delete from rds.ReportEDFactsK12StudentCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('160') and r.IsLocked=1) and ReportYear = @selectedReportYear
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
		else if @factTypeCode = 'discipline'
		begin
				delete from rds.ReportEDFactsK12StudentDisciplines where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('005', '006', '007','086','088','143','144','disciplinaryremovals','yeartoyearremoval', 'studentdiscipline') 
				and r.IsLocked=1) and  ReportYear = @selectedReportYear

				delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('indicator4a','indicator4b') and r.IsLocked=1) and  ReportYear = @selectedReportYear
		end
		else if @factTypeCode = 'assessment'
		begin
				delete from rds.ReportEDFactsK12StudentAssessments where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				where r.ReportCode in ('126', '139','175','178','179','185','188','189','138','137','050','142','157','stateassessmentsperformance') 
				and r.IsLocked=1) 
				and  ReportYear = @selectedReportYear
								

				delete from rds.ReportEDFactsK12StudentAssessments where ReportCode in (
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
		else if @factTypeCode = 'staff'
		begin
				delete from rds.ReportEDFactsK12StaffCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('070', '099','112','059','067') and r.IsLocked=1)  and  ReportYear = @selectedReportYear
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