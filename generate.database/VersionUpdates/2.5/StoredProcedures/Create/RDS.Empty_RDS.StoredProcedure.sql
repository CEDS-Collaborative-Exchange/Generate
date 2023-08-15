



CREATE PROCEDURE [RDS].[Empty_RDS]
	@factTypeCode as varchar(50)
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

		delete from rds.FactStudentCountReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			and t.ReportTypeCode in ('edfactsreport', 'sppaprreport')
			)			
		delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId

		delete from rds.FactStudentDisciplineReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			and t.ReportTypeCode in ('edfactsreport', 'sppaprreport')
			)			
		delete from rds.FactStudentDisciplines where DimFactTypeId = @dimFactTypeId

		delete from rds.FactStudentAssessmentReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			and t.ReportTypeCode in ('edfactsreport', 'sppaprreport')
			)			
		delete from rds.FactStudentAssessments where DimFactTypeId = @dimFactTypeId

		delete from rds.FactPersonnelCountReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			and t.ReportTypeCode in ('edfactsreport', 'sppaprreport')
			)			
		delete from rds.FactPersonnelCounts where DimFactTypeId = @dimFactTypeId

		delete from rds.FactCustomCounts where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			and t.ReportTypeCode in ('statereport')
			)			

	end
	else if @factTypeCode = 'childcount'
	begin
	
		-- Facts

		delete from rds.FactStudentCountReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			Where r.ReportCode in ('c002','c089')
			)			
		delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId

	end
	else if @factTypeCode = 'specedexit'
	begin
	
		-- Facts

		delete from rds.FactStudentCountReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			where r.ReportCode in ('c009','exitspecialeducation')
			)			
		delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId

	end
	else if @factTypeCode = 'cte'
	begin
	
		-- Facts

		delete from rds.FactStudentCountReports where ReportCode in (
			select ReportCode
			from app.GenerateReports r
			where r.ReportCode in ('c082','c083','c154','c155','c156','c158','c169')
			)			
		delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId

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

