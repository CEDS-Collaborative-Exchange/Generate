-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try

	begin transaction
		declare @indicatorStatusId as int
		declare @indicatorStatusCode as varchar(50)
		declare @indicatorStatusDescription as varchar(200)
		declare @indicatorStatusEdFactsCode as varchar(50)

		declare @indicatorStatusesTable table(
				IndicatorStatusId int,
				IndicatorStatusCode varchar(50),
				IndicatorStatusDescription varchar(200),
				IndicatorStatusEdFactsCode varchar(50)
			); 

		insert into @indicatorStatusesTable (IndicatorStatusId, IndicatorStatusCode, IndicatorStatusDescription, IndicatorStatusEdFactsCode)
		values 
		(-1, 'MISSING', 'The status of the indicator for a specific school is not available at the time the file is prepared.', 'MISSING')

		insert into @indicatorStatusesTable (IndicatorStatusId, IndicatorStatusCode, IndicatorStatusDescription, IndicatorStatusEdFactsCode)
		values 
		(1, 'STTDEF', 'A status defined by the state.  The state defined status is provided in a separate field in the file.', 'STTDEF')

		insert into @indicatorStatusesTable (IndicatorStatusId, IndicatorStatusCode, IndicatorStatusDescription, IndicatorStatusEdFactsCode)
		values 
		(2, 'TOOFEW', 'The number of students in the school or for a student subgroup was less than the minimum group size necessary required to reliably calculate the indicator.', 'TOOFEW')
		insert into @indicatorStatusesTable (IndicatorStatusId, IndicatorStatusCode, IndicatorStatusDescription, IndicatorStatusEdFactsCode)
		values 
		(3, 'NOSTUDENTS', 'There are no students in a student subgroup.  Alternatively, the row can be left out of the file.  If no students are in the school, the school should not be included in this file.', 'NOSTUDENTS')

		DECLARE indicatorStatuses_cursor CURSOR FOR 
		SELECT IndicatorStatusId, IndicatorStatusCode, IndicatorStatusDescription, IndicatorStatusEdFactsCode
		FROM @indicatorStatusesTable

		OPEN indicatorStatuses_cursor

		FETCH NEXT FROM indicatorStatuses_cursor INTO @indicatorStatusId, @indicatorStatusCode, @indicatorStatusDescription, @indicatorStatusEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @indicatorStatusCode = 'MISSING'
			begin
				if not exists(select 1 from RDS.DimIndicatorStatuses where IndicatorStatusCode = @indicatorStatusCode)
				begin
					set identity_insert RDS.DimIndicatorStatuses on
						INSERT INTO RDS.DimIndicatorStatuses
						(
							DimIndicatorStatusId,
							IndicatorStatusId,
							IndicatorStatusCode,
							IndicatorStatusDescription,
							IndicatorStatusEdFactsCode
						)
						VALUES 
						(
							-1,
							@indicatorStatusId, 
							@indicatorStatusCode, 
							@indicatorStatusDescription, 
							@indicatorStatusEdFactsCode
						)						

					set identity_insert RDS.DimIndicatorStatuses off
				end
			end
			else
			begin
					
				if not exists(select 1 from RDS.DimIndicatorStatuses where IndicatorStatusCode = @indicatorStatusCode)
				begin
					INSERT INTO RDS.DimIndicatorStatuses
					(
						IndicatorStatusId,
						IndicatorStatusCode,
						IndicatorStatusDescription,
						IndicatorStatusEdFactsCode
					)
					VALUES
					(
						@indicatorStatusId, 
						@indicatorStatusCode, 
						@indicatorStatusDescription, 
						@indicatorStatusEdFactsCode
					)
				end
			end
		FETCH NEXT FROM indicatorStatuses_cursor INTO @indicatorStatusId, @indicatorStatusCode, @indicatorStatusDescription, @indicatorStatusEdFactsCode
		END

		CLOSE indicatorStatuses_cursor
		DEALLOCATE indicatorStatuses_cursor
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
