CREATE PROCEDURE [RDS].[Migrate_DimDisciplines]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

	declare @lepPersonStatusTypeId as int
	select @lepPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'LEP'

	CREATE TABLE #studentOrganizations
			(
				DimStudentId int,
				PersonId int,
				DimCountDateId int,
				DimSchoolId int,
				DimLeaId int,
				OrganizationId int,
				LeaOrganizationId int
			)


	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,0)


	select 
		s.DimStudentId,
		s.StudentPersonId as PersonId,
		d.DimCountDateId,
		isnull(org.DimSchoolId, -1) as DimSchoolId,
		isnull(org.DimLeaId, -1) as DimLeaId,
		isnull(act.Code, 'MISSING') as DisciplineActionCode,
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
			when removalReason.Code in ('Drugs') then 'D'
			when removalReason.Code in ('Weapons') then 'W'
			when removalReason.Code in ('SeriousBodilyInjury') then 'SBI'
			else 'MISSING'
		end as RemovalReasonCode,
		case
			when removalType.Code in ('REMDW') or act.Code in ('03156', '03157') then 'REMDW'
			when removalType.Code in ('REMHO') or act.Code in ('03158') then 'REMHO'
			else 'MISSING'
		end as RemovalTypeCode,
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
		isnull(dis.DurationOfDisciplinaryAction, 0.0) as DisciplineDuration,
		dis.DisciplinaryActionStartDate
	from rds.DimStudents s 
	inner join @studentDates d on s.DimStudentId = d.DimStudentId
	inner join #studentOrganizations org
					on s.DimStudentId = org.DimStudentId and d.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationPersonRole r on d.PersonId = r.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)	
				and r.EntryDate <= d.SubmissionYearEndDate and (r.ExitDate >= d.SubmissionYearStartDate or r.ExitDate is null)	
	inner join ods.K12studentDiscipline dis on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId 
											and (dis.DisciplinaryActionStartDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate
											OR dis.DisciplinaryActionEndDate IS NULL 
											OR dis.DisciplinaryActionEndDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate)
	left outer join ods.PersonStatus statusLep on d.PersonId = statusLep.PersonId and statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
												and dis.DisciplinaryActionStartDate >= Convert(Date,statusLep.StatusStartDate) 
												and dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(statusLep.StatusEndDate,dis.DisciplinaryActionStartDate))
	left outer join ods.RefDisciplinaryActionTaken act on dis.RefDisciplinaryActionTakenId = act.RefDisciplinaryActionTakenId
	left outer join ods.RefIDEAInterimRemoval removalType on dis.RefIdeaInterimRemovalId = removalType.RefIDEAInterimRemovalId
	left outer join ods.RefIDEAInterimRemovalReason removalReason on dis.RefIdeaInterimRemovalReasonId = removalReason.RefIDEAInterimRemovalReasonId
	where s.DimStudentId <> -1
		
	
	drop TABLE #studentOrganizations

END

