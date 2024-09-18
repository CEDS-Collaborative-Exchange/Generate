-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction		
			
		 Update RDS.DimDirectoryStatuses set McKinneyVentoSubgrantRecipientId = -1,
											 McKinneyVentoSubgrantRecipientCode = 'MISSING',
											 McKinneyVentoSubgrantRecipientDescription = 'MISSING',
											 McKinneyVentoSubgrantRecipientEdFactsCode = 'MISSING'											 
		  where McKinneyVentoSubgrantRecipientId is NULL  
	
	
		declare @CharterLeaStatusId as int
			declare @CharterLeaStatusCode as varchar(50)
			declare @CharterLeaStatusDescription as varchar(200)
			declare @CharterLeaStatusEdFactsCode as varchar(50)

			declare @CharterLeaStatusTable table(
				CharterLeaStatusId int,
				CharterLeaStatusCode varchar(50),
				CharterLeaStatusDescription varchar(200),
				CharterLeaStatusEdFactsCode varchar(50)
			); 

			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(1, 'NA', 'Not applicable', 'NA')

			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(2, 'NOTCHR', 'Not a charter district', 'NOTCHR')

			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(3, 'CHRTIDEA', 'Not LEA for federal programs (Charter district which is not an LEA for federal programs)', 'CHRTIDEA')

			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(4, 'CHRTIDEA', 'LEA for IDEA (Charter district which is an LEA for programs authorized under IDEA but not under ESEA and Perkins)', 'CHRTIDEA')
		
			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(5, 'CHRTESEA', 'LEA for ESEA and Perkins (Charter district which is an LEA for programs authorized under ESEA and Perkins but not under IDEA)', 'CHRTESEA')

			insert into @CharterLeaStatusTable (CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode) 
			values 
			(6, 'CHRTIDEAESEA', 'LEA for federal programs (Charter district which is an LEA for programs authorized under IDEA, ESEA and Perkins)', 'CHRTIDEAESEA')


			declare @CharterSchoolStatusId as int
			declare @CharterSchoolStatusCode as varchar(50)
			declare @CharterSchoolStatusDescription as varchar(200)
			declare @CharterSchoolStatusEdFactsCode as varchar(50)

			declare @CharterSchoolStatusTable table(
				CharterSchoolStatusId int,
				CharterSchoolStatusCode varchar(50),
				CharterSchoolStatusDescription varchar(200),
				CharterSchoolStatusEdFactsCode varchar(50)
			); 

			insert into @CharterSchoolStatusTable (CharterSchoolStatusId, CharterSchoolStatusCode, CharterSchoolStatusDescription, CharterSchoolStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @CharterSchoolStatusTable (CharterSchoolStatusId, CharterSchoolStatusCode, CharterSchoolStatusDescription, CharterSchoolStatusEdFactsCode) 
			values 
			(1, 'NA', 'Not applicable', 'NA')

			insert into @CharterSchoolStatusTable (CharterSchoolStatusId, CharterSchoolStatusCode, CharterSchoolStatusDescription, CharterSchoolStatusEdFactsCode) 
			values 
			(2, 'YES', 'Charter school', 'YES')

			insert into @CharterSchoolStatusTable (CharterSchoolStatusId, CharterSchoolStatusCode, CharterSchoolStatusDescription, CharterSchoolStatusEdFactsCode) 
			values 
			(3, 'NO', 'Not a charter school', 'NO')


			declare @ReconstitutedStatusId as int
			declare @ReconstitutedStatusCode as varchar(50)
			declare @ReconstitutedStatusDescription as varchar(200)
			declare @ReconstitutedStatusEdFactsCode as varchar(50)

			declare @ReconstitutedStatusTable table(
				ReconstitutedStatusId int,
				ReconstitutedStatusCode varchar(50),
				ReconstitutedStatusDescription varchar(200),
				ReconstitutedStatusEdFactsCode varchar(50)
			); 

		
			insert into @ReconstitutedStatusTable (ReconstitutedStatusId, ReconstitutedStatusCode, ReconstitutedStatusDescription, ReconstitutedStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @ReconstitutedStatusTable (ReconstitutedStatusId, ReconstitutedStatusCode, ReconstitutedStatusDescription, ReconstitutedStatusEdFactsCode) 
			values 
			(1, 'Yes', 'Reconstituted school', 'YES')

			insert into @ReconstitutedStatusTable (ReconstitutedStatusId, ReconstitutedStatusCode, ReconstitutedStatusDescription, ReconstitutedStatusEdFactsCode) 
			values 
			(2, 'No', 'Not a reconstituted school', 'No')


			declare @OperationalStatusId as int
			declare @OperationalStatusCode as varchar(50)
			declare @OperationalStatusDescription as varchar(200)
			declare @OperationalStatusEdFactsCode as varchar(50)

			declare @OperationalStatusTable table(
				OperationalStatusId int,
				OperationalStatusCode varchar(50),
				OperationalStatusDescription varchar(200),
				OperationalStatusEdFactsCode varchar(50)
			);
		

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values 
			(1,	'Open',	'Open', 'Open')

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (2,	'Closed',	'Closed', 'Closed')

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (3,	'New',	'New', 'New')

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (4,	'Added',	'Added','Added')
		
			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (5,	'Changed boundary',	'Changed geographic boundary', 'ChangedBoundary' )

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (6,	'Inactive',	'Inactive', 'Inactive')

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (7,	'FutureAgency','Future agency', 'Future')

			insert into @OperationalStatusTable ( OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode) 
			values (8,	'Reopened',	'Reopened', 'Reopened')



			declare @UpdatedOperationalStatusId as int
			declare @UpdatedOperationalStatusCode as varchar(50)
			declare @UpdatedOperationalStatusDescription as varchar(200)
			declare @UpdatedOperationalStatusEdFactsCode as varchar(50)

			declare @UpdatedOperationalStatusTable table(
				UpdatedOperationalStatusId int,
				UpdatedOperationalStatusCode varchar(50),
				UpdatedOperationalStatusDescription varchar(200),
				UpdatedOperationalStatusEdFactsCode varchar(50)
			);
		

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values 
			(1,	'Open',	'Open', 'Open')

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (2,	'Closed',	'Closed', 'Closed')

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (3,	'New',	'New', 'New')

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (4,	'Added',	'Added','Added')
		
			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (5,	'Changed boundary',	'Changed geographic boundary', 'ChangedBoundary' )

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (6,	'Inactive',	'Inactive', 'Inactive')

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (7,	'FutureAgency','Future agency', 'Future')

			insert into @UpdatedOperationalStatusTable ( UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode) 
			values (8,	'Reopened',	'Reopened', 'Reopened')


			declare @McKinneyVentoSubgrantRecipientId as int
			declare @McKinneyVentoSubgrantRecipientCode as varchar(50)
			declare @McKinneyVentoSubgrantRecipientDescription as varchar(200)
			declare @McKinneyVentoSubgrantRecipientEdFactsCode as varchar(50)

			declare @McKinneyVentoSubgrantRecipientTable table(
				McKinneyVentoSubgrantRecipientId int,
				McKinneyVentoSubgrantRecipientCode varchar(50),
				McKinneyVentoSubgrantRecipientDescription varchar(200),
				McKinneyVentoSubgrantRecipientEdFactsCode varchar(50)
			);

			insert into @McKinneyVentoSubgrantRecipientTable ( McKinneyVentoSubgrantRecipientId, McKinneyVentoSubgrantRecipientCode, McKinneyVentoSubgrantRecipientDescription, McKinneyVentoSubgrantRecipientEdFactsCode) 
			values (-1, 'MISSING', 'Missing', 'MISSING')

				insert into @McKinneyVentoSubgrantRecipientTable ( McKinneyVentoSubgrantRecipientId, McKinneyVentoSubgrantRecipientCode, McKinneyVentoSubgrantRecipientDescription, McKinneyVentoSubgrantRecipientEdFactsCode) 
			values (1,	'Yes','Received McKinney-Vento subgrant recipient', 'MVSUBGYES')

				insert into @McKinneyVentoSubgrantRecipientTable ( McKinneyVentoSubgrantRecipientId, McKinneyVentoSubgrantRecipientCode, McKinneyVentoSubgrantRecipientDescription, McKinneyVentoSubgrantRecipientEdFactsCode) 
			values (2,	'No','Do not Receive McKinney-Vento subgrant', 'MVSUBGNO')




			DECLARE CharterLeaStatus_cursor CURSOR FOR 
			SELECT CharterLeaStatusId, CharterLeaStatusCode, CharterLeaStatusDescription, CharterLeaStatusEdFactsCode
			FROM @CharterLeaStatusTable

			OPEN CharterLeaStatus_cursor
			FETCH NEXT FROM CharterLeaStatus_cursor INTO @CharterLeaStatusId, @CharterLeaStatusCode, @CharterLeaStatusDescription, @CharterLeaStatusEdFactsCode

			WHILE @@FETCH_STATUS = 0
			BEGIN

			
				DECLARE CharterSchoolStatus_cursor CURSOR FOR 
				SELECT CharterSchoolStatusId, CharterSchoolStatusCode, CharterSchoolStatusDescription, CharterSchoolStatusEdFactsCode
				FROM @CharterSchoolStatusTable

				OPEN CharterSchoolStatus_cursor
				FETCH NEXT FROM CharterSchoolStatus_cursor INTO @CharterSchoolStatusId, @CharterSchoolStatusCode, @CharterSchoolStatusDescription, @CharterSchoolStatusEdFactsCode
				WHILE @@FETCH_STATUS = 0
				BEGIN
				
				
					DECLARE ReconstitutedStatus_cursor CURSOR FOR 
					SELECT ReconstitutedStatusId, ReconstitutedStatusCode, ReconstitutedStatusDescription, ReconstitutedStatusEdFactsCode
					FROM @ReconstitutedStatusTable

					OPEN ReconstitutedStatus_cursor
					FETCH NEXT FROM ReconstitutedStatus_cursor INTO @ReconstitutedStatusId, @ReconstitutedStatusCode, @ReconstitutedStatusDescription, @ReconstitutedStatusEdFactsCode
					WHILE @@FETCH_STATUS = 0
					BEGIN

						DECLARE OperationalStatus_cursor CURSOR FOR 
						SELECT OperationalStatusId, OperationalStatusCode, OperationalStatusDescription, OperationalStatusEdFactsCode
						FROM @OperationalStatusTable

						OPEN OperationalStatus_cursor
						FETCH NEXT FROM OperationalStatus_cursor INTO @OperationalStatusId, @OperationalStatusCode, @OperationalStatusDescription, @OperationalStatusEdFactsCode
						WHILE @@FETCH_STATUS = 0
						BEGIN

							DECLARE UpdatedOperationalStatus_cursor CURSOR FOR 
							SELECT UpdatedOperationalStatusId, UpdatedOperationalStatusCode, UpdatedOperationalStatusDescription, UpdatedOperationalStatusEdFactsCode
							FROM @UpdatedOperationalStatusTable

							OPEN UpdatedOperationalStatus_cursor
							FETCH NEXT FROM UpdatedOperationalStatus_cursor INTO @UpdatedOperationalStatusId, @UpdatedOperationalStatusCode, @UpdatedOperationalStatusDescription, @UpdatedOperationalStatusEdFactsCode
							WHILE @@FETCH_STATUS = 0
							BEGIN

								--if @UpdatedOperationalStatusCode = 'MISSING' AND @OperationalStatusCode = 'MISSING' AND @ReconstitutedStatusCode = 'MISSING' AND @CharterSchoolStatusCode ='MISSING' AND @CharterLeaStatusCode = 'MISSING'
								--BEGIN


								DECLARE McKinneyVentoSubgrantRecipient_cursor CURSOR FOR 
								SELECT McKinneyVentoSubgrantRecipientId, McKinneyVentoSubgrantRecipientCode, McKinneyVentoSubgrantRecipientDescription, McKinneyVentoSubgrantRecipientEdFactsCode
								FROM @McKinneyVentoSubgrantRecipientTable

								OPEN McKinneyVentoSubgrantRecipient_cursor
								FETCH NEXT FROM McKinneyVentoSubgrantRecipient_cursor INTO @McKinneyVentoSubgrantRecipientId, @McKinneyVentoSubgrantRecipientCode, @McKinneyVentoSubgrantRecipientDescription, @McKinneyVentoSubgrantRecipientEdFactsCode
								WHILE @@FETCH_STATUS = 0
								BEGIN

								if @UpdatedOperationalStatusCode = 'MISSING' AND @OperationalStatusCode = 'MISSING' AND @ReconstitutedStatusCode = 'MISSING' AND @CharterSchoolStatusCode ='MISSING' AND @CharterLeaStatusCode = 'MISSING' and @McKinneyVentoSubgrantRecipientCode  = 'MISSING'
								BEGIN


								
								if not exists (select 1 from rds.DimDirectoryStatuses where  UpdatedOperationalStatusCode= @UpdatedOperationalStatusCode  AND OperationalStatusCode = @OperationalStatusCode  AND ReconstitutedStatusCode= @ReconstitutedStatusCode  AND CharterSchoolStatusCode = @CharterSchoolStatusCode  AND CharterLeaStatusCode= @CharterLeaStatusCode and McKinneyVentoSubgrantRecipientCode= @McKinneyVentoSubgrantRecipientCode   )
								BEGIN

									set identity_insert rds.DimDirectoryStatuses on

									insert into rds.DimDirectoryStatuses (
																		DimDirectoryStatusId, OperationalStatusId,  OperationalStatusCode , OperationalStatusDescription ,OperationalStatusEdFactsCode ,
																		CharterLeaStatusId , CharterLeaStatusCode ,CharterLeaStatusDescription ,CharterLeaStatusEdFactsCode ,		         
																		CharterSchoolStatusId ,CharterSchoolStatusCode ,CharterSchoolStatusDescription ,CharterSchoolStatusEdFactsCode ,        
																		ReconstitutedStatusId , ReconstitutedStatusCode ,ReconstitutedStatusDescription ,ReconstitutedStatusEdFactsCode ,
																		UpdatedOperationalStatusId,  UpdatedOperationalStatusCode , UpdatedOperationalStatusDescription ,UpdatedOperationalStatusEdFactsCode,
																		McKinneyVentoSubgrantRecipientId, McKinneyVentoSubgrantRecipientCode, McKinneyVentoSubgrantRecipientDescription, McKinneyVentoSubgrantRecipientEdFactsCode

																		)
																		VALUES (
																		-1, @OperationalStatusId,  @OperationalStatusCode , @OperationalStatusDescription ,@OperationalStatusEdFactsCode ,
																		@CharterLeaStatusId , @CharterLeaStatusCode ,@CharterLeaStatusDescription ,@CharterLeaStatusEdFactsCode ,		         
																		@CharterSchoolStatusId ,@CharterSchoolStatusCode ,@CharterSchoolStatusDescription ,@CharterSchoolStatusEdFactsCode ,        
																		@ReconstitutedStatusId , @ReconstitutedStatusCode ,@ReconstitutedStatusDescription ,@ReconstitutedStatusEdFactsCode,
																		@UpdatedOperationalStatusId, @UpdatedOperationalStatusCode, @UpdatedOperationalStatusDescription, @UpdatedOperationalStatusEdFactsCode,
																		@McKinneyVentoSubgrantRecipientId, @McKinneyVentoSubgrantRecipientCode, @McKinneyVentoSubgrantRecipientDescription, @McKinneyVentoSubgrantRecipientEdFactsCode
																		)

									set identity_insert rds.DimDirectoryStatuses off

								END
								END
								ELSE
								BEGIN

								IF NOT EXISTS(select 1 from RDS.DimDirectoryStatuses where OperationalStatusCode = @OperationalStatusCode and CharterLeaStatusCode = @CharterLeaStatusCode
											and CharterSchoolStatusCode = @CharterSchoolStatusCode and ReconstitutedStatusCode = @ReconstitutedStatusCode and UpdatedOperationalStatusCode = @UpdatedOperationalStatusCode
											and McKinneyVentoSubgrantRecipientCode = @McKinneyVentoSubgrantRecipientCode)
											begin


									insert into rds.DimDirectoryStatuses (
																		OperationalStatusId,  OperationalStatusCode , OperationalStatusDescription ,OperationalStatusEdFactsCode ,
																		CharterLeaStatusId , CharterLeaStatusCode ,CharterLeaStatusDescription ,CharterLeaStatusEdFactsCode ,		         
																		CharterSchoolStatusId ,CharterSchoolStatusCode ,CharterSchoolStatusDescription ,CharterSchoolStatusEdFactsCode ,        
																		ReconstitutedStatusId , ReconstitutedStatusCode ,ReconstitutedStatusDescription ,ReconstitutedStatusEdFactsCode,
																		UpdatedOperationalStatusId,  UpdatedOperationalStatusCode , UpdatedOperationalStatusDescription ,UpdatedOperationalStatusEdFactsCode,
																		McKinneyVentoSubgrantRecipientId, McKinneyVentoSubgrantRecipientCode, McKinneyVentoSubgrantRecipientDescription, McKinneyVentoSubgrantRecipientEdFactsCode
																		)
																		VALUES (
																		@OperationalStatusId,  @OperationalStatusCode , @OperationalStatusDescription ,@OperationalStatusEdFactsCode ,
																		@CharterLeaStatusId , @CharterLeaStatusCode ,@CharterLeaStatusDescription ,@CharterLeaStatusEdFactsCode ,		         
																		@CharterSchoolStatusId ,@CharterSchoolStatusCode ,@CharterSchoolStatusDescription ,@CharterSchoolStatusEdFactsCode ,        
																		@ReconstitutedStatusId , @ReconstitutedStatusCode ,@ReconstitutedStatusDescription ,@ReconstitutedStatusEdFactsCode,
																		@UpdatedOperationalStatusId, @UpdatedOperationalStatusCode, @UpdatedOperationalStatusDescription, @UpdatedOperationalStatusEdFactsCode,
																		@McKinneyVentoSubgrantRecipientId, @McKinneyVentoSubgrantRecipientCode, @McKinneyVentoSubgrantRecipientDescription, @McKinneyVentoSubgrantRecipientEdFactsCode)
								END
							END
							
							FETCH NEXT FROM McKinneyVentoSubgrantRecipient_cursor INTO @McKinneyVentoSubgrantRecipientId, @McKinneyVentoSubgrantRecipientCode, @McKinneyVentoSubgrantRecipientDescription, @McKinneyVentoSubgrantRecipientEdFactsCode
							END
							CLOSE McKinneyVentoSubgrantRecipient_cursor
							DEALLOCATE McKinneyVentoSubgrantRecipient_cursor
							
							FETCH NEXT FROM UpdatedOperationalStatus_cursor INTO @UpdatedOperationalStatusId, @UpdatedOperationalStatusCode, @UpdatedOperationalStatusDescription, @UpdatedOperationalStatusEdFactsCode
							END
							CLOSE UpdatedOperationalStatus_cursor
							DEALLOCATE UpdatedOperationalStatus_cursor
					

						FETCH NEXT FROM OperationalStatus_cursor INTO @OperationalStatusId, @OperationalStatusCode, @OperationalStatusDescription, @OperationalStatusEdFactsCode
						END
						CLOSE OperationalStatus_cursor
						DEALLOCATE OperationalStatus_cursor
					


					FETCH NEXT FROM ReconstitutedStatus_cursor INTO @ReconstitutedStatusId, @ReconstitutedStatusCode, @ReconstitutedStatusDescription, @ReconstitutedStatusEdFactsCode
					END
					CLOSE ReconstitutedStatus_cursor
					DEALLOCATE ReconstitutedStatus_cursor


				FETCH NEXT FROM CharterSchoolStatus_cursor INTO @CharterSchoolStatusId, @CharterSchoolStatusCode, @CharterSchoolStatusDescription, @CharterSchoolStatusEdFactsCode
				END
				CLOSE CharterSchoolStatus_cursor
				DEALLOCATE CharterSchoolStatus_cursor

		

			FETCH NEXT FROM CharterLeaStatus_cursor INTO @CharterLeaStatusId, @CharterLeaStatusCode, @CharterLeaStatusDescription, @CharterLeaStatusEdFactsCode
			END
		
			CLOSE CharterLeaStatus_cursor
			DEALLOCATE CharterLeaStatus_cursor
	
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
