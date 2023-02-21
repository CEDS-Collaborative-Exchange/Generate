CREATE PROCEDURE [RDS].[Migrate_DimDemographics]
	@studentDates as StudentDateTableType READONLY,
	@useCutOffDate bit
AS
BEGIN
	
	declare @ecoDisPersonStatusTypeId as int
	select @ecoDisPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'EconomicDisadvantage'

	declare @homelessPersonStatusTypeId as int
	select @homelessPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'Homeless'

	declare @homelessUnaccompaniedYouthPersonStatusTypeId as int
	select @homelessUnaccompaniedYouthPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType 
	where code = 'HomelessUnaccompaniedYouth'
	
	declare @lepPersonStatusTypeId as int
	select @lepPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'LEP'

	declare @migrantPersonStatusTypeId as int
	select @migrantPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'Migrant'
	
	-- Statuses

	select 
		s.DimStudentId,
		p.PersonId,
		d.DimCountDateId,
		case when @useCutOffDate = 1 then 
		case
			when statusEcoDis.StatusValue is null then 'MISSING'
			when d.SubmissionYearDate BETWEEN statusEcoDis.StatusStartDate AND ISNULL(statusEcoDis.StatusEndDate, GETDATE())
				then
					case 
						when statusEcoDis.StatusValue = 1 then 'EconomicDisadvantage'
						else 'MISSING'
					end
			else 'MISSING' end
		else
		case
			when statusEcoDis.StatusValue is null then 'MISSING'
			when statusEcoDis.StatusStartDate <= d.SubmissionYearEndDate 
			and ISNULL(statusEcoDis.StatusEndDate, GETDATE()) >= d.SubmissionYearStartDate
			then
					case 
						when statusEcoDis.StatusValue = 1 then 'EconomicDisadvantage'
						else 'MISSING'
					end
			else 'MISSING' end
		end as EcoDisStatusCode,
		case when @useCutOffDate = 1 then 
		case
			when statusHomeless.StatusValue is null then 'MISSING'
			when d.SubmissionYearDate BETWEEN statusHomeless.StatusStartDate AND ISNULL(statusHomeless.StatusEndDate, GETDATE())
				then
					case 
						when statusHomeless.StatusValue = 1 then 'Homeless'
						else 'MISSING'
					end
			else 'MISSING' end
		else
			case
			when statusHomeless.StatusValue is null then 'MISSING'
			when statusHomeless.StatusStartDate <= d.SubmissionYearEndDate 
			and ISNULL(statusHomeless.StatusEndDate, GETDATE()) >= d.SubmissionYearStartDate
				then
					case 
						when statusHomeless.StatusValue = 1 then 'Homeless'
						else 'MISSING'
					end
			else 'MISSING' end
		end as HomelessStatusCode,
		case when @useCutOffDate = 1 then 
		case
			when statusHomelessUY.StatusValue is null then 'MISSING'
			when d.SubmissionYearDate BETWEEN statusHomelessUY.StatusStartDate AND ISNULL(statusHomelessUY.StatusEndDate, GETDATE())
				then
					case 
						when statusHomelessUY.StatusValue = 1 then 'UY'
						else 'MISSING'
					end
			else 'MISSING' end
		else
			case
			when statusHomelessUY.StatusValue is null then 'MISSING'
			when statusHomelessUY.StatusStartDate <= d.SubmissionYearEndDate 
			and ISNULL(statusHomelessUY.StatusEndDate, GETDATE()) >= d.SubmissionYearStartDate
				then
					case 
						when statusHomelessUY.StatusValue = 1 then 'UY'
						else 'MISSING'
					end
			else 'MISSING' end
		end as HomelessUYStatusCode,
		case when @useCutOffDate = 1 then 
		case
			when statusLep.StatusValue is null then 'MISSING'
			when d.SubmissionYearDate BETWEEN statusLep.StatusStartDate AND ISNULL(statusLep.StatusEndDate, GETDATE())
				then
					case 
						when statusLep.StatusValue = 1 then 'LEP'
						else 'NLEP'
					end
			else 'MISSING' end
		else
		case
			when statusLep.StatusValue is null then 'MISSING'
			when statusLep.StatusStartDate <= d.SubmissionYearEndDate 
			and ISNULL(statusLep.StatusEndDate, GETDATE()) >= d.SubmissionYearStartDate
				then
					case 
						when statusLep.StatusValue = 1 then 'LEP'
						else 'NLEP'
					end
			else 'MISSING' end
		end as LepStatusCode,
		case when @useCutOffDate = 1 then 
				case
					when statusMigrant.StatusValue is null then 'MISSING'
					when d.SubmissionYearDate BETWEEN statusMigrant.StatusStartDate AND ISNULL(statusMigrant.StatusEndDate, GETDATE())
					then
					case 
						when statusMigrant.StatusValue = 1 then 'Migrant'
						else 'MISSING'
					end
					else 'MISSING' end
		else 
				case
					when statusMigrant.StatusValue is null then 'MISSING'
					when statusMigrant.StatusStartDate <= d.SubmissionYearEndDate 
					and ISNULL(statusMigrant.StatusEndDate, GETDATE()) >= d.SubmissionYearStartDate
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
	inner join ods.PersonIdentifier id on id.Identifier = s.StateStudentIdentifier
	inner join ods.PersonDetail p on p.PersonId = id.PersonId
	left outer join ods.RefSex sex on p.RefSexId = sex.RefSexId
	left outer join ods.PersonStatus statusEcoDis on p.PersonId = statusEcoDis.PersonId
	and statusEcoDis.RefPersonStatusTypeId = @ecoDisPersonStatusTypeId
	left outer join ods.PersonStatus statusHomeless on p.PersonId = statusHomeless.PersonId
	and statusHomeless.RefPersonStatusTypeId = @homelessPersonStatusTypeId
	left outer join ods.PersonStatus statusHomelessUY on p.PersonId = statusHomelessUY.PersonId
	and statusHomelessUY.RefPersonStatusTypeId = @homelessUnaccompaniedYouthPersonStatusTypeId
	left outer join ods.PersonStatus statusLep on p.PersonId = statusLep.PersonId
	and statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
	left outer join ods.PersonStatus statusMigrant on p.PersonId = statusMigrant.PersonId
	and statusMigrant.RefPersonStatusTypeId = @migrantPersonStatusTypeId
	left join ods.PersonMilitary militaryStatus on militaryStatus.PersonId = p.PersonId
	left outer join ods.PersonHomelessness ph on ph.PersonId = p.PersonId
		and	ISNULL(ph.RecordStartDateTime, d.SubmissionYearDate) <= 
			case
				when @useCutOffDate = 0 then d.SubmissionYearEndDate
				else d.SubmissionYearDate
			end 
		and 
			ISNULL(ph.RecordEndDateTime, GETDATE()) >=
			case
				when @useCutOffDate = 0 then d.SubmissionYearStartDate
				else d.SubmissionYearDate
			end
	left join ods.RefHomelessNighttimeResidence dt on dt.RefHomelessNighttimeResidenceId = ph.RefHomelessNighttimeResidenceId

END