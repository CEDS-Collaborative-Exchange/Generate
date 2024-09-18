-- DimProgramStatuses

set nocount on;

begin try
	begin transaction

		
		if not exists(select 1 from RDS.DimProgramStatuses where HomelessServicedIndicatorCode = 'YES')
		BEGIN
			Update RDS.[DimProgramStatuses] set HomelessServicedIndicatorCode = 'YES', HomelessServicedIndicatorDescription = 'Serviced by Homeless Mckenney-Vento Program',
												HomelessServicedIndicatorEdFactsCode = 'YES', HomelessServicedIndicatorId = 1
			where DimProgramStatusId <> -1
		END

		if not exists(select 1 from RDS.DimProgramStatuses where HomelessServicedIndicatorCode = 'NO' and DimProgramStatusId <> -1)
		BEGIN
	  
			INSERT INTO [RDS].[DimProgramStatuses]
					   ([FoodServiceEligibilityCode]
					   ,[FoodServiceEligibilityDescription]
					   ,[FoodServiceEligibilityEdFactsCode]
					   ,[FoodServiceEligibilityId]
					   ,[FosterCareProgramCode]
					   ,[FosterCareProgramDescription]
					   ,[FosterCareProgramEdFactsCode]
					   ,[FosterCareProgramId]
					   ,[ImmigrantTitleIIIProgramCode]
					   ,[ImmigrantTitleIIIProgramDescription]
					   ,[ImmigrantTitleIIIProgramEdFactsCode]
					   ,[ImmigrantTitleIIIProgramId]
					   ,[Section504ProgramCode]
					   ,[Section504ProgramDescription]
					   ,[Section504ProgramEdFactsCode]
					   ,[Section504ProgramId]
					   ,[TitleiiiProgramParticipationCode]
					   ,[TitleiiiProgramParticipationDescription]
					   ,[TitleiiiProgramParticipationEdFactsCode]
					   ,[TitleiiiProgramParticipationId]
					   ,[HomelessServicedIndicatorCode]
					   ,[HomelessServicedIndicatorDescription]
					   ,[HomelessServicedIndicatorEdFactsCode]
					   ,[HomelessServicedIndicatorId])
			SELECT		[FoodServiceEligibilityCode]
					   ,[FoodServiceEligibilityDescription]
					   ,[FoodServiceEligibilityEdFactsCode]
					   ,[FoodServiceEligibilityId]
					   ,[FosterCareProgramCode]
					   ,[FosterCareProgramDescription]
					   ,[FosterCareProgramEdFactsCode]
					   ,[FosterCareProgramId]
					   ,[ImmigrantTitleIIIProgramCode]
					   ,[ImmigrantTitleIIIProgramDescription]
					   ,[ImmigrantTitleIIIProgramEdFactsCode]
					   ,[ImmigrantTitleIIIProgramId]
					   ,[Section504ProgramCode]
					   ,[Section504ProgramDescription]
					   ,[Section504ProgramEdFactsCode]
					   ,[Section504ProgramId]
					   ,[TitleiiiProgramParticipationCode]
					   ,[TitleiiiProgramParticipationDescription]
					   ,[TitleiiiProgramParticipationEdFactsCode]
					   ,[TitleiiiProgramParticipationId]
					   ,'NO'
					   ,'Not Serviced by Homeless Mckenney-Vento Program'
					   ,'NO'
					   ,2
			FROM RDS.DimProgramStatuses
			where DimProgramStatusId <> -1
		END

		Update rds.DimProgramStatuses set [HomelessServicedIndicatorCode] = 'NO', [HomelessServicedIndicatorDescription] = NULL, 
										  [HomelessServicedIndicatorEdFactsCode] = 'NO', [HomelessServicedIndicatorId] = 2
		where DimProgramStatusId = -1

				
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