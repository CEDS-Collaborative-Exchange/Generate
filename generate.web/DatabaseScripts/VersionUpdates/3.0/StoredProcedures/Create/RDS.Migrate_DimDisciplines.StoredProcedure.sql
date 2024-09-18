CREATE PROCEDURE [RDS].[Migrate_DimDisciplines]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

	declare @lepPersonStatusTypeId as int
	select @lepPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'LEP'

	-- DisciplineAction
	------------------------------

	declare @disciplineQuery as table (
		DimStudentId int,
		PersonId int,	
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DisciplineActionCode varchar(50),
		DisciplineMethodCode varchar(50),
		EducationalServicesCode varchar(50),
		RemovalTypeCode varchar(50),
		RemovalReasonCode varchar(50),
		DisciplineELStatusCode varchar(50),
		DisciplineDuration decimal(18,2),
		DisciplinaryActionStartDate Date
	)

	insert into @disciplineQuery
	(
		DimStudentId,
		PersonId,
		DimCountDateId,
		DimSchoolId,
		DimLeaId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalTypeCode,
		RemovalReasonCode,
		DisciplineELStatusCode,
		DisciplineDuration,
		DisciplinaryActionStartDate
	)
	select 
		s.DimStudentId,
		s.StudentPersonId as PersonId,
		d.DimCountDateId,
		sch.DimSchoolId,
		lea.DimLeaId,
		act.Code,
		case
			when act.Code in ('03086', '03087', '03101', '03102', '03154', '03155') then 'OUTOFSCHOOL'
			when act.Code in ('03100') then 'INSCHOOL'
			else 'MISSING'
		end as DisciplineMethodCode,
		case
			when act.Code in ('03086') then 'SERVPROV'
			when act.Code in ('03087') then 'SERVNOTPROV'
			else 'MISSING'
		end as EducationalServicesCode,
		case
			when removalType.Code in ('REMDW') or act.Code in ('03156', '03157') then 'REMDW'
			when removalType.Code in ('REMHO') or act.Code in ('03158') then 'REMHO'
			else 'MISSING'
		end as RemovalTypeCode,
		case
			when removalReason.Code in ('Drugs') then 'D'
			when removalReason.Code in ('Weapons') then 'W'
			when removalReason.Code in ('SeriousBodilyInjury') then 'SBI'
			else 'MISSING'
		end as RemovalReasonCode,
		case
			when statusLep.StatusValue is null then 'MISSING'
			when (statusLep.StatusStartDate is null and statusLep.StatusEndDate is null)
					or (not statusLep.StatusStartDate is null and not statusLep.StatusEndDate is null 
						and statusLep.StatusStartDate <= d.SubmissionYearStartDate and statusLep.StatusEndDate >= d.SubmissionYearEndDate
						and dis.DisciplinaryActionStartDate between statusLep.StatusStartDate and statusLep.StatusEndDate)
					or (not statusLep.StatusStartDate is null and statusLep.StatusEndDate is null 
						and statusLep.StatusStartDate <= d.SubmissionYearStartDate and statusLep.StatusStartDate <= dis.DisciplinaryActionStartDate)
				then
					case 
						when statusLep.StatusValue = 1 then 'LEP'
						else 'NLEP'
					end
			else 'MISSING' end
		 as LepStatusCode,
		dis.DurationOfDisciplinaryAction,
		dis.DisciplinaryActionStartDate
	from rds.DimStudents s 
	inner join @studentDates d on s.DimStudentId = d.DimStudentId
	inner join ods.OrganizationPersonRole r on s.StudentPersonId = r.PersonId	
	inner join ods.K12studentDiscipline dis on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
	inner join rds.DimSchools sch on r.OrganizationId = sch.SchoolOrganizationId
	inner join rds.DimLeas lea on lea.LeaOrganizationId= sch.LeaOrganizationId
	left outer join ods.RefDisciplinaryActionTaken act on dis.RefDisciplinaryActionTakenId = act.RefDisciplinaryActionTakenId
	left outer join ods.RefIDEAInterimRemoval removalType on dis.RefIdeaInterimRemovalId = removalType.RefIDEAInterimRemovalId
	left outer join ods.RefIDEAInterimRemovalReason removalReason on dis.RefIdeaInterimRemovalReasonId = removalReason.RefIDEAInterimRemovalReasonId
	left outer join ods.PersonStatus statusLep on s.StudentPersonId = statusLep.PersonId
	and statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
	and dis.DisciplinaryActionStartDate >= Convert(Date,statusLep.StatusStartDate) 
	and dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(statusLep.StatusEndDate,dis.DisciplinaryActionStartDate))
	where s.DimStudentId <> -1
	and r.EntryDate <= d.SubmissionYearEndDate and (r.ExitDate >= d.SubmissionYearStartDate or r.ExitDate is null)	
	and (dis.DisciplinaryActionStartDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate
		OR dis.DisciplinaryActionEndDate IS NULL 
		OR dis.DisciplinaryActionEndDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate)


	-- Return results

	select
		d.DimStudentId,
		d.PersonId,
		d.DimCountDateId,
		isnull(dis.DimSchoolId, -1) as DimSchoolId,
		isnull(dis.DimLeaId, -1) as DimLeaId,
		isnull(dis.DisciplineActionCode, 'MISSING') as DisciplineActionCode,
		isnull(dis.DisciplineMethodCode, 'MISSING') as DisciplineMethodCode,
		isnull(dis.EducationalServicesCode, 'MISSING') as EducationalServicesCode,
		isnull(dis.RemovalReasonCode, 'MISSING') as RemovalReasonCode,
		isnull(dis.RemovalTypeCode, 'MISSING') as RemovalTypeCode,
		isnull(dis.DisciplineELStatusCode, 'MISSING') as DisciplineELStatusCode,
		isnull(dis.DisciplineDuration, 0.0) as DisciplineDuration,
		dis.DisciplinaryActionStartDate
	from @studentDates d
	left outer join @disciplineQuery dis on d.DimStudentId = dis.DimStudentId and d.DimCountDateId = dis.DimCountDateId
	

END

