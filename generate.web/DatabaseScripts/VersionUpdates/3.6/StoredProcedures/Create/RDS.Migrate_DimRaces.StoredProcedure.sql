CREATE PROCEDURE [RDS].[Migrate_DimRaces]
	@factTypeCode as varchar(50),
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

SET NOCOUNT ON;

/*****************************
For Debugging 
*****************************/
--declare @studentDates as rds.StudentDateTableType
--declare @migrationType varchar(3) = 'rds'

----select the appropriate date variable, 8=17-18, 9=18-19, 10=19-20, etc...
--declare @selectedDate int = 9

----variable for the file spec, uncomment the appropriate one 
--declare     @factTypeCode as varchar(50) = 'childcount'
--declare     @factTypeCode as varchar(50) = 'chronic'
--declare     @factTypeCode as varchar(50) = 'cte'
--declare     @factTypeCode as varchar(50) = 'datapopulation'
--declare     @factTypeCode as varchar(50) = 'dropout'
--declare     @factTypeCode as varchar(50) = 'grad'
--declare     @factTypeCode as varchar(50) = 'gradrate'
--declare     @factTypeCode as varchar(50) = 'hsgradenroll'
--declare     @factTypeCode as varchar(50) = 'membership'
--declare     @factTypeCode as varchar(50) = 'mep'
--declare     @factTypeCode as varchar(50) = 'nord'
--declare     @factTypeCode as varchar(50) = 'other'
--declare     @factTypeCode as varchar(50) = 'specedexit'
--declare     @factTypeCode as varchar(50) = 'sppapr'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
--declare     @factTypeCode as varchar(50) = 'titleI'
--declare     @factTypeCode as varchar(50) = 'titleIIIELOct'

--insert into @studentDates
--(
--     DimStudentId,
--     PersonId,
--     DimCountDateId,
--     SubmissionYearDate,
--     [Year],
--     SubmissionYearStartDate,
--     SubmissionYearEndDate
--)
--exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate
/*****************************
End of Debugging code 
*****************************/
	
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
				pd.PersonId,
				d.DimCountDateId,
				case
					when race.DimRaceId is null then 'MISSING'
					else race.RaceCode
				end as RaceCode,
				ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.SubmissionYearStartDate)) as RaceRecordStartDate,
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
				pd.PersonId,
				d.DimCountDateId,
					race2.RaceCode,
					ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.SubmissionYearStartDate)) as RaceRecordStartDate,
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
				pd.PersonId,
				d.DimCountDateId,
				case
					when race.DimRaceId is null then 'MISSING'
					else race.RaceCode
				end as RaceCode,
				ISNULL(pdr.RecordStartDateTime, ISNULL(pd.RecordStartDateTime, d.SubmissionYearStartDate)) as RaceRecordStartDate,
				ISNULL(pdr.RecordEndDateTime, ISNULL(pd.RecordEndDateTime, d.SubmissionYearEndDate)) as RaceRecordEndDate
		from rds.DimStudents s
		inner join @studentDates d on s.DimStudentId = d.DimStudentId
		join ods.PersonDetail pd on pd.PersonId = d.PersonId
		left join ods.PersonDemographicRace pdr on pd.PersonId = pdr.PersonId
		left join ods.RefRace rr on pdr.RefRaceId = rr.RefRaceId
		left join rds.DimRaces race on
		(case when pd.HispanicLatinoEthnicity = 1 then 'HI7'
			when rr.Code = 'AmericanIndianorAlaskaNative' then 'AM7'
			when rr.Code = 'Asian' then 'AS7'
			when rr.Code = 'BlackorAfricanAmerican' then 'BL7'
			when rr.Code = 'NativeHawaiianorOtherPacificIslander' then 'PI7'
			when rr.Code = 'White' then 'WH7'
			when rr.Code = 'TwoorMoreRaces' then 'MU7'
		end   = race.RaceCode	
		)
			and race.DimFactTypeId = @factTypeId

	end

SET NOCOUNT OFF;

END