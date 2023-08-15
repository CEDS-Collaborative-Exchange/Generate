-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction

			---------- Set the new added dimension to MISSING ---------------------------------------------------------------

		  Update RDS.DimSchoolStatuses set StatePovertyDesignationId = -1 where StatePovertyDesignationId is NULL
		  Update RDS.DimSchoolStatuses set StatePovertyDesignationCode = 'MISSING' where StatePovertyDesignationCode is NULL
		  Update RDS.DimSchoolStatuses set StatePovertyDesignationDescription = 'MISSING' where StatePovertyDesignationDescription is NULL
		  Update RDS.DimSchoolStatuses set StatePovertyDesignationEdFactsCode = 'MISSING' where StatePovertyDesignationEdFactsCode is NULL
		  Update RDS.DimSchoolStatuses set ProgressAchievingEnglishLanguageId = -1 where ProgressAchievingEnglishLanguageId is NULL
		  Update RDS.DimSchoolStatuses set ProgressAchievingEnglishLanguageCode = 'MISSING' where ProgressAchievingEnglishLanguageCode is NULL
		  Update RDS.DimSchoolStatuses set ProgressAchievingEnglishLanguageDescription = 'MISSING' where ProgressAchievingEnglishLanguageDescription is NULL
		  Update RDS.DimSchoolStatuses set ProgressAchievingEnglishLanguageEdFactsCode = 'MISSING' where ProgressAchievingEnglishLanguageEdFactsCode is NULL
		  	-------- Insert Non missing records in the added dimension ---------------------------------------------------------
			
		declare @ProgressAchievingEnglishLanguageId as int
		declare @ProgressAchievingEnglishLanguageCode as varchar(50)
		declare @ProgressAchievingEnglishLanguageDescription as varchar(200)
		declare @ProgressAchievingEnglishLanguageEdFactsCode as varchar(50)

		declare @ProgressAchievingEnglishLanguageTable table(
			ProgressAchievingEnglishLanguageId int,
			ProgressAchievingEnglishLanguageCode varchar(50),
			ProgressAchievingEnglishLanguageDescription varchar(200),
			ProgressAchievingEnglishLanguageEdFactsCode varchar(50)
		); 

		insert into @ProgressAchievingEnglishLanguageTable (ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode, ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @ProgressAchievingEnglishLanguageTable (ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode,ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode) 
		values 
		(1, 'STTDEF', 'A status defined by the state', 'STTDEF')

			insert into @ProgressAchievingEnglishLanguageTable (ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode,ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode) 
		values 
		(2, 'TOOFEW', 'The number of students in the school was less than the minimum group size.', 'TOOFEW')
			insert into @ProgressAchievingEnglishLanguageTable (ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode,ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode) 
		values 
		(3, 'NOSTUDENTS', 'There are no students', 'NOSTUDENTS')

		declare @SharedTimeStatusId as int
		declare @SharedTimeStatusCode as varchar(50)
		declare @SharedTimeStatusDescription as varchar(200)
		declare @SharedTimeStatusEdFactsCode as varchar(50)

		declare @SharedTimeStatusTable table(
			SharedTimeStatusId int,
			SharedTimeStatusCode varchar(50),
			SharedTimeStatusDescription varchar(200),
			SharedTimeStatusEdFactsCode varchar(50)
		); 

		insert into @SharedTimeStatusTable (SharedTimeStatusId, SharedTimeStatusCode, SharedTimeStatusDescription, SharedTimeStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @SharedTimeStatusTable (SharedTimeStatusId, SharedTimeStatusCode, SharedTimeStatusDescription, SharedTimeStatusEdFactsCode) 
		values 
		(1, 'YES', 'Shared Time Yes', 'YES')

		insert into @SharedTimeStatusTable (SharedTimeStatusId, SharedTimeStatusCode, SharedTimeStatusDescription, SharedTimeStatusEdFactsCode) 
		values 
		(2, 'NO', 'Shared Time No', 'NO')


		declare @PersistentlyDangerousId as int
		declare @PersistentlyDangerousCode as varchar(50)
		declare @PersistentlyDangerousDescription as varchar(200)
		declare @PersistentlyDangerousEdFactsCode as varchar(50)

		declare @PersistentlyDangerousTable table(
			PersistentlyDangerousId int,
			PersistentlyDangerousCode varchar(50),
			PersistentlyDangerousDescription varchar(200),
			PersistentlyDangerousEdFactsCode varchar(50)
		); 

		insert into @PersistentlyDangerousTable (PersistentlyDangerousId, PersistentlyDangerousCode, PersistentlyDangerousDescription, PersistentlyDangerousEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @PersistentlyDangerousTable (PersistentlyDangerousId, PersistentlyDangerousCode, PersistentlyDangerousDescription, PersistentlyDangerousEdFactsCode) 
		values 
		(1, 'YES', 'Persistently Dangerous', 'YES')

		insert into @PersistentlyDangerousTable (PersistentlyDangerousId, PersistentlyDangerousCode, PersistentlyDangerousDescription, PersistentlyDangerousEdFactsCode)  
		values 
		(2, 'NO', 'Not persistently dangerous', 'NO')


		declare @ImprovementStatusId as int
		declare @ImprovementStatusCode as varchar(50)
		declare @ImprovementStatusDescription as varchar(200)
		declare @ImprovementStatusEdFactsCode as varchar(50)

		declare @ImprovementStatusTable table(
			ImprovementStatusId int,
			ImprovementStatusCode varchar(50),
			ImprovementStatusDescription varchar(200),
			ImprovementStatusEdFactsCode varchar(50)
		); 

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(1, 'CORRACT', 'Corrective Action', 'CORRACT')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(2, 'IMPYR1', 'Improvement Year 1', 'IMPYR1')
		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(3, 'IMPYR2 ', 'Improvement Year 2', 'IMPYR2')
		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(4, 'NOTIDENT', 'Not Identified for Improvement', 'NOTIDENT')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(5, 'RESTRPLAN', 'Restructuring Planning', 'RESTRPLAN')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(6, 'RESTR', 'Restructuring', 'RESTR')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(6, 'PRIORITY', 'Priority School', 'PRIORITY')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(6, 'FOCUS', 'Focus School', 'FOCUS')

		insert into @ImprovementStatusTable (ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode)  
		values 
		(6, 'NOTPRFOC', 'School that is neither Priority or Focus', 'NOTPRFOC')

		declare @MagnetStatusId as int
		declare @MagnetStatusCode as varchar(50)
		declare @MagnetStatusDescription as varchar(200)
		declare @MagnetStatusEdFactsCode as varchar(50)

		declare @MagnetStatusTable table(
			MagnetStatusId int,
			MagnetStatusCode varchar(50),
			MagnetStatusDescription varchar(200),
			MagnetStatusEdFactsCode varchar(50)
		); 

		insert into @MagnetStatusTable (MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @MagnetStatusTable (MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode) 
		values 
		(1, 'All', 'All students participate', 'MAGYES')

		insert into @MagnetStatusTable (MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode) 
		values 
		(3, 'Some', 'Some, but not all, students participate', 'MAGYES')

		insert into @MagnetStatusTable (MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode) 
		values 
		(2, 'None', 'No students participate', 'MAGNO')

		--insert into @MagnetStatusTable (MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode) 
		--values 
		--(, '', '', 'NA ')


		
		
		declare @NSLPStatusId as int
		declare @NSLPStatusCode as varchar(50)
		declare @NSLPStatusDescription as varchar(200)
		declare @NSLPStatusEdFactsCode as varchar(50)

		declare @NSLPStatusTable table(
			NSLPStatusId int,
			NSLPStatusCode varchar(50),
			NSLPStatusDescription varchar(200),
			NSLPStatusEdFactsCode varchar(50)
		); 

		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (-1, 'MISSING', 'Missing', 'MISSING')

		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (1,'NSLPPRO1', 'Provision 1', 'NSLPPRO1')
		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (2, 'NSLPPRO2', 'Provision 2', 'NSLPPRO3')
		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (3, 'NSLPPRO3','Provision 3', 'NSLPPRO3')
		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (4, 'NSLPCEO', 'Community Eligibility Option', 'NSLPCEO')
		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (5, 'NSLPNO', 'Not Participating', 'NSLPNO')
		insert into @NSLPStatusTable (NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode) 
		values (6, 'NSLPWOPRO', 'Without using any Provision or the CEO', 'NSLPWOPRO')
	

		declare @VirtualSchoolStatusId as int
		declare @VirtualSchoolStatusCode as varchar(50)
		declare @VirtualSchoolStatusDescription as varchar(200)
		declare @VirtualSchoolStatusEdFactsCode as varchar(50)

		declare @VirtualSchoolStatusTable table(
			VirtualSchoolStatusId int,
			VirtualSchoolStatusCode varchar(50),
			VirtualSchoolStatusDescription varchar(200),
			VirtualSchoolStatusEdFactsCode varchar(50)
		); 

		insert into @VirtualSchoolStatusTable (VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode) 
		values (-1, 'MISSING', 'Missing', 'MISSING')

		insert into @VirtualSchoolStatusTable (VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode) 
		values (1, 'FULLVIRTUAL', 'The school has no physical building where students meet with each other or with teachers, all instruction is virtual', 'FULLVIRTUAL')

		insert into @VirtualSchoolStatusTable (VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode) 
		values (2, 'FACEVIRTUAL', 'The school focuses on a systematic program of virtual instruction but includes some physical meetings among students or with teachers', 'FACEVIRTUAL')

		insert into @VirtualSchoolStatusTable (VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode) 
		values (3, 'SUPPVIRTUAL', 'The school offers virtual courses but virtual instruction is not the primary means of instruction', 'SUPPVIRTUAL')

		insert into @VirtualSchoolStatusTable (VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode) 
		values (4, 'NOTVIRTUAL', 'The school does not offer any virtual instruction', 'NOTVIRTUAL')

		
		declare @StatePovertyDesignationId as int
		declare @StatePovertyDesignationCode as varchar(50)
		declare @StatePovertyDesignationDescription as varchar(200)
		declare @StatePovertyDesignationEdFactsCode as varchar(50)

		declare @StatePovertyDesignationTable table(
			StatePovertyDesignationId int,
			StatePovertyDesignationCode varchar(50),
			StatePovertyDesignationDescription varchar(200),
			StatePovertyDesignationEdFactsCode varchar(50)
		); 

		insert into @StatePovertyDesignationTable (StatePovertyDesignationId, StatePovertyDesignationCode, StatePovertyDesignationDescription, StatePovertyDesignationEdFactsCode) 
		values (1, 'HIGH', 'High poverty quartile school', 'HIGH')

		insert into @StatePovertyDesignationTable (StatePovertyDesignationId, StatePovertyDesignationCode, StatePovertyDesignationDescription, StatePovertyDesignationEdFactsCode) 
		values (2, 'LOW', 'Low poverty quartile school', 'LOW')

		insert into @StatePovertyDesignationTable (StatePovertyDesignationId, StatePovertyDesignationCode, StatePovertyDesignationDescription, StatePovertyDesignationEdFactsCode) 
		values (3, 'NEITHER', 'Neither high nor low poverty quartile school', 'NEITHER')

		
		DECLARE SharedTimeStatus_cursor CURSOR FOR 
		SELECT SharedTimeStatusId, SharedTimeStatusCode, SharedTimeStatusDescription, SharedTimeStatusEdFactsCode
		FROM @SharedTimeStatusTable

		OPEN SharedTimeStatus_cursor
		FETCH NEXT FROM SharedTimeStatus_cursor INTO @SharedTimeStatusId, @SharedTimeStatusCode, @SharedTimeStatusDescription, @SharedTimeStatusEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE MagnetStatus_cursor CURSOR FOR 
			SELECT MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode
			FROM @MagnetStatusTable

			OPEN MagnetStatus_cursor
			FETCH NEXT FROM MagnetStatus_cursor INTO @MagnetStatusId, @MagnetStatusCode, @MagnetStatusDescription, @MagnetStatusEdFactsCode
			WHILE @@FETCH_STATUS = 0
			BEGIN


				DECLARE ImprovementStatus_cursor CURSOR FOR 
				SELECT ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode
				FROM @ImprovementStatusTable

				OPEN ImprovementStatus_cursor
				FETCH NEXT FROM ImprovementStatus_cursor INTO @ImprovementStatusId, @ImprovementStatusCode, @ImprovementStatusDescription, @ImprovementStatusEdFactsCode
				WHILE @@FETCH_STATUS = 0
				BEGIN


					DECLARE PDStatus_cursor CURSOR FOR 
					SELECT PersistentlyDangerousId, PersistentlyDangerousCode, PersistentlyDangerousDescription, PersistentlyDangerousEdFactsCode
					FROM @PersistentlyDangerousTable
				
					OPEN PDStatus_cursor
					FETCH NEXT FROM PDStatus_cursor INTO @PersistentlyDangerousId, @PersistentlyDangerousCode, @PersistentlyDangerousDescription, @PersistentlyDangerousEdFactsCode
					WHILE @@FETCH_STATUS = 0
					BEGIN


						DECLARE NSLPStatus_cursor CURSOR FOR 
						SELECT NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode
						FROM @NSLPStatusTable

						OPEN NSLPStatus_cursor
						FETCH NEXT FROM NSLPStatus_cursor INTO @NSLPStatusId, @NSLPStatusCode, @NSLPStatusDescription, @NSLPStatusEdFactsCode
						WHILE @@FETCH_STATUS = 0
						BEGIN

							DECLARE VirtualSchoolStatus_cursor CURSOR FOR 
							SELECT VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode
							FROM @VirtualSchoolStatusTable

							OPEN VirtualSchoolStatus_cursor
							FETCH NEXT FROM VirtualSchoolStatus_cursor INTO @VirtualSchoolStatusId, @VirtualSchoolStatusCode, @VirtualSchoolStatusDescription, @VirtualSchoolStatusEdFactsCode
							WHILE @@FETCH_STATUS = 0
							BEGIN

								DECLARE StatePovertyDesignation_cursor CURSOR FOR 
								SELECT StatePovertyDesignationId, StatePovertyDesignationCode, StatePovertyDesignationDescription, StatePovertyDesignationEdFactsCode
								FROM @StatePovertyDesignationTable

								OPEN StatePovertyDesignation_cursor
								FETCH NEXT FROM StatePovertyDesignation_cursor INTO @StatePovertyDesignationId, @StatePovertyDesignationCode, @StatePovertyDesignationDescription, @StatePovertyDesignationEdFactsCode
								WHILE @@FETCH_STATUS = 0
								BEGIN


								DECLARE ProgressAchievingEnglishLanguage_cursor CURSOR FOR 
								SELECT ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode, ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode
								FROM @ProgressAchievingEnglishLanguageTable

								OPEN ProgressAchievingEnglishLanguage_cursor
								FETCH NEXT FROM ProgressAchievingEnglishLanguage_cursor INTO @ProgressAchievingEnglishLanguageId, @ProgressAchievingEnglishLanguageCode, @ProgressAchievingEnglishLanguageDescription, @ProgressAchievingEnglishLanguageEdFactsCode
								WHILE @@FETCH_STATUS = 0
								BEGIN


	

								IF @SharedTimeStatusCode = 'MISSING' AND @MagnetStatusCode = 'MISSING' AND @NSLPStatusCode ='MISSING' AND @VirtualSchoolStatusCode = 'MISSING' AND @ImprovementStatusCode='MISSING' and @PersistentlyDangerousCode='MISSING' and @StatePovertyDesignationCode = 'MISSING' and @ProgressAchievingEnglishLanguageCode='MISSING'
								BEGIN

								if not exists(select 1 from rds.DimSchoolStatuses where SharedTimeStatusCode = @SharedTimeStatusCode
											 and MagnetStatusCode = @MagnetStatusCode
											and NSLPStatusCode = @NSLPStatusCode and VirtualSchoolStatusCode = @VirtualSchoolStatusCode
											and PersistentlyDangerousStatusCode = @PersistentlyDangerousCode
											and ImprovementStatusCode = @ImprovementStatusCode 
											and StatePovertyDesignationCode = @StatePovertyDesignationCode
											and ProgressAchievingEnglishLanguageCode = @ProgressAchievingEnglishLanguageCode)
								begin
								set identity_insert rds.DimSchoolStatuses on

								INSERT INTO RDS.DimSchoolStatuses(DimSchoolStatusId, SharedTimeStatusId, SharedTimeStatusCode, SharedTimeStatusDescription, SharedTimeStatusEdFactsCode, 
								MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode,
								NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode,
								VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode
								,PersistentlyDangerousStatusId, PersistentlyDangerousStatusCode, PersistentlyDangerousStatusDescription, PersistentlyDangerousStatusEdFactsCode
								,ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode,
								StatePovertyDesignationId, StatePovertyDesignationCode, StatePovertyDesignationDescription, StatePovertyDesignationEdFactsCode,
								ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode, ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode)								
								VALUES(
								-1, @SharedTimeStatusId, @SharedTimeStatusCode, @SharedTimeStatusDescription, @SharedTimeStatusEdFactsCode, 
								@MagnetStatusId, @MagnetStatusCode, @MagnetStatusDescription, @MagnetStatusEdFactsCode,
								@NSLPStatusId, @NSLPStatusCode, @NSLPStatusDescription, @NSLPStatusEdFactsCode,
								@VirtualSchoolStatusId, @VirtualSchoolStatusCode, @VirtualSchoolStatusDescription, @VirtualSchoolStatusEdFactsCode
								,@PersistentlyDangerousId, @PersistentlyDangerousCode, @PersistentlyDangerousDescription, @PersistentlyDangerousEdFactsCode
								,@ImprovementStatusId, @ImprovementStatusCode, @ImprovementStatusDescription, @ImprovementStatusEdFactsCode,
								@StatePovertyDesignationId, @StatePovertyDesignationCode, @StatePovertyDesignationDescription, @StatePovertyDesignationEdFactsCode,
								@ProgressAchievingEnglishLanguageId, @ProgressAchievingEnglishLanguageCode, @ProgressAchievingEnglishLanguageDescription, @ProgressAchievingEnglishLanguageEdFactsCode
								)
	
								set identity_insert rds.DimSchoolStatuses off
								end
							END
							ELSE
							BEGIN

								if not exists(select 1 from rds.DimSchoolStatuses where SharedTimeStatusCode = @SharedTimeStatusCode
											 and MagnetStatusCode = @MagnetStatusCode
											and NSLPStatusCode = @NSLPStatusCode and VirtualSchoolStatusCode = @VirtualSchoolStatusCode
											and PersistentlyDangerousStatusCode = @PersistentlyDangerousCode
											and ImprovementStatusCode = @ImprovementStatusCode 
											and StatePovertyDesignationCode = @StatePovertyDesignationCode
											and ProgressAchievingEnglishLanguageCode = @ProgressAchievingEnglishLanguageCode)
								begin

								INSERT INTO RDS.DimSchoolStatuses( SharedTimeStatusId, SharedTimeStatusCode, SharedTimeStatusDescription, SharedTimeStatusEdFactsCode, 
								MagnetStatusId, MagnetStatusCode, MagnetStatusDescription, MagnetStatusEdFactsCode,
									NSLPStatusId, NSLPStatusCode, NSLPStatusDescription, NSLPStatusEdFactsCode,
								VirtualSchoolStatusId, VirtualSchoolStatusCode, VirtualSchoolStatusDescription, VirtualSchoolStatusEdFactsCode,
								PersistentlyDangerousStatusId, PersistentlyDangerousStatusCode, PersistentlyDangerousStatusDescription, PersistentlyDangerousStatusEdFactsCode
								,ImprovementStatusId, ImprovementStatusCode, ImprovementStatusDescription, ImprovementStatusEdFactsCode,
								StatePovertyDesignationId, StatePovertyDesignationCode, StatePovertyDesignationDescription, StatePovertyDesignationEdFactsCode,
								ProgressAchievingEnglishLanguageId, ProgressAchievingEnglishLanguageCode, ProgressAchievingEnglishLanguageDescription, ProgressAchievingEnglishLanguageEdFactsCode)								
								VALUES(
								@SharedTimeStatusId, @SharedTimeStatusCode, @SharedTimeStatusDescription, @SharedTimeStatusEdFactsCode, 
								@MagnetStatusId, @MagnetStatusCode, @MagnetStatusDescription, @MagnetStatusEdFactsCode,
								@NSLPStatusId, @NSLPStatusCode, @NSLPStatusDescription, @NSLPStatusEdFactsCode,
								@VirtualSchoolStatusId, @VirtualSchoolStatusCode, @VirtualSchoolStatusDescription, @VirtualSchoolStatusEdFactsCode
								,@PersistentlyDangerousId, @PersistentlyDangerousCode, @PersistentlyDangerousDescription, @PersistentlyDangerousEdFactsCode
								,@ImprovementStatusId, @ImprovementStatusCode, @ImprovementStatusDescription, @ImprovementStatusEdFactsCode,
								@StatePovertyDesignationId, @StatePovertyDesignationCode, @StatePovertyDesignationDescription, @StatePovertyDesignationEdFactsCode
								,@ProgressAchievingEnglishLanguageId, @ProgressAchievingEnglishLanguageCode, @ProgressAchievingEnglishLanguageDescription, @ProgressAchievingEnglishLanguageEdFactsCode
								)
								end

							END

									FETCH NEXT FROM  ProgressAchievingEnglishLanguage_cursor INTO @ProgressAchievingEnglishLanguageId, @ProgressAchievingEnglishLanguageCode, @ProgressAchievingEnglishLanguageDescription, @ProgressAchievingEnglishLanguageEdFactsCode
									END
									CLOSE  ProgressAchievingEnglishLanguage_cursor
									DEALLOCATE  ProgressAchievingEnglishLanguage_cursor

							FETCH NEXT FROM StatePovertyDesignation_cursor INTO @StatePovertyDesignationId, @StatePovertyDesignationCode, @StatePovertyDesignationDescription, @StatePovertyDesignationEdFactsCode
							END
							CLOSE StatePovertyDesignation_cursor
							DEALLOCATE StatePovertyDesignation_cursor


							FETCH NEXT FROM VirtualSchoolStatus_cursor INTO @VirtualSchoolStatusId, @VirtualSchoolStatusCode, @VirtualSchoolStatusDescription, @VirtualSchoolStatusEdFactsCode
							END
							CLOSE VirtualSchoolStatus_cursor
							DEALLOCATE VirtualSchoolStatus_cursor


						FETCH NEXT FROM NSLPStatus_cursor INTO @NSLPStatusId, @NSLPStatusCode, @NSLPStatusDescription, @NSLPStatusEdFactsCode
						END
						CLOSE NSLPStatus_cursor
						DEALLOCATE NSLPStatus_cursor
				
					FETCH NEXT FROM PDStatus_cursor INTO @PersistentlyDangerousId, @PersistentlyDangerousCode, @PersistentlyDangerousDescription, @PersistentlyDangerousEdFactsCode
					END
					CLOSE PDStatus_cursor
					DEALLOCATE PDStatus_cursor

				FETCH NEXT FROM ImprovementStatus_cursor INTO @ImprovementStatusId, @ImprovementStatusCode, @ImprovementStatusDescription, @ImprovementStatusEdFactsCode
				END
				CLOSE ImprovementStatus_cursor
				DEALLOCATE ImprovementStatus_cursor


			FETCH NEXT FROM MagnetStatus_cursor INTO @MagnetStatusId, @MagnetStatusCode, @MagnetStatusDescription, @MagnetStatusEdFactsCode
			END
			CLOSE MagnetStatus_cursor
			DEALLOCATE MagnetStatus_cursor


		FETCH NEXT FROM SharedTimeStatus_cursor INTO @SharedTimeStatusId, @SharedTimeStatusCode, @SharedTimeStatusDescription, @SharedTimeStatusEdFactsCode
		END
		CLOSE SharedTimeStatus_cursor
		DEALLOCATE SharedTimeStatus_cursor



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
