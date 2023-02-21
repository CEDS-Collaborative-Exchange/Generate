-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction
	

			declare @schoolStateStatusId as int
			declare @schoolStateStatusCode as varchar(50)
			declare @schoolStateStatusDescription as varchar(200)
			declare @schoolStateStatusEdFactsCode as varchar(50)

			declare @schoolStateStatusTable table(
				SchoolStateStatusId int,
				SchoolStateStatusCode varchar(50),
				SchoolStateStatusDescription varchar(200),
				SchoolStateStatusEdFactsCode varchar(50)
			); 

			insert into @schoolStateStatusTable (SchoolStateStatusId, SchoolStateStatusCode, SchoolStateStatusDescription, SchoolStateStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @schoolStateStatusTable (SchoolStateStatusId, SchoolStateStatusCode, SchoolStateStatusDescription, SchoolStateStatusEdFactsCode) 
			values 
			(1, 'Blue', 'Blue', 'Blue')

			insert into @schoolStateStatusTable (SchoolStateStatusId, SchoolStateStatusCode, SchoolStateStatusDescription, SchoolStateStatusEdFactsCode) 
			values 
			(2, 'Green', 'Green', 'Green')

			insert into @schoolStateStatusTable (SchoolStateStatusId, SchoolStateStatusCode, SchoolStateStatusDescription, SchoolStateStatusEdFactsCode) 
			values 
			(3, 'Yellow', 'Yellow', 'Yellow')

		DECLARE schoolStateStatus_cursor CURSOR FOR 
		SELECT SchoolStateStatusId, SchoolStateStatusCode, SchoolStateStatusDescription, SchoolStateStatusEdFactsCode
		FROM @schoolStateStatusTable

		OPEN schoolStateStatus_cursor
		FETCH NEXT FROM schoolStateStatus_cursor INTO @schoolStateStatusId, @schoolStateStatusCode, @schoolStateStatusDescription, @schoolStateStatusEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			if  @schoolStateStatusCode = 'MISSING'
			begin

				if not exists(select 1 from RDS.DimSchoolStateStatus where SchoolStateStatusCode = @schoolStateStatusCode)
				begin

					set identity_insert RDS.DimSchoolStateStatus on

						INSERT INTO [RDS].[DimSchoolStateStatus](DimSchoolStateStatusId,[SchoolStateStatusId], [SchoolStateStatusCode], [SchoolStateStatusDescription], [SchoolStateStatusEdFactsCode])
									VALUES(-1, @schoolStateStatusId, @schoolStateStatusCode, @schoolStateStatusDescription, @schoolStateStatusEdFactsCode)						

					set identity_insert RDS.DimSchoolStateStatus off
				end
			end
			else
			begin
					
				if not exists(select 1 from RDS.DimSchoolStateStatus where SchoolStateStatusCode = @schoolStateStatusCode)
				begin
					INSERT INTO [RDS].[DimSchoolStateStatus]([SchoolStateStatusId], [SchoolStateStatusCode], [SchoolStateStatusDescription], [SchoolStateStatusEdFactsCode])
						VALUES(@schoolStateStatusId, @schoolStateStatusCode, @schoolStateStatusDescription, @schoolStateStatusEdFactsCode)		
				end


			end


		FETCH NEXT FROM schoolStateStatus_cursor INTO @schoolStateStatusId, @schoolStateStatusCode, @schoolStateStatusDescription, @schoolStateStatusEdFactsCode
		END

		CLOSE schoolStateStatus_cursor
		DEALLOCATE schoolStateStatus_cursor

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
