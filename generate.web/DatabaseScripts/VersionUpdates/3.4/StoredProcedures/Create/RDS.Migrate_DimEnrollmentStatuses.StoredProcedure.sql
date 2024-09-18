CREATE PROCEDURE [RDS].[Migrate_DimEnrollmentStatuses]
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


	select s.DimStudentId,org.DimSchoolId,org.DimLeaId,s.PersonId,s.DimCountDateId, isnull(refExitType.Code, 'MISSING') as ExitOrWithdrawalCode
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId and r.EntryDate <= s.SubmissionYearDate and (r.ExitDate >= s.SubmissionYearDate or r.ExitDate is null)
	inner join #studentOrganizations org on s.PersonId = org.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.K12StudentEnrollment enr on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
											and s.SubmissionYearDate between ISNULL(enr.RecordStartDateTime, s.SubmissionYearDate) and ISNULL(enr.RecordEndDateTime, GETDATE())
	left outer join ods.RefExitOrWithdrawalType refExitType on enr.RefExitOrWithdrawalTypeId = refExitType.RefExitOrWithdrawalTypeId


	drop TABLE #studentOrganizations
			
			
END



