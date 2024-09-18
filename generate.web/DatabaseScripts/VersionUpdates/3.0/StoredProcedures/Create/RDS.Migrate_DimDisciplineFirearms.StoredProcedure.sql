




CREATE PROCEDURE [RDS].[Migrate_DimFirearmsDiscipline]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN
	select 
		s.DimStudentId,	
		sch.DimSchoolId,
		s.StudentPersonId as PersonId,
		d.DimCountDateId,		
		ISNULL(refFirearms.Code, 'MISSING')	 as FirearmsDisciplineCode,
		ISNULL(refFirearmsIdea.Code, 'MISSING')	 as IDEAFirearmsDisciplineCode
	from rds.DimStudents s 
	inner join @studentDates d on s.DimStudentId = d.DimStudentId
	inner join ods.OrganizationPersonRole r on s.StudentPersonId = r.PersonId	
	inner join ods.K12studentDiscipline dis on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
	left outer join rds.DimSchools sch on r.OrganizationId = sch.SchoolOrganizationId
	left outer join ods.RefDisciplineMethodFirearms refFirearms on refFirearms.RefDisciplineMethodFirearmsId=dis.RefDisciplineMethodFirearmsId
	left outer join ods.RefIDEADisciplineMethodFirearm refFirearmsIdea on refFirearmsIdea.RefIDEADisciplineMethodFirearmId=dis.RefIDEADisciplineMethodFirearmId
	where s.DimStudentId <> -1 

END


