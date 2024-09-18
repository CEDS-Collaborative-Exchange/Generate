CREATE PROCEDURE [RDS].[Migrate_DimFirearms]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
     
       select 
             d.DimStudentId AS DimStudentId,
             org.DimSchoolId,
			 org.DimLeaId,
             d.PersonId as PersonId,
             d.DimCountDateId AS DimCountDateId,
           ISNULL(rft.Code,'MISSING') as FirearmsCode 
       from  @studentDates d 
	   inner join (select * from RDS.Get_StudentOrganizations(@studentDates, 0)) org
					on d.PersonId = org.PersonId and d.DimCountDateId = org.DimCountDateId
       inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)    
	   inner join ods.Incident incident on incident.OrganizationPersonRoleId = r.OrganizationPersonRoleId
	   left join ods.RefFirearmType rft on rft.RefFirearmTypeId=incident.RefFirearmTypeId	
         
       where r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null) and (incident.IncidentDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate)
END
