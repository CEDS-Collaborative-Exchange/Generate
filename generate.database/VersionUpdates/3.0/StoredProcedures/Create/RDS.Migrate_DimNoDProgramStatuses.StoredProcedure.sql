CREATE PROCEDURE [RDS].[Migrate_DimNoDProgramStatuses]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN


	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	declare @refParticipationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'CorrectionalEducationReentryServicesParticipation'


	select	
		s.DimStudentId,
		sch.DimSchoolId,
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
		 ELSE 'MISSING'
	END AS NeglectedProgramTypeCode
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	inner join ods.K12School k12sch on o.OrganizationId = k12sch.OrganizationId
	join ods.OrganizationPersonRole r2 on r2.PersonId = s.PersonId
		and r2.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	join ods.OrganizationRelationship ore on r2.OrganizationId = ore.OrganizationId and ore.Parent_OrganizationId = r.OrganizationId
	join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId and ppp.RefParticipationTypeId = @refParticipationTypeId
	inner join ods.ProgramParticipationNeglected ppn on ppn.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	inner join ods.[RefNeglectedProgramType] negprogtype on negprogtype.[RefNeglectedProgramTypeId] = ppn.[RefNeglectedProgramTypeId]

END