-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction
	

	------------------------
	-- Place code here
	------------------------
	IF NOT EXISTS (select 1 from RDS.DimDates where [SubmissionYear] = '2018-19')
	BEGIN
		insert into rds.DimDates(DateValue, Day, DayOfWeek, DayOfYear, Month, MonthName,SubmissionYear, Year) 
					      values('2018-11-01 00:00:00.0000000', 1,'Thursday',365, 11,'November','2018-19',2018 )
	END

	IF EXISTS (select 1 from RDS.DimRaces where [RaceDescription] = 'American Indian or Alaskan Native')
	BEGIN
		update RDS.DimRaces set [RaceDescription] = 'American Indian or Alaska Native' where [racecode]= 'AM7'
	END
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
 
set nocount off
