-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction
	

		declare @PostSecondaryEnrollmentStatusId as int
		declare @PostSecondaryEnrollmentStatusCode as varchar(50)
		declare @PostSecondaryEnrollmentStatusDescription as varchar(200)
		declare @PostSecondaryEnrollmentStatusEdFactsCode as varchar(50)

		declare @PostSecondaryEnrollmentStatusTable table(
				PostSecondaryEnrollmentStatusId int,
				PostSecondaryEnrollmentStatusCode varchar(50),
				PostSecondaryEnrollmentStatusDescription varchar(200),
				PostSecondaryEnrollmentStatusEdFactsCode varchar(50)
		); 

		insert into @PostSecondaryEnrollmentStatusTable (PostSecondaryEnrollmentStatusId, PostSecondaryEnrollmentStatusCode, PostSecondaryEnrollmentStatusDescription, PostSecondaryEnrollmentStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @PostSecondaryEnrollmentStatusTable (PostSecondaryEnrollmentStatusId, PostSecondaryEnrollmentStatusCode, PostSecondaryEnrollmentStatusDescription, PostSecondaryEnrollmentStatusEdFactsCode) 
		values 
		(1, 'NO', 'No information on postsecondary actions', 'NO')

		insert into @PostSecondaryEnrollmentStatusTable (PostSecondaryEnrollmentStatusId, PostSecondaryEnrollmentStatusCode, PostSecondaryEnrollmentStatusDescription, PostSecondaryEnrollmentStatusEdFactsCode) 
		values 
		(2, 'ENROLL', 'Enrolled in an IHE', 'ENROLL')

		insert into @PostSecondaryEnrollmentStatusTable (PostSecondaryEnrollmentStatusId, PostSecondaryEnrollmentStatusCode, PostSecondaryEnrollmentStatusDescription, PostSecondaryEnrollmentStatusEdFactsCode) 
		values 
		(3, 'NOENROLL', 'Did not enroll in an IHE', 'NOENROLL')



		DECLARE dimenrollments_cursor CURSOR FOR 
		SELECT PostSecondaryEnrollmentStatusId, PostSecondaryEnrollmentStatusCode, PostSecondaryEnrollmentStatusDescription, PostSecondaryEnrollmentStatusEdFactsCode
		FROM @PostSecondaryEnrollmentStatusTable
		OPEN dimenrollments_cursor
		FETCH NEXT FROM dimenrollments_cursor INTO @PostSecondaryEnrollmentStatusId, @PostSecondaryEnrollmentStatusCode, @PostSecondaryEnrollmentStatusDescription, @PostSecondaryEnrollmentStatusEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @PostSecondaryEnrollmentStatusCode = 'MISSING'
			begin
				if not exists(select 1 from RDS.DimEnrollment where PostSecondaryEnrollmentStatusCode = @PostSecondaryEnrollmentStatusCode)
				begin
					set identity_insert RDS.DimEnrollment on
						INSERT INTO [RDS].[DimEnrollment]([DimEnrollmentId],[PostSecondaryEnrollmentStatusId], [PostSecondaryEnrollmentStatusCode],[PostSecondaryEnrollmentStatusDescription],[PostSecondaryEnrollmentStatusEdFactsCode])
						VALUES(-1,@PostSecondaryEnrollmentStatusId, @PostSecondaryEnrollmentStatusCode, @PostSecondaryEnrollmentStatusDescription, @PostSecondaryEnrollmentStatusEdFactsCode)						

					set identity_insert RDS.DimEnrollment off
				end
			end
			else
			begin
					
				if not exists(select 1 from RDS.DimEnrollment where PostSecondaryEnrollmentStatusCode = @PostSecondaryEnrollmentStatusCode)
				begin
					INSERT INTO [RDS].[DimEnrollment]([PostSecondaryEnrollmentStatusId],[PostSecondaryEnrollmentStatusCode],[PostSecondaryEnrollmentStatusDescription],[PostSecondaryEnrollmentStatusEdFactsCode])
						VALUES(@PostSecondaryEnrollmentStatusId, @PostSecondaryEnrollmentStatusCode, @PostSecondaryEnrollmentStatusDescription, @PostSecondaryEnrollmentStatusEdFactsCode)			
				end
			end
				FETCH NEXT FROM dimenrollments_cursor INTO @PostSecondaryEnrollmentStatusId, @PostSecondaryEnrollmentStatusCode, @PostSecondaryEnrollmentStatusDescription, @PostSecondaryEnrollmentStatusEdFactsCode
		END

		CLOSE dimenrollments_cursor
		DEALLOCATE dimenrollments_cursor

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
