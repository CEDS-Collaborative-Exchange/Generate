CREATE PROCEDURE [RDS].[Migrate_DimEnrollments]
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
--declare     @factTypeCode as varchar(50) = 'hsgradenroll'
--declare     @factTypeCode as varchar(50) = 'nord'

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

	declare @k12StudentRoleId as int, @studentDiplomaTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @studentDiplomaTypeId = RefHighSchoolDiplomaTypeId from ods.[RefHighSchoolDiplomaType] where Code = '00806'
	
	CREATE TABLE #studentOrganizations (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	
	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId 
	from RDS.Get_StudentOrganizations(@studentDates,0)

	select 
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		org.DimSeaId,
		s.PersonId,
		s.DimCountDateId,
		case when psEnrollment.Code is null then 'MISSING'
			 when psEnrollment.Code ='NoInformation'  then 'NO'
			 when psEnrollment.Code ='Enrolled'  then 'ENROLL'
			 when psEnrollment.Code ='NotEnrolled'  then 'NOENROLL'
		END as 'PostSecondaryEnrollmentStatusCode'
	from @studentDates s
	inner join #studentOrganizations org
		on s.PersonId = org.PersonId 
		and s.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = s.PersonId 
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.OrganizationDetail o 
		on o.OrganizationId = r.OrganizationId
	left join ods.K12StudentAcademicRecord k12AcademicRecord 
		on k12AcademicRecord.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
		and k12AcademicRecord.RefHighSchoolDiplomaTypeId=@studentDiplomaTypeId
		and k12AcademicRecord.DiplomaOrCredentialAwardDate between DateAdd(month,-16,s.SubmissionYearEndDate) and s.SubmissionYearEndDate
	left join ods.RefPsEnrollmentAction psEnrollment 
		on psEnrollment.RefPsEnrollmentActionId=k12AcademicRecord.RefPsEnrollmentActionId
	
	drop TABLE #studentOrganizations

END