CREATE PROCEDURE [RDS].[Migrate_DimGradeLevels]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN


             declare @k12StudentRoleId as int
			select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'

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



               select         s.DimStudentId,
							  o.DimSchoolId,
							  o.DimLeaId,
                              d.PersonId,
                              d.DimCountDateId,
                              isnull(grd.Code, 'MISSING')
               from rds.DimStudents s 
			   inner join @studentDates d on s.DimStudentId = d.DimStudentId
               inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId and r.RoleId = @k12StudentRoleId
							 and r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
			   inner join #studentOrganizations o
				on d.DimStudentId = o.DimStudentId and d.DimCountDateId = o.DimCountDateId and r.OrganizationId = IIF(o.OrganizationId > 0 , o.OrganizationId, o.LeaOrganizationId)
			    inner join [ODS].[K12StudentEnrollment] enr on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId
				   and d.SubmissionYearDate between ISNULL(enr.RecordStartDateTime, d.SubmissionYearDate) and ISNULL(enr.RecordEndDateTime, GETDATE())
               inner join ods.RefGradeLevel grd on enr.RefEntryGradeLevelId = grd.RefGradeLevelId
			   inner join ods.RefGradeLevelType glt on grd.RefGradeLevelTypeId = glt.RefGradeLevelTypeId
					and glt.Code = '000100'
               where s.DimStudentId <> -1
			   order by s.DimStudentId
	
			 drop TABLE #studentOrganizations
	

END
