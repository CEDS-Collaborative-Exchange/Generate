-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction

		---------- Set the new added dimensions to MISSING ---------------------------------------------------------------

		  Update RDS.DimDemographics set HomelessNighttimeResidenceId = -1, HomelessUnaccompaniedYouthStatusId = -1 
		  where HomelessNighttimeResidenceId is NULL and HomelessUnaccompaniedYouthStatusId is NULL
		  Update RDS.DimDemographics set HomelessNighttimeResidenceCode = 'MISSING', HomelessUnaccompaniedYouthStatusCode = 'MISSING' 
		  where HomelessNighttimeResidenceCode is NULL and HomelessUnaccompaniedYouthStatusCode is NULL
		  Update RDS.DimDemographics set HomelessNighttimeResidenceDescription = 'MISSING', HomelessUnaccompaniedYouthStatusDescription = 'MISSING' 
		  where HomelessNighttimeResidenceDescription is NULL and HomelessUnaccompaniedYouthStatusDescription is NULL
		  Update RDS.DimDemographics set HomelessNighttimeResidenceEdFactsCode = 'MISSING', HomelessUnaccompaniedYouthStatusEdFactsCode = 'MISSING' 
		  where HomelessNighttimeResidenceEdFactsCode is NULL and HomelessUnaccompaniedYouthStatusEdFactsCode is NULL

		-------- Insert new records in the added dimensions ---------------------------------------------------------

		declare @sexId as int
		declare @sexCode as varchar(50)
		declare @sexDescription as varchar(200)
		declare @sexEdFactsCode as varchar(50)

		declare @sexTable table(
			SexId int,
			SexCode varchar(50),
			SexDescription varchar(200),
			SexEdFactsCode varchar(50)
		); 

		insert into @sexTable (SexId, SexCode, SexDescription, SexEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @sexTable (SexId, SexCode, SexDescription, SexEdFactsCode) 
		values 
		(1, 'Male', 'Male', 'M')

		insert into @sexTable (SexId, SexCode, SexDescription, SexEdFactsCode) 
		values 
		(2, 'Female', 'Female', 'F')

		insert into @sexTable (SexId, SexCode, SexDescription, SexEdFactsCode) 
		values 
		(3, 'NotSelected', 'Not selected', 'MISSING')


		declare @ecoDisStatusId as int
		declare @ecoDisStatusCode as varchar(50)
		declare @ecoDisStatusDescription as varchar(200)
		declare @ecoDisStatusEdFactsCode as varchar(50)

		declare @ecoDisStatusTable table(	
			EcoDisStatusId int,
			EcoDisStatusCode varchar(50),
			EcoDisStatusDescription varchar(200),
			EcoDisStatusEdFactsCode varchar(50)
		); 

		insert into @ecoDisStatusTable (EcoDisStatusId, EcoDisStatusCode, EcoDisStatusDescription, EcoDisStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @ecoDisStatusTable (EcoDisStatusId, EcoDisStatusCode, EcoDisStatusDescription, EcoDisStatusEdFactsCode) 
		values 
		(1, 'EconomicDisadvantage', 'Economically Disadvantaged (ED) Students', 'ECODIS')



		declare @homelessStatusId as int
		declare @homelessStatusCode as varchar(50)
		declare @homelessStatusDescription as varchar(200)
		declare @homelessStatusEdFactsCode as varchar(50)

		declare @homelessStatusTable table(	
			HomelessStatusId int,
			HomelessStatusCode varchar(50),
			HomelessStatusDescription varchar(200),
			HomelessStatusEdFactsCode varchar(50)
		); 


		insert into @homelessStatusTable (HomelessStatusId, HomelessStatusCode, HomelessStatusDescription, HomelessStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @homelessStatusTable (HomelessStatusId, HomelessStatusCode, HomelessStatusDescription, HomelessStatusEdFactsCode) 
		values 
		(1, 'Homeless', 'Homeless enrolled', 'HOMELSENRL')



		declare @lepId as int
		declare @lepCode as varchar(100)
		declare @lepDescription as varchar(500)
		declare @lepEdFactsCode as varchar(100)

		declare @lepTable table(
			LepId int,
			LepCode varchar(50),
			LepDescription varchar(200),
			LepEdFactsCode varchar(50)
		); 

		insert into @lepTable (LepId, LepCode, LepDescription, LepEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @lepTable (LepId, LepCode, LepDescription, LepEdFactsCode) 
		values 
		(1, 'LEP', 'Limited English proficient (LEP) Student', 'LEP')

		insert into @lepTable (LepId, LepCode, LepDescription, LepEdFactsCode) 
		values 
		(2, 'NLEP', 'Non-limited English proficient (non-LEP) Student', 'NLEP')



		declare @migrantStatusId as int
		declare @migrantStatusCode as varchar(50)
		declare @migrantStatusDescription as varchar(200)
		declare @migrantStatusEdFactsCode as varchar(50)

		declare @migrantStatusTable table(	
			MigrantStatusId int,
			MigrantStatusCode varchar(50),
			MigrantStatusDescription varchar(200),
			MigrantStatusEdFactsCode varchar(50)
		); 

		insert into @migrantStatusTable (MigrantStatusId, MigrantStatusCode, MigrantStatusDescription, MigrantStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @migrantStatusTable (MigrantStatusId, MigrantStatusCode, MigrantStatusDescription, MigrantStatusEdFactsCode) 
		values 
		(1, 'Migrant', 'Migrant students', 'MS')

		declare @militaryConnectedStatusId as int
		declare @militaryConnectedStatusCode as varchar(50)
		declare @militaryConnectedStatusDescription as varchar(200)
		declare @militaryConnectedStatusEdFactsCode as varchar(50)

		declare @militaryConnectedStatusTable table(	
			MilitaryConnectedStatusId int,
			MilitaryConnectedStatusCode varchar(50),
			MilitaryConnectedStatusDescription varchar(200),
			MilitaryConnectedStatusEdFactsCode varchar(50)
		); 

		insert into @militaryConnectedStatusTable (MilitaryConnectedStatusId, MilitaryConnectedStatusCode, MilitaryConnectedStatusDescription, MilitaryConnectedStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @militaryConnectedStatusTable (MilitaryConnectedStatusId, MilitaryConnectedStatusCode, MilitaryConnectedStatusDescription, MilitaryConnectedStatusEdFactsCode) 
		values 
		(1, 'MILCNCTD', 'Military connected', 'MILCNCTD')

		declare @homelessUnaccompaniedYouthStatusId as int
		declare @homelessUnaccompaniedYouthStatusCode as varchar(50)
		declare @homelessUnaccompaniedYouthStatusDescription as varchar(200)
		declare @homelessUnaccompaniedYouthStatusEdFactsCode as varchar(50)

		declare @homelessUnaccompaniedYouthStatusTable table(	
			HomelessUnaccompaniedYouthStatusId int,
			HomelessUnaccompaniedYouthStatusCode varchar(50),
			HomelessUnaccompaniedYouthStatusDescription varchar(200),
			HomelessUnaccompaniedYouthStatusEdFactsCode varchar(50)
		); 

		insert into @homelessUnaccompaniedYouthStatusTable(HomelessUnaccompaniedYouthStatusId,HomelessUnaccompaniedYouthStatusCode,HomelessUnaccompaniedYouthStatusDescription,HomelessUnaccompaniedYouthStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @homelessUnaccompaniedYouthStatusTable(HomelessUnaccompaniedYouthStatusId,HomelessUnaccompaniedYouthStatusCode,HomelessUnaccompaniedYouthStatusDescription,HomelessUnaccompaniedYouthStatusEdFactsCode) 
		values 
		(1, 'UY', 'Unaccompanied youth', 'UY')

		declare @homelessNighttimeResidenceId as int
		declare @homelessNighttimeResidenceCode as varchar(50)
		declare @homelessNighttimeResidenceDescription as varchar(200)
		declare @homelessNighttimeResidenceEdFactsCode as varchar(50)

		declare @homelessNighttimeResidenceTable table(	
			HomelessNighttimeResidenceId int,
			HomelessNighttimeResidenceCode varchar(50),
			HomelessNighttimeResidenceDescription varchar(200),
			HomelessNighttimeResidenceEdFactsCode varchar(50)
		); 

		insert into @homelessNighttimeResidenceTable(HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @homelessNighttimeResidenceTable(HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode) 
		values 
		(1, 'S', 'Shelters, Transitional housing, Awaiting Foster Care', 'S')

		insert into @homelessNighttimeResidenceTable(HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode) 
		values 
		(2, 'STH', 'Shelters and Transitional housing', 'STH')

		insert into @homelessNighttimeResidenceTable(HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode) 
		values 
		(3, 'D', 'Doubled–up', 'D')

		insert into @homelessNighttimeResidenceTable(HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode) 
		values 
		(4, 'U', 'Unsheltered', 'U')

		insert into @homelessNighttimeResidenceTable(HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode) 
		values 
		(5, 'HM', 'Hotels/motels', 'HM')


		-- Loop through cursors

		DECLARE sex_cursor CURSOR FOR 
		SELECT SexId, SexCode, SexDescription, SexEdFactsCode
		FROM @sexTable

		OPEN sex_cursor
		FETCH NEXT FROM sex_cursor INTO @sexId, @sexCode, @sexDescription, @sexEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN


			DECLARE ecoDisStatus_cursor CURSOR FOR 
			SELECT EcoDisStatusId, EcoDisStatusCode, EcoDisStatusDescription, EcoDisStatusEdFactsCode
			FROM @ecoDisStatusTable

			OPEN ecoDisStatus_cursor
			FETCH NEXT FROM ecoDisStatus_cursor INTO @ecoDisStatusId, @ecoDisStatusCode, @ecoDisStatusDescription, @ecoDisStatusEdFactsCode

			WHILE @@FETCH_STATUS = 0
			BEGIN


				DECLARE homelessStatus_cursor CURSOR FOR 
				SELECT HomelessStatusId, HomelessStatusCode, HomelessStatusDescription, HomelessStatusEdFactsCode
				FROM @homelessStatusTable

				OPEN homelessStatus_cursor
				FETCH NEXT FROM homelessStatus_cursor INTO @homelessStatusId, @homelessStatusCode, @homelessStatusDescription, @homelessStatusEdFactsCode

				WHILE @@FETCH_STATUS = 0
				BEGIN
			

					DECLARE lep_cursor CURSOR FOR 
					SELECT LepId, LepCode, LepDescription, LepEdFactsCode
					FROM @lepTable

					OPEN lep_cursor
					FETCH NEXT FROM lep_cursor INTO @lepId, @lepCode, @lepDescription, @lepEdFactsCode

					WHILE @@FETCH_STATUS = 0
					BEGIN


						DECLARE migrantStatus_cursor CURSOR FOR 
						SELECT MigrantStatusId, MigrantStatusCode, MigrantStatusDescription, MigrantStatusEdFactsCode
						FROM @migrantStatusTable

						OPEN migrantStatus_cursor
						FETCH NEXT FROM migrantStatus_cursor INTO @migrantStatusId, @migrantStatusCode, @migrantStatusDescription, @migrantStatusEdFactsCode

						WHILE @@FETCH_STATUS = 0
						BEGIN
					
								DECLARE militaryConnectedStatus_cursor CURSOR FOR 
								SELECT MilitaryConnectedStatusId, MilitaryConnectedStatusCode, MilitaryConnectedStatusDescription, MilitaryConnectedStatusEdFactsCode
								FROM @militaryConnectedStatusTable

								OPEN militaryConnectedStatus_cursor
								FETCH NEXT FROM militaryConnectedStatus_cursor INTO @militaryConnectedStatusId, @militaryConnectedStatusCode, @militaryConnectedStatusDescription, @militaryConnectedStatusEdFactsCode

								WHILE @@FETCH_STATUS = 0
								BEGIN

									DECLARE homelessUnaccompaniedYouthStatus_cursor CURSOR FOR 
									SELECT HomelessUnaccompaniedYouthStatusId,HomelessUnaccompaniedYouthStatusCode,HomelessUnaccompaniedYouthStatusDescription,HomelessUnaccompaniedYouthStatusEdFactsCode
									FROM @homelessUnaccompaniedYouthStatusTable

									OPEN homelessUnaccompaniedYouthStatus_cursor
									FETCH NEXT FROM homelessUnaccompaniedYouthStatus_cursor INTO @homelessUnaccompaniedYouthStatusId, @homelessUnaccompaniedYouthStatusCode, @homelessUnaccompaniedYouthStatusDescription, @homelessUnaccompaniedYouthStatusEdFactsCode

									WHILE @@FETCH_STATUS = 0
									BEGIN

										DECLARE homelessNighttimeResidence_cursor CURSOR FOR 
										SELECT HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode
										FROM @homelessNighttimeResidenceTable

										OPEN homelessNighttimeResidence_cursor
										FETCH NEXT FROM homelessNighttimeResidence_cursor INTO @homelessNighttimeResidenceId, @homelessNighttimeResidenceCode, @homelessNighttimeResidenceDescription, @homelessNighttimeResidenceEdFactsCode

										WHILE @@FETCH_STATUS = 0
										BEGIN
					

										if  @sexCode = 'MISSING'
										and @ecoDisStatusCode = 'MISSING'
										and @homelessStatusCode = 'MISSING'
										and @lepCode = 'MISSING'
										and @migrantStatusCode = 'MISSING'
										and @militaryConnectedStatusCode = 'MISSING'
										and @homelessUnaccompaniedYouthStatusCode = 'MISSING'
										and @homelessNighttimeResidenceCode = 'MISSING'
										begin

											if not exists(select 1 from RDS.DimDemographics where SexCode = @sexCode and EcoDisStatusCode = @ecoDisStatusCode
											and HomelessStatusCode = @homelessStatusCode and LEPStatusCode = @lepCode and MigrantStatusCode = @migrantStatusCode
											and MilitaryConnectedStatusCode = @militaryConnectedStatusCode 
											and HomelessUnaccompaniedYouthStatusCode = @homelessUnaccompaniedYouthStatusCode
											and HomelessNighttimeResidenceCode = @homelessNighttimeResidenceCode)
											begin

												set identity_insert rds.DimDemographics on

												insert into RDS.DimDemographics
												(
												DimDemographicId,
												SexId, SexCode, SexDescription, SexEdFactsCode,
												EcoDisStatusId, EcoDisStatusCode, EcoDisStatusDescription, EcoDisStatusEdFactsCode,
												HomelessStatusId, HomelessStatusCode, HomelessStatusDescription, HomelessStatusEdFactsCode,
												LEPStatusId, LEPStatusCode, LEPStatusDescription, LEPStatusEdFactsCode,
												MigrantStatusId, MigrantStatusCode, MigrantStatusDescription, MigrantStatusEdFactsCode,
												MilitaryConnectedStatusId, MilitaryConnectedStatusCode, MilitaryConnectedStatusDescription, MilitaryConnectedStatusEdFactsCode,
												HomelessUnaccompaniedYouthStatusId,HomelessUnaccompaniedYouthStatusCode,HomelessUnaccompaniedYouthStatusDescription,HomelessUnaccompaniedYouthStatusEdFactsCode,
												HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode
												)
												values
												(
												-1,
												@sexId, @sexCode, @sexDescription, @sexEdFactsCode,
												@ecoDisStatusId, @ecoDisStatusCode, @ecoDisStatusDescription, @ecoDisStatusEdFactsCode,
												@homelessStatusId, @homelessStatusCode, @homelessStatusDescription, @homelessStatusEdFactsCode,
												@lepId, @lepCode, @lepDescription, @lepEdFactsCode,
												@migrantStatusId, @migrantStatusCode, @migrantStatusDescription, @migrantStatusEdFactsCode,
												@militaryConnectedStatusId, @militaryConnectedStatusCode, @militaryConnectedStatusDescription, @militaryConnectedStatusEdFactsCode,
												@homelessUnaccompaniedYouthStatusId, @homelessUnaccompaniedYouthStatusCode, @homelessUnaccompaniedYouthStatusDescription, @homelessUnaccompaniedYouthStatusEdFactsCode,
												@homelessNighttimeResidenceId, @homelessNighttimeResidenceCode, @homelessNighttimeResidenceDescription, @homelessNighttimeResidenceEdFactsCode
												)

												set identity_insert rds.DimDemographics off
											end
										end
										else
										begin

											if not exists(select 1 from RDS.DimDemographics where SexCode = @sexCode and EcoDisStatusCode = @ecoDisStatusCode
											and HomelessStatusCode = @homelessStatusCode and LEPStatusCode = @lepCode and MigrantStatusCode = @migrantStatusCode
											and MilitaryConnectedStatusCode = @militaryConnectedStatusCode 
											and HomelessUnaccompaniedYouthStatusCode = @homelessUnaccompaniedYouthStatusCode
											and HomelessNighttimeResidenceCode = @homelessNighttimeResidenceCode)
											begin

												insert into RDS.DimDemographics
												(
												SexId, SexCode, SexDescription, SexEdFactsCode,
												EcoDisStatusId, EcoDisStatusCode, EcoDisStatusDescription, EcoDisStatusEdFactsCode,
												HomelessStatusId, HomelessStatusCode, HomelessStatusDescription, HomelessStatusEdFactsCode,
												LEPStatusId, LEPStatusCode, LEPStatusDescription, LEPStatusEdFactsCode,
												MigrantStatusId, MigrantStatusCode, MigrantStatusDescription, MigrantStatusEdFactsCode,
												MilitaryConnectedStatusId, MilitaryConnectedStatusCode, MilitaryConnectedStatusDescription, MilitaryConnectedStatusEdFactsCode,
												HomelessUnaccompaniedYouthStatusId,HomelessUnaccompaniedYouthStatusCode,HomelessUnaccompaniedYouthStatusDescription,HomelessUnaccompaniedYouthStatusEdFactsCode,
												HomelessNighttimeResidenceId,HomelessNighttimeResidenceCode,HomelessNighttimeResidenceDescription,HomelessNighttimeResidenceEdFactsCode
												)
												values
												(
												@sexId, @sexCode, @sexDescription, @sexEdFactsCode,
												@ecoDisStatusId, @ecoDisStatusCode, @ecoDisStatusDescription, @ecoDisStatusEdFactsCode,
												@homelessStatusId, @homelessStatusCode, @homelessStatusDescription, @homelessStatusEdFactsCode,
												@lepId, @lepCode, @lepDescription, @lepEdFactsCode,
												@migrantStatusId, @migrantStatusCode, @migrantStatusDescription, @migrantStatusEdFactsCode,
												@militaryConnectedStatusId, @militaryConnectedStatusCode, @militaryConnectedStatusDescription, @militaryConnectedStatusEdFactsCode,
												@homelessUnaccompaniedYouthStatusId, @homelessUnaccompaniedYouthStatusCode, @homelessUnaccompaniedYouthStatusDescription, @homelessUnaccompaniedYouthStatusEdFactsCode,
												@homelessNighttimeResidenceId, @homelessNighttimeResidenceCode, @homelessNighttimeResidenceDescription, @homelessNighttimeResidenceEdFactsCode
												)

											end

										end

										FETCH NEXT FROM homelessNighttimeResidence_cursor INTO @homelessNighttimeResidenceId, @homelessNighttimeResidenceCode, @homelessNighttimeResidenceDescription, @homelessNighttimeResidenceEdFactsCode
										END

										CLOSE homelessNighttimeResidence_cursor
										DEALLOCATE homelessNighttimeResidence_cursor

									FETCH NEXT FROM homelessUnaccompaniedYouthStatus_cursor INTO @homelessUnaccompaniedYouthStatusId, @homelessUnaccompaniedYouthStatusCode, @homelessUnaccompaniedYouthStatusDescription, @homelessUnaccompaniedYouthStatusEdFactsCode
									END

									CLOSE homelessUnaccompaniedYouthStatus_cursor
									DEALLOCATE homelessUnaccompaniedYouthStatus_cursor
								
								FETCH NEXT FROM militaryConnectedStatus_cursor INTO @militaryConnectedStatusId, @militaryConnectedStatusCode, @militaryConnectedStatusDescription, @militaryConnectedStatusEdFactsCode
								END

								CLOSE militaryConnectedStatus_cursor
								DEALLOCATE militaryConnectedStatus_cursor
		
							FETCH NEXT FROM migrantStatus_cursor INTO @migrantStatusId, @migrantStatusCode, @migrantStatusDescription, @migrantStatusEdFactsCode
						END

						CLOSE migrantStatus_cursor
						DEALLOCATE migrantStatus_cursor


						FETCH NEXT FROM lep_cursor INTO @lepId, @lepCode, @lepDescription, @lepEdFactsCode
					END

					CLOSE lep_cursor
					DEALLOCATE lep_cursor



					FETCH NEXT FROM homelessStatus_cursor INTO @homelessStatusId, @homelessStatusCode, @homelessStatusDescription, @homelessStatusEdFactsCode
				END

				CLOSE homelessStatus_cursor
				DEALLOCATE homelessStatus_cursor


				FETCH NEXT FROM ecoDisStatus_cursor INTO @ecoDisStatusId, @ecoDisStatusCode, @ecoDisStatusDescription, @ecoDisStatusEdFactsCode
			END

			CLOSE ecoDisStatus_cursor
			DEALLOCATE ecoDisStatus_cursor


		

			FETCH NEXT FROM sex_cursor INTO @sexId, @sexCode, @sexDescription, @sexEdFactsCode
		END

		CLOSE sex_cursor
		DEALLOCATE sex_cursor

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
