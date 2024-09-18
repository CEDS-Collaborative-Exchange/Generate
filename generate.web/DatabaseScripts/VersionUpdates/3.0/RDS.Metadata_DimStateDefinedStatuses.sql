-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------
set nocount on
begin try
	begin transaction
		declare @stateDefinedStatusId as int
		declare @stateDefinedStatusCode as varchar(50)
		declare @stateDefinedStatusDescription as varchar(200)

		declare @stateDefinedStatusesTable table(
				StateDefinedStatusId int,
				StateDefinedStatusCode varchar(50),
				StateDefinedStatusDescription varchar(200)
			); 

		insert into @stateDefinedStatusesTable (StateDefinedStatusId, StateDefinedStatusCode, StateDefinedStatusDescription) 
		values 
		(-1, 'Missing', 'State Defined Status not set')

		insert into @stateDefinedStatusesTable (StateDefinedStatusId, StateDefinedStatusCode, StateDefinedStatusDescription) 
		values 
		(1, 'Green', 'State Defined Status Green')

		insert into @stateDefinedStatusesTable (StateDefinedStatusId, StateDefinedStatusCode, StateDefinedStatusDescription) 
		values 
		(2, 'Yellow', 'State Defined Status Yellow')
		insert into @stateDefinedStatusesTable (StateDefinedStatusId, StateDefinedStatusCode, StateDefinedStatusDescription) 
		values 
		(3, 'Blue', 'State Defined Status Blue')

		DECLARE statedefinedstatus_cursor CURSOR FOR 
		SELECT StateDefinedStatusId, StateDefinedStatusCode, StateDefinedStatusDescription
		FROM @stateDefinedStatusesTable

		OPEN statedefinedstatus_cursor

		FETCH NEXT FROM statedefinedstatus_cursor INTO @stateDefinedStatusId, @stateDefinedStatusCode, @stateDefinedStatusDescription
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @stateDefinedStatusCode = 'MISSING'
			begin
				if not exists(select 1 from RDS.DimStateDefinedStatuses where StateDefinedStatusCode = @stateDefinedStatusCode)
				begin
					set identity_insert RDS.DimStateDefinedStatuses on
						INSERT INTO RDS.DimStateDefinedStatuses
						(
							DimStateDefinedStatusId,
							StateDefinedStatusId, 
							StateDefinedStatusCode, 
							StateDefinedStatusDescription
						)
						VALUES 
						(
							-1,
							@stateDefinedStatusId,
							@stateDefinedStatusCode, 
							@stateDefinedStatusDescription
						)						

					set identity_insert RDS.DimStateDefinedStatuses off
				end
			end
			else
			begin
				if not exists(select 1 from RDS.DimStateDefinedStatuses where StateDefinedStatusCode = @stateDefinedStatusCode)
				begin
					INSERT INTO RDS.DimStateDefinedStatuses
					(
						StateDefinedStatusId, 
						StateDefinedStatusCode, 
						StateDefinedStatusDescription
					)
					VALUES
					(
						@stateDefinedStatusId,
						@stateDefinedStatusCode, 
						@stateDefinedStatusDescription)
				end
			end
		FETCH NEXT FROM statedefinedstatus_cursor INTO @stateDefinedStatusId, @stateDefinedStatusCode, @stateDefinedStatusDescription
		END
		CLOSE statedefinedstatus_cursor
		DEALLOCATE statedefinedstatus_cursor
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
