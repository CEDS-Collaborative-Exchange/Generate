CREATE PROCEDURE [RDS].[migrate_DimStudentStatuses]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN
	

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	declare @refParticipationTypeId as int
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'MEPParticipation'
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

	CREATE TABLE #cte
	(
		PersonId int,
		OrganizationId int,
		Parent_OrganizationId int,
		EntryDate date,
		ExitDate date,
		SingleParentOrSinglePregnantWoman varchar(50),
		DisplacedHomemaker varchar(50),
		CteNonTraditionalCompletion varchar(50),
		PlacementType varchar(50),
		PlacementStatus varchar(50),
		RepresentationStatus varchar(50),
		DiplomaOrCredentialAwardDate varchar(10),
		RefProfessionalTechnicalCredentialTypeId INT,
		InclusionType varchar(50)
	)

	CREATE NONCLUSTERED INDEX IX_CTE_Person_Organization ON #cte(PersonId, Parent_OrganizationId)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates, 0)

	insert into #cte(PersonId, OrganizationId, Parent_OrganizationId, EntryDate, ExitDate, SingleParentOrSinglePregnantWoman, DisplacedHomemaker,
					CteNonTraditionalCompletion, PlacementType,	PlacementStatus, RepresentationStatus, DiplomaOrCredentialAwardDate, RefProfessionalTechnicalCredentialTypeId,	InclusionType)
	SELECT  opr.PersonId, opr.OrganizationId, op.Parent_OrganizationId, opr.EntryDate, opr.ExitDate,
			case	when p.SingleParentOrSinglePregnantWoman is null then 'MISSING'
					when p.SingleParentOrSinglePregnantWoman = 1 then 'SPPT'						
				    else 'MISSING' 
			end as 'SingleParentOrSinglePregnantWoman',
			case	when p.DisplacedHomemakerIndicator is null then 'MISSING'
					when p.DisplacedHomemakerIndicator = 1 then 'DH'						
				    else 'MISSING'  end as 'DisplacedHomemaker',
			case	when p.CteNonTraditionalCompletion is null then 'MISSING'
					when p.CteNonTraditionalCompletion = 1 then 'NTE'						
				    else 'MISSING'  end as 'CteNonTraditionalCompletion',
			case	when psEnrll.EntryDateIntoPostSecondary is not null THEN 'ADVTRAIN'
					when refemp.code ='Yes' then 'EMPLOYMENT'
					when emp.MilitaryEnlistmentAfterExit = 1 then 'MILITARY'
					When wpp.RefWfProgramParticipationId is not null then 'POSTSEC'
					ELSE 'MISSING' 
			end as 'PlacementType',
			case when (psEnrll.EntryDateIntoPostSecondary is not null or refemp.code ='Yes'  or emp.MilitaryEnlistmentAfterExit = 1  or wpp.RefWfProgramParticipationId is not null) 
			THEN 'PLACED' ELSE 'NOTPLACED' end as 'PlacementStatus',
			case when refnonTrdGender.code ='Underrepresented' THEN 'MEM'
				 WHEN refnonTrdGender.code ='NotUnderrepresented' THEN 'NM'
				 else 'MISSING' END as 'RepresentationStatus',
			cteDiploma.DiplomaOrCredentialAwardDate,
			cteDiploma.RefProfessionalTechnicalCredentialTypeId,
			case when p.CteCompleter =1 THEN 'GRAD'
				 WHEN p.CteCompleter =0 THEN 'NOTG'
				 else 'MISSING' END as 'INCLUTYP'
			FROM ods.OrganizationPersonRole opr   
			inner join ods.OrganizationRelationship op on opr.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on opr.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			inner join ods.ProgramParticipationCte p on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
			left join ods.RefNonTraditionalGenderStatus refnonTrdGender on p.RefNonTraditionalGenderStatusId = refnonTrdGender.RefNonTraditionalGenderStatusId
			left join ods.WorkforceEmploymentQuarterlyData emp on opr.OrganizationPersonRoleId = emp.OrganizationPersonRoleId -- Military & Employment
			left join ods.RefEmployedAfterExit refEmp on refEmp.RefEmployedAfterExitId = emp.RefEmployedAfterExitId
			left join ods.WorkforceProgramParticipation wpp on ppp.PersonProgramParticipationId= wpp.PersonProgramParticipationId  	--Advanced Training
			left join ods.RefWfProgramParticipation refpp on refpp.RefWfProgramParticipationId = wpp.RefWfProgramParticipationId
			left join [ODS].[PsStudentEnrollment]	psEnrll on opr.OrganizationPersonRoleId = psEnrll.[OrganizationPersonRoleId]  ---Postsecondary Education
			left join [ODS].[CteStudentAcademicRecord]	cteDiploma on opr.OrganizationPersonRoleId = cteDiploma.[OrganizationPersonRoleId]

	select distinct
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,
		s.DimCountDateId
		, case 
			when(ppm.MigrantStudentQualifyingArrivalDate between CAST('9/1/' + CAST(YEAR(ocs.BeginDate) AS VARCHAR(4)) AS DATE) and CAST('8/31/' + CAST(YEAR(ocs.BeginDate) + 1  AS VARCHAR(4)) AS DATE)) then 'QAD'
			else 'MISSING' 
		  end as 'MobilityStatus12moCode'
		  , case 
			when(ppm.MigrantStudentQualifyingArrivalDate > CAST('9/1/' + CAST((YEAR(s.SubmissionYearStartDate) - 3)  AS VARCHAR(4)) AS DATE)) then 'QAD36'			
			else 'MISSING' 
		  end as 'MobilityStatus36moCode'				
		, case 
			when(ppm.MigrantStudentQualifyingArrivalDate between  ocs.BeginDate and ocs.EndDate) then 'QMRSY'			
			else 'MISSING' 
		  end as 'MobilityStatusSYCode'
		, isnull(rmsv.Code,'MISSING')
		, case
			when sa.DiplomaOrCredentialAwardDate between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00806') then 'REGDIP'
			when sa.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00811') then 'OTHCOM'
			when sa.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00816') then 'HSDGED'
			when sa.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00806')
			AND cte.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND 
			cte.RefProfessionalTechnicalCredentialTypeId IS NOT NULL then 'HSDPROF'
			else 'MISSING'
		  end as 'DiplomaCredentialCode',
		isnull(cte.DisplacedHomemaker,'MISSING') as DisplacedHomemaker,
		isnull(cte.SingleParentOrSinglePregnantWoman,'MISSING') as SingleParent,
		ISNULL(cte.CteNonTraditionalCompletion,'MISSING') as CteNonTraditionalEnrollee,
		 ISNULL(cte.PlacementType,'MISSING') as PlacementType,
		ISNULL(cte.PlacementStatus, 'MISSING') as PlacementStatus,
		isnull(cte.RepresentationStatus,'MISSING') as RepresentationStatus,
		ISNULL(cte.InclusionType,'MISSING') as INCLUTYPCode
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join #studentOrganizations org
	on s.PersonId = org.PersonId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
	inner join ODS.OrganizationCalendar oc on o.OrganizationId=oc.OrganizationId
	inner join ODS.OrganizationCalendarSession ocs on oc.OrganizationCalendarId=ocs.OrganizationCalendarId
	left join ods.OrganizationPersonRole rp on rp.PersonId = s.PersonId 
		and rp.OrganizationId <> o.OrganizationId
		and rp.RoleId = @k12StudentRoleId
		and rp.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	left join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = rp.OrganizationPersonRoleId and ppp.RefParticipationTypeId =@refParticipationTypeId
	left join ods.ProgramParticipationMigrant ppm on ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId 
	left join ods.K12StudentAcademicRecord sa on sa.OrganizationPersonRoleId = r.OrganizationPersonRoleId
	left join ods.RefHighSchoolDiplomaType dt on dt.RefHighSchoolDiplomaTypeId = sa.RefHighSchoolDiplomaTypeId
	left join (select RefMepServiceTypeId, Code from ods.RefMepServiceType where Code ='ReferralServices') rmsv on rmsv.RefMepServiceTypeId = ppm.RefMepServiceTypeId
	left join #cte cte on s.PersonId = cte.PersonId and IIF(org.OrganizationId > 0, org.OrganizationId, org.LeaOrganizationId) = cte.Parent_OrganizationId
			
	drop TABLE #cte
	drop TABLE #studentOrganizations
			
			
END

