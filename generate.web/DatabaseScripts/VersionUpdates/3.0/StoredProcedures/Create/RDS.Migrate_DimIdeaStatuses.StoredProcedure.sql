CREATE PROCEDURE [RDS].[Migrate_DimIdeaStatuses]
	@studentDates as StudentDateTableType READONLY,
	@factTypeCode as varchar(50)

AS
BEGIN

	declare @k12StudentRoleId as int, @schoolOrganizationTypeId as int, @specialEdProgramTypeId as int

	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select @specialEdProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '04888'

	declare @ctePerkDisab as varchar(50)
			
	select @ctePerkDisab = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CTEPERKDISAB'

	declare @useChildCountDate as bit, @isADADisability as bit
	set @useChildCountDate = 0
	set @isADADisability = 0

	IF @factTypeCode = 'childcount'
	BEGIN
		set @useChildCountDate = 1
	END
	else IF @factTypeCode = 'cte' AND @ctePerkDisab = 'ADA Disability'
	BEGIN
		set @isADADisability = 1
	END

	select distinct
		s.DimStudentId,
		r.DimSchoolId,
		s.PersonId,
		s.DimCountDateId,
		case when @isADADisability = 1 then IIF(pd.DisabilityStatus = 1, isnull(dt.Code, 'MISSING'),'MISSING')
			 else isnull(dt.Code, 'MISSING') end as DisabilityCode, 
		isnull(e.Code, isnull(sa.Code, 'MISSING')) as EducEnvCode,
		isnull(exitReason.Code, 'MISSING') as BasisOfExitCode,
		case when @factTypeCode = 'specedexit' then p.SpecialEducationServicesExitDate else NULL end as SpecialEducationServicesExitDate
	from @studentDates s
	inner join (
			select 
				  r.PersonId
				, sch.DimSchoolId
				, r.OrganizationId
				, sd.DimCountDateId
			from @studentDates sd
			inner join ods.OrganizationPersonRole r on r.PersonId = sd.PersonId
				and r.RoleId = @k12StudentRoleId
				and r.EntryDate <=
						case
							when @useChildCountDate = 0 then sd.SubmissionYearEndDate
							else sd.SubmissionYearDate
						end 
					and (
						r.ExitDate >=
							case
								when @useChildCountDate = 0 then sd.SubmissionYearStartDate
								else sd.SubmissionYearDate
							end 
					or r.ExitDate is null)
			inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
				and o.RefOrganizationTypeId = @schoolOrganizationTypeId
			inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
		) as r
		on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationRelationship ore on r.OrganizationId = ore.Parent_OrganizationId
	inner join ods.OrganizationPersonRole rp on rp.PersonId = s.PersonId
		and rp.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
		and ore.OrganizationId = rp.OrganizationId
	inner join 	ods.OrganizationProgramType t on t.OrganizationId = rp.OrganizationId and t.RefProgramTypeId = @specialEdProgramTypeId
	left outer join ods.PersonDisability pd on pd.PersonId = S.PersonId
		and	ISNULL(pd.RecordStartDateTime, S.SubmissionYearDate) <= 
			case
				when @useChildCountDate = 0 then S.SubmissionYearEndDate
				else S.SubmissionYearDate
			end 
		and 
			ISNULL(pd.RecordEndDateTime, GETDATE()) >=
			case
				when @useChildCountDate = 0 then S.SubmissionYearStartDate
				else S.SubmissionYearDate
			end
	left join ods.RefDisabilityType dt on dt.RefDisabilityTypeId = pd.PrimaryDisabilityTypeId
	left join ods.PersonProgramParticipation ppp on rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId 
	left join ods.ProgramParticipationSpecialEducation p on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	left join ods.RefIDEAEducationalEnvironmentEC e on e.RefIDEAEducationalEnvironmentECId = p.RefIDEAEducationalEnvironmentECId
	left join ods.RefIDEAEducationalEnvironmentSchoolAge sa on sa.RefIDESEducationalEnvironmentSchoolAge = p.RefIDEAEdEnvironmentSchoolAgeId
	left join ods.RefSpecialEducationExitReason exitReason on p.RefSpecialEducationExitReasonId = exitReason.RefSpecialEducationExitReasonId

END


