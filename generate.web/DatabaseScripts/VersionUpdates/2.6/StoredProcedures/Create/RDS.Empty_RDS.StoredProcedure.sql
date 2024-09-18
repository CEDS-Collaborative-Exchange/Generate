



CREATE PROCEDURE [RDS].[Empty_RDS]
	@factTypeCode as varchar(50),
	@reportType as varchar(50)=null,
	@reportLevel as varchar(50)=null
AS
BEGIN

begin try
	begin transaction


	declare @dimFactTypeId as int
	select @dimFactTypeId = DimFactTypeId
	from rds.DimFactTypes where factTypeCode = @factTypeCode

	if @factTypeCode = 'datapopulation'
	begin
		
		-- Facts

		truncate table rds.FactStudentCountReports
		truncate table rds.FactStudentCounts

		truncate table rds.FactStudentDisciplineReports
		truncate table rds.FactStudentDisciplines

		truncate table rds.FactStudentAssessmentReports
		truncate table rds.FactStudentAssessments

		truncate table rds.FactPersonnelCountReports
		truncate table rds.FactPersonnelCounts

		truncate table rds.FactOrganizationCounts
		truncate table rds.FactOrganizationCountReports


		

		-- Bridge Tables

		truncate table rds.BridgeStudentRaces
		truncate table rds.BridgeDirectoryDate
		truncate table rds.[BridgeDirectoryGradeLevels]
		truncate table rds.[BridgePersonnelDate]
		truncate table rds.[BridgeSchoolDate]
		truncate table rds.[BridgeStudentDate]
		
		-- Dimensions

		delete from rds.DimSchools where DimSchoolId <> -1
		delete from rds.DimStudents where DimStudentId <> -1
		delete from rds.DimPersonnel where DimPersonnelId <> -1
		delete from rds.DimDirectories where DimDirectoryId <> -1
		delete from rds.DimSeas where DimSeaId  <> -1
		delete from rds.DimLeas where dimleaId <> -1

		delete from RDS.DimCharterSchoolApproverAgency WHERE DimCharterSchoolApproverAgencyId<>-1


		       
	end
	else if @factTypeCode = 'submission'
	begin
		-- Facts
		if(@reportType='studentcounts')
		begin
			if(@reportLevel='rds')
			begin
				delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId
			end
			else if (@reportLevel='report')
			begin
				delete from rds.FactStudentCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('c032','c033', 'c037','c040','c045','c052','c054','c116','c121','c122','c134','c141','c145','indicator9','indicator10','studentfederalprogramsparticipation',
				'studentmultifedprogsparticipation','edenvironmentdisabilitiesage3-5','edenvironmentdisabilitiesage6-21','c118','c204','c160', 'c165', 'c194','c195')and r.IsLocked=1)  and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 

					delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('cohortgraduationrate')and r.IsLocked=1)  and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 
			end
		end

		else if(@reportType='disciplinecounts')
		begin
			if(@reportLevel='rds')
			begin
				delete from rds.FactStudentDisciplines where DimFactTypeId = @dimFactTypeId
			end
			else if (@reportLevel='report')
			begin
				delete from rds.FactStudentDisciplineReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('c005', 'c006', 'c007','c086','c088','c143','c144','disciplinaryremovals') and r.IsLocked=1) and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 

				delete from rds.FactCustomCounts where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('indicator4a','indicator4b') and r.IsLocked=1) and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 
			end
		end
		else if(@reportType='studentassessments')
		begin
			if(@reportLevel='rds')
			begin
				delete from rds.FactStudentAssessments where DimFactTypeId = @dimFactTypeId
			end
			else if (@reportLevel='report')
			begin
				delete from rds.FactStudentAssessmentReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				where r.ReportCode in ('c126', 'c139','c175','c178','c179','c185','c188','c189','c138','c137','c050','c142','c157','stateassessmentsperformance') and r.IsLocked=1) and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 
			end
		end
		else if(@reportType='personnelcounts')
		begin
			if(@reportLevel='rds')
			begin
				delete from rds.FactPersonnelCounts where DimFactTypeId = @dimFactTypeId
			end
			else if (@reportLevel='report')
			begin
				delete from rds.FactPersonnelCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
				and r.ReportCode in ('c070', 'c099','c112','c059','c067') and r.IsLocked=1)  and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 
			end
		end
		else 
		begin
		delete from rds.FactCustomCounts where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			and t.ReportTypeCode in ('statereport')
			)			
		end
	end
	else if @factTypeCode = 'childcount'
	begin	
		-- Facts	
		if(@reportLevel='rds')
			begin
				delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId
			end
	else if (@reportLevel='report')
			begin
				delete from rds.FactStudentCountReports where ReportCode in (
					select ReportCode
					from app.GenerateReports r
					where r.ReportCode in ('c002','c089') and r.IsLocked=1) and  ReportYear in (
					select SubmissionYear	from rds.DimDates d		
					inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
					inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 
				end
	end
	else if @factTypeCode = 'specedexit'
	begin
		if(@reportLevel='rds')
			begin
				delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId
			end
		else if (@reportLevel='report')
			begin
				delete from rds.FactStudentCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c009','exitspecialeducation') and r.IsLocked=1)  and  ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 	
			end
	end
	else if @factTypeCode = 'cte'
	begin	
		-- Facts
		if(@reportLevel='rds')
		begin
			delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId
		end
		else if (@reportLevel='report')
		begin
			delete from rds.FactStudentCountReports where ReportCode in (
				select ReportCode
				from app.GenerateReports r
				where r.ReportCode in ('c082','c083','c154','c155','c156','c158','c169') and r.IsLocked=1) and ReportYear in (
				select SubmissionYear	from rds.DimDates d		
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
				inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId and dm.DataMigrationTypeCode='report'	) 
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

