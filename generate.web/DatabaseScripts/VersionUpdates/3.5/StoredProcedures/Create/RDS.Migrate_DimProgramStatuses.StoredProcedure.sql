CREATE PROCEDURE [RDS].[Migrate_DimProgramStatuses]
	@studentDates as StudentDateTableType READONLY,
	@useCutOffDate bit
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
--declare     @factTypeCode as varchar(50) = 'chronic'
--declare     @factTypeCode as varchar(50) = 'cte'
--declare     @factTypeCode as varchar(50) = 'grad'
--declare     @factTypeCode as varchar(50) = 'gradrate'
--declare     @factTypeCode as varchar(50) = 'homeless'
--declare     @factTypeCode as varchar(50) = 'membership'
--declare     @factTypeCode as varchar(50) = 'other'
--declare     @factTypeCode as varchar(50) = 'specedexit'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

----variable for UseCutOffDate, uncomment the appropriate one
----If you're working on     'childcount','membership','titleIIIELOct'
       --declare @useCutOffDate as bit = 1
----otherwise
       --declare @useCutOffDate as bit = 0

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

	declare @immigrantTitleIIIPersonStatusTypeId as int
	select @immigrantTitleIIIPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'TitleIIIImmigrant'

	declare @TitleIIIImmigrantParticipation as int
	select @TitleIIIImmigrantParticipation = RefParticipationTypeId from ods.RefParticipationType where code = 'TitleIIIImmigrantParticipation'

	declare @homelessServicedIndicator as int
	select @homelessServicedIndicator = RefParticipationTypeId from ods.RefParticipationType where code = 'HomelessServiced'


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

	CREATE TABLE #homeless
	(
		PersonId int,
		ParentOrganizationId int,
		EntryDate datetime,
		ExitDate datetime,
		HomelessServicedIndicator varchar(50)
	)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,@useCutOffDate)

				
	insert into #section504(PersonId,ParentOrganizationId,EntryDate,ExitDate,Section504Code)
	select  r504.PersonId, op.Parent_OrganizationId, r504.EntryDate, r504.ExitDate, ISNULL(pt.Code,'MISSING') as Section504Code
	from @studentDates s
	inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
			
	inner join ods.OrganizationRelationship op on op.Parent_OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
	inner join ods.OrganizationPersonRole r504 on r504.PersonId = s.PersonId and r504.RoleId = @k12StudentRoleId 
											and r504.OrganizationId = op.OrganizationId
											and ((@useCutOffDate = 0 and r504.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
											or (@useCutOffDate = 1 and s.SubmissionYearDate between r504.EntryDate and isnull(r504.ExitDate, getdate())))
	inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r504.OrganizationPersonRoleId
	inner join ods.OrganizationProgramType t2 on t2.OrganizationId = r504.OrganizationId and t2.RefProgramTypeId = @section504ProgramTypeId
	inner join ods.RefParticipationType pt on pt.RefParticipationTypeId = ppp.RefParticipationTypeId

	insert into #fosterCare(PersonId,ParentOrganizationId,EntryDate,ExitDate,FosterCareCode)
	select rfoster.PersonId, op.Parent_OrganizationId, rfoster.EntryDate, rfoster.ExitDate,
		case ISNULL(pt.Definition,'MISSING') when 'MISSING' then 'MISSING'	else 'FOSTERCARE' end as FosterCareCode
	from @studentDates s
	inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationRelationship op on  op.Parent_OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)

	inner join ods.OrganizationPersonRole rfoster on rfoster.PersonId = s.PersonId and rfoster.RoleId = @k12StudentRoleId 
											and rfoster.OrganizationId = op.OrganizationId
											and ((@useCutOffDate = 0 and rfoster.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
											or (@useCutOffDate = 1 and s.SubmissionYearDate between rfoster.EntryDate and isnull(rfoster.ExitDate, getdate())))
			
	inner join ods.PersonProgramParticipation ppp3 on ppp3.OrganizationPersonRoleId = rfoster.OrganizationPersonRoleId
	inner join ods.OrganizationProgramType t3 on t3.OrganizationId = rfoster.OrganizationId	and t3.RefProgramTypeId = @fosterCareProgramTypeId
	inner join ods.RefProgramType pt on t3.RefProgramTypeId = pt.RefProgramTypeId
		

	insert into #titleIII(PersonId,ParentOrganizationId,EntryDate,ExitDate,TitleIIIImmigrantParticipation)
	select r.PersonId, op.Parent_OrganizationId, rtitleiii.EntryDate, rtitleiii.ExitDate,
		CASE ISNULL(ptype.Code,'MISSING') when 'MISSING' then 'MISSING' ELSE 'PART' END  as TitleIIIImmigrantParticipation
		from @studentDates s
	inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	INNER JOIN [ODS].[OrganizationRelationship] op ON op.Parent_OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
			
	inner join ods.OrganizationPersonRole rtitleiii on op.OrganizationId = rtitleiii.OrganizationId
			and rtitleiii.OrganizationId = op.OrganizationId												  
			and ((@useCutOffDate = 0 and rtitleiii.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate)
			or (@useCutOffDate = 1 and s.SubmissionYearDate between rtitleiii.EntryDate and ISNULL(rtitleiii.ExitDate, GETDATE())))
	inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = rtitleiii.OrganizationPersonRoleId
	inner join ods.RefParticipationType ptype on ppp.RefParticipationTypeId = ptype.RefParticipationTypeId
			and ppp.RefParticipationTypeId = @TitleIIIImmigrantParticipation

	insert into #homeless(PersonId,ParentOrganizationId,EntryDate,ExitDate,HomelessServicedIndicator)
	select 
		s.PersonId
		, opp.Parent_OrganizationId AS ParentOrganizationId
		, rhomeless.EntryDate
		, rhomeless.ExitDate
		, CASE WHEN ISNULL(ptype.Code, 'NO') = 'NO' THEN 'NO' ELSE 'YES' END as HomelessServicedIndicator
	from @studentDates s
	inner join #studentOrganizations r	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	INNER JOIN [ODS].[OrganizationRelationship] opp ON opp.Parent_OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
	join  ods.OrganizationDetail od on od.OrganizationId = opp.OrganizationId
	inner join ods.OrganizationPersonRole rhomeless on rhomeless.PersonId = s.PersonId and rhomeless.RoleId = @k12StudentRoleId 
											and rhomeless.OrganizationId = opp.OrganizationId
											and s.SubmissionYearDate between rhomeless.EntryDate and isnull(rhomeless.ExitDate, getdate())

	inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = rhomeless.OrganizationPersonRoleId
	inner join ods.RefParticipationType ptype on ptype.RefParticipationTypeId = ppp.RefParticipationTypeId
													and ptype.RefParticipationTypeId = @homelessServicedIndicator


	select distinct
		s.DimStudentId,
		r.DimSchoolId,
		r.DimLeaId,
		s.PersonId,
		s.DimCountDateId,
		case
			when statusImmigrantTitleIII.StatusValue is null then 'MISSING'
			when statusImmigrantTitleIII.StatusValue = 1 
				and statusImmigrantTitleIII.StatusStartDate <= s.SubmissionYearEndDate 
				and ISNULL(statusImmigrantTitleIII.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate
					then 'IMMIGNTTTLIII'
			else 'MISSING'
		end as ImmigrantTitleIIICode,
		isnull(Section504Code, 'MISSING') as Section504Code,
		isnull(foodServiceEligibility.Code, 'MISSING') as FoodServiceEligibilityCode,
		isnull(FosterCareCode, 'MISSING') as FosterCareCode,
		ISNULL(TitleIIIImmigrantParticipation, 'MISSING') as TitleIIIImmigrantParticipation,
		ISNULL(homeless.HomelessServicedIndicator, 'NO') as HomelessServicedIndicatorCode
	from @studentDates s
	inner join #studentOrganizations r
	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationPersonRole opr on opr.PersonId = s.PersonId
		and opr.RoleId = @k12StudentRoleId and opr.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
		and ((@useCutOffDate = 0 and opr.EntryDate <= s.SubmissionYearEndDate and (isnull(opr.ExitDate, getdate()) >=  s.SubmissionYearStartDate or opr.ExitDate is null))
			or (@useCutOffDate = 1 and s.SubmissionYearDate between opr.EntryDate and isnull(opr.ExitDate, getdate())))
	left join ods.PersonStatus statusImmigrantTitleIII on s.PersonId = statusImmigrantTitleIII.PersonId
		and statusImmigrantTitleIII.RefPersonStatusTypeId = @immigrantTitleIIIPersonStatusTypeId
	left join ods.K12StudentEnrollment enrollment on enrollment.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
	left join ods.RefFoodServiceEligibility foodServiceEligibility on foodServiceEligibility.RefFoodServiceEligibilityId = enrollment.RefFoodServiceEligibilityId
	left join #section504 section504 on s.PersonId = section504.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = section504.ParentOrganizationId
	left join #fosterCare foster on s.PersonId = foster.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = foster.ParentOrganizationId
	left join #titleIII as ImmPart	on s.PersonId = ImmPart.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = ImmPart.ParentOrganizationId
	left join #homeless as homeless	on s.PersonId = homeless.PersonId and IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = homeless.ParentOrganizationId
	
	drop TABLE #studentOrganizations
	drop TABLE #section504
	drop TABLE #fosterCare
	drop TABLE #titleIII
	drop TABLE #homeless

END