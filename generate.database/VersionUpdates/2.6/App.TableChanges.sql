-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction

	------------------------
	-- Place code here
	------------------------
	IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[RDS].[DimDataMigrationTypes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	DECLARE @count as int
	SELECT @count=count(*) from rds.DimDataMigrationTypes
	if(@count=0)
		BEGIN		
			INSERT INTO RDS.DimDataMigrationTypes(DataMigrationTypeCode, DataMigrationTypeName)
			SELECT DataMigrationTypeCode, DataMigrationTypeName FROM APP.DataMigrationTypes
		END
	END 


	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'IsLocked' AND Object_ID = Object_ID(N'App.GenerateReports'))
	BEGIN
		ALTER TABLE App.GenerateReports ADD IsLocked  bit not null  default 0;
	END

	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'App.GenerateReports'))
	--BEGIN
	--	ALTER TABLE App.GenerateReports ADD Description  nvarchar(max)
	--END

	IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[RDS].[DimDateDataMigrationTypes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	SELECT @count=count(*) from rds.DimDateDataMigrationTypes
	if(@count=0)
		BEGIN
		declare @dimdateid as int
		DECLARE date_cursor CURSOR FOR 
				select DimDateId from rds.DimDates where DimDateId<>-1
			OPEN date_cursor
			FETCH NEXT FROM date_cursor INTO @dimdateid
			WHILE @@FETCH_STATUS = 0
				BEGIN		
					INSERT INTO rds.DimDateDataMigrationTypes (DimDateId, DataMigrationTypeId, IsSelected)
					SELECT DimDateId AS DimDateId , DimDataMigrationTypeId AS DataMigrationTypeId , 1 AS IsSelected FROM rds.DimDates
					cross join rds.DimDataMigrationTypes where DimDateId=@dimdateid			
			FETCH NEXT FROM date_cursor INTO @dimdateid
			END						
			CLOSE date_cursor
			DEALLOCATE date_cursor			
		END
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
