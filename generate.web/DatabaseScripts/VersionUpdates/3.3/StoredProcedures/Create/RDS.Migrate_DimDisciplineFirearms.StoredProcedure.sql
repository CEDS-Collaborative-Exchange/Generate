CREATE PROCEDURE [RDS].[Migrate_DimFirearmsDiscipline]
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

	select 
		s.DimStudentId,	
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,
		org.DimCountDateId,		
		ISNULL(refFirearms.Code, 'MISSING')	 as FirearmsDisciplineCode,
		ISNULL(refFirearmsIdea.Code, 'MISSING')	 as IDEAFirearmsDisciplineCode
	from @studentDates s 
	 inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId and r.RoleId = @k12StudentRoleId 
	 and r.EntryDate <= s.SubmissionYearDate and (r.ExitDate >= s.SubmissionYearDate or r.ExitDate is null)
	 inner join #studentOrganizations org on r.PersonId = org.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	 inner join ods.K12studentDiscipline dis on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
	 left outer join ods.RefDisciplineMethodFirearms refFirearms on refFirearms.RefDisciplineMethodFirearmsId=dis.RefDisciplineMethodFirearmsId
	 left outer join ods.RefIDEADisciplineMethodFirearm refFirearmsIdea on refFirearmsIdea.RefIDEADisciplineMethodFirearmId=dis.RefIDEADisciplineMethodFirearmId
	 where s.DimStudentId <> -1 
	
	drop TABLE #studentOrganizations


END




