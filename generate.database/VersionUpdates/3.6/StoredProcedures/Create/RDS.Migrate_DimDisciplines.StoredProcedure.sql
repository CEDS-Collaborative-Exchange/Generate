CREATE PROCEDURE [RDS].[Migrate_DimDisciplines]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

/*****************************
For Debugging 
*****************************/
--declare @studentDates as rds.StudentDateTableType
--declare @migrationType varchar(3) = 'rds'

----select the appropriate date variable, 8=17-18, 9=18-19, 10=19-20, etc...
--declare @selectedDate int = 9

----variable for the file spec, uncomment the appropriate one 
--declare     @factTypeCode as varchar(50) = 'childcount'
--declare     @factTypeCode as varchar(50) = 'datapopulation'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

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

	declare @lepPersonStatusTypeId as int
	select @lepPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'LEP'

	CREATE TABLE #studentOrganizations (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId 
	from RDS.Get_StudentOrganizations(@studentDates,0)

	select 
		s.DimStudentId,
		r.PersonId,
		d.DimCountDateId,
		isnull(org.DimSchoolId, -1) as DimSchoolId,
		NULL as DimLeaId,
		NULL as DimSeaId,
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
	into #Disciplines
	from rds.DimStudents s 
	inner join @studentDates d 
		on s.DimStudentId = d.DimStudentId
	inner join #studentOrganizations org
		on s.DimStudentId = org.DimStudentId 
		and d.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationDetail od 
		on org.OrganizationId = od.OrganizationId
	inner join ods.RefOrganizationType ot 
		on od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		and ot.Code = 'K12School'
	inner join ods.OrganizationPersonRole r 
		on d.PersonId = r.PersonId 
		and r.OrganizationId = org.OrganizationId	
		and r.EntryDate <= d.SubmissionYearEndDate 
		and (r.ExitDate >= d.SubmissionYearStartDate or r.ExitDate is null)	
	inner join ods.K12studentDiscipline dis 
		on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId 
		and (dis.DisciplinaryActionStartDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate
			OR dis.DisciplinaryActionEndDate IS NULL 
			OR dis.DisciplinaryActionEndDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate)
	left outer join ods.PersonStatus statusLep 
		on d.PersonId = statusLep.PersonId 
		and statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
		and dis.DisciplinaryActionStartDate >= Convert(Date,statusLep.StatusStartDate) 
		and dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(statusLep.StatusEndDate,dis.DisciplinaryActionStartDate))
	left outer join ods.RefDisciplinaryActionTaken act 
		on dis.RefDisciplinaryActionTakenId = act.RefDisciplinaryActionTakenId
	left outer join ods.RefIDEAInterimRemoval removalType 
		on dis.RefIdeaInterimRemovalId = removalType.RefIDEAInterimRemovalId
	left outer join ods.RefIDEAInterimRemovalReason removalReason 
		on dis.RefIdeaInterimRemovalReasonId = removalReason.RefIDEAInterimRemovalReasonId
	where s.DimStudentId <> -1

	update #Disciplines
	set DimLeaId = org.DimLeaId, DimSeaId = org.DimSeaId
	from #Disciplines d
	inner join #studentOrganizations org
		on d.DimStudentId = org.DimStudentId 
		and d.DimCountDateId = org.DimCountDateId
		and d.DimSchoolId = org.DimSchoolId
	inner join ods.OrganizationDetail od 
		on org.LeaOrganizationId = od.OrganizationId
	inner join ods.RefOrganizationType ot 
		on od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		and ot.Code = 'LEA'
	inner join ods.OrganizationPersonRole r 
		on d.PersonId = r.PersonId 
		and r.OrganizationId = org.LeaOrganizationId	
		and d.DisciplinaryActionStartDate between r.EntryDate and ISNULL(r.ExitDate, GETDATE())
	inner join ods.K12studentDiscipline dis 
		on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId 
		and dis.DisciplinaryActionStartDate = d.DisciplinaryActionStartDate

	select * from #Disciplines
	
	drop TABLE #studentOrganizations
	drop TABLE #Disciplines


END