CREATE PROCEDURE [RDS].[Migrate_DimCteStatuses]
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
--declare     @factTypeCode as varchar(50) = 'cte'
--declare     @factTypeCode as varchar(50) = 'grad'
--declare     @factTypeCode as varchar(50) = 'gradrate'
--declare     @factTypeCode as varchar(50) = 'membership'
--declare     @factTypeCode as varchar(50) = 'other'
--declare     @factTypeCode as varchar(50) = 'specedexit'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

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

	declare @k12StudentRoleId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'

	declare @cteProgramTypeId as int
	select @cteProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '04906'

	declare @lepPerkinsPersonStatusTypeId as int
	select @lepPerkinsPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'Perkins LEP'

	CREATE TABLE #studentOrganizations (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	CREATE TABLE #cte (
		PersonId int,
		OrganizationId int,
		Parent_OrganizationId int,
		EntryDate date,
		ExitDate date,
		CteProgram varchar(50),
		SingleParentOrSinglePregnantWoman varchar(50),
		DisplacedHomemaker varchar(50),
		CteNonTraditionalCompletion varchar(50),
		RepresentationStatus varchar(50),
		InclusionType varchar(50),
		LepPerkinsStatusCode varchar(50)
	)

	create nonclustered index IX_CTE_Person_Organization on #cte(PersonId, Parent_OrganizationId)


	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates, 0)

	insert into #cte(PersonId, OrganizationId, Parent_OrganizationId, EntryDate, ExitDate, CteProgram, SingleParentOrSinglePregnantWoman, DisplacedHomemaker,
					CteNonTraditionalCompletion, RepresentationStatus, InclusionType, LepPerkinsStatusCode)
	SELECT  opr.PersonId, opr.OrganizationId, opr.OrganizationId, opr.EntryDate, opr.ExitDate,
			case	when p.CteConcentrator = 1 then 'CTECONC'
					when p.CteParticipant = 1 then 'CTEPART'						
					when p.CteParticipant = 0 then 'NONCTEPART'
					else 'MISSING' 
			end,
			case	when p.SingleParentOrSinglePregnantWoman is null then 'MISSING'
					when p.SingleParentOrSinglePregnantWoman = 1 then 'SPPT'						
				    else 'MISSING' 
			end,
			case	when p.DisplacedHomemakerIndicator is null then 'MISSING'
					when p.DisplacedHomemakerIndicator = 1 then 'DH'						
				    else 'MISSING'  
			end,
			case	when p.CteNonTraditionalCompletion is null then 'MISSING'
					when p.CteNonTraditionalCompletion = 1 then 'NTE'						
				    else 'MISSING'  
			end,
			case when refnonTrdGender.code ='Underrepresented' THEN 'MEM'
				 WHEN refnonTrdGender.code ='NotUnderrepresented' THEN 'NM'
				 else 'MISSING' 
			end,
			case when p.CteCompleter =1 THEN 'GRAD'
				 WHEN p.CteCompleter =0 THEN 'NOTG'
				 else 'MISSING' 
			end,
			case when statusLepp.StatusValue = 1 then 'LEPP' else 'MISSING' end as LepPerkinsStatusCode
			FROM ods.OrganizationPersonRole opr 	
			inner join ods.OrganizationRelationship op 
				on opr.OrganizationId = op.Parent_OrganizationId 
				and opr.RoleId = @k12StudentRoleId
			inner join ods.OrganizationPersonRole opr2 
				on opr2.OrganizationId = op.OrganizationId 
				and opr2.PersonId = opr.PersonId
			inner join ods.PersonProgramParticipation ppp 
				on opr2.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			inner join ods.ProgramParticipationCte p 
				on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
			inner join ods.OrganizationProgramType t 
				on t.OrganizationId = opr2.OrganizationId 
				and t.RefProgramTypeId = @cteProgramTypeId
			left join ods.RefNonTraditionalGenderStatus refnonTrdGender 
				on p.RefNonTraditionalGenderStatusId = refnonTrdGender.RefNonTraditionalGenderStatusId
			left outer join ods.PersonStatus statusLepp 
				on opr.PersonId = statusLepp.PersonId	
				and statusLepp.RefPersonStatusTypeId = @lepPerkinsPersonStatusTypeId


	select distinct
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,
		s.DimCountDateId,
		isnull(cte.CteProgram, 'MISSING') as CteProgram,
		isnull(cte.DisplacedHomemaker,'MISSING') as CteAeDisplacedHomemakerIndicator,
		isnull(cte.SingleParentOrSinglePregnantWoman,'MISSING') as SingleParentOrSinglePregnantWoman,
		ISNULL(cte.CteNonTraditionalCompletion,'MISSING') as CteNontraditionalGenderStatus,
		isnull(cte.RepresentationStatus,'MISSING') as RepresentationStatus,
		ISNULL(cte.InclusionType,'MISSING') as CteGraduationRateInclusion,
		ISNULL(cte.LepPerkinsStatusCode,'MISSING') as LepPerkinsStatusCode
	from @studentDates s
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate <= s.SubmissionYearEndDate and (r.ExitDate >=  s.SubmissionYearStartDate or r.ExitDate is null)
	inner join #studentOrganizations org
		on s.PersonId = org.PersonId 
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	left join #cte cte 
		on s.PersonId = cte.PersonId 
		and IIF(org.OrganizationId > 0, org.OrganizationId, org.LeaOrganizationId) = cte.Parent_OrganizationId
	
	drop TABLE #cte
	drop TABLE #studentOrganizations
			
			
END