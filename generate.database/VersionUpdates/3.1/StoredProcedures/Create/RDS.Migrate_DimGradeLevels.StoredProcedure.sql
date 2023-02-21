CREATE PROCEDURE [RDS].[Migrate_DimGradeLevels]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN


               select         s.DimStudentId,
							  o.DimSchoolId,
							  o.DimLeaId,
                              d.PersonId,
                              d.DimCountDateId,
                              isnull(grd.Code, 'MISSING')
               from rds.DimStudents s 
			   inner join @studentDates d on s.DimStudentId = d.DimStudentId
               inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId
			   inner join (select * from RDS.Get_StudentOrganizations(@studentDates,0)) o
				on d.PersonId = o.PersonId and d.DimCountDateId = o.DimCountDateId and r.OrganizationId = IIF(o.OrganizationId > 0 , o.OrganizationId, o.LeaOrganizationId)
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
