CREATE PROCEDURE [RDS].[Migrate_DimAssessmentStatuses]
	@studentDates as rds.StudentDateTableType ReadOnly
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

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

	CREATE TABLE #studentOrganizations (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	CREATE TABLE #firstAssessed (
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		FirstAssessedDate date
	)

	CREATE TABLE #progressLevel (
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		AcademicSubject varchar(100),
		ProgressLevel varchar(100)
	)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates, 0)

	
	insert into #firstAssessed(PersonId, DimSchoolId, DimLeaId, DimCountDateId, FirstAssessedDate)
	SELECT reg.PersonId, org.DimSchoolId, org.DimLeaId, org.DimCountDateId,  min(adm.StartDate) as 'FirstAssessedDate'
    from  #studentOrganizations org
    inner join ods.AssessmentRegistration reg 
		on org.PersonId = reg.PersonId 
		and IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId) = isnull(reg.SchoolOrganizationId,reg.LeaOrganizationId)
    inner join ods.RefGradeLevel grd 
		on reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
    inner join ods.AssessmentAdministration adm 
		on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId        
    inner join ods.Assessment ass 
		on adm.AssessmentId = ass.AssessmentId
    inner join (select RefAcademicSubjectId from ods.RefAcademicSubject where Code = '00256') sub 
		on ass.RefAcademicSubjectId = sub.RefAcademicSubjectId
    inner join ods.OrganizationCalendar oc 
		on oc.OrganizationId = isnull(reg.SchoolOrganizationId,reg.LeaOrganizationId)
    inner join ods.OrganizationCalendarSession ocs 
		on  oc.OrganizationCalendarId = ocs.OrganizationCalendarId    
		and adm.StartDate between ocs.BeginDate and ocs.EndDate
    group by reg.PersonId, org.DimSchoolId, org.DimLeaId, org.DimCountDateId         
				
	insert into #progressLevel(PersonId, DimSchoolId, DimLeaId, DimCountDateId, AcademicSubject, ProgressLevel)            
	SELECT distinct reg.PersonId, org.DimSchoolId, org.DimLeaId, org.DimCountDateId, sub.Code as AcademicSubject, levels.Code as ProgressLevel
	from @studentDates s
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = s.PersonId
		and r.EntryDate <= s.SubmissionYearDate 
		and (r.ExitDate >= s.SubmissionYearDate or r.ExitDate is null)
	inner join #studentOrganizations org 
		on s.PersonId = org.PersonId 
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.OrganizationRelationship orp 
		on  r.OrganizationId = orp.Parent_OrganizationId
	inner join ods.OrganizationPersonRole r2 
		on r2.OrganizationId = orp.OrganizationId
	inner join ods.PersonProgramParticipation ppp 
		on r2.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId 
	inner join ods.ProgramParticipationNeglectedProgressLevel ppnProgress 
		on ppp.PersonProgramParticipationId = ppnProgress.PersonProgramParticipationId
	inner join ods.RefProgressLevel levels 
		on levels.RefProgressLevelId = ppnProgress.RefProgressLevelId
	inner join ods.AssessmentRegistration  reg 
		on r.PersonId = reg.PersonId 
		and r.OrganizationId = isnull(reg.SchoolOrganizationId,reg.LeaOrganizationId)  
	inner join ods.RefGradeLevel grd	
		on reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
	inner join ods.AssessmentAdministration adm 
		on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId        
	inner join ods.RefAcademicSubject sub 
		on ppnProgress.RefAcademicSubjectId = sub.RefAcademicSubjectId
	inner join ods.OrganizationCalendar oc 
		on oc.OrganizationId = r.OrganizationId
	inner join ods.OrganizationCalendarSession ocs 
		on oc.OrganizationCalendarId = ocs.OrganizationCalendarId 
		and adm.StartDate between ocs.BeginDate and ocs.EndDate


	SELECT distinct s.DimStudentId,	IIF(aft.DimSchoolId > 0, aft.DimSchoolId, progress.DimSchoolId) as DimSchoolId,		
			IIF(aft.DimLeaId > 0, aft.DimLeaId, progress.DimLeaId) as DimLeaId,	s.PersonId,	s.DimCountDateId,
			case when aft.FirstAssessedDate IS NOT NULL and  aft.FirstAssessedDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate 
			THEN 'FIRSTASSESS' ELSE 'MISSING'	END as 'FirstAssessed',
			AcademicSubject, isnull(progress.ProgressLevel,'MISSING') as ProgressLevel
	FROM  @studentDates s 
	left outer join #firstAssessed aft 
		on aft.PersonId = s.PersonId
	left outer join #progressLevel progress 
		on progress.PersonId = s.PersonId

	drop TABLE #firstAssessed
	drop TABLE #progressLevel
	drop TABLE #studentOrganizations
				
END               