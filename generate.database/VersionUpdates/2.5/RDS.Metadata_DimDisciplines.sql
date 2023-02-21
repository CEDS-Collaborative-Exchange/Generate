-- DimDisciplines

set nocount on;

begin try
	begin transaction

				---------- Set the new added dimensions to MISSING ---------------------------------------------------------------

		  Update RDS.DimDisciplines set DisciplineELStatusId = -1  where DisciplineELStatusId is NULL
		  Update RDS.DimDisciplines set DisciplineELStatusCode = 'MISSING'  where DisciplineELStatusCode is NULL
		  Update RDS.DimDisciplines set DisciplineELStatusDescription = 'MISSING'  where DisciplineELStatusDescription is NULL
		  Update RDS.DimDisciplines set DisciplineELStatusEdFactsCode = 'MISSING'  where DisciplineELStatusEdFactsCode is NULL


		declare @disciplineActionId as int
		declare @disciplineActionCode as varchar(50)
		declare @disciplineActionDescription as varchar(200)
		declare @disciplineActionEdFactsCode as varchar(50)

		declare @disciplineActionTable table(
			disciplineActionId int,
			disciplineActionCode varchar(50),
			disciplineActionDescription varchar(200),
			disciplineActionEdFactsCode varchar(50)
		); 

		insert into @disciplineActionTable (disciplineActionId, disciplineActionCode, disciplineActionDescription, disciplineActionEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @disciplineActionTable (disciplineActionId, disciplineActionCode, disciplineActionDescription, disciplineActionEdFactsCode) 
		select RefDisciplinaryActionTakenId, Code, [Description], Code
		from ODS.RefDisciplinaryActionTaken


		declare @disciplineMethodId as int
		declare @disciplineMethodCode as varchar(50)
		declare @disciplineMethodDescription as varchar(200)
		declare @disciplineMethodEdFactsCode as varchar(50)

		declare @disciplineMethodTable table(
			disciplineMethodId int,
			disciplineMethodCode varchar(50),
			disciplineMethodDescription varchar(200),
			disciplineMethodEdFactsCode varchar(50)
		); 

		insert into @disciplineMethodTable (disciplineMethodId, disciplineMethodCode, disciplineMethodDescription, disciplineMethodEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @disciplineMethodTable (disciplineMethodId, disciplineMethodCode, disciplineMethodDescription, disciplineMethodEdFactsCode) 
		values 
		(1, 'OutOfSchool', 'Out-of-School Suspensions/Expulsions', 'OUTOFSCHOOL')

		insert into @disciplineMethodTable (disciplineMethodId, disciplineMethodCode, disciplineMethodDescription, disciplineMethodEdFactsCode) 
		values 
		(2, 'InSchool', 'In School Suspensions', 'INSCHOOL')


		declare @educationalServicesId as int
		declare @educationalServicesCode as varchar(50)
		declare @educationalServicesDescription as varchar(200)
		declare @educationalServicesEdFactsCode as varchar(50)

		declare @educationalServicesTable table(
			educationalServicesId int,
			educationalServicesCode varchar(50),
			educationalServicesDescription varchar(200),
			educationalServicesEdFactsCode varchar(50)
		); 

		insert into @educationalServicesTable (educationalServicesId, educationalServicesCode, educationalServicesDescription, educationalServicesEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @educationalServicesTable (educationalServicesId, educationalServicesCode, educationalServicesDescription, educationalServicesEdFactsCode) 
		values 
		(1, 'SERVPROV', 'Received educational services', 'SERVPROV')

		insert into @educationalServicesTable (educationalServicesId, educationalServicesCode, educationalServicesDescription, educationalServicesEdFactsCode) 
		values 
		(2, 'SERVNOTPROV ', 'Did not receive educational services', 'SERVNOTPROV ')


		declare @removalReasonId as int
		declare @removalReasonCode as varchar(50)
		declare @removalReasonDescription as varchar(200)
		declare @removalReasonEdFactsCode as varchar(50)

		declare @removalReasonTable table(
			removalReasonId int,
			removalReasonCode varchar(50),
			removalReasonDescription varchar(200),
			removalReasonEdFactsCode varchar(50)
		); 

		insert into @removalReasonTable (removalReasonId, removalReasonCode, removalReasonDescription, removalReasonEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @removalReasonTable (removalReasonId, removalReasonCode, removalReasonDescription, removalReasonEdFactsCode) 
		values 
		(1, 'SBI', 'Serious bodily injury', 'SBI')

		insert into @removalReasonTable (removalReasonId, removalReasonCode, removalReasonDescription, removalReasonEdFactsCode) 
		values 
		(2, 'W', 'Weapons', 'W')

		insert into @removalReasonTable (removalReasonId, removalReasonCode, removalReasonDescription, removalReasonEdFactsCode) 
		values 
		(3, 'D', 'Drugs', 'D')




		declare @removalTypeId as int
		declare @removalTypeCode as varchar(50)
		declare @removalTypeDescription as varchar(200)
		declare @removalTypeEdFactsCode as varchar(50)

		declare @removalTypeTable table(
			removalTypeId int,
			removalTypeCode varchar(50),
			removalTypeDescription varchar(200),
			removalTypeEdFactsCode varchar(50)
		); 

		insert into @removalTypeTable (removalTypeId, removalTypeCode, removalTypeDescription, removalTypeEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @removalTypeTable (removalTypeId, removalTypeCode, removalTypeDescription, removalTypeEdFactsCode) 
		values 
		(1, 'REMDW', 'Unilaterally removed to an interim alternative educational setting by School Personnel (NOT the IEP team) for drugs, weapons, or serious bodily injury', 'REMDW')

		insert into @removalTypeTable (removalTypeId, removalTypeCode, removalTypeDescription, removalTypeEdFactsCode) 
		values 
		(2, 'REMHO', 'Removed to an interim alternative ed setting based on a Hearing Officer finding that there is substantial likelihood of injury to the child or others', 'REMHO')


		declare @disciplineELStatusId as int
		declare @disciplineELStatusCode as varchar(100)
		declare @disciplineELStatusDescription as varchar(500)
		declare @disciplineELStatusEdFactsCode as varchar(100)

		declare @disciplineELStatusTable table(
			disciplineELStatusId int,
			disciplineELStatusCode varchar(50),
			disciplineELStatusDescription varchar(200),
			disciplineELStatusEdFactsCode varchar(50)
		); 

		insert into @disciplineELStatusTable (disciplineELStatusId, disciplineELStatusCode, disciplineELStatusDescription, disciplineELStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @disciplineELStatusTable (disciplineELStatusId, disciplineELStatusCode, disciplineELStatusDescription, disciplineELStatusEdFactsCode) 
		values 
		(1, 'LEP', 'English Learner', 'LEP')

		insert into @disciplineELStatusTable (disciplineELStatusId, disciplineELStatusCode, disciplineELStatusDescription, disciplineELStatusEdFactsCode) 
		values 
		(2, 'NLEP', 'Non–English learner', 'NLEP')


		-- Loop through cursors

		DECLARE disciplineAction_cursor CURSOR FOR 
		SELECT disciplineActionId, disciplineActionCode, disciplineActionDescription, disciplineActionEdFactsCode
		FROM @disciplineActionTable

		OPEN disciplineAction_cursor
		FETCH NEXT FROM disciplineAction_cursor INTO @disciplineActionId, @disciplineActionCode, @disciplineActionDescription, @disciplineActionEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE disciplineMethod_cursor CURSOR FOR 
			SELECT disciplineMethodId, disciplineMethodCode, disciplineMethodDescription, disciplineMethodEdFactsCode
			FROM @disciplineMethodTable

			OPEN disciplineMethod_cursor
			FETCH NEXT FROM disciplineMethod_cursor INTO @disciplineMethodId, @disciplineMethodCode, @disciplineMethodDescription, @disciplineMethodEdFactsCode

			WHILE @@FETCH_STATUS = 0
			BEGIN


				DECLARE educationalServices_cursor CURSOR FOR 
				SELECT educationalServicesId, educationalServicesCode, educationalServicesDescription, EducationalServicesEdFactsCode
				FROM @educationalServicesTable

				OPEN educationalServices_cursor
				FETCH NEXT FROM educationalServices_cursor INTO @educationalServicesId, @educationalServicesCode, @educationalServicesDescription, @educationalServicesEdFactsCode

				WHILE @@FETCH_STATUS = 0
				BEGIN


					DECLARE removalReason_cursor CURSOR FOR 
					SELECT removalReasonId, removalReasonCode, removalReasonDescription, removalReasonEdFactscode
					FROM @removalReasonTable

					OPEN removalReason_cursor
					FETCH NEXT FROM removalReason_cursor INTO @removalReasonId, @removalReasonCode, @removalReasonDescription, @removalReasonEdFactscode

					WHILE @@FETCH_STATUS = 0
					BEGIN

						DECLARE removalType_cursor CURSOR FOR 
						SELECT removalTypeId, removalTypeCode, removalTypeDescription, removalTypeEdFactsCode
						FROM @removalTypeTable

						OPEN removalType_cursor
						FETCH NEXT FROM removalType_cursor INTO @removalTypeId, @removalTypeCode, @removalTypeDescription, @removalTypeEdFactsCode

						WHILE @@FETCH_STATUS = 0
						BEGIN

							DECLARE EL_cursor CURSOR FOR 
							SELECT disciplineELStatusId, disciplineELStatusCode, disciplineELStatusDescription, disciplineELStatusEdFactsCode
							FROM  @disciplineELStatusTable

							OPEN EL_cursor
							FETCH NEXT FROM EL_cursor INTO @disciplineELStatusId, @disciplineELStatusCode, @disciplineELStatusDescription, @disciplineELStatusEdFactsCode

							WHILE @@FETCH_STATUS = 0
							BEGIN

						
							if @disciplineActionCode = 'MISSING'
							and @disciplineMethodCode = 'MISSING'
							and @educationalServicesCode = 'MISSING'
							and @removalReasonCode = 'MISSING'
							and @removalTypeCode = 'MISSING'
							and @disciplineELStatusCode = 'MISSING'
							begin

								
								if not exists(select 1 from RDS.DimDisciplines where DisciplineActionCode = @disciplineActionCode and DisciplineMethodCode = @disciplineMethodCode
											and EducationalServicesCode = @educationalServicesCode and RemovalReasonCode = @removalReasonCode and RemovalTypeCode = @removalTypeCode
											and DisciplineELStatusCode = @disciplineELStatusCode)
								begin

									set identity_insert rds.DimDisciplines on

									insert into RDS.DimDisciplines
									(
										DimDisciplineId,
										DisciplineActionId, DisciplineActionCode, DisciplineActionDescription, DisciplineActionEdFactsCode,
										DisciplineMethodId, DisciplineMethodCode, DisciplineMethodDescription, DisciplineMethodEdFactsCode,
										EducationalServicesId, EducationalServicesCode, EducationalServicesDescription, EducationalServicesEdFactsCode,
										RemovalReasonId, RemovalReasonCode, RemovalReasonDescription, RemovalReasonEdFactsCode,
										RemovalTypeId, RemovalTypeCode, RemovalTypeDescription, RemovalTypeEdFactsCode,
										disciplineELStatusId, disciplineELStatusCode, disciplineELStatusDescription, disciplineELStatusEdFactsCode
									)
									values
									(
									-1,
									@disciplineActionId, @disciplineActionCode, @disciplineActionDescription, @disciplineActionEdFactsCode,
									@disciplineMethodId, @disciplineMethodCode, @disciplineMethodDescription, @disciplineMethodEdFactsCode,
									@educationalServicesId, @educationalServicesCode, @educationalServicesDescription, @educationalServicesEdFactsCode,
									@removalReasonId, @removalReasonCode, @removalReasonDescription, @removalReasonEdFactsCode,
									@removalTypeId, @removalTypeCode, @removalTypeDescription, @removalTypeEdFactsCode,
									 @disciplineELStatusId, @disciplineELStatusCode, @disciplineELStatusDescription, @disciplineELStatusEdFactsCode
									)

									set identity_insert rds.DimDisciplines off
								end
							end
							else
							begin

								if not exists(select 1 from RDS.DimDisciplines where DisciplineActionCode = @disciplineActionCode and DisciplineMethodCode = @disciplineMethodCode
											and EducationalServicesCode = @educationalServicesCode and RemovalReasonCode = @removalReasonCode and RemovalTypeCode = @removalTypeCode
											and DisciplineELStatusCode = @disciplineELStatusCode)
								begin

									insert into RDS.DimDisciplines
									(
										DisciplineActionId, DisciplineActionCode, DisciplineActionDescription, DisciplineActionEdFactsCode,
										DisciplineMethodId, DisciplineMethodCode, DisciplineMethodDescription, DisciplineMethodEdFactsCode,
										EducationalServicesId, EducationalServicesCode, EducationalServicesDescription, EducationalServicesEdFactsCode,
										RemovalReasonId, RemovalReasonCode, RemovalReasonDescription, RemovalReasonEdFactsCode,
										RemovalTypeId, RemovalTypeCode, RemovalTypeDescription, RemovalTypeEdFactsCode,
										disciplineELStatusId, disciplineELStatusCode, disciplineELStatusDescription, disciplineELStatusEdFactsCode
									)
									values
									(
									@disciplineActionId, @disciplineActionCode, @disciplineActionDescription, @disciplineActionEdFactsCode,
									@disciplineMethodId, @disciplineMethodCode, @disciplineMethodDescription, @disciplineMethodEdFactsCode,
									@educationalServicesId, @educationalServicesCode, @educationalServicesDescription, @educationalServicesEdFactsCode,
									@removalReasonId, @removalReasonCode, @removalReasonDescription, @removalReasonEdFactsCode,
									@removalTypeId, @removalTypeCode, @removalTypeDescription, @removalTypeEdFactsCode,
									 @disciplineELStatusId, @disciplineELStatusCode, @disciplineELStatusDescription, @disciplineELStatusEdFactsCode
									)
								end
							end

							FETCH NEXT FROM EL_cursor INTO @disciplineELStatusId, @disciplineELStatusCode, @disciplineELStatusDescription, @disciplineELStatusEdFactsCode
							END

							CLOSE EL_cursor
							DEALLOCATE EL_cursor

							FETCH NEXT FROM removalType_cursor INTO @removalTypeId, @removalTypeCode, @removalTypeDescription, @removalTypeEdFactsCode
						END

						CLOSE removalType_cursor
						DEALLOCATE removalType_cursor



						FETCH NEXT FROM removalReason_cursor INTO @removalReasonId, @removalReasonCode, @removalReasonDescription, @removalReasonEdFactsCode
					END

					CLOSE removalReason_cursor
					DEALLOCATE removalReason_cursor


					FETCH NEXT FROM educationalServices_cursor INTO @educationalServicesId, @educationalServicesCode, @educationalServicesDescription, @educationalServicesEdFactsCode
				END

				CLOSE educationalServices_cursor
				DEALLOCATE educationalServices_cursor

		

				FETCH NEXT FROM disciplineMethod_cursor INTO @disciplineMethodId, @disciplineMethodCode, @disciplineMethodDescription, @disciplineMethodEdFactsCode
			END

			CLOSE disciplineMethod_cursor
			DEALLOCATE disciplineMethod_cursor


			FETCH NEXT FROM disciplineAction_cursor INTO @disciplineActionId, @disciplineActionCode, @disciplineActionDescription, @disciplineActionEdFactsCode

		END

		CLOSE disciplineAction_cursor
		DEALLOCATE disciplineAction_cursor

	
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