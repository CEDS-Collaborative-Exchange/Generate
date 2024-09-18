CREATE PROCEDURE [RDS].[Migrate_DimRaces]
	@factTypeCode as varchar(50),
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

	SET NOCOUNT ON;


	
				-- Lookup Values
				declare @factTypeId as int
				select @factTypeId = DimFactTypeId
				from rds.DimFactTypes where FactTypeCode = @factTypeCode

									
				declare @missingDimRaceId as int
				select @missingDimRaceId = DimRaceId from rds.DimRaces where RaceCode = 'MISSING'
				
				declare @MU7DimRaceId as int
				select @MU7DimRaceId = DimRaceId from rds.DimRaces where RaceCode = 'MU7'



				-- Data Population

				if(@factTypeCode = 'datapopulation')
				begin

					select distinct
							s.DimStudentId,
							s.StudentPersonId,
							d.DimCountDateId,
							case
								when race.DimRaceId is null then 'MISSING'
								else race.RaceCode
							end as RaceCode,
							pdr.RecordStartDateTime as RaceRecordStartDate,
							pdr.RecordEndDateTime as RaceRecordEndDate
					from rds.DimStudents s
					inner join @studentDates d on s.DimStudentId = d.DimStudentId
					join ods.PersonDetail pd on pd.PersonId = d.PersonId
					left join ods.PersonDemographicRace pdr on pd.PersonId = pdr.PersonId
					left join ods.RefRace rr on pdr.RefRaceId = rr.RefRaceId
					left join rds.DimRaces race on rr.Code = race.RaceCode or (pd.HispanicLatinoEthnicity = 1 and race.RaceCode = 'HI')
						and race.DimFactTypeId = @factTypeId

				end
				else if(@factTypeCode = 'submission')
				begin
				
					select distinct
							s.DimStudentId,
							s.StudentPersonId,
							d.DimCountDateId,
							 race2.RaceCode,
							 pdr.RecordStartDateTime as RaceRecordStartDate,
							pdr.RecordEndDateTime as RaceRecordEndDate
					from rds.DimStudents s
					inner join @studentDates d on s.DimStudentId = d.DimStudentId
					join ods.PersonDetail pd on pd.PersonId = d.PersonId
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
						or (pd.HispanicLatinoEthnicity = 0 and rc.RaceCount = 1 and (race.RaceDescription = race2.RaceDescription 
						or (race.RaceCode = 'AmericanIndianorAlaskaNative' and race2.RaceCode = 'AM7'))) 
						or (pd.HispanicLatinoEthnicity = 0 and rc.RaceCount > 1 and race2.DimRaceId = @MU7DimRaceId))
						and race2.DimFactTypeId = @factTypeId
					order by s.DimStudentId 

				end

			else
			begin

					select distinct
							s.DimStudentId,
							s.StudentPersonId,
							d.DimCountDateId,
						 case
							when race.DimRaceId is null then 'MISSING'
							else race.RaceCode
							end as RaceCode,
							pdr.RecordStartDateTime as RaceRecordStartDate,
							pdr.RecordEndDateTime as RaceRecordEndDate
					from rds.DimStudents s
					inner join @studentDates d on s.DimStudentId = d.DimStudentId
					join ods.PersonDetail pd on pd.PersonId = d.PersonId
					left join ods.PersonDemographicRace pdr on pd.PersonId = pdr.PersonId
					left join ods.RefRace rr on pdr.RefRaceId = rr.RefRaceId
					left join rds.DimRaces race on
				
					(case when rr.Code = 'AmericanIndianorAlaskaNative' then 'AM7'
						when rr.Code = 'Asian' then 'AS7'
						when rr.Code = 'BlackorAfricanAmerican' then 'BL7'
						when rr.Code = 'NativeHawaiianorOtherPacificIslander' then 'PI7'
						when rr.Code = 'White' then 'WH7'
						when rr.Code = 'TwoorMoreRaces' then 'MU7'
					end   = race.RaceCode	
					 or (pd.HispanicLatinoEthnicity = 1 and race.RaceCode = 'HI7')
					 )
					 and race.DimFactTypeId = @factTypeId

					
				end



	SET NOCOUNT OFF;

END

