CREATE PROCEDURE [RDS].[Migrate_DimDemographics]
	@studentDates as StudentDateTableType READONLY,
	@useChildCountDate bit
AS
BEGIN
	
	declare @ecoDisPersonStatusTypeId as int
	select @ecoDisPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'EconomicDisadvantage'

	declare @homelessPersonStatusTypeId as int
	select @homelessPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'Homeless'

	declare @homelessUnaccompaniedYouthPersonStatusTypeId as int
	select @homelessUnaccompaniedYouthPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'HomelessUnaccompaniedYouth'
	
	declare @lepPersonStatusTypeId as int
	select @lepPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'LEP'

	declare @migrantPersonStatusTypeId as int
	select @migrantPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'Migrant'
	
	-- Statuses

	select 
		s.DimStudentId,
		s.StudentPersonId as PersonId,
		d.DimCountDateId,
		case when @useChildCountDate = 1 then 
		case
			when statusEcoDis.StatusValue is null then 'MISSING'
			when (statusEcoDis.StatusStartDate is null and statusEcoDis.StatusEndDate is null)
					or (not statusEcoDis.StatusStartDate is null and not statusEcoDis.StatusEndDate is null 
						and statusEcoDis.StatusStartDate <= d.SubmissionYearDate and statusEcoDis.StatusEndDate >= d.SubmissionYearDate)
					or (not statusEcoDis.StatusStartDate is null and statusEcoDis.StatusEndDate is null 
						and statusEcoDis.StatusStartDate <= d.SubmissionYearDate)
				then
					case 
						when statusEcoDis.StatusValue = 1 then 'EconomicDisadvantage'
						else 'MISSING'
					end
			else 'MISSING' end
		else
		case
			when statusEcoDis.StatusValue is null then 'MISSING'
			when (statusEcoDis.StatusStartDate is null and statusEcoDis.StatusEndDate is null)
					or (not statusEcoDis.StatusStartDate is null and not statusEcoDis.StatusEndDate is null 
						and statusEcoDis.StatusStartDate <= d.SubmissionYearStartDate and statusEcoDis.StatusEndDate >= d.SubmissionYearEndDate)
					or (not statusEcoDis.StatusStartDate is null and statusEcoDis.StatusEndDate is null 
						and statusEcoDis.StatusStartDate <= d.SubmissionYearStartDate)
				then
					case 
						when statusEcoDis.StatusValue = 1 then 'EconomicDisadvantage'
						else 'MISSING'
					end
			else 'MISSING' end
		end as EcoDisStatusCode,
		case when @useChildCountDate = 1 then 
		case
			when statusHomeless.StatusValue is null then 'MISSING'
			when (statusHomeless.StatusStartDate is null and statusHomeless.StatusEndDate is null)
					or (not statusHomeless.StatusStartDate is null and not statusHomeless.StatusEndDate is null 
						and statusHomeless.StatusStartDate <= d.SubmissionYearDate and statusHomeless.StatusEndDate >= d.SubmissionYearDate)
					or (not statusHomeless.StatusStartDate is null and statusHomeless.StatusEndDate is null 
						and statusHomeless.StatusStartDate <= d.SubmissionYearDate)
				then
					case 
						when statusHomeless.StatusValue = 1 then 'Homeless'
						else 'MISSING'
					end
			else 'MISSING' end
		else
			case
			when statusHomeless.StatusValue is null then 'MISSING'
			when (statusHomeless.StatusStartDate is null and statusHomeless.StatusEndDate is null)
					or (not statusHomeless.StatusStartDate is null and not statusHomeless.StatusEndDate is null 
						and statusHomeless.StatusStartDate <= d.SubmissionYearStartDate and statusHomeless.StatusEndDate >= d.SubmissionYearEndDate)
					or (not statusHomeless.StatusStartDate is null and statusHomeless.StatusEndDate is null 
						and statusHomeless.StatusStartDate <= d.SubmissionYearStartDate)
				then
					case 
						when statusHomeless.StatusValue = 1 then 'Homeless'
						else 'MISSING'
					end
			else 'MISSING' end
		end as HomelessStatusCode,
		case when @useChildCountDate = 1 then 
		case
			when statusHomelessUY.StatusValue is null then 'MISSING'
			when (statusHomelessUY.StatusStartDate is null and statusHomelessUY.StatusEndDate is null)
					or (not statusHomelessUY.StatusStartDate is null and not statusHomelessUY.StatusEndDate is null 
						and statusHomelessUY.StatusStartDate <= d.SubmissionYearDate and statusHomelessUY.StatusEndDate >= d.SubmissionYearDate)
					or (not statusHomelessUY.StatusStartDate is null and statusHomelessUY.StatusEndDate is null 
						and statusHomelessUY.StatusStartDate <= d.SubmissionYearDate)
				then
					case 
						when statusHomelessUY.StatusValue = 1 then 'UY'
						else 'MISSING'
					end
			else 'MISSING' end
		else
			case
			when statusHomelessUY.StatusValue is null then 'MISSING'
			when (statusHomelessUY.StatusStartDate is null and statusHomelessUY.StatusEndDate is null)
					or (not statusHomelessUY.StatusStartDate is null and not statusHomelessUY.StatusEndDate is null 
						and statusHomelessUY.StatusStartDate <= d.SubmissionYearStartDate and statusHomelessUY.StatusEndDate >= d.SubmissionYearEndDate)
					or (not statusHomelessUY.StatusStartDate is null and statusHomelessUY.StatusEndDate is null 
						and statusHomelessUY.StatusStartDate <= d.SubmissionYearStartDate)
				then
					case 
						when statusHomelessUY.StatusValue = 1 then 'UY'
						else 'MISSING'
					end
			else 'MISSING' end
		end as HomelessUYStatusCode,
		case when @useChildCountDate = 1 then 
		case
			when statusLep.StatusValue is null then 'MISSING'
			when (statusLep.StatusStartDate is null and statusLep.StatusEndDate is null)
					or (not statusLep.StatusStartDate is null and not statusLep.StatusEndDate is null 
						and statusLep.StatusStartDate <= d.SubmissionYearDate and statusLep.StatusEndDate >= d.SubmissionYearDate)
					or (not statusLep.StatusStartDate is null and statusLep.StatusEndDate is null 
						and statusLep.StatusStartDate <= d.SubmissionYearDate)
				then
					case 
						when statusLep.StatusValue = 1 then 'LEP'
						else 'NLEP'
					end
			else 'MISSING' end
		else
		case
			when statusLep.StatusValue is null then 'MISSING'
			when (statusLep.StatusStartDate is null and statusLep.StatusEndDate is null)
					or (not statusLep.StatusStartDate is null and not statusLep.StatusEndDate is null 
						and statusLep.StatusStartDate <= d.SubmissionYearStartDate and statusLep.StatusEndDate >= d.SubmissionYearEndDate)
					or (not statusLep.StatusStartDate is null and statusLep.StatusEndDate is null 
						and statusLep.StatusStartDate <= d.SubmissionYearStartDate)
				then
					case 
						when statusLep.StatusValue = 1 then 'LEP'
						else 'NLEP'
					end
			else 'MISSING' end
		end as LepStatusCode,
		case when @useChildCountDate = 1 then 
				case
					when statusMigrant.StatusValue is null then 'MISSING'
					when (statusMigrant.StatusStartDate is null and statusMigrant.StatusEndDate is null)
						or (not statusMigrant.StatusStartDate is null and not statusMigrant.StatusEndDate is null 
						and statusMigrant.StatusStartDate <= d.SubmissionYearDate and statusMigrant.StatusEndDate >= d.SubmissionYearDate)
						or (not statusMigrant.StatusStartDate is null and statusMigrant.StatusEndDate is null 
						and statusMigrant.StatusStartDate <= d.SubmissionYearDate)
					then
					case 
						when statusMigrant.StatusValue = 1 then 'Migrant'
						else 'MISSING'
					end
					else 'MISSING' end
		else 
				case
					when statusMigrant.StatusValue is null then 'MISSING'
					when (statusMigrant.StatusStartDate is null and statusMigrant.StatusEndDate is null)
						or (not statusMigrant.StatusStartDate is null and not statusMigrant.StatusEndDate is null 
						and statusMigrant.StatusStartDate <= d.SubmissionYearStartDate and statusMigrant.StatusEndDate >= d.SubmissionYearEndDate)
						or (not statusMigrant.StatusStartDate is null and statusMigrant.StatusEndDate is null 
						and statusMigrant.StatusStartDate <= d.SubmissionYearStartDate)
					then
					case 
						when statusMigrant.StatusValue = 1 then 'Migrant'
						else 'MISSING'
					end
				else 'MISSING' end
		end as MigrantStatusCode,
		isnull(sex.Code, 'MISSING') AS SexCode,
		case when ISNULL(militaryStatus.RefMilitaryConnectedStudentIndicatorId,0) = 0 then 'MISSING'
			else 'MILCNCTD' 
		end  as 'MilitaryConnectedStatus',
		case when dt.Code = 'Shelters' THEN 'STH' 
			 when dt.Code = 'DoubledUp' THEN 'D' 
			 when dt.Code = 'Unsheltered' THEN 'U'
			 when dt.Code = 'HotelMotel' THEN 'HM' 
			 ELSE ISNull(dt.Code,'MISSING') 
			 END as HomelessNighttimeResidence,
		p.RecordStartDateTime as PersonStartDate,
		p.RecordEndDateTime as PersonEndDate
	from rds.DimStudents s 
	inner join @studentDates d on s.DimStudentId = d.DimStudentId
	inner join ods.PersonDetail p on p.PersonId = s.StudentPersonId
	left outer join ods.RefSex sex on p.RefSexId = sex.RefSexId
	left outer join ods.PersonStatus statusEcoDis on s.StudentPersonId = statusEcoDis.PersonId
	and statusEcoDis.RefPersonStatusTypeId = @ecoDisPersonStatusTypeId
	left outer join ods.PersonStatus statusHomeless on s.StudentPersonId = statusHomeless.PersonId
	and statusHomeless.RefPersonStatusTypeId = @homelessPersonStatusTypeId
	left outer join ods.PersonStatus statusHomelessUY on s.StudentPersonId = statusHomelessUY.PersonId
	and statusHomelessUY.RefPersonStatusTypeId = @homelessUnaccompaniedYouthPersonStatusTypeId
	left outer join ods.PersonStatus statusLep on s.StudentPersonId = statusLep.PersonId
	and statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
	left outer join ods.PersonStatus statusMigrant on s.StudentPersonId = statusMigrant.PersonId
	and statusMigrant.RefPersonStatusTypeId = @migrantPersonStatusTypeId
	left join ods.PersonMilitary militaryStatus on militaryStatus.PersonId = s.StudentPersonId
	left outer join ods.PersonHomelessness ph on ph.PersonId = d.PersonId
		and	ISNULL(ph.RecordStartDateTime, d.SubmissionYearDate) <= 
			case
				when @useChildCountDate = 0 then d.SubmissionYearEndDate
				else d.SubmissionYearDate
			end 
		and 
			ISNULL(ph.RecordEndDateTime, GETDATE()) >=
			case
				when @useChildCountDate = 0 then d.SubmissionYearStartDate
				else d.SubmissionYearDate
			end
	left join ods.RefHomelessNighttimeResidence dt on dt.RefHomelessNighttimeResidenceId = ph.RefHomelessNighttimeResidenceId

END