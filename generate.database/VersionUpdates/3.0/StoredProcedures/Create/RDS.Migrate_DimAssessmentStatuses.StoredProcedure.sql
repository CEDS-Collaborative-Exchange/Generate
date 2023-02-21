CREATE PROCEDURE [RDS].[Migrate_DimAssessmentStatuses]
	@studentDates as rds.StudentDateTableType ReadOnly
AS
BEGIN
	
	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	
	
SELECT 
	s.DimStudentId,	
	ISNULL(aft.DimSchoolId, progress.DimSchoolId) as DimSchoolId,		
	s.PersonId,
	s.DimCountDateId,
	case when 
	aft.FirstAssessedDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate THEN 'FIRSTASSESS' ELSE 'MISSING'
	END as 'FirstAssessed',
	AcademicSubject,
	isnull(progress.ProgressLevel,'MISSING') as ProgressLevel

FROM  @studentDates s 
left outer join (

		
		  SELECT distinct  reg.PersonId, DimSchoolId, reg.SchoolOrganizationId,  min(adm.StartDate) as 'FirstAssessedDate'
          from ods.OrganizationPersonRole r 
				inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
										and o.RefOrganizationTypeId =  @schoolOrganizationTypeId
										and r.RoleId = @k12StudentRoleId
				inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
                inner join ods.AssessmentRegistration  reg on r.PersonId = reg.PersonId and r.OrganizationId = reg.SchoolOrganizationId   
                inner join ods.RefGradeLevel grd on reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
                inner join ods.AssessmentAdministration adm on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId        
                inner join ods.Assessment ass on adm.AssessmentId = ass.AssessmentId
                inner join ods.RefAcademicSubject sub on ass.RefAcademicSubjectId = sub.RefAcademicSubjectId
                inner join ods.OrganizationCalendar oc on oc.OrganizationId = reg.SchoolOrganizationId
                inner join ods.OrganizationCalendarSession ocs on
					  oc.OrganizationCalendarId = ocs.OrganizationCalendarId    
					  and adm.StartDate between ocs.BeginDate and ocs.EndDate
				where sub.Code = '00256'		--ELP Subjects
                group by reg.PersonId, DimSchoolId, reg.SchoolOrganizationId                      
                                        
                ) aft on aft.PersonId = s.PersonId    
left outer join (

					  SELECT distinct  reg.PersonId, DimSchoolId, reg.SchoolOrganizationId, sub.Code as AcademicSubject, levels.Code as ProgressLevel
          from ods.OrganizationPersonRole r 
				inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
										and o.RefOrganizationTypeId =  @schoolOrganizationTypeId
										and r.RoleId = @k12StudentRoleId
				inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
				inner join ods.K12StudentAcademicRecord acad on r.OrganizationPersonRoleId = acad.OrganizationPersonRoleId   
                inner join ods.RefProgressLevel levels on levels.RefProgressLevelId = acad.RefProgressLevelId
                inner join ods.AssessmentRegistration  reg on r.PersonId = reg.PersonId and r.OrganizationId = reg.SchoolOrganizationId   
                inner join ods.RefGradeLevel grd on reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
                inner join ods.AssessmentAdministration adm on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId        
                inner join ods.Assessment ass on adm.AssessmentId = ass.AssessmentId
                inner join ods.RefAcademicSubject sub on ass.RefAcademicSubjectId = sub.RefAcademicSubjectId
                inner join ods.OrganizationCalendar oc on oc.OrganizationId = reg.SchoolOrganizationId
                inner join ods.OrganizationCalendarSession ocs on
					  oc.OrganizationCalendarId = ocs.OrganizationCalendarId    
					  and adm.StartDate between ocs.BeginDate and ocs.EndDate
        
                                        
                ) progress on progress.PersonId = s.PersonId    
				
 END               