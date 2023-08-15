CREATE PROCEDURE [RDS].[Migrate_DimFirearmsDiscipline]
	@studentDates as StudentDateTableType READONLY
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
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	   
	CREATE TABLE #studentOrganizations (
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
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = s.PersonId 
		and r.RoleId = @k12StudentRoleId 
		and r.EntryDate <= s.SubmissionYearDate 
		and (r.ExitDate >= s.SubmissionYearDate or r.ExitDate is null)
	inner join #studentOrganizations org 
		on r.PersonId = org.PersonId 
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.K12studentDiscipline dis 
		on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
	left outer join ods.RefDisciplineMethodFirearms refFirearms 
		on refFirearms.RefDisciplineMethodFirearmsId=dis.RefDisciplineMethodFirearmsId
	left outer join ods.RefIDEADisciplineMethodFirearm refFirearmsIdea 
		on refFirearmsIdea.RefIDEADisciplineMethodFirearmId = dis.RefIDEADisciplineMethodFirearmId
	where s.DimStudentId <> -1 
	
	drop TABLE #studentOrganizations


END




