



CREATE PROCEDURE [RDS].[Seed_BridgeStudentRaces]
AS
BEGIN

	SET NOCOUNT ON;

	begin try
		begin transaction

			if not exists (select 1 from rds.BridgeStudentRaces)
			begin
	
				-- Lookup Values
								declare @dataPopulationFactTypeId as int
				select @dataPopulationFactTypeId = DimFactTypeId
				from rds.DimFactTypes where FactTypeCode = 'datapopulation'

				declare @submissionFactTypeId as int
				select @submissionFactTypeId = DimFactTypeId
				from rds.DimFactTypes where FactTypeCode = 'submission'
									
				declare @missingDimRaceId as int
				select @missingDimRaceId = DimRaceId from rds.DimRaces where RaceCode = 'MISSING'
				
				declare @MU7DimRaceId as int
				select @MU7DimRaceId = DimRaceId from rds.DimRaces where RaceCode = 'MU7'


				-- Data Population

				insert into rds.BridgeStudentRaces
				select distinct
						ds.DimStudentId
					, case
						when race.DimRaceId is null then @missingDimRaceId
						else race.DimRaceId
						end 
				from ods.PersonDetail pd 
				join rds.DimStudents ds on pd.PersonId = ds.StudentPersonId
				left join ods.PersonDemographicRace pdr on pd.PersonId = pdr.PersonId
				left join ods.RefRace rr on pdr.RefRaceId = rr.RefRaceId
				left join rds.DimRaces race on rr.Code = race.RaceCode or (pd.HispanicLatinoEthnicity = 1 and race.RaceCode = 'HI')
					and race.DimFactTypeId = @dataPopulationFactTypeId
				
				insert into rds.BridgeStudentRaces
				select distinct
						ds.DimStudentId
					, race2.DimRaceId
				from ods.PersonDetail pd 
				join rds.DimStudents ds on pd.PersonId = ds.StudentPersonId
				left join (
						select PersonId, count(1) as RaceCount
						from ods.PersonDemographicRace
						group by PersonId
						) as rc
						on pd.PersonId = rc.PersonId
				left join ods.PersonDemographicRace pdr on pd.PersonId = pdr.PersonId
				left join ods.RefRace rr on pdr.RefRaceId = rr.RefRaceId
				left join rds.DimRaces race on rr.Code = race.RaceCode
					and race.DimFactTypeId = 1
				join rds.DimRaces race2 on ((pd.HispanicLatinoEthnicity = 1 and race2.RaceCode = 'HI7')
					or (pd.HispanicLatinoEthnicity = 0 and rc.RaceCount = 1 and (race.RaceDescription = race2.RaceDescription or (race.RaceCode = 'AmericanIndianorAlaskaNative' and race2.RaceCode = 'AM7'))) 
					or (pd.HispanicLatinoEthnicity = 0 and rc.RaceCount > 1 and race2.DimRaceId = @MU7DimRaceId))
					and race2.DimFactTypeId = @submissionFactTypeId
				order by ds.DimStudentId 
			end

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


	SET NOCOUNT OFF;

END


