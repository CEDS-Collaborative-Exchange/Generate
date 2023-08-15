CREATE PROCEDURE [RDS].[Migrate_DimTitleIIIStatuses] 
	@studentDates as rds.StudentDateTableType ReadOnly
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
--declare     @factTypeCode as varchar(50) = 'submission'
--declare     @factTypeCode as varchar(50) = 'titleIIIELOct'
--declare     @factTypeCode as varchar(50) = 'titleIIIELSY'

----variable for UseCutOffDate, uncomment the appropriate one
----If you're working on 'titleIIIELOct'
--       declare @useCutOffDate as bit = 1
----otherwise
--       declare @useCutOffDate as bit = 0

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
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

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

	CREATE TABLE #titleIIIAccountabilityProgress 
	(
		PersonId int,
		OrganizationId int,
		TitleIIIAccountabilityCode varchar(50)
	)

	CREATE TABLE #formerEnglishLearnerYear
	(
		PersonId int,
		NumberOfYear int,
		OrganizationId int
	)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,0)

	insert into #titleIIIAccountabilityProgress(PersonId, OrganizationId , TitleIIIAccountabilityCode)
	SELECT distinct r1.PersonId, op.Parent_OrganizationId, titleIIIAcct.Code  
	FROM ods.OrganizationPersonRole r1
		inner join ods.OrganizationRelationship op on r1.OrganizationId = op.Parent_OrganizationId and r1.RoleId = @k12StudentRoleId
		inner join ods.OrganizationPersonRole rp on op.OrganizationId = rp.OrganizationId and r1.PersonId = rp.PersonId
		inner join ods.PersonProgramParticipation ppp on rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
		inner join ods.ProgramParticipationTitleIIILep partIIILep on ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId
		inner join ods.RefTitleIIIAccountability titleIIIAcct on titleIIIAcct.RefTitleIIIAccountabilityId = partIIILep.RefTitleIIIAccountabilityId	

	insert into #formerEnglishLearnerYear(PersonId, NumberOfYear, OrganizationId)
	select PersonId as PersonId, count(*) as NumberOfYear, fy.OrganizationId  
	from
	(select distinct r.PersonId, 1 as NumberOfYear, op.Parent_OrganizationId as OrganizationId
	from ods.OrganizationPersonRole r
	inner join ods.OrganizationRelationship op on r.OrganizationId = op.Parent_OrganizationId and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationPersonRole rp on op.OrganizationId = rp.OrganizationId and r.PersonId = rp.PersonId
	inner join ods.PersonProgramParticipation ppp on rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
	inner join ods.ProgramParticipationTitleIIILep partIIILep on ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId and ppp.RefProgramExitReasonId is null
	inner join ods.RefTitleIIIAccountability iiiAcct on partIIILep.RefTitleIIIAccountabilityId = iiiAcct.RefTitleIIIAccountabilityId
	inner join ods.OrganizationCalendar c on c.OrganizationId = r.OrganizationId
	inner join ods.OrganizationCalendarSession ocs on ocs.OrganizationCalendarId = c.OrganizationCalendarId and partIIILep.RecordStartDateTime <= ocs.EndDate 
	group by Designator, r.PersonId, iiiAcct.Code, op.Parent_OrganizationId,ppp.RefProgramExitReasonId) fy	
	group by fy.PersonId, fy.OrganizationId	
		
SELECT distinct
		s.DimStudentId,	
		org.DimSchoolId,
		org.DimLeaId,	
		org.DimSeaId,	
		s.PersonId,
		s.DimCountDateId		
		,ISNULL(titleIIIAcct.TitleIIIAccountabilityCode,'MISSING') as TitleIIIAccountability
		
		, ISNULL(TitleIIILanguageInstructionProg.Code, 'MISSING') as TitleIIILanguageInstructionProgramType
		
		,	Case when ISNULL(titleIIIAcct.TitleIIIAccountabilityCode,'MISSING') ='MISSING' THEN 'MISSING'
				WHEN schreg.AssessmentParticipationCode = 'DidNotParticipate' and fely.NumberOfYear>=4 THEN 'NOTPROFICIENT'
				WHEN titleIIIAcct.TitleIIIAccountabilityCode = 'PROFICIENT' THEN 'PROFICIENT '
				ELSE  'NOTPROFICIENT '
			END as ProficiencyStatus 
		,
		CASE WHEN ISNULL(fely.NumberOfYear,0) = 0 THEN 'MISSING'
			 WHEN fely.NumberOfYear = 1 THEN '1YEAR' 
			 WHEN fely.NumberOfYear = 2 THEN '2YEAR' 
			 WHEN fely.NumberOfYear = 3 THEN '3YEAR' 
			 WHEN fely.NumberOfYear = 4 THEN '4YEAR' 
			 WHEN fely.NumberOfYear > 4 THEN '5YEAR' 
			END AS FormerEnglishLearnerYearStatus
FROM  @studentDates s  
	 inner join #studentOrganizations org	on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
	left join ods.AssessmentRegistration reg on s.PersonId = reg.PersonId and org.LeaOrganizationid = reg.LeaOrganizationId
	left join ods.AssessmentAdministration adm on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId
		and adm.StartDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate		
	left join (select distinct PersonId, SchoolOrganizationId, ind.Code as AssessmentParticipationCode
	from ods.AssessmentRegistration assreg
	inner join ods.RefAssessmentParticipationIndicator ind on assreg.RefAssessmentParticipationIndicatorId = ind.RefAssessmentParticipationIndicatorId
	 where ind.Code = 'DidNotParticipate') schreg 
	on s.PersonId = schreg.PersonId and org.Organizationid = schreg.SchoolOrganizationId
	left join #titleIIIAccountabilityProgress titleIIIAcct on s.PersonId = titleIIIAcct.PersonId 
															and IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId) = titleIIIAcct.OrganizationId
	Left join (SELECT LangInst.OrganizationId, LangInst.RefTitleIIILanguageInstructionProgramTypeId, progType.Code 
						 FROM   ods.K12TitleIIILanguageInstruction LangInst 
					inner join ods.RefTitleIIILanguageInstructionProgramType progType on LangInst.RefTitleIIILanguageInstructionProgramTypeId = progType.RefTitleIIILanguageInstructionProgramTypeId
			)TitleIIILanguageInstructionProg on TitleIIILanguageInstructionProg.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	left join #formerEnglishLearnerYear fely on fely.PersonId = s.PersonId and fely.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)

	DROP TABLE #titleIIIAccountabilityProgress 
	DROP TABLE #formerEnglishLearnerYear
	DROP TABLE #studentOrganizations
	
END