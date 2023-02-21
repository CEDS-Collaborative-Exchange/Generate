CREATE PROCEDURE [RDS].[migrate_DimEnrollments]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN
	

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	declare @studentDiplomaTypeId as int, @gedDiplomaTypeId as int
	declare @gedParticipationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select @studentDiplomaTypeId = RefHighSchoolDiplomaTypeId from ods.[RefHighSchoolDiplomaType] where Code = '00806'
	select @gedDiplomaTypeId = RefHighSchoolDiplomaTypeId from ods.[RefHighSchoolDiplomaType] where Code = '00816'
	select @gedParticipationTypeId = RefParticipationTypeId  from ods.RefParticipationType where Code = 'GEDPreparationProgramParticipation'

	select 
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,
		s.DimCountDateId,

		case when psEnrollment.Code is null then 'MISSING'
			  when psEnrollment.Code ='NoInformation'  then 'NO'
			  when psEnrollment.Code ='Enrolled'  then 'ENROLL'
			  when psEnrollment.Code ='NotEnrolled'  then 'NOENROLL'
			 END as 'PostSecondaryEnrollmentStatusCode',
		case when l.Code is not null then 'EARNCRE'
			 when ged.Code is not null then 'ENROLLGED'
			 when gedType.Code is not null then 'EARNGED'
			 when diplomaType.Code is not null then 'EARNDIPL'
			 when psEnrollment.Code ='Enrolled' then 'POSTSEC'
			 when wf.RefEmployedAfterExitId is not null then 'OBTAINEMP'
			 ELSE 'MISSING'
		END as 'AcademicOrVocationalOutcome'
	from @studentDates s
	inner join (select * from RDS.Get_StudentOrganizations(@studentDates,0)) org
				on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId and r.RoleId = @k12StudentRoleId
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
	left join ods.K12StudentAcademicRecord k12AcademicRecord on k12AcademicRecord.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
																and k12AcademicRecord.RefHighSchoolDiplomaTypeId=@studentDiplomaTypeId
																and k12AcademicRecord.DiplomaOrCredentialAwardDate between DateAdd(month,-16,s.SubmissionYearEndDate) and s.SubmissionYearEndDate
	left join ods.RefPsEnrollmentAction psEnrollment on psEnrollment.RefPsEnrollmentActionId=k12AcademicRecord.RefPsEnrollmentActionId
	left join ODS.Course c on o.OrganizationId = c.OrganizationId
	left join ods.RefCourseApplicableEducationLevel l on c.RefCourseApplicableEducationLevelId = l.RefCourseApplicableEducationLevelId
	left join ods.PersonProgramParticipation pp on r.OrganizationPersonRoleId = pp.OrganizationPersonRoleId and pp.RecordStartDateTime between s.SubmissionYearEndDate and s.SubmissionYearEndDate
	left join ods.RefParticipationType ged on pp.RefParticipationTypeId = @gedParticipationTypeId	
	left join ods.K12StudentAcademicRecord k12GedAcademicRecord on k12GedAcademicRecord.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
																and k12GedAcademicRecord.RefHighSchoolDiplomaTypeId=@gedDiplomaTypeId
																and k12GedAcademicRecord.DiplomaOrCredentialAwardDate between DateAdd(month,-16,s.SubmissionYearEndDate) and s.SubmissionYearEndDate
	left join ods.RefHighSchoolDiplomaType gedType on gedType.RefHighSchoolDiplomaTypeId = k12GedAcademicRecord.RefHighSchoolDiplomaTypeId
	left join ods.RefHighSchoolDiplomaType diplomaType on diplomaType.RefHighSchoolDiplomaTypeId = k12AcademicRecord.RefHighSchoolDiplomaTypeId
	left join ods.WorkforceEmploymentQuarterlyData wf on wf.OrganizationPersonRoleId = r.OrganizationPersonRoleId
END

