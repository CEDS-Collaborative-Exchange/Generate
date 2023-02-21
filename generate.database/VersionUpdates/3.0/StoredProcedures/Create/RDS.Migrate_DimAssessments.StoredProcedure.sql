
CREATE PROCEDURE [RDS].[Migrate_DimAssessments]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

	declare @k12StudentRoleId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'

	select 
		s.DimStudentId,
		s.PersonId,
		sch.DimSchoolId,
		s.DimCountDateId,
		isnull(sub.Code, 'MISSING') as AssessmentSubjectCode,
		--isnull(cwd.Code, 'MISSING') as AssessmentTypeCode,
		case when  isnull(sub.Code, 'MISSING') =  '00256'  then 'ELPASS'
		else	isnull(cwd.Code, 'MISSING') 
		end as AssessmentTypeCode,

		isnull(grd.Code, 'MISSING') as GradeLevelCode,
		case
			
			when par.Code = 'DidNotParticipate' and isnull(rea.Code, 'MISSING') = 'Medical' then 'MEDEXEMPT'
			when par.Code = 'DidNotParticipate' and isnull(rea.Code, 'MISSING') = 'PARTELP' then 'PARTELP'
			when par.Code is null then 'MISSING' 
			when par.Code = 'DidNotParticipate' then 'NPART'
			when par.Code = 'Participated' and isnull(cwd.Code, 'MISSING') = 'REGASSWOACC' then 'REGPARTWOACC'
			when par.Code = 'Participated' and isnull(cwd.Code, 'MISSING') = 'REGASSWACC' then 'REGPARTWACC'
			when par.Code = 'Participated' and isnull(cwd.Code, 'MISSING') = 'ALTASSGRADELVL' then 'ALTPARTGRADELVL'
			when par.Code = 'Participated' and isnull(cwd.Code, 'MISSING') = 'ALTASSMODACH' then 'ALTPARTMODACH'
			when par.Code = 'Participated' and isnull(cwd.Code, 'MISSING') = 'ALTASSALTACH' then 'ALTPARTALTACH'
			else 'MISSING'
		end as ParticipationStatusCode,
		isnull(lev.Identifier, 'MISSING'),
		case
			when reg.StateFullAcademicYear = 1 then 'FULLYR'
			when reg.StateFullAcademicYear = 0 then 'NFULLYR'
			else 'MISSING'
		end as SeaFullYearStatusCode,
		case
			when reg.LeaFullAcademicYear = 1 then 'FULLYR'
			when reg.LeaFullAcademicYear = 0 then 'NFULLYR'
			else 'MISSING'
		end as LeaFullYearStatusCode,
		case
			when reg.SchoolFullAcademicYear = 1 then 'FULLYR'
			when reg.SchoolFullAcademicYear = 0 then 'NFULLYR'
			else 'MISSING'
		end as SchFullYearStatusCode,
		1 as AssessmentCount
	from @studentDates s 
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join ods.AssessmentRegistration reg on s.PersonId = reg.PersonId and r.OrganizationId = reg.SchoolOrganizationId
	inner join rds.DimSchools sch on r.OrganizationId = sch.SchoolOrganizationId
	inner join ods.RefGradeLevel grd on reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
	inner join ods.AssessmentAdministration adm on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId
		and adm.StartDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join ods.Assessment ass on adm.AssessmentId = ass.AssessmentId
	inner join ods.RefAcademicSubject sub on ass.RefAcademicSubjectId = sub.RefAcademicSubjectId
	left outer join ods.RefAssessmentParticipationIndicator par on reg.RefAssessmentParticipationIndicatorId = par.RefAssessmentParticipationIndicatorId
	left outer join ods.RefAssessmentTypeChildrenWithDisabilities cwd on ass.RefAssessmentTypeChildrenWithDisabilitiesId = cwd.RefAssessmentTypeChildrenWithDisabilitiesId
	left outer join ods.AssessmentResult res on reg.AssessmentRegistrationId = res.AssessmentRegistrationId
	left outer join ods.AssessmentResult_PerformanceLevel per on res.AssessmentResultId = per.AssessmentResultId
	left outer join ods.AssessmentPerformanceLevel lev on per.AssessmentPerformanceLevelId = lev.AssessmentPerformanceLevelId
	left outer join ods.RefAssessmentReasonNotCompleting rea on reg.RefAssessmentReasonNotCompletingId = rea.RefAssessmentReasonNotCompletingId
	where r.EntryDate <= s.SubmissionYearDate and (r.ExitDate >= s.SubmissionYearDate or r.ExitDate is null)
		and adm.StartDate >= r.EntryDate and (adm.FinishDate <= r.ExitDate or r.ExitDate is null)
		and s.DimStudentId <> -1
END