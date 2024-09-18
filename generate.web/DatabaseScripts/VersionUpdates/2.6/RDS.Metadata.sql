-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction

	IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[RDS].[DimDataMigrationTypes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		declare @dataMigrationTypeCode as varchar(50)
		DECLARE dataMigrationType_cursor CURSOR FOR 
				SELECT DataMigrationTypeCode FROM APP.DataMigrationTypes
			OPEN dataMigrationType_cursor
			FETCH NEXT FROM dataMigrationType_cursor INTO @dataMigrationTypeCode
			WHILE @@FETCH_STATUS = 0
				BEGIN	
				If NOT EXISTS(select 1 from RDS.DimDataMigrationTypes where DataMigrationTypeCode=@dataMigrationTypeCode)
				BEGIN
				INSERT INTO RDS.DimDataMigrationTypes(DataMigrationTypeCode, DataMigrationTypeName)
					SELECT DataMigrationTypeCode, DataMigrationTypeName FROM APP.DataMigrationTypes where DataMigrationTypeCode=@dataMigrationTypeCode
				END
			FETCH NEXT FROM dataMigrationType_cursor INTO @dataMigrationTypeCode
			END						
			CLOSE dataMigrationType_cursor
			DEALLOCATE dataMigrationType_cursor		
	END 



	IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[RDS].[DimDateDataMigrationTypes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		declare @dimdateid as int
		DECLARE date_cursor CURSOR FOR 
				select DimDateId from rds.DimDates where DimDateId<>-1
			OPEN date_cursor
			FETCH NEXT FROM date_cursor INTO @dimdateid
			WHILE @@FETCH_STATUS = 0
				BEGIN	
				If NOT EXISTS(select 1 from RDS.DimDateDataMigrationTypes where DimDateId=@dimdateid)
				BEGIN
					INSERT INTO rds.DimDateDataMigrationTypes (DimDateId, DataMigrationTypeId, IsSelected)
					SELECT DimDateId AS DimDateId , DimDataMigrationTypeId AS DataMigrationTypeId , 1 AS IsSelected FROM rds.DimDates
					cross join rds.DimDataMigrationTypes where DimDateId=@dimdateid	
				END
			FETCH NEXT FROM date_cursor INTO @dimdateid
			END						
			CLOSE date_cursor
			DEALLOCATE date_cursor			
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
