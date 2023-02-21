-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction
	

			declare @firearmsId as int
			declare @firearmsCode as varchar(50)
			declare @firearmsDescription as varchar(200)
			declare @firearmsEdFactsCode as varchar(50)

			declare @firearmsTable table(
				FirearmsId int,
				FirearmsCode varchar(50),
				FirearmsDescription varchar(200),
				FirearmsEdFactsCode varchar(50)
			); 

			insert into @fireArmsTable (FirearmsId, FirearmsCode, FirearmsDescription, FirearmsEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @fireArmsTable (FirearmsId, FirearmsCode, FirearmsDescription, FirearmsEdFactsCode) 
			values 
			(1, 'HANDGUNS', 'Handguns', 'HANDGUNS')

			insert into @fireArmsTable (FirearmsId, FirearmsCode, FirearmsDescription, FirearmsEdFactsCode) 
			values 
			(2, 'RIFLESHOTGUN', 'Rifles / Shotguns', 'RIFLESHOTGUN')
			insert into @fireArmsTable (FirearmsId, FirearmsCode, FirearmsDescription, FirearmsEdFactsCode) 
			values 
			(3, 'OTHER', 'Any firearm that is not a handgun or a rifle or a shotgun.', 'OTHER')
				insert into @fireArmsTable (FirearmsId, FirearmsCode, FirearmsDescription, FirearmsEdFactsCode) 
			values 
			(4, 'MULTIPLE', 'Use of more than one of the above.', 'MULTIPLE')

		DECLARE firearms_cursor CURSOR FOR 
		SELECT FirearmsId, FirearmsCode, FirearmsDescription, FirearmsEdFactsCode
		FROM @firearmsTable
		OPEN firearms_cursor
		FETCH NEXT FROM firearms_cursor INTO @firearmsId, @firearmsCode, @firearmsDescription, @firearmsEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @firearmsCode = 'MISSING'
			begin
				if not exists(select 1 from RDS.DimFirearms where FirearmsCode = @firearmsCode)
				begin
					set identity_insert RDS.DimFirearms on
						INSERT INTO [RDS].[DimFirearms](DimFirearmsId,[FirearmsCode],[FirearmsDescription],[FirearmsEdFactsCode],[FirearmsId])
						VALUES(-1,@firearmsCode, @firearmsDescription, @firearmsEdFactsCode, @firearmsId)						

					set identity_insert RDS.DimFirearms off
				end
			end
			else
			begin
					
				if not exists(select 1 from RDS.DimFirearms where FirearmsCode = @firearmsCode)
				begin
					INSERT INTO [RDS].[DimFirearms]([FirearmsCode],[FirearmsDescription],[FirearmsEdFactsCode],[FirearmsId])
						VALUES(@firearmsCode, @firearmsDescription, @firearmsEdFactsCode, @firearmsId)			
				end
			end
		FETCH NEXT FROM firearms_cursor INTO @firearmsId, @firearmsCode, @firearmsDescription, @firearmsEdFactsCode
		END

		CLOSE firearms_cursor
		DEALLOCATE firearms_cursor

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
