CREATE PROCEDURE [RDS].[Migrate_DimAges]
	@studentDates as StudentDateTableType READONLY,
	@factTypeCode as varchar(50) = 'submission'
AS
BEGIN

	declare @specialEdProgramTypeId as int
	select @specialEdProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '04888'

	
	
	if @factTypeCode = 'specedexit'
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
		select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId 
		from RDS.Get_StudentOrganizations(@studentDates,0)
		
		
		CREATE TABLE #studentSpecEdExit
		(
			DimStudentId int,
			PersonId int,
			Organizationid int,
			DimCountDateId int,
			ChildCountDate datetime,
			Exitdate datetime
		)

		insert into #studentSpecEdExit(DimStudentId, PersonId, Organizationid, DimCountDateId, ChildCountDate, Exitdate)
		select s.DimStudentId, s.PersonId, r.OrganizationId, s.DimCountDateId,
		case when s.SubmissionYearDate <= max(p.SpecialEducationServicesExitDate)
		then s.SubmissionYearDate else DATEADD(y, -1, s.SubmissionYearDate) end as SubmissionYearDate, 
		max(p.SpecialEducationServicesExitDate)
		from @studentDates s
		inner join #studentOrganizations r	on s.DimStudentId = r.DimStudentId and s.DimCountDateId = r.DimCountDateId
		inner join ods.OrganizationRelationship op on op.Parent_OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
		inner join ods.OrganizationPersonRole rp on rp.OrganizationId = op.OrganizationId and  rp.PersonId = r.PersonId
			and rp.EntryDate <= s.SubmissionYearEndDate and (rp.ExitDate >=  s.SubmissionYearStartDate or rp.ExitDate is null)
		inner join 	ods.OrganizationProgramType t on t.OrganizationId = op.OrganizationId and t.RefProgramTypeId = @specialEdProgramTypeId
		inner join ods.PersonProgramParticipation ppp on rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId 
		inner join ods.ProgramParticipationSpecialEducation p on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		where p.SpecialEducationServicesExitDate is not null
		group by s.DimStudentId, s.PersonId, r.OrganizationId, s.DimCountDateId, s.SubmissionYearDate
	
		select 
			s.DimStudentId,
			s.StudentPersonId as PersonId,
			org.DimLeaId,
			org.DimSchoolId,
			spedexit.DimCountDateId,
			case 
				when s.BirthDate is null then 'MISSING'
				when (CONVERT(int,CONVERT(char(8), spedexit.ChildCountDate,112))-CONVERT(char(8), s.BirthDate,112))/10000  <= 0 then 'MISSING'
				else CONVERT(varchar(5), (CONVERT(int,CONVERT(char(8), spedexit.ChildCountDate,112))-CONVERT(char(8), s.BirthDate,112))/10000)
			end as AgeCode,
			spedexit.Exitdate
		from rds.DimStudents s
		inner join #studentSpecEdExit spedexit on s.DimStudentId = spedexit.DimStudentId
		inner join #studentOrganizations org on spedexit.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)

		drop TABLE #studentSpecEdExit
		drop TABLE #studentOrganizations

	END
	ELSE
	BEGIN
		

		select 
			s.DimStudentId,
			s.StudentPersonId as PersonId,
			d.DimCountDateId,
			case 
				when s.BirthDate is null then 'MISSING'
				when (CONVERT(int,CONVERT(char(8), d.SubmissionYearDate,112))-CONVERT(char(8), s.BirthDate,112))/10000  <= 0 then 'MISSING'
				else CONVERT(varchar(5), (CONVERT(int,CONVERT(char(8), d.SubmissionYearDate,112))-CONVERT(char(8), s.BirthDate,112))/10000)
			end as AgeCode
		from rds.DimStudents s
		inner join @studentDates d on s.DimStudentId = d.DimStudentId


	END

	
END