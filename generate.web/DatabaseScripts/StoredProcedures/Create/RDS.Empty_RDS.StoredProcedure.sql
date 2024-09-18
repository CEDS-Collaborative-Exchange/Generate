CREATE PROCEDURE [RDS].[Empty_RDS]
	@factTypeCode as varchar(50)
AS
BEGIN

begin try
	
	declare @dimFactTypeId as int
	select @dimFactTypeId = DimFactTypeId
	from rds.DimFactTypes where factTypeCode = @factTypeCode

	CREATE TABLE #selectedSchoolYears
	(
		DimSchoolYearId int
	)

	CREATE TABLE #factTable
	(
		factId int
	)

	insert into #selectedSchoolYears(DimSchoolYearId)
	select distinct d.DimSchoolYearId
	from rds.DimSchoolYears d		
	inner join rds.DimSchoolYearDataMigrationTypes dd on dd.DimSchoolYearId = d.DimSchoolYearId and dd.IsSelected = 1
	inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId = dd.DataMigrationTypeId 
	and dm.DataMigrationTypeCode = 'rds'

		
		if @factTypeCode = 'discipline'
		begin	
			insert into #factTable(factId)
			select FactK12StudentDisciplineId from rds.FactK12StudentDisciplines 
			where FactTypeId = @dimFactTypeId and SchoolYearId in (select DimSchoolYearId from #selectedSchoolYears)

			delete from rds.FactK12StudentDisciplines where FactK12StudentDisciplineId in (select factId from #factTable)
		end
		else if @factTypeCode = 'staff'
		begin	
			insert into #factTable(factId)
			select FactK12StaffCountId from rds.FactK12StaffCounts 
			where FactTypeId = @dimFactTypeId and SchoolYearId in (select DimSchoolYearId from #selectedSchoolYears)

			delete from rds.FactK12StaffCounts where FactK12StaffCountId in (select factId from #factTable)
		end
		else if @factTypeCode = 'assessment'
		begin	
			insert into #factTable(factId)
			select FactK12StudentAssessmentId from rds.FactK12StudentAssessments 
			where FactTypeId = @dimFactTypeId and SchoolYearId in (select DimSchoolYearId from #selectedSchoolYears)

			delete from RDS.BridgeK12StudentAssessmentRaces where FactK12StudentAssessmentId in (select factId from #factTable)

			delete from RDS.BridgeK12StudentAssessmentAccommodations where FactK12StudentAssessmentId in (select factId from #factTable)

			delete from rds.FactK12StudentAssessments where FactK12StudentAssessmentId in (select factId from #factTable)
		end
		else if @factTypeCode = 'attendance'
		begin	
			insert into #factTable(factId)
			select factK12StudentAttendanceRateId from rds.FactK12StudentAttendanceRates 
			where FactTypeId = @dimFactTypeId and SchoolYearId in (select DimSchoolYearId from #selectedSchoolYears)

			delete from rds.FactK12StudentAttendanceRates where factK12StudentAttendanceRateId in (select factId from #factTable)
		end
		else
		begin
			insert into #factTable(factId)
			select FactK12StudentCountId from rds.FactK12StudentCounts where FactTypeId = @dimFactTypeId and SchoolYearId in (select DimSchoolYearId from #selectedSchoolYears)

			delete from rds.FactK12StudentCounts where FactK12StudentCountId in (select factId from #factTable)
		end
	
		drop TABLE #selectedSchoolYears
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