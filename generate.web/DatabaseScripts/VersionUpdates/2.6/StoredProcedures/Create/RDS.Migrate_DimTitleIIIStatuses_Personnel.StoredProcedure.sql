



CREATE  PROCEDURE [RDS].[Migrate_DimTitleIIIStatuses_Personnel] 
	@personnelDates as PersonnelDateTableType READONLY
AS
BEGIN

	declare @k12TeacherRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12TeacherRoleId = RoleId from ods.[Role] where Name = 'K12 Personnel'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
 		
SELECT 
		s.DimPersonnelId,	
		sch.DimSchoolId,	
		s.PersonId,
		s.DimCountDateId		
		,ISNULL(titleIIIAcct.Code,'MISSING') as TitleIIIAccountability
		
		, ISNULL(TitleIIILanguageInstructionProg.Code, 'MISSING') as TitleIIILanguageInstructionProgramType
		
		,	Case when ISNULL(titleIIIAcct.Code,'MISSING') ='MISSING' THEN 'MISSING'
				WHEN titleIIIAcct.Code = 'PROFICIENT' THEN 'PROFICIENT '
				ELSE  'NOTPROFICIENT '
			END as ProficiencyStatus 
		,
		CASE WHEN ISNULL(fely.NumberOfYear,0) = 0 THEN 'MISSING'
			 WHEN fely.NumberOfYear = 1 THEN '1YEAR ' 
			 WHEN fely.NumberOfYear = 2 THEN '2YEAR ' 
			 WHEN fely.NumberOfYear = 3 THEN '3YEAR ' 
			 WHEN fely.NumberOfYear = 4 THEN '4YEAR ' 
			END AS FormerEnglishLearnerYearStatus

FROM @personnelDates s

	 inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
											and r.RoleId = @k12TeacherRoleId
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
										and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	left join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r.OrganizationPersonRoleId
		left join ods.ProgramParticipationTitleIIILep partIIILep on ppp.PersonProgramParticipationId = partIIILep.PersonProgramParticipationId
		left join ods.RefTitleIIIAccountability titleIIIAcct on titleIIIAcct.RefTitleIIIAccountabilityId = partIIILep.RefTitleIIIAccountabilityId	
	Left join (SELECT LangInst.OrganizationId, LangInst.RefTitleIIILanguageInstructionProgramTypeId, progType.Code  FROM   ods.K12TitleIIILanguageInstruction LangInst 
					inner join ods.RefTitleIIILanguageInstructionProgramType progType on LangInst.RefTitleIIILanguageInstructionProgramTypeId = progType.RefTitleIIILanguageInstructionProgramTypeId
			)TitleIIILanguageInstructionProg on TitleIIILanguageInstructionProg.OrganizationId = o.OrganizationId

			-- Former English Learner Year	
	left join (select PersonId, count(1) - 1 as NumberOfYear, iiiAcct.Code
									from ods.OrganizationCalendarSession ocs
									inner join ods.ProgramParticipationTitleIIILep iii
										on iii.RecordStartDateTime <= ocs.EndDate
										and iii.RefTitleIIIAccountabilityId = 3
									inner join ods.PersonProgramParticipation ppp
										on iii.PersonProgramParticipationId = ppp.PersonProgramParticipationId
									inner join ods.OrganizationPersonRole opr
										on ppp.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
									inner join ods.RefTitleIIIAccountability iiiAcct on iii.RefTitleIIIAccountabilityId = iiiAcct.RefTitleIIIAccountabilityId
									group by opr.PersonId, iiiAcct.Code
									having count(1) >= 2		
	) fely on fely.PersonId = s.PersonId
	
END




