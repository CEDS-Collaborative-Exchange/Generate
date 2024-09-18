-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction
	

			declare @absenteeismId as int
			declare @absenteeismCode as varchar(50)
			declare @absenteeismDescription as varchar(200)
			declare @absenteeismEdFactsCode as varchar(50)

			declare @absenteeismTable table(
				AbsenteeismId int,
				AbsenteeismCode varchar(50),
				AbsenteeismDescription varchar(200),
				AbsenteeismEdFactsCode varchar(50)
			); 

			insert into @absenteeismTable (AbsenteeismId, AbsenteeismCode, AbsenteeismDescription, AbsenteeismEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @absenteeismTable (AbsenteeismId, AbsenteeismCode, AbsenteeismDescription, AbsenteeismEdFactsCode) 
			values 
			(1, 'CA', 'Chronic Absenteeism', 'CA')

			insert into @absenteeismTable (AbsenteeismId, AbsenteeismCode, AbsenteeismDescription, AbsenteeismEdFactsCode) 
			values 
			(2, 'NCA', 'Non Chronic Absenteeism', 'NCA')

		DECLARE attendance_cursor CURSOR FOR 
		SELECT AbsenteeismId, AbsenteeismCode, AbsenteeismDescription, AbsenteeismEdFactsCode
		FROM @absenteeismTable

		OPEN attendance_cursor
		FETCH NEXT FROM attendance_cursor INTO @absenteeismId, @absenteeismCode, @absenteeismDescription, @absenteeismEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			if  @absenteeismCode = 'MISSING'
			begin

				if not exists(select 1 from RDS.DimAttendance where AbsenteeismCode = @absenteeismCode)
				begin

					set identity_insert RDS.DimAttendance on

						INSERT INTO [RDS].[DimAttendance](DimAttendanceId,[AbsenteeismCode],[AbsenteeismDescription],[AbsenteeismEdFactsCode],[AbsenteeismId])
						VALUES(-1,@absenteeismCode, @absenteeismDescription, @absenteeismEdFactsCode, @absenteeismId)						

					set identity_insert RDS.DimAttendance off
				end
			end
			else
			begin
					
				if not exists(select 1 from RDS.DimAttendance where AbsenteeismCode = @absenteeismCode)
				begin
					INSERT INTO [RDS].[DimAttendance]([AbsenteeismCode],[AbsenteeismDescription],[AbsenteeismEdFactsCode],[AbsenteeismId])
						VALUES(@absenteeismCode, @absenteeismDescription, @absenteeismEdFactsCode, @absenteeismId)		
				end


			end


		FETCH NEXT FROM attendance_cursor INTO @absenteeismId, @absenteeismCode, @absenteeismDescription, @absenteeismEdFactsCode
		END

		CLOSE attendance_cursor
		DEALLOCATE attendance_cursor

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
