-- DimNorDProgramStatuses

Update rds.DimNorDProgramStatuses set AcademicOrVocationalOutcomeCode = NULL, AcademicOrVocationalOutcomeDescription = 'Missing', AcademicOrVocationalOutcomeEdFactsCode = 'MISSING',
									  AcademicOrVocationalOutcomeId = -1, AcademicOrVocationalExitOutcomeCode = NULL, 
									  AcademicOrVocationalExitOutcomeDescription = 'Missing',	AcademicOrVocationalExitOutcomeEdFactsCode = 'MISSING',	
									  AcademicOrVocationalExitOutcomeId = -1
Where DimNorDProgramStatusId = -1

set nocount on;

begin try
	begin transaction


		declare @longtermstatusId as int
		declare @longtermstatusCode as varchar(50)
		declare @longtermstatusDescription as varchar(200)
		declare @longtermstatusEdFactsCode as varchar(50)

		declare @longtermstatusTable table(
			longtermstatusId int,
			longtermstatusCode varchar(50),
			longtermstatusDescription varchar(200),
			longtermstatusEdFactsCode varchar(50)
		); 

		insert into @longtermstatusTable (longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @longtermstatusTable (longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode) 
		values 
		(1, 'NDLONGTERM', 'Long-Term N or D Students', 'NDLONGTERM')

		declare @neglectedprogramtypeId as int
		declare @neglectedprogramtypeCode as varchar(50)
		declare @neglectedprogramtypeDescription as varchar(200)
		declare @neglectedprogramtypeEdFactsCode as varchar(50)

		declare @neglectedprogramtypeTable table(
					neglectedprogramtypeId int,
					neglectedprogramtypeCode varchar(50),
					neglectedprogramtypeDescription varchar(200),
					neglectedprogramtypeEdFactsCode varchar(50)
		); 

		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode) 
		values 
		(1, 'NEGLECT', 'Neglected Programs', 'NEGLECT')

		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode) 
		values 
		(2, 'JUVDET', 'Juvenile Detention', 'JUVDET')

		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode) 
		values 
		(3, 'JUVCORR', 'Juvenile Correction', 'JUVCORR')

		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode)  
		values 
		(4, 'ADLTCORR', 'Adult Correction', 'ADLTCORR')
		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode) 
		values 
		(5, 'ATRISK', 'At-Risk Programs', 'ATRISK')

		insert into @neglectedprogramtypeTable (neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode) 
		values 
		(6, 'OTHER', 'Other Programs', 'OTHER')

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
		(-1, NULL, 'Missing', 'MISSING')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(1, NULL, 'Earned high school course credits', 'EARNCRE')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(2, NULL, 'Enrolled in a GED program', 'ENROLLGED')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(3, NULL, 'Earned a GED', 'EARNGED')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode)  
		values 
		(4, NULL, 'Obtained high school diploma', 'EARNDIPL')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(5, NULL, 'Accepted and/or enrolled into post-secondary education', 'POSTSEC')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(6, NULL, 'Enrolled in job training courses/programs', 'ENROLLTRAIN ')

		insert into @academicorvocationaloutcomeTable (academicorvocationaloutcomeId, academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode) 
		values 
		(7, NULL, 'Obtained employment', 'OBTAINEMP')

		declare @academicorvocationalexitoutcomeId as int
		declare @academicorvocationalexitoutcomeCode as varchar(50)
		declare @academicorvocationalexitoutcomeDescription as varchar(200)
		declare @academicorvocationalexitoutcomeEdFactsCode as varchar(50)

		declare @academicorvocationalexitoutcomeTable table(
					academicorvocationalexitoutcomeId int,
					academicorvocationalexitoutcomeCode varchar(50),
					academicorvocationalexitoutcomeDescription varchar(200),
					academicorvocationalexitoutcomeEdFactsCode varchar(50)
		); 

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(-1, NULL, 'Missing', 'MISSING')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(1, NULL, 'Enrolled in local district school', 'ENROLLSCH')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(2, NULL, 'Earned high school course credits', 'EARNCRE')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(3, NULL, 'Enrolled in a GED program', 'ENROLLGED')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(4, NULL, 'Earned a GED', 'EARNGED')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(5, NULL, 'Obtained high school diploma', 'EARNDIPL')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(6, NULL, 'Accepted and/or enrolled into post-secondary education', 'POSTSEC')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode) 
		values 
		(7, NULL, 'Enrolled in job training courses/programs', 'ENROLLTRAIN ')

		insert into @academicorvocationalexitoutcomeTable (academicorvocationalexitoutcomeId, academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, academicorvocationalexitoutcomeEdFactsCode)
		values 
		(8, NULL, 'Obtained employment', 'OBTAINEMP')

					DECLARE longtermstatus_cur CURSOR FOR 
					SELECT longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode
					FROM @longtermstatusTable

					OPEN longtermstatus_cur
					FETCH NEXT FROM longtermstatus_cur INTO @longtermstatusId, @longtermstatusCode, @longtermstatusDescription, @longtermstatusEdFactsCode

					WHILE @@FETCH_STATUS = 0
					BEGIN

							DECLARE neglectedprogramtype_cur CURSOR FOR 
							SELECT neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode
							FROM @neglectedprogramtypeTable
									
							OPEN neglectedprogramtype_cur
							FETCH NEXT FROM neglectedprogramtype_cur INTO @neglectedprogramtypeId, @neglectedprogramtypeCode, @neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode
									
							WHILE @@FETCH_STATUS = 0
							BEGIN

								DECLARE acadOutcome_cur CURSOR FOR 
								SELECT academicorvocationaloutcomeCode, academicorvocationaloutcomeDescription, academicorvocationaloutcomeEdFactsCode, academicorvocationaloutcomeId
								FROM @academicorvocationaloutcomeTable
									
								OPEN acadOutcome_cur
								FETCH NEXT FROM acadOutcome_cur INTO @academicorvocationaloutcomeCode,
								 @academicorvocationaloutcomeDescription, @academicorvocationaloutcomeEdFactsCode, @academicorvocationaloutcomeId
									
								WHILE @@FETCH_STATUS = 0
								BEGIN

									DECLARE acadExitOutcome_cur CURSOR FOR 
									SELECT academicorvocationalexitoutcomeCode, academicorvocationalexitoutcomeDescription, 
									academicorvocationalexitoutcomeEdFactsCode, academicorvocationalexitoutcomeId
									FROM @academicorvocationalexitoutcomeTable
									
									OPEN acadExitOutcome_cur
									FETCH NEXT FROM acadExitOutcome_cur INTO  @academicorvocationalexitoutcomeCode,
									 @academicorvocationalexitoutcomeDescription, @academicorvocationalexitoutcomeEdFactsCode, @academicorvocationalexitoutcomeId
									
									WHILE @@FETCH_STATUS = 0
									BEGIN
						
							if @longtermstatusCode = 'MISSING' and @neglectedprogramtypeCode = 'MISSING' and @academicorvocationaloutcomeCode IS NULL 
							and @academicorvocationalexitoutcomeCode IS NULL
							begin

								if not exists(select 1 from RDS.DimNorDProgramStatuses where longtermstatusCode = @longtermstatusCode 
									and neglectedprogramtypeCode = @neglectedprogramtypeCode and AcademicOrVocationalOutcomeCode IS NULL
									and AcademicOrVocationalExitOutcomeCode IS NULL)
									begin


											set identity_insert rds.DimNorDProgramStatuses on

											insert into RDS.DimNorDProgramStatuses
											(
												DimNorDProgramStatusId,
												longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode,
												neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode,
												[AcademicOrVocationalOutcomeCode],[AcademicOrVocationalOutcomeDescription],
												[AcademicOrVocationalOutcomeEdFactsCode],[AcademicOrVocationalOutcomeId]
												,[AcademicOrVocationalExitOutcomeCode],[AcademicOrVocationalExitOutcomeDescription],[AcademicOrVocationalExitOutcomeEdFactsCode]
												,[AcademicOrVocationalExitOutcomeId]
											)
											values
											(
											-1,
											@longtermstatusId, @longtermstatusCode, @longtermstatusDescription, @longtermstatusEdFactsCode,
											@neglectedprogramtypeId, @neglectedprogramtypeCode, @neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode,
											@academicorvocationaloutcomeCode, @academicorvocationaloutcomeDescription, 
											@academicorvocationaloutcomeEdFactsCode, @academicorvocationaloutcomeId,
											@academicorvocationalexitoutcomeCode, @academicorvocationalexitoutcomeDescription, @academicorvocationalexitoutcomeEdFactsCode,
											@academicorvocationalexitoutcomeId
											)

											set identity_insert rds.DimNorDProgramStatuses off
										end
										end
										else
										begin
											if not exists(select 1 from RDS.DimNorDProgramStatuses where longtermstatusCode = @longtermstatusCode 
												and neglectedprogramtypeCode = @neglectedprogramtypeCode and AcademicOrVocationalOutcomeCode = @academicorvocationaloutcomeCode
												and AcademicOrVocationalExitOutcomeCode = @academicorvocationalexitoutcomeCode)
											begin

											insert into RDS.DimNorDProgramStatuses
											(
												longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode,
												neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode,
												[AcademicOrVocationalOutcomeCode],[AcademicOrVocationalOutcomeDescription],
												[AcademicOrVocationalOutcomeEdFactsCode],[AcademicOrVocationalOutcomeId]
												,[AcademicOrVocationalExitOutcomeCode],[AcademicOrVocationalExitOutcomeDescription],[AcademicOrVocationalExitOutcomeEdFactsCode]
												,[AcademicOrVocationalExitOutcomeId]
											)
											values
											(
											@longtermstatusId, @longtermstatusCode, @longtermstatusDescription, @longtermstatusEdFactsCode,
											@neglectedprogramtypeId, @neglectedprogramtypeCode, @neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode,
											@academicorvocationaloutcomeCode, @academicorvocationaloutcomeDescription, 
											@academicorvocationaloutcomeEdFactsCode, @academicorvocationaloutcomeId,
											@academicorvocationalexitoutcomeCode, @academicorvocationalexitoutcomeDescription, @academicorvocationalexitoutcomeEdFactsCode,
											@academicorvocationalexitoutcomeId
											)

										end
										end

									FETCH NEXT FROM acadExitOutcome_cur INTO  @academicorvocationalexitoutcomeCode,
									 @academicorvocationalexitoutcomeDescription, @academicorvocationalexitoutcomeEdFactsCode, @academicorvocationalexitoutcomeId
									END
									CLOSE acadExitOutcome_cur
									DEALLOCATE acadExitOutcome_cur

								FETCH NEXT FROM acadOutcome_cur INTO @academicorvocationaloutcomeCode,
								 @academicorvocationaloutcomeDescription, @academicorvocationaloutcomeEdFactsCode, @academicorvocationaloutcomeId
								END
								CLOSE acadOutcome_cur
								DEALLOCATE acadOutcome_cur

							FETCH NEXT FROM neglectedprogramtype_cur INTO @neglectedprogramtypeId, @neglectedprogramtypeCode, 
							@neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode
							END
							CLOSE neglectedprogramtype_cur
							DEALLOCATE neglectedprogramtype_cur


					FETCH NEXT FROM longtermstatus_cur INTO @longtermstatusId, @longtermstatusCode, @longtermstatusDescription, @longtermstatusEdFactsCode
					END
					CLOSE longtermstatus_cur
					DEALLOCATE longtermstatus_cur
				
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