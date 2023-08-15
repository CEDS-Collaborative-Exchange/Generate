-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction


		declare @assessedfirsttimeId as int
		declare @assessedfirsttimeCode as varchar(50)
		declare @assessedfirsttimeDescription as varchar(200)
		declare @assessedfirsttimeEdFactsCode as varchar(50)

		declare @assessedfirsttimeTable table(
				assessedfirsttimeId int,
				assessedfirsttimeCode varchar(50),
				assessedfirsttimeDescription varchar(200),
				assessedfirsttimeEdFactsCode varchar(50)
		); 

		insert into @assessedfirsttimeTable (assessedfirsttimeId, assessedfirsttimeCode, assessedfirsttimeDescription, assessedfirsttimeEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @assessedfirsttimeTable (assessedfirsttimeId, assessedfirsttimeCode, assessedfirsttimeDescription, assessedfirsttimeEdFactsCode) 
		values 
		(1, 'FIRSTASSESS', 'Students assessed for the first time', 'FIRSTASSESS')

		declare @assessmentprogresslevelId as int
		declare @assessmentprogresslevelCode as varchar(50)
		declare @assessmentprogresslevelDescription as varchar(200)
		declare @assessmentprogresslevelEdFactsCode as varchar(50)

		declare @assessmentprogresslevelTable table(
					assessmentprogresslevelId int,
					assessmentprogresslevelCode varchar(50),
					assessmentprogresslevelDescription varchar(200),
					assessmentprogresslevelEdFactsCode varchar(50)
		); 

		insert into @assessmentprogresslevelTable (assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @assessmentprogresslevelTable (assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode) 
		values 
		(1, 'NEGGRADE', 'the students showed a negative grade level change from the pre– to post– test', 'NEGGRADE')

		insert into @assessmentprogresslevelTable (assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode) 
		values 
		(2, 'NOCHANGE', 'the students showed no change from the pre– to post– test', 'NOCHANGE')

		insert into @assessmentprogresslevelTable (assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode) 
		values 
		(3, 'UPONEGRADE', 'the students showed improvement of up to one full grade level from the pre- to the post-test.', 'UPONEGRADE')

		insert into @assessmentprogresslevelTable (assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode)  
		values 
		(4, 'UPGTONE', 'the students showed improvement of more than one full grade level from the pre– to post– test.', 'UPGTONE')

					DECLARE assessedfirsttime_cur CURSOR FOR 
					SELECT assessedfirsttimeId, assessedfirsttimeCode, assessedfirsttimeDescription, assessedfirsttimeEdFactsCode
					FROM @assessedfirsttimeTable

					OPEN assessedfirsttime_cur
					FETCH NEXT FROM assessedfirsttime_cur INTO @assessedfirsttimeId, @assessedfirsttimeCode, @assessedfirsttimeDescription, @assessedfirsttimeEdFactsCode

					WHILE @@FETCH_STATUS = 0
					BEGIN

							DECLARE assessmentprogresslevel_cur CURSOR FOR 
							SELECT assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode
							FROM @assessmentprogresslevelTable
									
							OPEN assessmentprogresslevel_cur
							FETCH NEXT FROM assessmentprogresslevel_cur INTO @assessmentprogresslevelId, @assessmentprogresslevelCode, @assessmentprogresslevelDescription, @assessmentprogresslevelEdFactsCode
									
							WHILE @@FETCH_STATUS = 0
							BEGIN

						
							if @assessedfirsttimeCode = 'MISSING' and @assessmentprogresslevelCode = 'MISSING'
							begin

								if not exists(select 1 from RDS.DimAssessmentStatuses where assessedfirsttimeCode = @assessedfirsttimeCode 
									and assessmentprogresslevelCode = @assessmentprogresslevelCode)
								begin

									if exists(select 1 from RDS.DimAssessmentStatuses where assessedfirsttimeCode = @assessedfirsttimeCode  and assessmentprogresslevelCode IS NULL)
									begin
										UPDATE [RDS].[DimAssessmentStatuses]
										   SET 
											  [AssessmentProgressLevelCode] = @assessmentprogresslevelCode
											  ,[AssessmentProgressLevelDescription] = @assessmentprogresslevelDescription
											  ,[AssessmentProgressLevelEdFactsCode] = @assessmentprogresslevelEdFactsCode
											  ,[AssessmentProgressLevelId] = @assessmentprogresslevelId
										Where  assessedfirsttimeCode = @assessedfirsttimeCode and assessmentprogresslevelCode IS NULL
									end
									else
									begin
										set identity_insert rds.DimAssessmentStatuses on

										insert into RDS.DimAssessmentStatuses
										(
											DimAssessmentStatusId,
											assessedfirsttimeId, assessedfirsttimeCode, assessedfirsttimeDescription, assessedfirsttimeEdFactsCode,
											assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode
										)
										values
										(
											-1,
											@assessedfirsttimeId, @assessedfirsttimeCode, @assessedfirsttimeDescription, @assessedfirsttimeEdFactsCode,
											@assessmentprogresslevelId, @assessmentprogresslevelCode, @assessmentprogresslevelDescription, @assessmentprogresslevelEdFactsCode
										)

										set identity_insert rds.DimAssessmentStatuses off
									end
								end

							end
							else
							begin
								if not exists(select 1 from RDS.DimAssessmentStatuses where  assessedfirsttimeCode = @assessedfirsttimeCode and assessmentprogresslevelCode = @assessmentprogresslevelCode)
								begin

									if exists(select 1 from RDS.DimAssessmentStatuses where assessedfirsttimeCode = @assessedfirsttimeCode and assessmentprogresslevelCode IS NULL)
									begin
										UPDATE [RDS].[DimAssessmentStatuses]
										   SET 
											  [AssessmentProgressLevelCode] = @assessmentprogresslevelCode
											  ,[AssessmentProgressLevelDescription] = @assessmentprogresslevelDescription
											  ,[AssessmentProgressLevelEdFactsCode] = @assessmentprogresslevelEdFactsCode
											  ,[AssessmentProgressLevelId] = @assessmentprogresslevelId
										Where  assessedfirsttimeCode = @assessedfirsttimeCode and assessmentprogresslevelCode IS NULL
									end
									else 
									begin
										insert into RDS.DimAssessmentStatuses
										(
											assessedfirsttimeId, assessedfirsttimeCode, assessedfirsttimeDescription, assessedfirsttimeEdFactsCode,
											assessmentprogresslevelId, assessmentprogresslevelCode, assessmentprogresslevelDescription, assessmentprogresslevelEdFactsCode
										)
										values
										(
										@assessedfirsttimeId, @assessedfirsttimeCode, @assessedfirsttimeDescription, @assessedfirsttimeEdFactsCode,
										@assessmentprogresslevelId, @assessmentprogresslevelCode, @assessmentprogresslevelDescription, @assessmentprogresslevelEdFactsCode
										)
									end
								end
							end

							FETCH NEXT FROM assessmentprogresslevel_cur INTO @assessmentprogresslevelId, @assessmentprogresslevelCode, @assessmentprogresslevelDescription, @assessmentprogresslevelEdFactsCode
							END
							CLOSE assessmentprogresslevel_cur
							DEALLOCATE assessmentprogresslevel_cur


					FETCH NEXT FROM assessedfirsttime_cur INTO @assessedfirsttimeId, @assessedfirsttimeCode, @assessedfirsttimeDescription, @assessedfirsttimeEdFactsCode
					END
					CLOSE assessedfirsttime_cur
					DEALLOCATE assessedfirsttime_cur

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
