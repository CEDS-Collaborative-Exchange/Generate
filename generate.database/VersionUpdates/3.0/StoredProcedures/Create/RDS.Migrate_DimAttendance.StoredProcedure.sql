CREATE PROCEDURE [RDS].[Migrate_DimAttendance]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
       
            
       select 
             s.DimStudentId,
             sch.DimSchoolId,
             s.StudentPersonId as PersonId,
             d.DimCountDateId,
             case when (att.AttendanceRate * 100) < 10 then 'CA'
				  else 'NCA'
			 end as  AbsenteeismCode 
       from rds.DimStudents s 
       inner join @studentDates d on s.DimStudentId = d.DimStudentId
       inner join ods.OrganizationPersonRole r on r.PersonId = s.StudentPersonId
       inner join ods.Organization o on o.OrganizationId = r.OrganizationId
       inner join ods.RoleAttendance att on att.OrganizationPersonRoleId = r.OrganizationPersonRoleId
	   inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
       where r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
END



