CREATE PROCEDURE [RDS].[Empty_RDS]
	@factTypeCode as varchar(50),
	@reportType as varchar(50)=null
AS
BEGIN

begin try
	
	declare @dimFactTypeId as int
	select @dimFactTypeId = DimFactTypeId
	from rds.DimFactTypes where factTypeCode = @factTypeCode

	CREATE TABLE #selectedDates
	(
		DimDateId int
	)

	CREATE TABLE #factTable
	(
		factId int
	)

	insert into #selectedDates(DimDateId)
	select distinct d.DimDateId	
	from rds.DimDates d		
	inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
	inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId 
	and dm.DataMigrationTypeCode = 'rds'

	

	if @factTypeCode in ('datapopulation', 'submission')
		begin	
				
				if(@reportType='studentcounts')
				begin
					insert into #factTable(factId)
					select FactStudentCountId from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId and DimCountdateId in (select DimDateId from #selectedDates)

					delete from rds.FactStudentCounts where FactStudentCountId in (select factId from #factTable)
	
				end
				else if(@reportType='disciplinecounts')
				begin
					insert into #factTable(factId)
					select FactStudentDisciplineId from rds.FactStudentDisciplines where DimFactTypeId = @dimFactTypeId and DimCountdateId in (select DimDateId from #selectedDates)

					delete from rds.FactStudentDisciplines where FactStudentDisciplineId in (select factId from #factTable)
	
				end
				else if(@reportType='studentassessments')
				begin

					insert into #factTable(factId)
					select FactStudentAssessmentId from rds.FactStudentAssessments where DimFactTypeId = @dimFactTypeId and DimCountdateId in (select DimDateId from #selectedDates)

					delete from rds.FactStudentAssessments where FactStudentAssessmentId in (select factId from #factTable)

				end
				else if(@reportType='personnelcounts')
				begin
					insert into #factTable(factId)
					select FactPersonnelCountId from rds.FactPersonnelCounts where DimFactTypeId = @dimFactTypeId and DimCountdateId in (select DimDateId from #selectedDates)

					delete from rds.FactPersonnelCounts where FactPersonnelCountId in (select factId from #factTable)
				end
				else if(@reportType='studentattendance')
				begin
					insert into #factTable(factId)
					select factK12StudentAttendanceId from rds.FactK12StudentAttendance where DimFactTypeId = @dimFactTypeId and DimCountdateId in (select DimDateId from #selectedDates)

					delete from rds.FactK12StudentAttendance where factK12StudentAttendanceId in (select factId from #factTable)
	
				end
		end	
		else
		begin
			insert into #factTable(factId)
			select FactStudentCountId from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId and DimCountdateId in (select DimDateId from #selectedDates)

			delete from rds.FactStudentCounts where FactStudentCountId in (select factId from #factTable)
		end
	
		drop TABLE #selectedDates
		drop TABLE #factTable
	   	 
	end try
	begin catch

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH; 


END