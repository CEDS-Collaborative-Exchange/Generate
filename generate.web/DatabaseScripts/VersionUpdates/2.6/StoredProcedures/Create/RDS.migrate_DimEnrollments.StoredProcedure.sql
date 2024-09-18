



CREATE PROCEDURE [RDS].[migrate_DimEnrollments]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN
	

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	declare @studentDiplomaTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select @studentDiplomaTypeId = RefHighSchoolDiplomaTypeId from ods.[RefHighSchoolDiplomaType] where Code = '00806'

	select 
		s.DimStudentId,
		sch.DimSchoolId,
		s.PersonId,
		s.DimCountDateId,

		case when psEnrollment.Code is null then 'MISSING'
			  when psEnrollment.Code ='NoInformation'  then 'NO'
			  when psEnrollment.Code ='Enrolled'  then 'ENROLL'
			  when psEnrollment.Code ='NotEnrolled'  then 'NOENROLL'
			 END as 'PostSecondaryEnrollmentStatusCode'
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId and r.RoleId = @k12StudentRoleId
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	left join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	left join ods.K12StudentAcademicRecord k12AcademicRecord on k12AcademicRecord.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
																and k12AcademicRecord.RefHighSchoolDiplomaTypeId=@studentDiplomaTypeId
																and k12AcademicRecord.DiplomaOrCredentialAwardDate between DateAdd(month,-16,s.SubmissionYearEndDate) and s.SubmissionYearEndDate
	left join ods.RefPsEnrollmentAction psEnrollment on psEnrollment.RefPsEnrollmentActionId=k12AcademicRecord.RefPsEnrollmentActionId
			
END

