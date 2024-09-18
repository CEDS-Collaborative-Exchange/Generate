-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction

		declare @factTypeId as int, @factTypeCode as varchar(50), @submissionFactTypeID as int
				
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'membership')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('membership','Memebership')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'dropout')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('dropout','Dropout')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'grad')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('grad','Graduation/Completer')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'titleIIIELOct')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('titleIIIELOct','Title III EL Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'titleIIIELSY')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('titleIIIELSY','Title III EL Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'sppapr')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('sppapr','SPP APR Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'titleI')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('titleI','Title I Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'mep')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('mep','MEP Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'immigrant')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('immigrant','Immigrant Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'nord')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('nord','N or D Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'homeless')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('homeless','Homeless Students')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'chronic')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('chronic','Chronic Absenteeism')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'gradrate')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('gradrate','Grad Rate')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'hsgradenroll')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('hsgradenroll','HS Grad PS Enrollment')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'other')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('other','Other Reports like State defined reports')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'directory')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('directory','Directory related reports')
		END
		if not exists(select 1 from rds.DimFactTypes where FactTypeCode = 'organizationstatus')
		BEGIN
			INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription]) values('organizationstatus','Organization Status related reports')
		END


		
		select @submissionFactTypeID = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'submission'

		DECLARE race_cursor CURSOR FOR 
		select DimFactTypeId, FactTypeCode from rds.DimFactTypes Where DimFactTypeId > 0

		OPEN race_cursor
		FETCH NEXT FROM race_cursor INTO @factTypeId, @factTypeCode

		WHILE @@FETCH_STATUS = 0
		BEGIN
	
			IF NOT EXISTS(Select 1 from rds.DimRaces where DimFactTypeId = @factTypeId)
			BEGIN
				INSERT INTO [RDS].[DimRaces]([DimFactTypeId],[RaceCode],[RaceDescription])
				Select @factTypeId, RaceCode, RaceDescription from 
				rds.DimRaces Where DimFactTypeId = @submissionFactTypeID
			END
			FETCH NEXT FROM race_cursor INTO @factTypeId, @factTypeCode
		END

		CLOSE race_cursor
		DEALLOCATE race_cursor

		Update rds.DimRaces set RaceId = DimRaceId Where RaceId IS NULL AND DimRaceId > 0

	  select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'organizationstatus'

	 Update rds.DimRaces set RaceCode = 'AmericanIndianorAlaskaNative' where RaceCode = 'AM7' and DimFactTypeId = @factTypeId
	 Update rds.DimRaces set RaceCode = 'Asian' where RaceCode = 'AS7' and DimFactTypeId = @factTypeId
	 Update rds.DimRaces set RaceCode = 'BlackorAfricanAmerican' where RaceCode = 'BL7' and DimFactTypeId = @factTypeId
	 Update rds.DimRaces set RaceCode = 'HI' where RaceCode = 'HI7' and DimFactTypeId = @factTypeId
	 Update rds.DimRaces set RaceCode = 'NativeHawaiianorOtherPacificIslander' where RaceCode = 'PI7' and DimFactTypeId = @factTypeId
	 Update rds.DimRaces set RaceCode = 'White' where RaceCode = 'WH7' and DimFactTypeId = @factTypeId
	 Update rds.DimRaces set RaceCode = 'TwoorMoreRaces' where RaceCode = 'MU7' and DimFactTypeId = @factTypeId
  

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
