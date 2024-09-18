




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
	DimSchoolId,		
	s.PersonId,
	s.DimCountDateId,
	case when 
	aft.FirstAssessedDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate THEN 'FIRSTASSESS' 
	END as 'FirstAssessed'

FROM  @studentDates s 
inner join (

		
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
				
 END               

