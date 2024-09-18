CREATE PROCEDURE [RDS].[Empty_RDS]
	@factTypeCode as varchar(50),
	@reportType as varchar(50)=null
AS
BEGIN

begin try
	begin transaction


	declare @dimFactTypeId as int
	select @dimFactTypeId = DimFactTypeId
	from rds.DimFactTypes where factTypeCode = @factTypeCode

	if @factTypeCode in ('datapopulation', 'submission')
		begin	
				
				if(@reportType='studentcounts')
				begin
					delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId
		and DimCountdateId in (
					select distinct d.DimDateId	from rds.DimDates d		
					inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
					inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId 
					and dm.DataMigrationTypeCode = 'rds')
	
				end
				else if(@reportType='disciplinecounts')
				begin
					delete from rds.FactStudentDisciplines where DimFactTypeId = @dimFactTypeId
					and DimCountdateId in (
					select distinct d.DimDateId	from rds.DimDates d		
					inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
					inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId 
					and dm.DataMigrationTypeCode = 'rds')
	
				end
				else if(@reportType='studentassessments')
				begin
					delete from rds.FactStudentAssessments where DimFactTypeId = @dimFactTypeId
					and DimCountdateId in (
					select distinct d.DimDateId	from rds.DimDates d		
					inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
					inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId 
					and dm.DataMigrationTypeCode = 'rds')
	
				end
				else if(@reportType='personnelcounts')
				begin
					delete from rds.FactPersonnelCounts where DimFactTypeId = @dimFactTypeId
					and DimCountdateId in (
					select distinct d.DimDateId	from rds.DimDates d		
					inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
					inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId 
					and dm.DataMigrationTypeCode = 'rds')
	
				end
		end	
		else
		begin
			delete from rds.FactStudentCounts where DimFactTypeId = @dimFactTypeId
			and DimCountdateId in (
					select distinct d.DimDateId	from rds.DimDates d		
					inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1
					inner join app.DataMigrationTypes dm on dm.DataMigrationTypeId=dd.DataMigrationTypeId 
					and dm.DataMigrationTypeCode = 'rds')
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