CREATE PROCEDURE [RDS].[Migrate_DimFirearmsDiscipline]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN
	select 
		s.DimStudentId,	
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,
		org.DimCountDateId,		
		ISNULL(refFirearms.Code, 'MISSING')	 as FirearmsDisciplineCode,
		ISNULL(refFirearmsIdea.Code, 'MISSING')	 as IDEAFirearmsDisciplineCode
	from @studentDates s 
	inner join (select * from RDS.Get_StudentOrganizations(@studentDates, 0)) org
					on s.DimStudentId = org.DimStudentId
    inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.K12studentDiscipline dis on r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
	left outer join ods.RefDisciplineMethodFirearms refFirearms on refFirearms.RefDisciplineMethodFirearmsId=dis.RefDisciplineMethodFirearmsId
	left outer join ods.RefIDEADisciplineMethodFirearm refFirearmsIdea on refFirearmsIdea.RefIDEADisciplineMethodFirearmId=dis.RefIDEADisciplineMethodFirearmId
	where s.DimStudentId <> -1 

END



