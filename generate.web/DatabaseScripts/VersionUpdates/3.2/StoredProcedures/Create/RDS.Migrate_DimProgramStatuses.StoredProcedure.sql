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

			CREATE TABLE #studentOrganizations
			(
				DimStudentId int,
				PersonId int,
				DimCountDateId int,
				DimSchoolId int,
				DimLeaId int,
				OrganizationId int,
				LeaOrganizationId int
			)


			CREATE TABLE #cteData
			(
				PersonId int,
				ParentOrganizationId int,
				EntryDate datetime,
				ExitDate datetime,
				CteCode varchar(50)
			)

			CREATE TABLE #section504
			(
				PersonId int,
				ParentOrganizationId int,
				EntryDate datetime,
				ExitDate datetime,
				Section504Code varchar(50)
			)

			CREATE TABLE #fosterCare
			(
				PersonId int,
				ParentOrganizationId int,
				EntryDate datetime,
				ExitDate datetime,
				FosterCareCode varchar(50)
			)

			CREATE TABLE #titleIII
			(
				PersonId int,
				ParentOrganizationId int,
				EntryDate datetime,
				ExitDate datetime,
				TitleIIIImmigrantParticipation varchar(50)
			)

			insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
			select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,@useCutOffDate)

			insert into #cteData(PersonId,ParentOrganizationId,EntryDate,ExitDate,CteCode)
			select rcte.PersonId, op.Parent_OrganizationId, rcte.EntryDate, rcte.ExitDate, 
					  case
							when p.CteConcentrator = 1 then 'CTECONC'
							when p.CteParticipant = 1 then 'CTEPART'						
							when p.CteParticipant = 0 then 'NONCTEPART'
					  else 'MISSING' 
					  end as CteCode
			FROM @studentDates s
			inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
			inner join ods.OrganizationPersonRole rcte on rcte.PersonId = s.PersonId and rcte.RoleId = @k12StudentRoleId 
													   and rcte.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
													   and ((@useCutOffDate = 0 and rcte.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
														or (@useCutOffDate = 1 and s.SubmissionYearDate between rcte.EntryDate and rcte.ExitDate))
			inner join ods.OrganizationRelationship op on rcte.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on rcte.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			inner join ods.ProgramParticipationCte p on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
			inner join ods.OrganizationProgramType t on t.OrganizationId = rcte.OrganizationId and t.RefProgramTypeId = @cteProgramTypeId


	
			insert into #section504(PersonId,ParentOrganizationId,EntryDate,ExitDate,Section504Code)
			select  r504.PersonId, op.Parent_OrganizationId, r504.EntryDate, r504.ExitDate, ISNULL(pt.Code,'MISSING') as Section504Code
			from @studentDates s
			inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
			inner join ods.OrganizationPersonRole r504 on r504.PersonId = s.PersonId and r504.RoleId = @k12StudentRoleId 
												  and r504.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
												  and ((@useCutOffDate = 0 and r504.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
													or (@useCutOffDate = 1 and s.SubmissionYearDate between r504.EntryDate and r504.ExitDate))
			inner join ods.OrganizationRelationship op on r504.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r504.OrganizationPersonRoleId
			inner join ods.OrganizationProgramType t2 on t2.OrganizationId = r504.OrganizationId and t2.RefProgramTypeId = @section504ProgramTypeId
			inner join ods.RefParticipationType pt on pt.RefParticipationTypeId = ppp.RefParticipationTypeId

			insert into #fosterCare(PersonId,ParentOrganizationId,EntryDate,ExitDate,FosterCareCode)
			select rfoster.PersonId, op.Parent_OrganizationId, rfoster.EntryDate, rfoster.ExitDate,
			 case ISNULL(pt.Definition,'MISSING') when 'MISSING' then 'MISSING'	else 'FOSTERCARE' end as FosterCareCode
			from @studentDates s
			inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
			inner join ods.OrganizationPersonRole rfoster on rfoster.PersonId = s.PersonId and rfoster.RoleId = @k12StudentRoleId 
												  and rfoster.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
												  and ((@useCutOffDate = 0 and rfoster.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
													or (@useCutOffDate = 1 and s.SubmissionYearDate between rfoster.EntryDate and rfoster.ExitDate))
			inner join ods.OrganizationRelationship op on rfoster.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp3 on ppp3.OrganizationPersonRoleId = rfoster.OrganizationPersonRoleId
			inner join ods.OrganizationProgramType t3 on t3.OrganizationId = rfoster.OrganizationId	and t3.RefProgramTypeId = @fosterCareProgramTypeId
			inner join ods.RefProgramType pt on t3.RefProgramTypeId = pt.RefProgramTypeId
		

			insert into #titleIII(PersonId,ParentOrganizationId,EntryDate,ExitDate,TitleIIIImmigrantParticipation)
			select rimm.PersonId, op.Parent_OrganizationId, rimm.EntryDate, rimm.ExitDate,
			 CASE ISNULL(ptype.Code,'MISSING') when 'MISSING' then 'MISSING' ELSE 'PART' END  as TitleIIIImmigrantParticipation
			 from @studentDates s
			inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
			inner join ods.OrganizationPersonRole rimm on rimm.PersonId = s.PersonId and rimm.RoleId = @k12StudentRoleId 
												  and rimm.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
												  and s.SubmissionYearDate between rimm.EntryDate and rimm.ExitDate
			inner join ods.OrganizationRelationship op on rimm.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = rimm.OrganizationPersonRoleId
			inner join ods.RefParticipationType ptype on ptype.RefParticipationTypeId = ppp.RefParticipationTypeId
														   and ptype.RefParticipationTypeId = @TitleIIIImmigrantParticipation


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
	inner join #studentOrganizations r
	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationPersonRole opr on opr.PersonId = s.PersonId
		and opr.RoleId = @k12StudentRoleId and opr.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
		and ((@useCutOffDate = 0 and opr.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
			or (@useCutOffDate = 1 and s.SubmissionYearDate between opr.EntryDate and opr.ExitDate))
	left join ods.PersonStatus statusImmigrantTitleIII on s.PersonId = statusImmigrantTitleIII.PersonId
		and statusImmigrantTitleIII.RefPersonStatusTypeId = @immigrantTitleIIIPersonStatusTypeId
	left join ods.K12StudentEnrollment enrollment on enrollment.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
	left join ods.RefFoodServiceEligibility foodServiceEligibility on foodServiceEligibility.RefFoodServiceEligibilityId = enrollment.RefFoodServiceEligibilityId
	left join #cteData cte	on s.PersonId = cte.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = cte.ParentOrganizationId
	left join #section504 section504 on s.PersonId = section504.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = section504.ParentOrganizationId
	left join #fosterCare foster on s.PersonId = foster.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = foster.ParentOrganizationId
	left join #titleIII as ImmPart	on s.PersonId = ImmPart.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = ImmPart.ParentOrganizationId
	
	drop TABLE #studentOrganizations
	drop TABLE #cteData
	drop TABLE #section504
	drop TABLE #fosterCare
	drop TABLE #titleIII

END