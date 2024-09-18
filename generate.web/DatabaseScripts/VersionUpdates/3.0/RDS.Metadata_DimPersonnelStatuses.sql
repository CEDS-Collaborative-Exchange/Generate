-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on;

begin try
	begin transaction

		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusId = NULL, EmergencyOrProvisionalCredentialStatusId = NULL , OutOfFieldStatusId = NULL
		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusCode = NULL, EmergencyOrProvisionalCredentialStatusCode = NULL , OutOfFieldStatusCode = NULL
		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusDescription = NULL, EmergencyOrProvisionalCredentialStatusDescription = NULL , OutOfFieldStatusDescription = NULL
		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusEdFactsCode = NULL, EmergencyOrProvisionalCredentialStatusEdFactsCode = NULL , OutOfFieldStatusEdFactsCode = NULL

	
		---------- Set the new added dimensions to MISSING ---------------------------------------------------------------

		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusId = -1, EmergencyOrProvisionalCredentialStatusId = -1 , OutOfFieldStatusId = -1
		  where UnexperiencedStatusId is NULL and EmergencyOrProvisionalCredentialStatusId is NULL and OutOfFieldStatusId is NULL
		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusCode = 'MISSING', EmergencyOrProvisionalCredentialStatusCode = 'MISSING' , OutOfFieldStatusCode = 'MISSING'
		  where UnexperiencedStatusCode is NULL and EmergencyOrProvisionalCredentialStatusCode is NULL and OutOfFieldStatusCode is NULL
		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusDescription = 'MISSING', EmergencyOrProvisionalCredentialStatusDescription = 'MISSING' , OutOfFieldStatusDescription = 'MISSING'
		  where UnexperiencedStatusDescription is NULL and EmergencyOrProvisionalCredentialStatusDescription is NULL and OutOfFieldStatusDescription is NULL
		  Update RDS.DimPersonnelStatuses set UnexperiencedStatusEdFactsCode = 'MISSING', EmergencyOrProvisionalCredentialStatusEdFactsCode = 'MISSING' , OutOfFieldStatusEdFactsCode = 'MISSING'
		  where UnexperiencedStatusEdFactsCode is NULL and EmergencyOrProvisionalCredentialStatusEdFactsCode is NULL and OutOfFieldStatusEdFactsCode is NULL

		-------- Insert new records in the added dimensions ---------------------------------------------------------

		declare @ageGroupId as int
		declare @ageGroupCode as varchar(50)
		declare @ageGroupDescription as varchar(200)
		declare @ageGroupEdFactsCode as varchar(50)

		declare @ageGroupTable table(
			ageGroupId int,
			ageGroupCode varchar(50),
			ageGroupDescription varchar(200),
			ageGroupEdFactsCode varchar(50)
		); 

		insert into @ageGroupTable (ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @ageGroupTable (ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode) values (1, '3TO5', '3 through 5', '3TO5')
		insert into @ageGroupTable (ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode) values (2, '6TO21', '6 through 21', '6TO21')

		declare @certificationStatusId as int
		declare @certificationStatusCode as varchar(50)
		declare @certificationStatusDescription as varchar(200)
		declare @certificationStatusEdFactsCode as varchar(50)

		declare @certificationStatusTable table(
			certificationStatusId int,
			certificationStatusCode varchar(50),
			certificationStatusDescription varchar(200),
			certificationStatusEdFactsCode varchar(50)
		); 

		insert into @certificationStatusTable (certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @certificationStatusTable (certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode) values (1, 'FC', 'Fully certified or licensed', 'FC')
		insert into @certificationStatusTable (certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode) values (2, 'NFC', 'Not fully certified or licensed', 'NFC')

		declare @personnelTypeId as int
		declare @personnelTypeCode as varchar(50)
		declare @personnelTypeDescription as varchar(200)
		declare @personnelTypeEdFactsCode as varchar(50)

		declare @personnelTypeTable table(
			personnelTypeId int,
			personnelTypeCode varchar(50),
			personnelTypeDescription varchar(200),
			personnelTypeEdFactsCode varchar(50)
		); 

		insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
		values 
		(1, 'STAFF', 'Related services personnel', 'STAFF')

		insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
		values 
		(2, 'TEACHER', 'Teacher', 'TEACHER')

		insert into @personnelTypeTable (personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode) 
		values 
		(3, 'PARAPROFESSIONAL', 'Paraprofessional', 'PARAPROFESSIONAL')


		declare @qualificationStatusId as int
		declare @qualificationStatusCode as varchar(50)
		declare @qualificationStatusDescription as varchar(200)
		declare @qualificationStatusEdFactsCode as varchar(50)

		declare @qualificationStatusTable table(
			qualificationStatusId int,
			qualificationStatusCode varchar(50),
			qualificationStatusDescription varchar(200),
			qualificationStatusEdFactsCode varchar(50)
		); 

		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (1, 'HQ', 'Highly qualified', 'HQ')
		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (2, 'NHQ', 'Not highly qualified', 'NHQ')
		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (3, 'Qualified', 'Qualified', 'Q')
		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (4, 'NotQualified', 'Not qualified', 'NQ')
		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (5, 'SPEDTCHFULCRT', 'Fully certified', 'SPEDTCHFULCRT')
		insert into @qualificationStatusTable (qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactsCode) values (6, 'SPEDTCHNFULCRT', 'Not fully certified', 'SPEDTCHNFULCRT')

		declare @unexperiencedStatusId as int
		declare @unexperiencedStatusCode as varchar(50)
		declare @unexperiencedStatusDescription as varchar(200)
		declare @unexperiencedStatusEdFactsCode as varchar(50)

		declare @unexperiencedStatusTable table(
				UnexperiencedStatusId int,
				UnexperiencedStatusCode varchar(50),
				UnexperiencedStatusDescription varchar(200),
				UnexperiencedStatusEdFactsCode varchar(50)
			); 

		insert into @unexperiencedStatusTable (UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode) 
		values(-1, 'MISSING', 'Missing', 'MISSING')
		insert into @unexperiencedStatusTable (UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode) 
		values(1, 'TCHEXPRNCD', 'Experienced teachers', 'TCHEXPRNCD')
		insert into @unexperiencedStatusTable (UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode) 
		values(2, 'TCHINEXPRNCD', 'Inexperienced teachers', 'TCHINEXPRNCD')

		declare @emergencyOrProvisionalCredentialStatusId as int
		declare @emergencyOrProvisionalCredentialStatusCode as varchar(50)
		declare @emergencyOrProvisionalCredentialStatusDescription as varchar(200)
		declare @emergencyOrProvisionalCredentialStatusEdFactsCode as varchar(50)

		declare @emergencyOrProvisionalCredentialStatusTable table(
				EmergencyOrProvisionalCredentialStatusId int,
				EmergencyOrProvisionalCredentialStatusCode varchar(50),
				EmergencyOrProvisionalCredentialStatusDescription varchar(200),
				EmergencyOrProvisionalCredentialStatusEdFactsCode varchar(50)
			); 

		insert into @emergencyOrProvisionalCredentialStatusTable (EmergencyOrProvisionalCredentialStatusId, 	EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, 	EmergencyOrProvisionalCredentialStatusEdFactsCode) 
		values(-1, 'MISSING', 'Missing', 'MISSING')
		insert into @emergencyOrProvisionalCredentialStatusTable (EmergencyOrProvisionalCredentialStatusId, 	EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, 	EmergencyOrProvisionalCredentialStatusEdFactsCode) 
		values(1, 'TCHWEMRPRVCRD', 'Emergency or Provisional – Teachers with emergency or provisional credential', 'TCHWEMRPRVCRD')
		insert into @emergencyOrProvisionalCredentialStatusTable (EmergencyOrProvisionalCredentialStatusId, 	EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, 	EmergencyOrProvisionalCredentialStatusEdFactsCode) 
		values(2, 'TCHWOEMRPRVCRD', 'No Emergency or Provisional – Teachers without emergency or provisional credential', 'TCHWOEMRPRVCRD')

		declare @outOfFieldStatusId as int
		declare @outOfFieldStatusCode as varchar(50)
		declare @outOfFieldStatusDescription as varchar(200)
		declare @outOfFieldStatusEdFactsCode as varchar(50)

		declare @OutOfFieldStatusTable table(
				OutOfFieldStatusId int,
				OutOfFieldStatusCode varchar(50),
				OutOfFieldStatusDescription varchar(200),
				OutOfFieldStatusEdFactsCode varchar(50)
			); 

		insert into @OutOfFieldStatusTable(OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode)
		values(-1, 'MISSING', 'Missing', 'MISSING')
		insert into @OutOfFieldStatusTable(OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode)
		values(1, 'TCHINFLD', 'Teaching in field', 'TCHINFLD')
		insert into @OutOfFieldStatusTable(OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode)
		values(2, 'TCHOUTFLD', 'Not teaching in field', 'TCHOUTFLD')
		
		-- Loop through cursors

		DECLARE ageGroup_cursor CURSOR FOR 
		SELECT ageGroupId, ageGroupCode, ageGroupDescription, ageGroupEdFactsCode
		FROM @ageGroupTable

		OPEN ageGroup_cursor
		FETCH NEXT FROM ageGroup_cursor INTO @ageGroupId, @ageGroupCode, @ageGroupDescription, @ageGroupEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE certificationStatus_cursor CURSOR FOR 
			SELECT certificationStatusId, certificationStatusCode, certificationStatusDescription, certificationStatusEdFactsCode
			FROM @certificationStatusTable

			OPEN certificationStatus_cursor
			FETCH NEXT FROM certificationStatus_cursor INTO @certificationStatusId, @certificationStatusCode, @certificationStatusDescription, @certificationStatusEdFactsCode

			WHILE @@FETCH_STATUS = 0
			BEGIN


				DECLARE personnelType_cursor CURSOR FOR 
				SELECT personnelTypeId, personnelTypeCode, personnelTypeDescription, personnelTypeEdFactsCode
				FROM @personnelTypeTable

				OPEN personnelType_cursor
				FETCH NEXT FROM personnelType_cursor INTO @personnelTypeId, @personnelTypeCode, @personnelTypeDescription, @personnelTypeEdFactsCode

				WHILE @@FETCH_STATUS = 0
				BEGIN


					DECLARE qualificationStatus_cursor CURSOR FOR 
					SELECT qualificationStatusId, qualificationStatusCode, qualificationStatusDescription, qualificationStatusEdFactscode
					FROM @qualificationStatusTable

					OPEN qualificationStatus_cursor
					FETCH NEXT FROM qualificationStatus_cursor INTO @qualificationStatusId, @qualificationStatusCode, @qualificationStatusDescription, @qualificationStatusEdFactscode

					WHILE @@FETCH_STATUS = 0
					BEGIN
						
						DECLARE unexperiencedStatus_cursor CURSOR FOR 
						SELECT UnexperiencedStatusId, UnexperiencedStatusCode, 	UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode
						FROM @unexperiencedStatusTable

						OPEN unexperiencedStatus_cursor
						FETCH NEXT FROM unexperiencedStatus_cursor INTO  @unexperiencedStatusId, @unexperiencedStatusCode, @unexperiencedStatusDescription, @unexperiencedStatusEdFactsCode

						WHILE @@FETCH_STATUS = 0
						BEGIN

							DECLARE emergencyOrProvisionalCredentialStatus_cursor CURSOR FOR 
							SELECT EmergencyOrProvisionalCredentialStatusId, EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, EmergencyOrProvisionalCredentialStatusEdFactsCode
							FROM @emergencyOrProvisionalCredentialStatusTable

							OPEN emergencyOrProvisionalCredentialStatus_cursor
							FETCH NEXT FROM emergencyOrProvisionalCredentialStatus_cursor INTO  @emergencyOrProvisionalCredentialStatusId, @emergencyOrProvisionalCredentialStatusCode, @emergencyOrProvisionalCredentialStatusDescription, @emergencyOrProvisionalCredentialStatusEdFactsCode

							WHILE @@FETCH_STATUS = 0
							BEGIN
						
								DECLARE outOfFieldStatus_cursor CURSOR FOR 
								SELECT OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode
								FROM @OutOfFieldStatusTable

								OPEN outOfFieldStatus_cursor
								FETCH NEXT FROM outOfFieldStatus_cursor INTO  @outOfFieldStatusId, @outOfFieldStatusCode, @outOfFieldStatusDescription, @outOfFieldStatusEdFactsCode


								WHILE @@FETCH_STATUS = 0
								BEGIN
											
								if @ageGroupCode = 'MISSING'
								and @certificationStatusCode = 'MISSING'
								and @personnelTypeCode = 'MISSING'
								and @qualificationStatusCode = 'MISSING'
								and @unexperiencedStatusCode = 'MISSING' and @emergencyOrProvisionalCredentialStatusCode = 'MISSING' and @outOfFieldStatusCode = 'MISSING'
									begin

										
										if not exists(select 1 from rds.DimPersonnelStatuses where AgeGroupCode = @ageGroupCode and CertificationStatusCode =  @certificationStatusCode
											and  PersonnelTypeCode = @personnelTypeCode and  QualificationStatusCode = @qualificationStatusCode 
											and UnexperiencedStatusCode = @unexperiencedStatusCode
											and EmergencyOrProvisionalCredentialStatusCode = @emergencyOrProvisionalCredentialStatusCode
											and OutOfFieldStatusCode = @outOfFieldStatusCode)
										begin

										set identity_insert rds.DimPersonnelStatuses on

										insert into RDS.DimPersonnelStatuses
										(
											DimPersonnelStatusId,
											AgeGroupId, AgeGroupCode, AgeGroupDescription, AgeGroupEdFactsCode,
											CertificationStatusId, CertificationStatusCode, CertificationStatusDescription, CertificationStatusEdFactsCode,
											PersonnelTypeId, PersonnelTypeCode, PersonnelTypeDescription, PersonnelTypeEdFactsCode,
											QualificationStatusId, QualificationStatusCode, QualificationStatusDescription, QualificationStatusEdFactsCode,
											UnexperiencedStatusId, UnexperiencedStatusCode, UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode,
											EmergencyOrProvisionalCredentialStatusId, EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, EmergencyOrProvisionalCredentialStatusEdFactsCode,
											OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode
										)
										values
										(
										-1,
										@ageGroupId, @ageGroupCode, @ageGroupDescription, @ageGroupEdFactsCode,
										@certificationStatusId, @certificationStatusCode, @certificationStatusDescription, @certificationStatusEdFactsCode,
										@personnelTypeId, @personnelTypeCode, @personnelTypeDescription, @personnelTypeEdFactsCode,
										@qualificationStatusId, @qualificationStatusCode, @qualificationStatusDescription, @qualificationStatusEdFactsCode,
										@unexperiencedStatusId, @unexperiencedStatusCode, @unexperiencedStatusDescription, @unexperiencedStatusEdFactsCode,
										@emergencyOrProvisionalCredentialStatusId, @emergencyOrProvisionalCredentialStatusCode, @emergencyOrProvisionalCredentialStatusDescription, @emergencyOrProvisionalCredentialStatusEdFactsCode,
										@outOfFieldStatusId, @outOfFieldStatusCode, @outOfFieldStatusDescription, @outOfFieldStatusEdFactsCode
										)

										set identity_insert rds.DimPersonnelStatuses off

										end

									end
									else
									begin

										if not exists(select 1 from rds.DimPersonnelStatuses where AgeGroupCode = @ageGroupCode and CertificationStatusCode =  @certificationStatusCode
											and  PersonnelTypeCode = @personnelTypeCode and  QualificationStatusCode = @qualificationStatusCode 
											and UnexperiencedStatusCode = @unexperiencedStatusCode
											and EmergencyOrProvisionalCredentialStatusCode = @emergencyOrProvisionalCredentialStatusCode
											and OutOfFieldStatusCode = @outOfFieldStatusCode)
										begin

											insert into RDS.DimPersonnelStatuses
											(
												AgeGroupId, AgeGroupCode, AgeGroupDescription, AgeGroupEdFactsCode,
												CertificationStatusId, CertificationStatusCode, CertificationStatusDescription, CertificationStatusEdFactsCode,
												PersonnelTypeId, PersonnelTypeCode, PersonnelTypeDescription, PersonnelTypeEdFactsCode,
												QualificationStatusId, QualificationStatusCode, QualificationStatusDescription, QualificationStatusEdFactsCode,
												UnexperiencedStatusId, UnexperiencedStatusCode, UnexperiencedStatusDescription, UnexperiencedStatusEdFactsCode,
												EmergencyOrProvisionalCredentialStatusId, EmergencyOrProvisionalCredentialStatusCode, EmergencyOrProvisionalCredentialStatusDescription, EmergencyOrProvisionalCredentialStatusEdFactsCode,
												OutOfFieldStatusId, OutOfFieldStatusCode, OutOfFieldStatusDescription, OutOfFieldStatusEdFactsCode
											)
											values
											(
											@ageGroupId, @ageGroupCode, @ageGroupDescription, @ageGroupEdFactsCode,
											@certificationStatusId, @certificationStatusCode, @certificationStatusDescription, @certificationStatusEdFactsCode,
											@personnelTypeId, @personnelTypeCode, @personnelTypeDescription, @personnelTypeEdFactsCode,
											@qualificationStatusId, @qualificationStatusCode, @qualificationStatusDescription, @qualificationStatusEdFactsCode,
											@unexperiencedStatusId, @unexperiencedStatusCode, @unexperiencedStatusDescription, @unexperiencedStatusEdFactsCode,
											@emergencyOrProvisionalCredentialStatusId, @emergencyOrProvisionalCredentialStatusCode, @emergencyOrProvisionalCredentialStatusDescription, @emergencyOrProvisionalCredentialStatusEdFactsCode,
											@outOfFieldStatusId, @outOfFieldStatusCode, @outOfFieldStatusDescription, @outOfFieldStatusEdFactsCode
											)

										end

									end
									FETCH NEXT FROM outOfFieldStatus_cursor INTO  @outOfFieldStatusId, @outOfFieldStatusCode, @outOfFieldStatusDescription, @outOfFieldStatusEdFactsCode
									END

									CLOSE outOfFieldStatus_cursor
									DEALLOCATE outOfFieldStatus_cursor


								FETCH NEXT FROM emergencyOrProvisionalCredentialStatus_cursor INTO  @emergencyOrProvisionalCredentialStatusId, @emergencyOrProvisionalCredentialStatusCode, @emergencyOrProvisionalCredentialStatusDescription, @emergencyOrProvisionalCredentialStatusEdFactsCode
								END

								CLOSE emergencyOrProvisionalCredentialStatus_cursor
								DEALLOCATE emergencyOrProvisionalCredentialStatus_cursor
							

							FETCH NEXT FROM unexperiencedStatus_cursor INTO  @unexperiencedStatusId, @unexperiencedStatusCode, @unexperiencedStatusDescription, @unexperiencedStatusEdFactsCode
							END

							CLOSE unexperiencedStatus_cursor
							DEALLOCATE unexperiencedStatus_cursor
					
						FETCH NEXT FROM qualificationStatus_cursor INTO @qualificationStatusId, @qualificationStatusCode, @qualificationStatusDescription, @qualificationStatusEdFactsCode
					END

					CLOSE qualificationStatus_cursor
					DEALLOCATE qualificationStatus_cursor


					FETCH NEXT FROM personnelType_cursor INTO @personnelTypeId, @personnelTypeCode, @personnelTypeDescription, @personnelTypeEdFactsCode
				END

				CLOSE personnelType_cursor
				DEALLOCATE personnelType_cursor

		

				FETCH NEXT FROM certificationStatus_cursor INTO @certificationStatusId, @certificationStatusCode, @certificationStatusDescription, @certificationStatusEdFactsCode
			END

			CLOSE certificationStatus_cursor
			DEALLOCATE certificationStatus_cursor


			FETCH NEXT FROM ageGroup_cursor INTO @ageGroupId, @ageGroupCode, @ageGroupDescription, @ageGroupEdFactsCode

		END

		CLOSE ageGroup_cursor
		DEALLOCATE ageGroup_cursor

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