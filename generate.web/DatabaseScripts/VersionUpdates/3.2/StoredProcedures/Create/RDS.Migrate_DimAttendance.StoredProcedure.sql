﻿CREATE PROCEDURE [RDS].[Migrate_DimAttendance]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
       
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
		select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates, 0)
       
		select 
             s.DimStudentId,
             org.DimSchoolId,
			 org.DimLeaId,
             s.StudentPersonId as PersonId,
             d.DimCountDateId,
             case when (att.AttendanceRate * 100) < 10 then 'CA'
				  else 'NCA'
			 end as  AbsenteeismCode 
       from rds.DimStudents s 
       inner join @studentDates d on s.DimStudentId = d.DimStudentId
	   inner join #studentOrganizations org	on d.PersonId = org.PersonId and d.DimCountDateId = org.DimCountDateId
       inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
											and r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
       inner join ods.RoleAttendance att on att.OrganizationPersonRoleId = r.OrganizationPersonRoleId

	    drop TABLE #studentOrganizations
END



