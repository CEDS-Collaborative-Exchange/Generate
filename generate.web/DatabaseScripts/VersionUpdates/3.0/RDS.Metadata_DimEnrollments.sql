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

		declare @academicorvocationaloutcomeId as int
		declare @academicorvocationaloutcomeCode as varchar(50)
		declare @academicorvocationaloutcomeDescription as varchar(200)
		declare @academicorvocationaloutcomeEdFactsCode as varchar(50)

		declare @academicorvocationaloutcomeTable table(
					academicorvocationaloutcomeId int,
					academicorvocationaloutcomeCode varchar(50),
					academicorvocationaloutcomeDescription varchar(200),
					academicorvocationaloutcomeEdFactsCode varchar(50)
		); 

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(1, 'EARNCRE', 'Earned high school course credits', 'EARNCRE')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(2, 'ENROLLGED', 'Enrolled in a GED program', 'ENROLLGED')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(3, 'EARNGED', 'Earned a GED', 'EARNGED')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode)  
		values 
		(4, 'EARNDIPL', 'Obtained high school diploma', 'EARNDIPL')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(5, 'POSTSEC', 'Accepted and/or enrolled into post-secondary education', 'POSTSEC')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(5, 'ENROLLTRAIN ', 'Enrolled in job training courses/programs', 'ENROLLTRAIN ')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(5, 'OBTAINEMP', 'Obtained employment', 'OBTAINEMP')

					DECLARE postsecondaryenrollmentstatus_cur CURSOR FOR 
					SELECT postsecondaryenrollmentstatusId, postsecondaryenrollmentstatusCode, postsecondaryenrollmentstatusDescription, postsecondaryenrollmentstatusEdFactsCode
					FROM @postsecondaryenrollmentstatusTable

					OPEN postsecondaryenrollmentstatus_cur
					FETCH NEXT FROM postsecondaryenrollmentstatus_cur INTO @postsecondaryenrollmentstatusId, @postsecondaryenrollmentstatusCode, @postsecondaryenrollmentstatusDescription, @postsecondaryenrollmentstatusEdFactsCode

					WHILE @@FETCH_STATUS = 0
					BEGIN

							DECLARE academicorvocationaloutcome_cur CURSOR FOR 
							SELECT academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode
							FROM @academicorvocationaloutcomeTable
									
							OPEN academicorvocationaloutcome_cur
							FETCH NEXT FROM academicorvocationaloutcome_cur INTO @academicorvocationaloutcomeId, @academicorvocationaloutcomeCode, @academicorvocationaloutcomeDescription, @academicorvocationaloutcomeEdFactsCode
									
							WHILE @@FETCH_STATUS = 0
							BEGIN

						
							if @postsecondaryenrollmentstatusCode = 'MISSING' and @academicorvocationaloutcomeCode = 'MISSING'
							begin

								if not exists(select 1 from RDS.DimEnrollment where postsecondaryenrollmentstatusCode = @postsecondaryenrollmentstatusCode 
									and academicorvocationaloutcomeCode = @academicorvocationaloutcomeCode)
								begin

									if exists(select 1 from RDS.DimEnrollment where postsecondaryenrollmentstatusCode = @postsecondaryenrollmentstatusCode 
										and academicorvocationaloutcomeCode IS NULL)
									begin
										UPDATE [RDS].[DimEnrollment]
										   SET 
												[AcademicOrVocationalOutcomeCode] = @academicorvocationaloutcomeCode
											  ,[AcademicOrVocationalOutcomeDescription] = @academicorvocationaloutcomeDescription
											  ,[AcademicOrVocationalOutcomeEdFactsCode] = @academicorvocationaloutcomeEdFactsCode
											  ,[AcademicOrVocationalOutcomeId] = @academicorvocationaloutcomeId 
										 WHERE postsecondaryenrollmentstatusCode = @postsecondaryenrollmentstatusCode 
												and academicorvocationaloutcomeCode IS NULL
									end
									else
									begin
										set identity_insert rds.DimEnrollment on

										insert into RDS.DimEnrollment
										(
											DimEnrollmentId,
											postsecondaryenrollmentstatusId, postsecondaryenrollmentstatusCode, postsecondaryenrollmentstatusDescription, postsecondaryenrollmentstatusEdFactsCode,
											academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode
										)
										values
										(
											-1,
											@postsecondaryenrollmentstatusId, @postsecondaryenrollmentstatusCode, @postsecondaryenrollmentstatusDescription, @postsecondaryenrollmentstatusEdFactsCode,
											@academicorvocationaloutcomeId, @academicorvocationaloutcomeCode, @academicorvocationaloutcomeDescription, @academicorvocationaloutcomeEdFactsCode
										)

										set identity_insert rds.DimEnrollment off
									end
								end
							end
							else
							begin
								if not exists(select 1 from RDS.DimEnrollment where  postsecondaryenrollmentstatusCode = @postsecondaryenrollmentstatusCode and academicorvocationaloutcomeCode = @academicorvocationaloutcomeCode)
								begin
									if exists(select 1 from RDS.DimEnrollment where postsecondaryenrollmentstatusCode = @postsecondaryenrollmentstatusCode 
										and academicorvocationaloutcomeCode IS NULL)
									begin
										UPDATE [RDS].[DimEnrollment]
										   SET 
												[AcademicOrVocationalOutcomeCode] = @academicorvocationaloutcomeCode
											  ,[AcademicOrVocationalOutcomeDescription] = @academicorvocationaloutcomeDescription
											  ,[AcademicOrVocationalOutcomeEdFactsCode] = @academicorvocationaloutcomeEdFactsCode
											  ,[AcademicOrVocationalOutcomeId] = @academicorvocationaloutcomeId 
										 WHERE postsecondaryenrollmentstatusCode = @postsecondaryenrollmentstatusCode 
												and academicorvocationaloutcomeCode IS NULL
									end
									else
									begin
										insert into RDS.DimEnrollment
										(
											postsecondaryenrollmentstatusId, postsecondaryenrollmentstatusCode, postsecondaryenrollmentstatusDescription, postsecondaryenrollmentstatusEdFactsCode,
											academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode
										)
										values
										(
										@postsecondaryenrollmentstatusId, @postsecondaryenrollmentstatusCode, @postsecondaryenrollmentstatusDescription, @postsecondaryenrollmentstatusEdFactsCode,
										@academicorvocationaloutcomeId, @academicorvocationaloutcomeCode, @academicorvocationaloutcomeDescription, @academicorvocationaloutcomeEdFactsCode
										)
								end
							end
							end

							FETCH NEXT FROM academicorvocationaloutcome_cur INTO @academicorvocationaloutcomeId, @academicorvocationaloutcomeCode, @academicorvocationaloutcomeDescription, @academicorvocationaloutcomeEdFactsCode
							END
							CLOSE academicorvocationaloutcome_cur
							DEALLOCATE academicorvocationaloutcome_cur


					FETCH NEXT FROM postsecondaryenrollmentstatus_cur INTO @postsecondaryenrollmentstatusId, @postsecondaryenrollmentstatusCode, @postsecondaryenrollmentstatusDescription, @postsecondaryenrollmentstatusEdFactsCode
					END
					CLOSE postsecondaryenrollmentstatus_cur
					DEALLOCATE postsecondaryenrollmentstatus_cur

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
