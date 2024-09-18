CREATE PROCEDURE [RDS].[Migrate_DimNoDProgramStatuses]
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
--declare     @factTypeCode as varchar(50) = 'nord'
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
	declare @schoolOrganizationTypeId as int
	declare @refParticipationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'CorrectionalEducationReentryServicesParticipation'

	CREATE TABLE #studentOrganizations (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	
	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId 
	from RDS.Get_StudentOrganizations(@studentDates,0)

	select	
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		org.DimSeaId,
		s.PersonId,	
		s.DimCountDateId,		
		CASE 
		WHEN negprogtype.Code <> 'MISSING' AND ppp.RecordEndDateTime IS NOT NULL 
		AND DATEDIFF(d, ppp.RecordStartDateTime, ISNULL(ppp.RecordEndDateTime, GetDate())) >= 90 THEN 'NDLONGTERM'
		WHEN negprogtype.Code <> 'MISSING' AND ppp.RecordEndDateTime IS NULL 
		AND DATEDIFF(d, ppp.RecordStartDateTime, ISNULL(s.SubmissionYearEndDate, GetDate())) >= 90 THEN 'NDLONGTERM'
		ELSE 'MISSING'
	END AS LongTermStatusCode,
	case when negprogtype.Code = 'NeglectedPrograms' then 'NEGLECT'
		 when negprogtype.Code = 'JuvenileDetention' then 'JUVDET'
		 when negprogtype.Code = 'JuvenileCorrection' then 'JUVCORR'
		 when negprogtype.Code = 'AtRiskPrograms' then 'ATRISK'
		 when negprogtype.Code = 'AdultCorrection' then 'ADLTCORR'
		 when negprogtype.Code = 'OtherPrograms' then 'OTHER'
		 ELSE 'MISSING' END AS NeglectedProgramTypeCode,
		 ISNULL(inProgram.Code,'MISSING'),
		 ISNULL(exitedProgram.Code,'MISSING')
	from @studentDates s
	inner join #studentOrganizations org
		on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
		and r.EntryDate <= s.SubmissionYearEndDate and (r.ExitDate >=  s.SubmissionYearStartDate or r.ExitDate is null)
	inner join ods.OrganizationPersonRole r2 
		on r2.PersonId = s.PersonId
		and r2.EntryDate <= s.SubmissionYearEndDate and (r2.ExitDate >=  s.SubmissionYearStartDate or r2.ExitDate is null)
	inner join ods.OrganizationRelationship ore 
		on r2.OrganizationId = ore.OrganizationId 
		and ore.Parent_OrganizationId = r.OrganizationId
	inner join ods.PersonProgramParticipation ppp 
		on ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId 
		and ppp.RefParticipationTypeId = @refParticipationTypeId
	inner join ods.ProgramParticipationNeglected ppn 
		on ppn.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	inner join ods.RefNeglectedProgramType negprogtype 
		on negprogtype.[RefNeglectedProgramTypeId] = ppn.[RefNeglectedProgramTypeId]
	left join ods.RefAcademicCareerAndTechnicalOutcomesInProgram inProgram 
		on inProgram.RefAcademicCareerAndTechnicalOutcomesInProgramId = ppn.RefAcademicCareerAndTechnicalOutcomesInProgramId
	left join ods.RefAcademicCareerAndTechnicalOutcomesExitedProgram exitedProgram 
		on exitedProgram.RefAcademicCareerAndTechnicalOutcomesExitedProgramId = ppn.RefAcademicCareerAndTechnicalOutcomesExitedProgramId

	drop TABLE #studentOrganizations

END