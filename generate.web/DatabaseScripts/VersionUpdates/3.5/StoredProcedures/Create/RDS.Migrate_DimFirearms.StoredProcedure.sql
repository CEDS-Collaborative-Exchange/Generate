CREATE PROCEDURE [RDS].[Migrate_DimFirearms]
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

----variable for UseCutOffDate, uncomment the appropriate one
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
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,0)
     
    select 
        d.DimStudentId AS DimStudentId,
        org.DimSchoolId,
		org.DimLeaId,
        d.PersonId as PersonId,
        d.DimCountDateId AS DimCountDateId,
        ISNULL(rft.Code,'MISSING') as FirearmsCode 
    from  @studentDates d 
	inner join #studentOrganizations org
		on d.PersonId = org.PersonId 
		and d.DimCountDateId = org.DimCountDateId
    inner join ods.OrganizationPersonRole r 
		on r.PersonId = d.PersonId 
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)    
	inner join ods.Incident incident 
		on incident.OrganizationPersonRoleId = r.OrganizationPersonRoleId
	left join ods.RefFirearmType rft 
		on rft.RefFirearmTypeId = incident.RefFirearmTypeId	
    where r.EntryDate <= d.SubmissionYearDate 
	and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null) 
	and (incident.IncidentDate between d.SubmissionYearStartDate and d.SubmissionYearEndDate)

    drop TABLE #studentOrganizations

END
