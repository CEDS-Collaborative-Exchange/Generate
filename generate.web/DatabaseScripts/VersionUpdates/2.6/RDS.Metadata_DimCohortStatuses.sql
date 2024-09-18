-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------
set nocount on
begin try
	begin transaction
		declare @cohortstatusId as int
		declare @cohortstatusCode as varchar(50)
		declare @cohortstatusDescription as varchar(200)
		declare @cohortstatusEdFactsCode as varchar(50)

		declare @cohortstatusesTable table(
			CohortStatusId int,
			CohortStatusCode varchar(50),
			CohortStatusDescription varchar(200),
			CohortStatusEdFactsCode varchar(50)
		); 

		insert into @cohortstatusesTable (CohortStatusId, CohortStatusCode, CohortStatusDescription, CohortStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @cohortstatusesTable (CohortStatusId, CohortStatusCode, CohortStatusDescription, CohortStatusEdFactsCode) 
		values 
		(1, 'COHYES', 'Graduated with a regular high school diploma within the allowable time', 'COHYES')

		insert into @cohortstatusesTable (CohortStatusId, CohortStatusCode, CohortStatusDescription, CohortStatusEdFactsCode) 
		values 
		(2, 'COHNO', 'Did not graduate with a regular or alternate high school diploma within the allowable time', 'COHNO')
		insert into @cohortstatusesTable (CohortStatusId, CohortStatusCode, CohortStatusDescription, CohortStatusEdFactsCode) 
		values 
		(3, 'COHALTDPL', 'Graduated with a state-defined alternate high school diploma, in accordance with ESEA, within the allowable time', 'COHALTDPL')
			insert into @cohortstatusesTable (CohortStatusId, CohortStatusCode, CohortStatusDescription, CohortStatusEdFactsCode) 
		values 
		(4, 'COHREM', 'Has not graduated with a state-defined alternate high school diploma, in accordance with ESEA, and removed from the cohort', 'COHREM')

		DECLARE cohortstatus_cursor CURSOR FOR 
		SELECT CohortStatusId, CohortStatusCode, CohortStatusDescription, CohortStatusEdFactsCode
		FROM @cohortstatusesTable

		OPEN cohortstatus_cursor

		FETCH NEXT FROM cohortstatus_cursor INTO @cohortstatusId, @cohortstatusCode, @cohortstatusDescription, @cohortstatusEdFactsCode
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @cohortstatusCode = 'MISSING'
				begin
					if not exists(select 1 from RDS.DimCohortStatuses where CohortStatusCode = @cohortstatusCode)
					begin
						set identity_insert RDS.DimCohortStatuses on
							INSERT INTO [RDS].[DimCohortStatuses] 
								([DimCohortStatusId],[CohortStatusId],[CohortStatusCode],[CohortStatusDescription],[CohortStatusEdFactsCode])
								VALUES(-1,@cohortstatusId, @cohortstatusCode, @cohortstatusDescription, @cohortstatusEdFactsCode)						

						set identity_insert RDS.DimCohortStatuses off
					end
				end
			else
				begin
					if not exists(select 1 from RDS.DimCohortStatuses where CohortStatusCode = @cohortstatusCode)
					begin
						INSERT INTO [RDS].[DimCohortStatuses] 
							([CohortStatusId],[CohortStatusCode],[CohortStatusDescription],[CohortStatusEdFactsCode])
							VALUES(@cohortstatusId, @cohortstatusCode, @cohortstatusDescription, @cohortstatusEdFactsCode)			
					end
				end
		FETCH NEXT FROM cohortstatus_cursor INTO @cohortstatusId, @cohortstatusCode, @cohortstatusDescription, @cohortstatusEdFactsCode
		END
		CLOSE cohortstatus_cursor
		DEALLOCATE cohortstatus_cursor
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
