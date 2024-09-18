CREATE PROCEDURE [RDS].[migrate_DimStudentStatuses]
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
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
--declare     @factTypeCode as varchar(50) = 'cte'
--declare     @factTypeCode as varchar(50) = 'membership'
--declare     @factTypeCode as varchar(50) = 'grad'
--declare     @factTypeCode as varchar(50) = 'mep'

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
	declare @schoolOrganizationTypeId as int
	declare @refParticipationTypeId as int
	declare @stateId as int
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'MEPParticipation'
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

	select @stateId = rst.RefStateId 
	from ods.K12Sea s
	inner join ods.RefStateANSICode st on s.RefStateANSICode = st.Code
	inner join ods.RefState rst on rst.[Description] = st.StateName

	CREATE TABLE #studentOrganizations
	(
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	CREATE TABLE #studentDiploma
	(
		PersonId int,
		OrganizationId int,
		Parent_OrganizationId int,
		EntryDate date,
		ExitDate date,
		PlacementType varchar(50),
		PlacementStatus varchar(50),
		DiplomaOrCredentialAwardDate varchar(10),
		RefProfessionalTechnicalCredentialTypeId INT
	)

	create nonclustered index IX_CTE_Person_Organization on #studentDiploma(PersonId, Parent_OrganizationId)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId 
	from RDS.Get_StudentOrganizations(@studentDates, 0)

	insert into #studentDiploma(PersonId, OrganizationId, Parent_OrganizationId, EntryDate, ExitDate, PlacementType, PlacementStatus, 
					DiplomaOrCredentialAwardDate, RefProfessionalTechnicalCredentialTypeId)
	SELECT  opr.PersonId, opr.OrganizationId, op.Parent_OrganizationId, opr.EntryDate, opr.ExitDate,
			case	when psEnrll.EntryDateIntoPostSecondary is not null THEN 'ADVTRAIN'
					when refemp.code ='Yes' then 'EMPLOYMENT'
					when emp.MilitaryEnlistmentAfterExit = 1 then 'MILITARY'
					When wpp.RefWfProgramParticipationId is not null then 'POSTSEC'
					ELSE 'MISSING' 
			end as 'PlacementType',
			case when (psEnrll.EntryDateIntoPostSecondary is not null or refemp.code ='Yes'  or emp.MilitaryEnlistmentAfterExit = 1  or wpp.RefWfProgramParticipationId is not null) 
			THEN 'PLACED' ELSE 'NOTPLACED' end as 'PlacementStatus',
			diploma.DiplomaOrCredentialAwardDate,
			diploma.RefProfessionalTechnicalCredentialTypeId
			FROM ods.OrganizationPersonRole opr   
			inner join ods.OrganizationRelationship op on opr.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on opr.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			left join ods.WorkforceEmploymentQuarterlyData emp on opr.OrganizationPersonRoleId = emp.OrganizationPersonRoleId -- Military & Employment
			left join ods.RefEmployedAfterExit refEmp on refEmp.RefEmployedAfterExitId = emp.RefEmployedAfterExitId
			left join ods.WorkforceProgramParticipation wpp on ppp.PersonProgramParticipationId= wpp.PersonProgramParticipationId  	--Advanced Training
			left join ods.RefWfProgramParticipation refpp on refpp.RefWfProgramParticipationId = wpp.RefWfProgramParticipationId
			left join ods.PsStudentEnrollment psEnrll on opr.OrganizationPersonRoleId = psEnrll.[OrganizationPersonRoleId]  ---Postsecondary Education
			left join ods.K12StudentAcademicRecord	diploma on opr.OrganizationPersonRoleId = diploma.[OrganizationPersonRoleId]

	select distinct
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		org.DimSeaId,
		s.PersonId,
		s.DimCountDateId
		, case 
			when(ppm.MigrantStudentQualifyingArrivalDate between CAST('9/1/' + CAST(YEAR(ocs.BeginDate) AS VARCHAR(4)) AS DATE) and CAST('8/31/' + CAST(YEAR(ocs.BeginDate) + 1  AS VARCHAR(4)) AS DATE)) AND ppm.MepEligibilityExpirationDate > s.SubmissionYearStartDate then 'QAD'
			else 'MISSING' 
		  end as 'MobilityStatus12moCode'
		  , case 
			when(ppm.MigrantStudentQualifyingArrivalDate > CAST('9/1/' + CAST((YEAR(s.SubmissionYearStartDate) - 3)  AS VARCHAR(4)) AS DATE))
			AND ppm.MepEligibilityExpirationDate > s.SubmissionYearStartDate then 'QAD36'			
			else 'MISSING' 
		  end as 'MobilityStatus36moCode'				
		, case 
			when(ppm.MigrantStudentQualifyingArrivalDate between  ocs.BeginDate and ocs.EndDate) AND ppm.MepEligibilityExpirationDate > s.SubmissionYearStartDate then 'QMRSY'	
			else 'MISSING' 
		  end as 'MobilityStatusSYCode'
		, isnull(rmsv.Code,'MISSING')
		, case
			when sa.DiplomaOrCredentialAwardDate between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00806') then 'REGDIP'
			when sa.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00811') then 'OTHCOM'
			when sa.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00816') then 'HSDGED'
			when sa.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND (dt.Code = '00806')
			AND diploma.DiplomaOrCredentialAwardDate  between  CAST('10/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) and CAST('9/30/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE) AND 
			diploma.RefProfessionalTechnicalCredentialTypeId IS NOT NULL then 'HSDPROF'
			else 'MISSING'
		  end as 'DiplomaCredentialCode',
		ISNULL(diploma.PlacementType,'MISSING') as PlacementType,
		ISNULL(diploma.PlacementStatus, 'MISSING') as PlacementStatus,
		case
			when enr.NSLPDirectCertificationIndicator = 1 then 'YES'
			when enr.NSLPDirectCertificationIndicator = 0 then 'NO'
			else 'MISSING'
		  end as 'NSLPDirectCertificationIndicatorCode'
	from @studentDates s
	inner join #studentOrganizations org
		on s.PersonId = org.PersonId 
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate <= s.SubmissionYearEndDate and (r.ExitDate >=  s.SubmissionYearStartDate or r.ExitDate is null)
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
	inner join ODS.OrganizationCalendar oc on o.OrganizationId=oc.OrganizationId
	inner join ODS.OrganizationCalendarSession ocs on oc.OrganizationCalendarId=ocs.OrganizationCalendarId
	left join ods.K12StudentEnrollment enr on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
	left join ods.PersonDetail pd on pd.PersonId = s.PersonId
	left join ods.OrganizationRelationship ore on r.OrganizationId = ore.Parent_OrganizationId
	left join ods.OrganizationPersonRole mopr on ore.OrganizationId = mopr.OrganizationId and mopr.PersonId = r.PersonId
	left join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = mopr.OrganizationPersonRoleId and ppp.RefParticipationTypeId = @refParticipationTypeId
	left join ods.ProgramParticipationMigrant ppm on ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId 
	left join ods.K12StudentAcademicRecord sa on sa.OrganizationPersonRoleId = r.OrganizationPersonRoleId
	left join ods.RefHighSchoolDiplomaType dt on dt.RefHighSchoolDiplomaTypeId = sa.RefHighSchoolDiplomaTypeId
	left join ods.RefMepServiceType rmsv on rmsv.RefMepServiceTypeId = ppm.RefMepServiceTypeId and rmsv.Code ='ReferralServices'
	left join #studentDiploma diploma on s.PersonId = diploma.PersonId and IIF(ore.OrganizationId > 0, ore.OrganizationId, org.LeaOrganizationId) = diploma.OrganizationId
	where ((ISNULL(enr.RecordStartDateTime, getdate()) between CAST('09/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE)
	and CAST('8/31/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE)) 
	OR (ISNULL(enr.RecordEndDateTime, getdate()) between CAST('09/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) 
	and CAST('8/31/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE)))
	OR (pd.RefStateOfResidenceId = @stateId
	and ((ISNULL(pd.RecordStartDateTime, getdate()) between CAST('09/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE)
	and CAST('8/31/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE)) 
	OR (ISNULL(pd.RecordEndDateTime, getdate()) between CAST('09/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE) 
	and CAST('8/31/' + CAST(YEAR(s.SubmissionYearEndDate) AS VARCHAR(4)) AS DATE))))
	and (ppm.MepEligibilityExpirationDate IS NULL OR ppm.MepEligibilityExpirationDate > CAST('09/1/' + CAST(YEAR(s.SubmissionYearStartDate) AS VARCHAR(4)) AS DATE))
	
			
	drop TABLE #studentDiploma
	drop TABLE #studentOrganizations
			
			
END