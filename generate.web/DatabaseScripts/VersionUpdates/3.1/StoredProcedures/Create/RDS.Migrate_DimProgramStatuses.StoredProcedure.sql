CREATE PROCEDURE [RDS].[Migrate_DimProgramStatuses]
	@studentDates as StudentDateTableType READONLY,
	@useCutOffDate bit
AS
BEGIN


	declare @immigrantTitleIIIPersonStatusTypeId as int
	select @immigrantTitleIIIPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'TitleIIIImmigrant'

	declare @TitleIIIImmigrantParticipation as int
	select @TitleIIIImmigrantParticipation = RefParticipationTypeId from ods.RefParticipationType where code = 'TitleIIIImmigrantParticipation'

	declare @cteProgramTypeId as int
	select @cteProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '04906'

	declare @section504ProgramTypeId as int
	select @section504ProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '04967'

	declare @fosterCareProgramTypeId as int
	select @fosterCareProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '75000'

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

	select distinct
		s.DimStudentId,
		r.DimSchoolId,
		r.DimLeaId,
		s.PersonId,
		s.DimCountDateId,
		isnull(CteCode, 'MISSING') as CteCode,
		case
			when statusImmigrantTitleIII.StatusValue is null then 'MISSING'
			when statusImmigrantTitleIII.StatusStartDate <= s.SubmissionYearEndDate 
			and ISNULL(statusImmigrantTitleIII.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate
				then
					case 
						when statusImmigrantTitleIII.StatusValue = 1 then 'IMMIGNTTTLIII'
						else 'MISSING'
					end
			else 'MISSING'
		end as ImmigrantTitleIIICode,

		isnull(Section504Code, 'MISSING') as Section504Code,
		isnull(foodServiceEligibility.Code, 'MISSING') as FoodServiceEligibilityCode,
		isnull(FosterCareCode, 'MISSING') as FosterCareCode,
		ISNULL(TitleIIIImmigrantParticipation, 'MISSING') as TitleIIIImmigrantParticipation
	from @studentDates s
	inner join (select * from RDS.Get_StudentOrganizations(@studentDates,@useCutOffDate)) r
	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationPersonRole opr on opr.PersonId = s.PersonId
		and opr.RoleId = @k12StudentRoleId and opr.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
		and ((@useCutOffDate = 0 and opr.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
			or (@useCutOffDate = 1 and s.SubmissionYearDate between opr.EntryDate and opr.ExitDate))
	left join ods.PersonStatus statusImmigrantTitleIII on s.PersonId = statusImmigrantTitleIII.PersonId
		and statusImmigrantTitleIII.RefPersonStatusTypeId = @immigrantTitleIIIPersonStatusTypeId
	left join ods.K12StudentEnrollment enrollment on enrollment.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
	left join ods.RefFoodServiceEligibility foodServiceEligibility on foodServiceEligibility.RefFoodServiceEligibilityId = enrollment.RefFoodServiceEligibilityId
	
	-- CTE subselect 
	left join (
			select 
				  rcte.PersonId
				, op.Parent_OrganizationId
				, rcte.EntryDate
				, rcte.ExitDate
				, case
						when p.CteConcentrator = 1 then 'CTECONC'
						when p.CteParticipant = 1 then 'CTEPART'						
						when p.CteParticipant = 0 then 'NONCTEPART'
				  else 'MISSING' 
				  end as CteCode
			FROM ods.OrganizationPersonRole rcte 
			join ods.OrganizationRelationship op on rcte.OrganizationId = op.OrganizationId
			join ods.PersonProgramParticipation ppp on rcte.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			join ods.ProgramParticipationCte p on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
			join ods.OrganizationProgramType t on t.OrganizationId = rcte.OrganizationId
				and t.RefProgramTypeId = @cteProgramTypeId
			where rcte.RoleId = @k12StudentRoleId
		) cte
		on s.PersonId = cte.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId)  = cte.Parent_OrganizationId
			and ((@useCutOffDate = 0 and cte.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
				or (@useCutOffDate = 1 and s.SubmissionYearDate between cte.EntryDate and cte.ExitDate))


	-- 504 subselect

	left join (
			select 
				  r504.PersonId
				, op.Parent_OrganizationId
				, r504.EntryDate
				, r504.ExitDate
				, ISNULL(pt.Code,'MISSING') as Section504Code
			from ods.OrganizationPersonRole r504
			join ods.OrganizationRelationship op on r504.OrganizationId = op.OrganizationId
			join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r504.OrganizationPersonRoleId
			join ods.OrganizationProgramType t2 on t2.OrganizationId = r504.OrganizationId and t2.RefProgramTypeId = @section504ProgramTypeId
			join ods.RefParticipationType pt on pt.RefParticipationTypeId = ppp.RefParticipationTypeId) as s504
		on s.PersonId = s504.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = s504.Parent_OrganizationId
			and ((@useCutOffDate = 0 and s504.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
				or (@useCutOffDate = 1 and s.SubmissionYearDate between s504.EntryDate and s504.ExitDate))

	-- foster care subselect
	left join (
			select 
				  rfoster.PersonId
				, op.Parent_OrganizationId
				, rfoster.EntryDate
				, rfoster.ExitDate
				, case ISNULL(pt.Definition,'MISSING')
					when 'MISSING' then 'MISSING'
					else 'FOSTERCARE'
				  end as FosterCareCode
			from ods.OrganizationPersonRole rfoster
			join ods.OrganizationRelationship op on rfoster.OrganizationId = op.OrganizationId
			join ods.PersonProgramParticipation ppp3 on ppp3.OrganizationPersonRoleId = rfoster.OrganizationPersonRoleId
			join ods.OrganizationProgramType t3 on t3.OrganizationId = rfoster.OrganizationId
				and t3.RefProgramTypeId = @fosterCareProgramTypeId
			join ods.RefProgramType pt on t3.RefProgramTypeId = pt.RefProgramTypeId) as foster
		on s.PersonId = foster.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = foster.Parent_OrganizationId
			and ((@useCutOffDate = 0 and foster.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
				or (@useCutOffDate = 1 and s.SubmissionYearDate between foster.EntryDate and foster.ExitDate))

left join (
			select 
				  imgParti.PersonId
				, op.Parent_OrganizationId
				, imgParti.EntryDate
				, imgParti.ExitDate
				, CASE ISNULL(ptype.Code,'MISSING')
					when 'MISSING' then 'MISSING'
					ELSE 'PART'
					END  as TitleIIIImmigrantParticipation
			from ods.OrganizationPersonRole imgParti
			inner join ods.OrganizationRelationship op on imgParti.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = imgParti.OrganizationPersonRoleId
			inner join ods.RefParticipationType ptype on ptype.RefParticipationTypeId = ppp.RefParticipationTypeId
													   and ptype.RefParticipationTypeId = @TitleIIIImmigrantParticipation
													   ) as ImmPart
		on s.PersonId = ImmPart.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = ImmPart.Parent_OrganizationId
			and ( s.SubmissionYearDate between ImmPart.EntryDate and ImmPart.ExitDate	)




END