



CREATE PROCEDURE [RDS].[Migrate_DimTitleIIIStatuses] 
	@studentDates as rds.StudentDateTableType ReadOnly
AS
BEGIN
	
	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	
		
SELECT 
		s.DimStudentId,	
		sch.DimSchoolId,		
		s.PersonId,
		s.DimCountDateId		
		,ISNULL(titleIIIAcct.Code,'MISSING') as TitleIIIAccountability
		
		, ISNULL(TitleIIILanguageInstructionProg.Code, 'MISSING') as TitleIIILanguageInstructionProgramType
		
		,	Case when ISNULL(titleIIIAcct.Code,'MISSING') ='MISSING' THEN 'MISSING'
				WHEN reg.RefAssessmentParticipationIndicatorId=2 and fely.NumberOfYear>=4 THEN 'NOTPROFICIENT'
				WHEN titleIIIAcct.Code = 'PROFICIENT' THEN 'PROFICIENT '
				ELSE  'NOTPROFICIENT '
			END as ProficiencyStatus 
		,
		CASE WHEN ISNULL(fely.NumberOfYear,0) = 0 THEN 'MISSING'
			 WHEN fely.NumberOfYear = 1 THEN '1YEAR' 
			 WHEN fely.NumberOfYear = 2 THEN '2YEAR' 
			 WHEN fely.NumberOfYear = 3 THEN '3YEAR' 
			 WHEN fely.NumberOfYear >= 4 THEN '4YEAR' 
			END AS FormerEnglishLearnerYearStatus
		

FROM  @studentDates s  
	 inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
											and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
										and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join ods.AssessmentRegistration reg on s.PersonId = reg.PersonId and r.OrganizationId = reg.SchoolOrganizationId
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	inner join ods.AssessmentAdministration adm on reg.AssessmentAdministrationId = adm.AssessmentAdministrationId
		and adm.StartDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate		
	--	TitleIII Accountability Progress
	left join (
	SELECT r1.PersonId, op.Parent_OrganizationId, titleIIIAcct.Code  FROM ods.OrganizationPersonRole r1
		inner join ods.OrganizationRelationship op on r1.OrganizationId = op.OrganizationId
			inner join ods.PersonProgramParticipation ppp on r1.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId			
		inner join ods.ProgramParticipationTitleIIILep partIIILep on ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId
		inner  join ods.RefTitleIIIAccountability titleIIIAcct on titleIIIAcct.RefTitleIIIAccountabilityId = partIIILep.RefTitleIIIAccountabilityId	
		where  r1.RoleId = @k12StudentRoleId
		) titleIIIAcct 
		on s.PersonId = titleIIIAcct.PersonId and sch.SchoolOrganizationId = titleIIIAcct.Parent_OrganizationId
	--	TitleIII LanguageInstruction ProgramType
	Left join (SELECT LangInst.OrganizationId, LangInst.RefTitleIIILanguageInstructionProgramTypeId, progType.Code 
						 FROM   ods.K12TitleIIILanguageInstruction LangInst 
					inner join ods.RefTitleIIILanguageInstructionProgramType progType on LangInst.RefTitleIIILanguageInstructionProgramTypeId = progType.RefTitleIIILanguageInstructionProgramTypeId
			)TitleIIILanguageInstructionProg on TitleIIILanguageInstructionProg.OrganizationId = o.OrganizationId
	
	-- Former English Learner Year	
	left join (select PersonId as PersonId, count(*)-1 as NumberOfYear, fy.Code, fy.OrganizationId  from (select Designator, r1.PersonId, 1 as NumberOfYear, iiiAcct.Code, op.Parent_OrganizationId as OrganizationId
									  FROM ods.OrganizationPersonRole r1
									inner join ods.OrganizationRelationship op on r1.OrganizationId = op.OrganizationId
									inner join ods.PersonProgramParticipation ppp
										on r1.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
									inner join ods.ProgramParticipationTitleIIILep partIIILep on ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId 									
									inner join ods.RefTitleIIIAccountability iiiAcct on partIIILep.RefTitleIIIAccountabilityId = iiiAcct.RefTitleIIIAccountabilityId
									inner join ods.OrganizationCalendarSession ocs on partIIILep.RecordStartDateTime <= ocs.EndDate where ppp.RefProgramExitReasonId is null
									group by Designator, r1.PersonId, iiiAcct.Code, op.Parent_OrganizationId,ppp.RefProgramExitReasonId
									)fy	
									group by fy.PersonId, fy.Code, fy.OrganizationId	
	) fely on fely.PersonId = s.PersonId and fely.OrganizationId = sch.SchoolOrganizationId


	
END



