



CREATE PROCEDURE [RDS].[Migrate_DimGradeLevels]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN


				declare @k12StudentRoleId as int
                select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'

			    declare @schoolOrganizationTypeId as int
				select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

               select         s.DimStudentId,
							  sch.DimSchoolId,
                              s.StudentPersonId as PersonId,
                              d.DimCountDateId,
                              isnull(grd.Code, 'MISSING')
               from rds.DimStudents s 
			   inner join @studentDates d on s.DimStudentId = d.DimStudentId
               inner join ods.OrganizationPersonRole r on r.PersonId = s.StudentPersonId
			   inner join rds.DimSchools sch on r.OrganizationId = sch.SchoolOrganizationId
			   inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
				   and o.RefOrganizationTypeId = @schoolOrganizationTypeId
				   and r.RoleId = @k12StudentRoleId 
				   and d.SubmissionYearDate between ISNULL(o.RecordStartDateTime, d.SubmissionYearDate) and ISNULL(o.RecordEndDateTime, GETDATE())
			   inner join [ODS].[K12StudentEnrollment] enr on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId
				   and d.SubmissionYearDate between ISNULL(enr.RecordStartDateTime, d.SubmissionYearDate) and ISNULL(enr.RecordEndDateTime, GETDATE())
               inner join ods.OrganizationCalendar calendar on r.OrganizationId = calendar.OrganizationId
			   inner join ods.OrganizationCalendarSession calendarSession on calendar.OrganizationCalendarId = calendarSession.OrganizationCalendarId
               inner join ods.RefGradeLevel grd on enr.RefEntryGradeLevelId = grd.RefGradeLevelId
               where s.DimStudentId <> -1
				   and r.EntryDate >= calendarSession.BeginDate and (r.ExitDate <= calendarSession.EndDate or r.ExitDate is null)
				   and r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
			   order by s.DimStudentId
	
	

END


