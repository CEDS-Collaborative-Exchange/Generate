-- DimNorDProgramStatuses

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

						
							if @longtermstatusCode = 'MISSING' and @neglectedprogramtypeCode = 'MISSING'
							begin

										if not exists(select 1 from RDS.DimNorDProgramStatuses where longtermstatusCode = @longtermstatusCode 
											and neglectedprogramtypeCode = @neglectedprogramtypeCode)
											begin


								set identity_insert rds.DimNorDProgramStatuses on

								insert into RDS.DimNorDProgramStatuses
								(
									DimNorDProgramStatusId,
									longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode,
									neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode
								)
								values
								(
								-1,
								@longtermstatusId, @longtermstatusCode, @longtermstatusDescription, @longtermstatusEdFactsCode,
								@neglectedprogramtypeId, @neglectedprogramtypeCode, @neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode
								)

								set identity_insert rds.DimNorDProgramStatuses off
							end
							end
							else
							begin
								if not exists(select 1 from RDS.DimNorDProgramStatuses where  longtermstatusCode = @longtermstatusCode and neglectedprogramtypeCode = @neglectedprogramtypeCode)
											begin

								insert into RDS.DimNorDProgramStatuses
								(
									longtermstatusId, longtermstatusCode, longtermstatusDescription, longtermstatusEdFactsCode,
									neglectedprogramtypeId, neglectedprogramtypeCode, neglectedprogramtypeDescription, neglectedprogramtypeEdFactsCode
								)
								values
								(
								@longtermstatusId, @longtermstatusCode, @longtermstatusDescription, @longtermstatusEdFactsCode,
								@neglectedprogramtypeId, @neglectedprogramtypeCode, @neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode
								)

							end
							end

							FETCH NEXT FROM neglectedprogramtype_cur INTO @neglectedprogramtypeId, @neglectedprogramtypeCode, @neglectedprogramtypeDescription, @neglectedprogramtypeEdFactsCode
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