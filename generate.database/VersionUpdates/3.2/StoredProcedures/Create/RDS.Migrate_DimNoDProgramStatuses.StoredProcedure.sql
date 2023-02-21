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

	
	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,0)


	select	
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
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
	inner join #studentOrganizations org
	on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join ods.OrganizationPersonRole r2 on r2.PersonId = s.PersonId
		and r2.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join ods.OrganizationRelationship ore on r2.OrganizationId = ore.OrganizationId and ore.Parent_OrganizationId = r.OrganizationId
	inner join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId and ppp.RefParticipationTypeId = @refParticipationTypeId
	inner join ods.ProgramParticipationNeglected ppn on ppn.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	inner join ods.[RefNeglectedProgramType] negprogtype on negprogtype.[RefNeglectedProgramTypeId] = ppn.[RefNeglectedProgramTypeId]

	drop TABLE #studentOrganizations

END