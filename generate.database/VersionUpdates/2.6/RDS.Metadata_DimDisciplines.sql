-- DimFirearmDisciplines

set nocount on;

begin try
	begin transaction


		declare @firearmsDisciplineId as int
		declare @firearmsDisciplineCode as varchar(50)
		declare @firearmsDisciplineDescription as varchar(200)
		declare @firearmsDisciplineEdFactsCode as varchar(50)

		declare @firearmsDisciplineTable table(
			firearmsDisciplineId int,
			firearmsDisciplineCode varchar(50),
			firearmsDisciplineDescription varchar(200),
			firearmsDisciplineEdFactsCode varchar(50)
		); 

		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(1, 'EXPNOTMODNOALT', 'Received the one year expulsion and who did not receive educational services', 'EXPNOTMODNOALT')

		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(2, 'EXPALT', 'Received the one year expulsion and were provided with educational services', 'EXPALT')

		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(3, 'EXPMODNOALT', 'Received expulsion modified to less than one year and did not receive educational services', 'EXPMODNOALT')

		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(4, 'EXPMODALT', 'Received expulsion modified to less than one year and were provided with educational services ', 'EXPMODALT')
		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(5, 'REMOVEOTHER', 'no expulsion because the student was removed for other reasons such as death, withdrawal, or incarceration', 'REMOVEOTHER')
		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(6, 'OTHERDISACTION', 'received another type of disciplinary action', 'OTHERDISACTION')
		insert into @firearmsDisciplineTable (firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode) 
		values 
		(7, 'NOACTION', 'No disciplinary action', 'NOACTION')

		declare @IDEAFirearmsDisciplineId as int
		declare @IDEAFirearmsDisciplineCode as varchar(50)
		declare @IDEAFirearmsDisciplineDescription as varchar(200)
		declare @IDEAFirearmsDisciplineEdFactsCode as varchar(50)

		declare @IDEAFirearmsDisciplineTable table(
					IDEAFirearmsDisciplineId int,
					IDEAFirearmsDisciplineCode varchar(50),
					IDEAFirearmsDisciplineDescription varchar(200),
					IDEAFirearmsDisciplineEdFactsCode varchar(50)
		); 

		insert into @IDEAFirearmsDisciplineTable (IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @IDEAFirearmsDisciplineTable (IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode) 
		values 
		(1, 'EXPMOD', 'Received an expulsion that was modified to less than one year and received educational services under IDEA', 'EXPMOD')

		insert into @IDEAFirearmsDisciplineTable (IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode) 
		values 
		(2, 'EXPNOTMOD', 'Received a one year expulsion and received educational services under IDEA', 'EXPNOTMOD')

		insert into @IDEAFirearmsDisciplineTable (IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode) 
		values 
		(3, 'REMOVEOTHER', 'No expulsion because the student was removed for other reasons such as death, withdrawal, or incarceration', 'REMOVEOTHER')

		insert into @IDEAFirearmsDisciplineTable (IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode)  
		values 
		(4, 'OTHERDISACTION', 'Received another type of disciplinary action', 'OTHERDISACTION')
		insert into @IDEAFirearmsDisciplineTable (IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode) 
		values 
		(5, 'NOACTION', 'No disciplinary action', 'NOACTION')

					DECLARE firearmDiscipline_cursor CURSOR FOR 
					SELECT firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode
					FROM @firearmsDisciplineTable

					OPEN firearmDiscipline_cursor
					FETCH NEXT FROM firearmDiscipline_cursor INTO @firearmsDisciplineId, @firearmsDisciplineCode, @firearmsDisciplineDescription, @firearmsDisciplineEdFactsCode

					WHILE @@FETCH_STATUS = 0
					BEGIN

							DECLARE IDEAfirearmDiscipline_cursor CURSOR FOR 
							SELECT IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode
							FROM @IDEAFirearmsDisciplineTable
									
							OPEN IDEAfirearmDiscipline_cursor
							FETCH NEXT FROM IDEAfirearmDiscipline_cursor INTO @IDEAFirearmsDisciplineId, @IDEAFirearmsDisciplineCode, @IDEAFirearmsDisciplineDescription, @IDEAFirearmsDisciplineEdFactsCode
									
							WHILE @@FETCH_STATUS = 0
							BEGIN

						
							if @firearmsDisciplineCode = 'MISSING' and @IDEAFirearmsDisciplineCode = 'MISSING'
							begin

										if not exists(select 1 from RDS.DimFirearmsDiscipline where firearmsDisciplineCode = @firearmsDisciplineCode 
											and IDEAFirearmsDisciplineCode = @IDEAFirearmsDisciplineCode)
											begin


								set identity_insert rds.DimFirearmsDiscipline on

								insert into RDS.DimFirearmsDiscipline
								(
									DimFirearmsDisciplineId,
									firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode,
									IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode
								)
								values
								(
								-1,
								@firearmsDisciplineId, @firearmsDisciplineCode, @firearmsDisciplineDescription, @firearmsDisciplineEdFactsCode,
								@IDEAFirearmsDisciplineId, @IDEAFirearmsDisciplineCode, @IDEAFirearmsDisciplineDescription, @IDEAFirearmsDisciplineEdFactsCode
								)

								set identity_insert rds.DimFirearmsDiscipline off
							end
							end
							else
							begin
								if not exists(select 1 from RDS.DimFirearmsDiscipline where  firearmsDisciplineCode = @firearmsDisciplineCode and IDEAFirearmsDisciplineCode = @IDEAFirearmsDisciplineCode)
											begin

								insert into RDS.DimFirearmsDiscipline
								(
									firearmsDisciplineId, firearmsDisciplineCode, firearmsDisciplineDescription, firearmsDisciplineEdFactsCode,
									IDEAFirearmsDisciplineId, IDEAFirearmsDisciplineCode, IDEAFirearmsDisciplineDescription, IDEAFirearmsDisciplineEdFactsCode
								)
								values
								(
								@firearmsDisciplineId, @firearmsDisciplineCode, @firearmsDisciplineDescription, @firearmsDisciplineEdFactsCode,
								@IDEAFirearmsDisciplineId, @IDEAFirearmsDisciplineCode, @IDEAFirearmsDisciplineDescription, @IDEAFirearmsDisciplineEdFactsCode
								)

							end
							end

							FETCH NEXT FROM IDEAfirearmDiscipline_cursor INTO @IDEAFirearmsDisciplineId, @IDEAFirearmsDisciplineCode, @IDEAFirearmsDisciplineDescription, @IDEAFirearmsDisciplineEdFactsCode
							END
							CLOSE IDEAfirearmDiscipline_cursor
							DEALLOCATE IDEAfirearmDiscipline_cursor


					FETCH NEXT FROM firearmDiscipline_cursor INTO @firearmsDisciplineId, @firearmsDisciplineCode, @firearmsDisciplineDescription, @firearmsDisciplineEdFactsCode
					END
					CLOSE firearmDiscipline_cursor
					DEALLOCATE firearmDiscipline_cursor
				
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

set nocount off;