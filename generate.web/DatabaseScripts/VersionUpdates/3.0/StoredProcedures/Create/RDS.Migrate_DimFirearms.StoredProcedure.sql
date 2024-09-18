CREATE PROCEDURE [RDS].[Migrate_DimFirearms]
       @studentDates as StudentDateTableType READONLY
AS
BEGIN
     
       select 
             d.DimStudentId AS DimStudentId,
            sch.DimSchoolId AS DimSchoolId,
             d.PersonId as PersonId,
             d.DimCountDateId AS DimCountDateId,
           ISNULL(rft.Code,'MISSING') as FirearmsCode 
       from  @studentDates d 
       inner join ods.OrganizationPersonRole r on r.PersonId = d.PersonId     
	   inner join ods.Incident incident on incident.OrganizationPersonRoleId = r.OrganizationPersonRoleId
	   inner join rds.DimSchools sch on sch.SchoolOrganizationId = r.OrganizationId 
	   left join ods.RefFirearmType rft on rft.RefFirearmTypeId=incident.RefFirearmTypeId	
         
       where r.EntryDate <= d.SubmissionYearDate and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null) and (incident.IncidentDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate)
END
